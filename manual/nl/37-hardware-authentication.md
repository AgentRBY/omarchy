# Hardware-authenticatie

### Vingerafdruk-authenticatie

Veel laptops hebben een vingerafdruksensor voor authenticatie. Je kunt die gebruiken met Omarchy door _Instellen > Security > Fingerprint_ uit te voeren in het Omarchy-menu (`Super + Space`).

Dat installeert het vingerafdrukpakket, verzamelt je afdruk, verifieert hem, en je kunt aan de slag met je vingerafdruk om te ontgrendelen vanaf het vergrendelscherm (dat je kunt activeren met `Super + Ctrl + L`), de sudo-modus in te gaan en systeemprompts te autoriseren.

Als het deksel van je laptop dicht is, wordt de vingerafdrukprompt automatisch overgeslagen, zodat je direct naar de wachtwoordprompt gaat in plaats van te wachten op een sensor waar je niet bij kunt. Als je anderszins moet werken op een extern toetsenbord zonder sensor, druk dan gewoon op `CTRL + C` wanneer je tijdens `sudo` om je vingerafdruk wordt gevraagd.

Je kunt de vingerafdruk-authenticatie verwijderen onder _Verwijderen > Security > Fingerprint_ in het Omarchy-menu.

### Fido2-authenticatie

Als je een Fido2-apparaat gebruikt, kun je het instellen voor `sudo`-authenticatie via _Instellen > Security > Fido2_ in het Omarchy-menu (`Super + Space`). Het dekt echter `sudo` en systeemautorisatieprompts, niet het ontgrendelen van je computer.

Je kunt de fido2-authenticatie verwijderen onder _Verwijderen > Security > Fido2_ in het Omarchy-menu.
