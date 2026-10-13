# Hardvérová autentifikácia

### Autentifikácia odtlačkom prsta

Mnoho notebookov má snímač odtlačkov prstov na autentifikáciu. Môžete ho používať s Omarchy spustením časti _Nastavenie > Security > Fingerprint_ v ponuke Omarchy (`Super + Space`).

Tým sa nainštaluje balík pre odtlačky prstov, zaznamená sa váš odtlačok, overí sa a ste pripravení používať odtlačok prsta na odomknutie zo zamknutej obrazovky (ktorú môžete vyvolať skratkou `Super + Ctrl + L`), na vstup do režimu sudo a na autorizáciu systémových výziev.

Keď je veko notebooku zatvorené, výzva na odtlačok prsta sa automaticky preskočí, takže prejdete rovno na výzvu na zadanie hesla, namiesto toho, aby ste čakali na snímač, na ktorý nedosiahnete. Ak inak potrebujete pracovať na externej klávesnici, ktorá snímač nemá, stačí stlačiť `CTRL + C`, keď sa vás systém počas `sudo` pýta na odtlačok prsta.

Autentifikáciu odtlačkom prsta môžete odstrániť v časti _Odstrániť > Security > Fingerprint_ v ponuke Omarchy.

### Autentifikácia Fido2

Ak používate zariadenie Fido2, môžete ho nastaviť na autentifikáciu cez `sudo` v časti _Nastavenie > Security > Fido2_ v ponuke Omarchy (`Super + Space`). Pokrýva však `sudo` a výzvy na autorizáciu systému, nie odomykanie počítača.

Autentifikáciu fido2 môžete odstrániť v časti _Odstrániť > Security > Fido2_ v ponuke Omarchy.
