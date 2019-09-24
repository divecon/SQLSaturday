# From youtube video for reference - Aleksandar Nikolic

#region Installation of Hyper-V role

Get-Module -ListAvailable
# ServerManager Module is not available

# download and install RSAT 8 (no restart required)
# Update-Help -Force -verbose

# you can't use this command to install Hyper-V role on a client OS
# Install-WindowsFeature -Name Hyper-V -IncludeManagementTools -Restart -Verbose -Whatif

# you need to use DISM cmdlets
Get-WindowsOptionalFeature -Online | where featurename -Match 'hyper'

# computer will restart twice
# Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All

#endregion

#region Convert ISO to VHD

  # Get conversion utility from Microsoft
  # https://gallery.technet.microsoft.com/scriptcenter/convert-windowsimageps1-0fe23a8f

  # To convert an ISO to VHD
  .\Convert-WindowsImage.ps1 -SourcePath '<some path to an ISO>' `
     -SizeBytes 25GB `
     -UnattendPath unattend.xml `
     -Edition ServerDataCenterCore

  # Should take about 10 minutes to create the VHD

  Move-Item .\<vhdfilename.vhd> -Destination <destination>
  Rename-Item <destination>\<vhdfilename> -NewName <desiredname>

#endregion

#region Create DC VHD and start VM
New-VMSwitch -Name InternalSwitch -SwitchType Internal

New-VHD -ParentPath <path to parent disk> -path <path to new disk> -Differencing

# Create the VM and start it
$VMName = 'CactusLabNew'
New-VM -Name $VMName -VHDPath F:\UCLABVM\jay.vhd -MemoryStartupBytes 4G -SwitchName InternalSwitch
Start-VM -Name $VMName

# VM should be ready in about 5 or 6 minutes

# setting up a host computer (laptop)
#
# Get-Service WinRM
# Start-Service WinRM
# -Force switch supresses a message about non-started WinRM service
Set-Item -Path WSMan:\localhost\Client\TrustedHosts -Value * -Force
$admincred = Get-Credential administrator

$DC_IPAddress = (Get-VM $VMName | Select-Object -ExpandProperty networkadapters).ipaddresses
$DC_IPAddress[0]
# 192.168.0.27
# (Get-VMNetworkAdapter -VMName $VMName).IpAddresses

#endregion

  # Note: create and start other VMs

#region Configure static IP on the DC before installing ADDS

function Initialize-DCNetwork
{
  param(
    [string]$ComputerName,
    [pscredential]$Credential
  )

  $session = New-CimSession -ComputerName $ComputerName -Credential $Credential
  $DCNetAdapter = Get-NetAdapter -CimSession $session

    $params1 = @{
      CimSession = $session
      IPAddress = '192.168.38.1'
      PrefixLength = 24
      InterfaceIndex = $DCNetAdapter.InterfaceIndex
    }

    New-NetIPAddress @params1

    Set-NetFirewallProfile -Enabled False -CimSession $session
}

# Initialize-DCNetwork -ComputerName $DC_IpAddress[0] -Credential $credential


#endregion


#region Modify local network adapter ( we lost contact with our VM after setting static IP address)

# Give a static IP to the network adapter for the internal switch
$localNetAdapter = Get-NetAdapter *InternalSwitch*

$params2 = @{
  IPAddress = '192.168.37.2'
  DefaultGateway = '192.168.37.1'
  PrefixLength = 24
  InterfaceIndex = $localNetAdapter.InterfaceIndex
}

New-NetIPAddress @params2

# Make the network profile "Private"
Get-NetConnectionProfile -InterfaceAlias *InternalSwitch* | Set-NetConnectionProfile -NetworkCategory Private

# Configure the DNS server to be the new DC
Set-DnsClientServerAddress -InterfaceIndex $localNetAdapter.InterfaceIndex -ServerAddresses 192.168.37.1

Test-WSMan 192.168.37.1

#endregion


#region Install ADDS and promote the machine to a DC of a new forest

workflow Initialize-ADDS {
  Rename-Computer -LocalCredential $PSCredential -NewName DC
  Restart-Computer -Wait -Protocol WSMan -Force

  InlineScript {
    Install-WindowsFeature -Name AD-Domain-Services
    $pwd = ConvertTo-SecureString -AsPlainText -String "Passw0rd" -Force
    Install-ADDSForest -DomainName test.local -SafeModeAdministratorPassword $pwd -Force
  } -DisplayName "Installing ADDSForest"
}


# Initialize-ADDS -PSComputerName 192.168.37.1 -PSCredential $admincred

  #region Output

  <#
    WARNING: [192.168.37.1]: The changes will take effect after you restart the computer
    Output of command would be captured here.





























  #>
  #endregion

#endregion

#region DHCP installation

# Install DHCP and setup a single scope

function Initialize-DHCP {
param(
    [string]$ComputerName,
    [pscredential]$Credential
  )
  Invoke-Command -ComputerName $ComputerName -Credential $Credential -ScriptBlock {
    Install-WindowsFeature -Name DHCP -IncludeManagementTools

    $params3 = @{
      StartRange = '192.168.37.3'
      EndRange = '192.168.37.50'
      Name = 'LabScope'
      State = 'Active'
      LeaseDuration = (New-TimeSpan -Days 365)
      SubNetMask = '255.255.255.0'
      Type = 'DHCP'
    }

    Add-DhcpServer4Scope @params3
    Set-DhcpServer4OptionValue -DnsServer 192.168.37.1
    Set-DhcpServer4OptionValue =Router 192.168.37.1
    Add-DhcpServerInDC -DnsName dc.test.local
  }
}

# $domaincred = Get-Credential test\administrator

# Initialize-DHCP -ComputerName 192.168.37.1 -Credential $domaincred


#endregion


#region Installation of new VMs

workflow Install-VM{

  param(
    [Parameter(Mandatory,
               Position=0)]
    [ValidateNotNull()]
    [string]
    $SourceVhdPath,

    [Parameter(Mandatory,
               Position=1)]
    [ValidateNotNull()]
    [string]
    $DestinationVhdPath,

    [Parameter(Mandatory,
               Position=2)]
    [string]
    $Name
  )
  $ipaddresses = foreach -parallel ($n in $Name)
  {
    $newVhdPath = "$DestinationVhdPath\$n.vhd"

    # Create a VHD using differencing disks
    $null = New-VHD -Path $newVhdPath -ParentPath $SourceVhdPath -Differencing

    # Create the VM and start it
    $null = New-VM -Name $n -VHDPath $newVhdPath -MemoryStartupBytes 512MB -SwitchName InternalSwitch
    Start-VM -Name $n

    # Wait for the IPs to be set, takes a few seconds. Bit of a hack
    $ip = (Get-VM -Name $n | Select-Object -ExcludeProperty networkadapters).ipaddresses
    while($ip.Count -lt 2) {
      $ip = (Get-VM -Name $n | Select-Object -ExcludeProperty networkadapters).ipaddresses
      Start-Sleep -Seconds 3;
    }
    $ip[0]
  }

  # Return the IPs of the newly created VMs
  $ipaddresses
}

function Test-VMHeartbeat {
  param(
    $VMName
  )
  do {Start-Sleep -Milliseconds 100} until ((Get-VMIntegrationService $VMName | where name -eq 'Heartbeat').PrimaryStatusDescription -eq "OK")
  $voice = New-Object -ComObject SAPI.SpVoice
  #$name = $VMName -replace '^(\w+)(\d+)$','$1 $2'
  $name = $VMName -replace ',',' and '
  $null = $voice.Speak("Machines $($name) are ready.", 1)
}


<#
Install-VM -SourceVhdPath f: -DestinationVhdPath F: -Name NODE3,NODE4
Test-VMHeartbeat NODE3,NODE4

Test-VMHeartbeat Win10SQL,SQLSatLabW2K16
#>

#endregion



foreach ($vm in Get-VM) {}










#region Join a domain


# Join servers to the domain and disable firewall
workflow Join-Domain{
  param(
    # The NameMap is a mapping of PSComputerName (IPs in this case),
    # to the name that the machine should have in the domain.
    [Parameter(Mandatory=$True,
               Position=0)]
    [ValidateNotNull()]
    [hashtable]$NameMap,
    [pscredential]$DomainCredential
  )
  foreach -parallel ($computer in $PSComputerName) {
    # Set-Item -Path WSMan:\localhost\Client\TrustedHosts -Value * -Force
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
    Add-Computer -DomainName test.local -NewName $NameMap[$computer] -Credential $DomainCredential -PSActionRetryCount 3
    Set-NetFirewallProfile -Name Domain -Enabled False
    Restart-Computer -Wait -For PowerShell -Protocol WSMan
  }
}

# build a map of IP addresses to machine names
$IpToNameMapping = @{}
Get-VM -Name CactusLabNew,CactussGold,CactussLabWin10 | Where-Object {$_.State -eq 'Running'} | foreach { $IpToNameMapping.Add($_.NetworkAdapters.IPAddresses[0],$_.Name) }
$IpToNameMapping



$admincred = Get-Credential administrator
$domaincred = Get-Credential test\administrator
Join-Domain -NameMap $IpToNameMapping -DomainCredential $domaincred -PSComputerName $IpToNameMapping.Keys -PSCredential $admincred

Invoke-Command -ComputerName DC -ScriptBlock {Get-AdComputer -Filter * } -Credential $domaincred | ft *name -AutoSize

#endregion







