#!/bin/bash
# Pre-Configure
touch tmp
# Installing packages
result1=$(dpkg-query -W -f='${Status} ${Version}\n' hostapd)
result2=$(dpkg-query -W -f='${Status} ${Version}\n' dnsmasq)

if [[ $result1 =~ ".*install ok installed.*" ]]; then
  echo -n "hostapd already installed... "
else
  echo -n "Installing hostapd... "
  apt-get install hostapd
fi
echo "[Done]"

if [[ $result2 =~ ".*install ok installed.*" ]]; then
  echo -n "dnsmasq already installed... "
else
  echo -n "Installing dnsmasq... "
  apt-get install dnsmasq
fi
echo "[Done]"

# Stop the processes if running and disable from starting on system start up
echo -n "Stopping hostapd... "
service hostapd stop >tmp
echo "[Done]"
echo -n "Stopping dnsmasq... "
service dnsmasq stop>tmp
echo "[Done]"
echo -n "Disabling hotapd from starting on system startup... "
update-rc.d hostapd disable>tmp
echo "[Done]"
echo -n "Disabling dnsmasq from starting on system startup... "
update-rc.d dnsmasq disable>tmp
echo "[Done]"

# Editing /etc/dnsmasq.conf
result3=$(cat /etc/dnsmasq.conf)
if [[ $result3 =~ ".*# Bind to only one interface
bind-interfaces
# Choose interface for binding
interface=wlan0
# Specify range of IP addresses for DHCP leasses
dhcp-range=192.168.150.2,192.168.150.10.*" ]]; then
  echo -n "dnsmasq already edited... "
else
  echo -n "Editing dnsmasq... \t"
  echo "# Bind to only one interface
bind-interfaces
# Choose interface for binding
interface=wlan0
# Specify range of IP addresses for DHCP leasses
dhcp-range=192.168.150.2,192.168.150.10" >> /etc/dnsmasq.conf
fi
echo "[Done]"

# Take details in
echo "Please insert hotspot ssid:"
read ssid

echo "Please insert hotspot password:"
stty -echo
read password
stty echo

echo -n "Do you want to see the password once?[Y/N]"
read input
k="Y"
if [ "$input" = "$k" ]
then
  echo -n "Password:"
  echo $password
fi

# Editing /etc/hostapd.conf
echo "# Define interface
interface=wlan0
# Select driver
driver=nl80211
# Set access point name
ssid=$ssid
# Set access point harware mode to 802.11g
hw_mode=g
# Set WIFI channel (can be easily changed)
channel=6
# Enable WPA2 only (1 for WPA, 2 for WPA2, 3 for WPA + WPA2)
wpa=2
wpa_passphrase=$password" > /etc/hostapd.conf

# Start
# Configure IP address for WLAN
ifconfig wlan0 192.168.150.1
# Start DHCP/DNS server
service dnsmasq restart
# Enable routing
sysctl net.ipv4.ip_forward=1
# Enable NAT
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
# Run access point daemon
hostapd /etc/hostapd.conf
# Stop
# Disable NAT
iptables -D POSTROUTING -t nat -o eth0 -j MASQUERADE
# Disable routing
sysctl net.ipv4.ip_forward=0
# Disable DHCP/DNS server
service dnsmasq stop
service hostapd stop
