$NICNAME = "lan"
$IFINDEX = (Get-NetAdapter | Where-Object Name -EQ "$NICNAME" | Select-Object -ExpandProperty "IfIndex")
$IPADDRESS = "40.40.40.1"
$PREFIX = "24"
$MASK = "255.255.255.0"
$LOOPBACK = "127.0.0.1"
$DOMAINNAME = "Name.local"
$BIOSNAME = "NAME"
$PASSWORD = (ConvertTo-SecureString -String "ZAQ!2wsx" -AsPlainText -Force)
$SCOPENAME = "NAME"
$STARTRANGE = "40.40.40.100"
$ENDRANGE = "40.40.40.150"

New-NetIPAddress -InterfaceIndex "$IFINDEX" -IPAddress "$IPADDRESS" -PrefixLength "$PREFIX"
Set-DnsClientServerAddress -InterfaceIndex "$IFINDEX" -ServerAddresses "$LOOPBACK"

Install-WindowsFeature -Name "DHCP","AD-Domain-Services","DNS" -IncludeManagementTools

Add-DhcpServerv4Scope -Name "$SCOPENAME" -StartRange "$STARTRANGE" -EndRange "$ENDRANGE" -SubnetMask "$MASK" -State Active
Set-DhcpServerv4OptionValue -Router "$IPADDRESS" -DnsServer "$IPADDRESS"

Install-ADDSForest -DomainName "$DOMAINNAME" -DomainNetBiosName "$BIOSNAME" -InstallDns -SafeModeAdministratorPassword $PASSWORD

#After Reboot just use this command to authorize DHCP Server on domain
#Add-DhcpServerInDC

