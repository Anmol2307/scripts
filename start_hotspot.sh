#!/bin/bash
# Pre-Configure
touch tmp
CAT=/etc/cat
# Installing packages
result1=$(dpkg-query -l 'hostapd')
echo $result1
result2=$(dpkg-query -l 'dnsmasq')

if [[ $result1 =~ "dpkg-query: no packages found matching.*" ]]; then
  echo -n "Installing hostapd... \t"
  @apt-get install hostapd
else
  echo -n "hostapd already installed... \t"
fi
echo "[Done]"

if [[ $result1 =~ "dpkg-query: no packages found matching.*" ]]; then
  echo -n "Installing dnsmasq... \t"
  @apt-get install dnsmasq
else
  echo -n "dnsmasq already installed... \t"
fi
echo "[Done]"

# Stop the processes if running and disable from starting on system start up
echo -n "Stopping hostapd... \t"
service hostapd stop >tmp
echo "[Done]"
echo -n "Stopping dnsmasq... \t"
service dnsmasq stop>tmp
echo "[Done]"
echo -n "Disabling hotapd from starting on system startup... \t"
update-rc.d hostapd disable>tmp
echo "[Done]"
echo -n "Disabling dnsmasq from starting on system startup... \t"
update-rc.d dnsmasq disable>tmp
echo "[Done]"

# Editing /etc/dnsmasq.conf
result3=$($(CAT) /etc/dnsmasq)
if [[ $result3 =~ ".*# Bind to only one interface\n
      bind-interfaces\n
      # Choose interface for binding\n
      interface=wlan0\n
      # Specify range of IP addresses for DHCP leasses\n
      dhcp-range=192.168.150.2,192.168.150.10.*" ]]; then
  echo -n "dnsmasq already edited... \t"
else
  echo -n "Editing dnsmasq... \t"
  echo "# Bind to only one interface\n
      bind-interfaces\n
      # Choose interface for binding\n
      interface=wlan0\n
      # Specify range of IP addresses for DHCP leasses\n
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
echo "# Define interface\n
      interface=wlan0\n
      # Select driver\n
      driver=nl80211\n
      # Set access point name\n
      ssid=$ssid\n
      # Set access point harware mode to 802.11g\n
      hw_mode=g\n
      # Set WIFI channel (can be easily changed)\n
      channel=6\n
      # Enable WPA2 only (1 for WPA, 2 for WPA2, 3 for WPA + WPA2)\n
      wpa=2\n
      wpa_passphrase=$password" > /etc/hotapd.conf

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
