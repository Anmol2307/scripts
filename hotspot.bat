:: batch script for hotspot in windows 7
:: doesn't take errors into consideration
:: make sure your wifi is on
:: run this script as administrator
@echo off
echo This is the script for hotspot in windows 7
set /p name=Hotspotname:
set /p pass=password(greater than 8 chars):
echo the Hotspot name is %name%
netsh wlan set hostednetwork mode=allow ssid=%name%  key=%pass% 
netsh wlan start hostednetwork
pause
