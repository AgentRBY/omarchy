# Prise en main

Omarchy s'installe à l'aide d'une ISO. Vous pouvez choisir entre une installation sur disque entier, qui prend tout le disque, ou une installation dans l'espace libre, qui place Omarchy dans l'espace non alloué d'un disque — c'est ainsi que vous faites un double démarrage à côté de Windows ou d'un autre OS (voir [installation en double démarrage](50-dual-boot-install.md) — notez que vous devrez d'abord désactiver BitLocker dans Windows). Dans les deux cas, l'installation utilise par défaut le chiffrement complet, et l'option disque entier effacera le disque sélectionné, alors assurez-vous de faire une sauvegarde avant d'utiliser un disque existant !

[Téléchargez d'abord l'ISO Omarchy](https://omarchy.org/), mettez-la sur une clé USB (utilisez [balenaEtcher](https://etcher.balena.io/) sur Mac/Windows ou [caligula](https://github.com/ifd3f/caligula) sur Linux), et démarrez depuis la clé.

_Vous devez désactiver Secure Boot et/ou TPM dans le BIOS. Vous devez les désactiver pour pouvoir installer Omarchy. Ce sont des mécanismes de sécurité Microsoft pensés pour Windows et les distributions Linux affiliées à Microsoft._

Répondez ensuite aux questions de configuration, et confirmez-les comme ceci :

 ![install-config](images/install-config.webp)

Sélectionnez ensuite un disque pour votre installation, installez-vous confortablement et regardez le spectacle de l'installation. Elle peut se terminer en moins d'une minute sur les machines modernes les plus rapides, mais elle ne devrait pas prendre plus de 5 minutes même sur un ordinateur plus ancien.

 ![install-done](images/install-done.webp)

Vous êtes maintenant prêt pour Omarchy !

### Utilisez un clavier filaire ou 2,4 GHz !

Le chiffrement complet du disque ne vous permettra pas de saisir le mot de passe depuis un clavier Bluetooth au démarrage. Tout comme vous ne pouvez pas utiliser un clavier Bluetooth pour entrer dans le BIOS d'un PC. Vous aurez besoin d'un clavier qui utilise soit un dongle 2,4 GHz, soit un câble (ce qui est de toute façon bien mieux pour la latence !). Personnellement, j'adore le [Lofree Flow84](https://www.lofree.co/products/lofree-flow-the-smoothest-mechanical-keyboard) !

### Installer pour un autre propriétaire

Si vous configurez une machine pour quelqu'un d'autre — un membre de la famille, un nouvel employé, un acheteur — vous ne devriez pas répondre aux questions personnelles à sa place. Faites `Ctrl + C` sur le tout premier écran de l'installateur (la sélection du clavier), et Omarchy proposera de préparer la machine pour un autre propriétaire à la place. Le système s'installe tout de suite, mais toute la configuration personnelle — disposition du clavier, nom d'utilisateur, mot de passe — est différée jusqu'au premier démarrage de la machine. Le disque reste chiffré par défaut, et le mot de passe que le nouveau propriétaire choisit lors de ce premier démarrage devient aussi le mot de passe de chiffrement. (Une machine que vous utilisez déjà peut aussi être transmise sans réinstallation — voir [réinitialiser l'ordinateur](48-security.md).)

### Installations sans surveillance

L'ISO peut aussi s'installer complètement toute seule — sans clavier, sans assistant — lorsqu'on lui fournit sa configuration sur un second disque. C'est la façon d'utiliser Omarchy comme image de base pour les VM et les flottes de machines. Voir [installations sans surveillance](51-unattended-installs.md).

### Installations sans chiffrement

Omarchy est installé avec chiffrement par défaut. C'est le choix sûr et responsable pour tout ordinateur qui peut éventuellement être perdu ou volé. Vous ne voulez pas que quiconque ayant accès à votre matériel puisse obtenir vos données !

Mais dans des circonstances particulières, comme des installations Omarchy distantes sur des ordinateurs protégés ou des installations jetables sans données sensibles, vous pouvez vouloir installer sans chiffrement. Vous pouvez faire `Ctrl + C` lors de la confirmation du formatage du disque pour passer à une installation sans chiffrement.

### Langue

Omarchy parle 50 langues — le même ensemble qu'omarchy.org — et l'anglais est la valeur par défaut. Pour changer, ouvrez le menu Omarchy et allez dans _Configuration > Langue_, ou exécutez `omarchy language <code>` dans un terminal (`omarchy language list` affiche les codes). Le menu, le bureau et les propres notifications d'Omarchy changent de langue immédiatement, et les paramètres régionaux du système sont définis pour correspondre, de sorte que vos autres applications suivront à votre prochaine connexion.

### De l'aide si vous êtes bloqué

Si vous êtes bloqué, vous trouverez généralement quelqu'un prêt à aider dans le canal _#omarchy-help_ sur [le Discord de la communauté](https://omarchy.org/discord).
