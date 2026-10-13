# Preverjanje pristnosti s strojno opremo

### Preverjanje pristnosti s prstnim odtisom

Veliko prenosnikov ima senzor prstnega odtisa za preverjanje pristnosti. To lahko uporabljate z Omarchyjem tako, da v meniju Omarchy (`Super + Space`) zaženete _Nastavitve > Security > Fingerprint_.

S tem namestite paket za prstne odtise, zberete svoj odtis, ga preverite in ste pripravljeni uporabljati prstni odtis za odklepanje z zaklepanja zaslona (ki ga lahko sprožite s `Super + Ctrl + L`), vstop v način sudo in avtorizacijo sistemskih pozivov.

Ko je pokrov prenosnika zaprt, se poziv za prstni odtis samodejno preskoči, tako da greste naravnost na poziv za geslo, namesto da čakate na senzor, ki ga ne morete doseči. Če morate sicer delati na zunanji tipkovnici, ki nima senzorja, med `sudo` preprosto pritisnite `CTRL + C`, ko vas sistem pozove k prstnemu odtisu.

Preverjanje pristnosti s prstnim odtisom lahko odstranite pod _Odstrani > Security > Fingerprint_ v meniju Omarchy.

### Preverjanje pristnosti Fido2

Če uporabljate napravo Fido2, jo lahko nastavite za preverjanje pristnosti `sudo` prek _Nastavitve > Security > Fido2_ v meniju Omarchy (`Super + Space`). Pokriva pozive za `sudo` in sistemsko avtorizacijo, vendar ne odklepanja računalnika.

Preverjanje pristnosti fido2 lahko odstranite pod _Odstrani > Security > Fido2_ v meniju Omarchy.
