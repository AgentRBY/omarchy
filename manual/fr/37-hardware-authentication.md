# Authentification matérielle

### Authentification par empreinte digitale

Beaucoup de portables sont dotés d'un capteur d'empreintes digitales pour l'authentification. Vous pouvez l'utiliser avec Omarchy en lançant _Configuration > Sécurité > Empreinte digitale_ dans le menu Omarchy (`Super + Space`).

Cela installera le paquet d'empreinte digitale, recueillera votre empreinte, la vérifiera, et vous serez prêt à utiliser votre empreinte pour déverrouiller depuis l'écran de verrouillage (que vous pouvez déclencher avec `Super + Ctrl + L`), passer en mode sudo et autoriser les invites système.

Quand le capot de votre portable est fermé, l'invite d'empreinte digitale est automatiquement ignorée, si bien que vous passez directement à l'invite de mot de passe au lieu d'attendre un capteur que vous ne pouvez pas atteindre. Si vous devez travailler sur un clavier externe sans capteur, appuyez simplement sur `CTRL + C` quand on vous demande votre empreinte pendant `sudo`.

Vous pouvez retirer l'authentification par empreinte digitale sous _Supprimer > Sécurité > Empreinte digitale_ dans le menu Omarchy.

### Authentification Fido2

Si vous utilisez un appareil Fido2, vous pouvez le configurer pour l'authentification `sudo` avec _Configuration > Sécurité > Fido2_ dans le menu Omarchy (`Super + Space`). Il couvre `sudo` et les invites d'autorisation système, mais pas le déverrouillage de votre ordinateur.

Vous pouvez retirer l'authentification Fido2 sous _Supprimer > Sécurité > Fido2_ dans le menu Omarchy.
