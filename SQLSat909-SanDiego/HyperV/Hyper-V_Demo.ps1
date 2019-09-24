# Enable the Hyper-V PowerShell Module
Enable-WindowsOptionalFeature -Online -FeatureName  Microsoft-Hyper-V-Management-PowerShell

# Additionally install the management console
Enable-WindowsOptionalFeature -Online -FeatureName  Microsoft-Hyper-V-Tools-All

# Actually enable Hyper-V
Enable-WindowsOptionalFeature -Online -FeatureName  Microsoft-Hyper-V-All 

# Get list of all modules
get-module

# Get list of commandlets in Hyper-V module
get-command -Module Hyper-V


# Get list of existing Network Adapters
Get-NetAdapter

# Get help on New-VMSwitch
Get-Help New-VMSwitch -ShowWindow

# Create a new, external switch and attach to a particlar NIC
# In this case, the new switch is named BlackwaterConfig and the NIC is WLAN
# Specifies whether the parent partition (i.e. the management operating system) 
# is to have access to the physical NIC bound to the virtual switch to be created.
New-VMSwitch -name BlackwaterConfig -SwitchType External -NetAdapterName WLAN -AllowManagementOS $true

# Create new Internal switch
New-VMSwitch -Name BlackwaterConfig_I -SwitchType Internal

# Create new private switch
New-VMSwitch -Name BlackwaterConfig_P -SwitchType Private


# Once system has been setup with all desired applications and you're ready to create
# your gold disk:
sysprep /generalize /oobe /mode:vm