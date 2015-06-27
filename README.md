# OpenVPN-install
Ce script Bash vous permet d'installer un serveur OpenVPN simplement et rapidement sous Debian 8 *uniquement*.

###Utilisation
Voici les 3 commandes à rentrer :

`wget https://github.com/Angristan/OpenVPN-install/blob/master/openvpn-install.sh`
`chmod +x openvpn-install.sh`
`./openvpn-install.sh`

Le script vous permet de faire 2 choses : installer OpenVPN ou créer un utilisateur.
La deuxième option ne fonctionne bien évidemment que si vous avez effectué la première.
Vous pouvez relancer ce script autant de fois que vous le voulez pour créer des utilisateurs.

###Quel serveur utiliser ?
Ce script marchera sur tout serveur dédié utilisant Debian 8, et sur les VPS OpenVZ ayant le module TUN/TAP d'activé.
Je vous conseille [PulseHeberg](http://manager.pulseheberg.com/aff.php?aff=1204), qui propose des VPS où vous pouvez activer ce module. Ils disposent d'uene très bonne bande passante avec traffic illimité et à petit prix, et cela dans plusieurs pays.
