# OpenVPN-install
Ce script Bash vous permet d'installer un serveur OpenVPN simplement et rapidement sous Debian 8 *uniquement*.

Un article sur mon blog au sujet de ce script est en cours de rédaction.

###Utilisation
Voici les 3 commandes à rentrer :

`wget https://github.com/Angristan/OpenVPN-install/blob/master/openvpn-install.sh`

`chmod +x openvpn-install.sh`

`./openvpn-install.sh`

Le script vous permet de faire 2 choses : installer OpenVPN ou créer un utilisateur.
La deuxième option ne fonctionne bien évidemment que si vous avez effectué la première.
Vous pouvez relancer ce script autant de fois que vous le voulez pour créer des utilisateurs.

###Quel serveur utiliser ?
Ce script marchera sur :
- Serveur dédié
- VPS VMware et KVM
- VPS OpenVZ avec le module TUN/TAP (vous pouvez en trouver chez [PulseHeberg](http://manager.pulseheberg.com/aff.php?aff=1204))
