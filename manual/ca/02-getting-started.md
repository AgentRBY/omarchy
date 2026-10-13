# Primers passos

Omarchy s'instal·la amb una ISO. Pots triar entre una instal·lació a disc complet, que ocupa tota la unitat, o una instal·lació en espai lliure, que posa Omarchy a l'espai sense assignar d'una unitat — així és com fas l'arrencada dual al costat de Windows o d'un altre sistema operatiu (vegeu [instal·lació amb arrencada dual](50-dual-boot-install.md) — tingueu en compte que primer haureu de desactivar BitLocker a Windows). En tots dos casos, la instal·lació utilitza per defecte el xifratge complet, i l'opció de disc complet esborrarà la unitat seleccionada, així que assegureu-vos de fer una còpia de seguretat abans de fer servir una unitat existent!

[Baixeu la ISO d'Omarchy](https://omarchy.org/) primer, poseu-la en una memòria USB (feu servir [balenaEtcher](https://etcher.balena.io/) a Mac/Windows o [caligula](https://github.com/ifd3f/caligula) a Linux) i arrenqueu des de la memòria.

_Heu de desactivar Secure Boot i/o TPM a la BIOS. Els heu de desactivar per poder instal·lar Omarchy. Són esquemes de seguretat de Microsoft pensats per a Windows i per a distribucions Linux afiliades a Microsoft._

Després responeu a les preguntes de configuració i confirmeu-les així:

 ![install-config](images/install-config.webp)

Després seleccioneu una unitat per a la vostra instal·lació, ajeu-vos i mireu l'espectacle de la instal·lació. Es pot fer en menys d'un minut a les màquines modernes més ràpides, però no hauria de trigar més de 5 minuts ni tan sols en un ordinador més vell.

 ![install-done](images/install-done.webp)

Ara ja esteu a punt per a Omarchy!

### Feu servir un teclat amb cable o de 2,4 GHz!

El xifratge complet del disc no us permetrà introduir la contrasenya des d'un teclat Bluetooth a l'arrencada. Igual que no podeu fer servir un teclat Bluetooth per entrar a la BIOS d'un PC. Us caldrà un teclat que faci servir o bé un adaptador de 2,4 GHz o bé un cable (que de totes maneres és molt millor per a la latència!). Personalment m'encanta el [Lofree Flow84](https://www.lofree.co/products/lofree-flow-the-smoothest-mechanical-keyboard)!

### Instal·lar per a un altre propietari

Si esteu configurant una màquina per a algú altre — un familiar, un empleat nou, un comprador — no hauríeu de respondre les preguntes personals en nom seu. Premeu `Ctrl + C` a la primera pantalla de l'instal·lador (la selecció de teclat) i Omarchy us oferirà preparar la màquina per a un altre propietari. El sistema s'instal·la immediatament, però tota la configuració personal — disposició del teclat, nom d'usuari, contrasenya — es posposa fins que la màquina arrenqui per primera vegada. La unitat continua xifrada per defecte, i la contrasenya que el nou propietari triï en aquesta primera arrencada esdevindrà també la contrasenya de xifratge. (Una màquina que ja heu estat fent servir també es pot lliurar sense reinstal·lar-la — vegeu [restablir l'ordinador](48-security.md).)

### Instal·lacions desateses

La ISO també es pot instal·lar completament sola — sense teclat, sense assistent — quan se li lliura la seva configuració en una segona unitat. Aquesta és la manera de tractar Omarchy com una imatge base per a màquines virtuals i màquines d'una flota. Vegeu [instal·lacions desateses](51-unattended-installs.md).

### Instal·lacions sense xifratge

Omarchy s'instal·la amb xifratge per defecte. És l'opció segura i responsable per a qualsevol ordinador que pugui perdre's o ser robat. No voleu que ningú amb accés al vostre maquinari pugui obtenir les vostres dades!

Però en circumstàncies especials, com ara instal·lacions remotes d'Omarchy en ordinadors protegits o instal·lacions provisionals sense dades sensibles, potser voleu instal·lar-lo sense xifratge. Podeu prémer `Ctrl + C` a la confirmació del format del disc per passar a una instal·lació sense xifratge.

### Idioma

Omarchy parla 50 idiomes — el mateix conjunt que omarchy.org — i l'anglès és l'idioma per defecte. Per canviar-lo, obriu el menú d'Omarchy i aneu a _Configuració > Idioma_, o executeu `omarchy language <code>` en un terminal (`omarchy language list` mostra els codis). El menú, l'escriptori i les notificacions pròpies d'Omarchy canvien d'idioma immediatament, i la configuració regional del sistema s'ajusta perquè coincideixi, de manera que les vostres altres aplicacions segueixin el canvi la propera vegada que inicieu sessió.

### Ajuda si us quedeu encallats

Si us quedeu encallats, normalment podeu trobar algú disposat a ajudar-vos al canal _#omarchy-help_ de [el Discord de la comunitat](https://omarchy.org/discord).
