$NATSwitchName = "NATSwitch"
$NATNetworkName = "NATNetwork"
$HostIPAddress = "192.168.56.1"
$IPPrefixLength = 24
$NATNetworkPrefix = "192.168.56.0/24"
$VirtualNetworkAdapterName = "vEthernet ($NATSwitchName)"

# Check if the virtual switch exists. If not, create it.
if (-not (Get-VMSwitch -Name $NATSwitchName -ErrorAction SilentlyContinue)) {
    Write-Host "Creating Internal-only switch named '$NATSwitchName' on Windows Hyper-V host..."
    New-VMSwitch -Name $NATSwitchName -SwitchType Internal
} else {
    Write-Host "'$NATSwitchName' already exists; skipping."
}

# Check if the IP address is assigned to the virtual switch. If not, assign it.
if (-not (Get-NetIPAddress -InterfaceAlias $VirtualNetworkAdapterName -IPAddress $HostIPAddress -ErrorAction SilentlyContinue)) {
    Write-Host "Registering IP address '$HostIPAddress' on '$VirtualNetworkAdapterName'..."
    New-NetIPAddress -IPAddress $HostIPAddress -PrefixLength $IPPrefixLength -InterfaceAlias $VirtualNetworkAdapterName
} else {
    Write-Host "IP address '$HostIPAddress' already registered on '$VirtualNetworkAdapterName'; skipping."
}

# Check if the NAT network exists. If not, create it.
if (-not (Get-NetNAT -Name $NATNetworkName -ErrorAction SilentlyContinue)) {
    Write-Host "Registering new NAT adapter for '$NATNetworkPrefix'..."
    New-NetNAT -Name $NATNetworkName -InternalIPInterfaceAddressPrefix $NATNetworkPrefix
} else {
    Write-Host "NAT adapter for '$NATNetworkPrefix' already registered; skipping."
}