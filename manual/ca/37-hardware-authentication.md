# Autenticació per maquinari

### Autenticació per empremta digital

Molts portàtils venen amb un sensor d'empremta digital per fer l'autenticació. Pots fer-lo servir amb Omarchy executant _Configuració > Seguretat > Empremta digital_ al menú d'Omarchy (`Super + Space`).

Això instal·larà el paquet d'empremta digital, recollirà la teva empremta, la verificarà, i ja estaràs a punt per fer servir l'empremta per desbloquejar des de la pantalla de bloqueig (que pots activar amb `Super + Ctrl + L`), entrar en mode sudo i autoritzar les sol·licituds del sistema.

Quan la tapa del portàtil està tancada, la sol·licitud d'empremta digital se salta automàticament, de manera que vas directament a la sol·licitud de contrasenya en comptes d'esperar un sensor al qual no pots arribar. Si, altrament, necessites treballar amb un teclat extern que no té sensor, només cal que premis `CTRL + C` quan se't demani l'empremta digital durant `sudo`.

Pots eliminar l'autenticació per empremta digital a _Elimina > Seguretat > Empremta digital_ al menú d'Omarchy.

### Autenticació Fido2

Si fas servir un dispositiu Fido2, el pots configurar per a l'autenticació de `sudo` fent servir _Configuració > Seguretat > Fido2_ al menú d'Omarchy (`Super + Space`). Tanmateix, cobreix `sudo` i les sol·licituds d'autorització del sistema, no el desbloqueig de l'ordinador.

Pots eliminar l'autenticació Fido2 a _Elimina > Seguretat > Fido2_ al menú d'Omarchy.
