# OpenVPN-install
This script allows you to install an OpenVPN server quickly and esealy on Debian 8 *only*.

## Use

`wget https://raw.githubusercontent.com/Angristan/OpenVPN-install/master/openvpn-install.sh`

`chmod +x openvpn-install.sh`

`./openvpn-install.sh`

The script allows you to do 3 things : install OpenVPN, create an user, or uninstall OpenVPN.
The second option can only be used after the first one.

You can use the script as many times as you want to create users (no limit).

The script support 2 netwkork interfaces : *eth0** et **venet0**. You can check yours with the `ifconfig` command. If you're using another interface, please contact me.


## Wich server should I use ?
This script will work on :
- Dedeciated server
- VMware or KVM/QEMU VPS
- OpenVZ VPS with the TUN (TUN/TAP) mudule activated (you can find some at [PulseHeberg](http://angristan.fr/pulseheberg/))

## Contact / Feedback

http://angristan.fr/contact/ or open an [issue](https://github.com/Angristan/OpenVPN-install/issues)

## Licence

[GNU GPL v2.0](https://github.com/Angristan/OpenVPN-install/blob/master/LICENSE)
