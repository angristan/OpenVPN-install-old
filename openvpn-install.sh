#!/bin/bash
#Coloration variables
RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
DEFAULT="\033[0m"

echo -e "$BLUE""#######################################################################"
echo -e "$BLUE""#                                                                     #"
echo -e "$BLUE""#  ""$YELLOW""This script will install an OpenVPN server on Debian 8 only.      ""$BLUE""#"
echo -e "$BLUE""#  ""$YELLOW""The server will use the TCP protocol on the port of your choice,  ""$BLUE""#"
echo -e "$BLUE""#  ""$YELLOW""and will also use the French Data Network's (FDN) DNS servers.    ""$BLUE""#"
echo -e "$BLUE""#                                                                     #"
echo -e "$BLUE""#######################################################################""$DEFAULT"

if [ "$UID" -ne "0" ] #We check the user
then
  echo -e "$RED""Please use this script as root.""$DEFAULT"
  exit
elif [[ ! -e /dev/net/tun ]] #We check that the TUN module is activated
then
  echo -e "$RED""TUN/TAP is not activated.""$DEFAULT"
  exit
else
  PS3='Enter your choice : '
  choices=("Install the OpenVPN server" "Create a user" "Uninstall OpenVPN" "Exit")
  select opt in "${choices[@]}"
  do
    case $opt in #1st choice
      "Install the OpenVPN server")
        INT_eth0=`ifconfig | grep "eth0" | awk '{print $1}'`
        INT_venet0=`ifconfig | grep "venet0:0" | awk '{print $1}'`
        if [[ -n "$INT_eth0" ]] && [[ $INT_eth0 = "eth0" ]]
        then
          INTERFACE="eth0"
        elif [[ -n "$INT_venet0" ]] && [[ $INT_venet0 = "venet0:0" ]]
        then
          INTERFACE="venet0"
        else
          echo -e "$RED""Your network interface is not supported."
          echo -e "$RED""Please contact Angristan ;)""$DEFAULT"
          break
        fi
        read -p 'Port to use with the VPN: ' PORT
        PS3='Do you want to enable server's logging ?
        choices=("Yes" "No")
        select opt in "${choices[@]}"
        do
          case $opt in
            "Yes")
              log=true
            ;;
            "No")
              log=false
            ;;
            *)
              echo "Wrong choice."
            ;;
            esac
        done
        IP=`dig +short myip.opendns.com @resolver1.opendns.com` #We get the public IP of the server
        echo -e "$GREEN""###########################"
        echo -e "$GREEN""# Installation of OpenVPN #"
        echo -e "$GREEN""###########################""$DEFAULT"
        apt-get -y install openvpn easy-rsa zip dnsutils
        echo -e "$GREEN""###################################"
        echo -e "$GREEN""#  Keys and certificates creation #"
        echo -e "$GREEN""###################################""$DEFAULT"
        cd /etc/openvpn/
        mkdir easy-rsa
        cp -R /usr/share/easy-rsa/* easy-rsa/
        cd /etc/openvpn/easy-rsa/
        source vars
        ./clean-all
        ./build-dh
        ./pkitool --initca
        ./pkitool --server server
        openvpn --genkey --secret keys/the.key
        cd /etc/openvpn/easy-rsa/keys
        cp ca.crt dh2048.pem server.crt server.key the.key ../../
        echo -e "$GREEN""##########################################"
        echo -e "$GREEN""# Creation of the server's configuration #"
        echo -e "$GREEN""##########################################""$DEFAULT"
        mkdir /etc/openvpn/jail
        mkdir /etc/openvpn/jail//tmp
        mkdir /etc/openvpn/confuser
        cd /etc/openvpn
echo "#Serveur
mode server
proto tcp
port $PORT
dev tun

#Clés et certificats
ca ca.crt
cert server.crt
key server.key
dh dh2048.pem
tls-auth the.key 0
cipher AES-256-CBC

#Réseau
server 10.10.10.0 255.255.255.0
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 80.67.169.12" #French Data Network's (FDN) DNS servers
push "dhcp-option DNS 80.67.169.40"
keepalive 10 120

#Sécurité
user nobody
group nogroup
chroot /etc/openvpn/jail
persist-key
persist-tun
comp-lzo #Compression" > server.conf
        if [ $log=true ]
        then
          echo "

#Log
verb 3 #Log level
mute 20
status openvpn-status.log
log-append /var/log/openvpn/openvpn.log #Log file" >> server.conf
        mkdir /var/log/openvpn/ #We create the log folder and file
        touch /var/log/openvpn/openvpn.log
        elif [ $log!=false && $log!=true ]
        then
          echo -e "$RED""ERROR - Please uninstall and retry""$DEFAULT"
          exit
        fi
        echo -e "$GREEN""#########################"
        echo -e "$GREEN""# Network configuration #"
        echo -e "$GREEN""#########################""$DEFAULT"
        systemctl enable openvpn #Autostart of OpenVPN server's daemon activation
        service openvpn restart #We start the OpenVPN server's daemon
        sed -i 's|#net.ipv4.ip_forward=1|net.ipv4.ip_forward=1|' /etc/sysctl.conf
        sysctl -p
        iptables -t nat -A POSTROUTING -s 10.10.10.0/24 -o $INTERFACE -j MASQUERADE
        sh -c "iptables-save > /etc/iptables.rules" #Saving iptables rules in case of reboot
        echo "pre-up iptables-restore < /etc/iptables.rules" >> /etc/network/interfaces
      break
      ;;
      "Create a user") #2nd choice
        if [ -e /etc/openvpn/server.conf ] #We verify that the server has been installed
          then
            echo -e "$BLUE""A user is able to do only one connection at the same time."
            echo -e "$BLUE""But you can create unlimited users !"
            echo -e "$BLUE""So you can have unlimited simultaneous connections :)""$DEFAULT"
            read -p "Username (no special characters) : " CLIENT
            PORT=`grep port /etc/openvpn/server.conf | awk '{print $2}'`
            IP=`dig +short myip.opendns.com @resolver1.opendns.com` #We get the public IP adress
            echo -e "$GREEN""###################################"
            echo -e "$GREEN""#  Keys and certificates creation #"
            echo -e "$GREEN""###################################""$DEFAULT"
            cd /etc/openvpn/easy-rsa
            source vars
            ./build-key-pass $CLIENT
            mkdir /etc/openvpn/confuser/$CLIENT
            cp keys/$CLIENT*.* keys/the.key keys/ca.crt /etc/openvpn/confuser/$CLIENT/
            echo -e "$GREEN""########################################"
            echo -e "$GREEN""# Creation of the user's configuration #"
            echo -e "$GREEN""########################################""$DEFAULT"
            cd /etc/openvpn/confuser/$CLIENT/
echo "#Client
client
dev tun
proto tcp-client
remote $IP $PORT
resolv-retry infinite
cipher AES-256-CBC

#Clés et certificats
ca ca.crt
cert $CLIENT.crt
key $CLIENT.key
tls-auth the.key 1

#Sécurité
nobind
persist-key
persist-tun
comp-lzo #Compression
verb 3 #Log level" > client.conf
            cp client.conf client.ovpn
            chmod +r * #We make the keys readable
            zip $CLIENT-vpn.zip * #We put all the configuration in a zip file
            chmod +r $CLIENT-vpn.zip
            echo -e "$GREEN""The client configuration can be found in $PWD/$CLIENT-vpn.zip"
            echo -e "$GREEN""To get this file, you can use this command on your computer (Linux/OSX) : "
            echo -e "$YELLOW""scp SSHuser@$IP:/etc/openvpn/confuser/$CLIENT/$CLIENT-vpn.zip $CLIENT-vpn.zip"
            echo -e "$YELLOW""You can also download the file via SFTP.""$DEFAULT"
            break
        else #If the server is not installed
          echo -e "$RED""You must install the server before creating users.""$DEFAULT"
          break
        fi
      ;;
      "Uninstall OpenVPN") #3rd choice
        systemctl stop openvpn
        systemctl disable openvpn
        rm -rf /etc/openvpn
        rm ~/*-vpn.zip
        rm -rf /var/log/openvpn/
        sed -i 's|net.ipv4.ip_forward=1|#net.ipv4.ip_forward=1|' /etc/sysctl.conf
        sysctl -p
        sed -i 's|pre-up iptables-restore < /etc/iptables.rules||' /etc/network/interfaces
        iptables -F
        apt-get autoremove --purge openvpn easy-rsa -y
        echo -e "$GREEN""########################################################"
        echo -e "$GREEN""# The OpenVPN server has been successfully uninstalled #"
        echo -e "$GREEN""########################################################""$DEFAULT"
        break
      ;;
      "Exit") #4rth choice
        break
      ;;
      *) #Else
        echo "Invalid choice."
      ;;
    esac
  done
fi
