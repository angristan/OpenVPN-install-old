# OpenVPN-install
Ce script Bash vous permet d'installer un serveur OpenVPN simplement et rapidement sous Debian 8 *uniquement*.

Un article sur mon blog au sujet de ce script est en cours de rédaction.

## Utilisation
Voici les 3 commandes à rentrer :

`wget https://raw.githubusercontent.com/Angristan/OpenVPN-install/master/openvpn-install.sh`

`chmod +x openvpn-install.sh`

`./openvpn-install.sh`

Le script vous permet de faire 3 choses : installer OpenVPN, créer un utilisateur (client) et désinstaller complètement OpenVPN. La deuxième option ne fonctionne bien évidemment que si vous avez effectué la première.

Vous pouvez relancer ce script autant de fois que vous le voulez pour créer des utilisateurs.

## Quel serveur utiliser ?
Ce script marchera sur :
- Serveur dédié
- VPS VMware et KVM
- VPS OpenVZ avec le module TUN/TAP activé (vous pouvez en trouver chez [PulseHeberg](http://manager.pulseheberg.com/aff.php?aff=1204))

## Contact

http://angristan.fr/contact/

## Licence

[GNU GPL v2.0](https://github.com/Angristan/OpenVPN-install/blob/master/LICENSE)
