# Aparatūras autentifikācija

### Pirksta nospieduma autentifikācija

Daudzos klēpjdatoros autentifikācijai ir pirksta nospieduma sensors. Omarchy to varat izmantot, Omarchy izvēlnē (`Super + Space`) palaižot _Iestatīšana > Drošība > Pirksta nospiedums_.

Tas instalēs pirksta nospieduma pakotni, paņems jūsu nospiedumu, pārbaudīs to, un jūs varēsiet ar pirksta nospiedumu atbloķēt no bloķēšanas ekrāna (ko varat izsaukt ar `Super + Ctrl + L`), pāriet sudo režīmā un autorizēt sistēmas uzvednes.

Kad klēpjdatora vāks ir aizvērts, pirksta nospieduma uzvedne tiek automātiski izlaista, tāpēc uzreiz nonākat pie paroles uzvednes, nevis gaidāt sensoru, ko nevarat aizsniegt. Ja citādi jāstrādā ar ārēju tastatūru bez sensora, vienkārši nospiediet `CTRL + C`, kad `sudo` laikā jums prasa pirksta nospiedumu.

Pirksta nospieduma autentifikāciju varat noņemt Omarchy izvēlnē sadaļā _Noņemt > Drošība > Pirksta nospiedums_.

### Fido2 autentifikācija

Ja izmantojat Fido2 ierīci, varat to iestatīt `sudo` autentifikācijai Omarchy izvēlnē (`Super + Space`) sadaļā _Iestatīšana > Drošība > Fido2_. Tomēr tas attiecas uz `sudo` un sistēmas autorizācijas uzvednēm, nevis datora atbloķēšanu.

Fido2 autentifikāciju varat noņemt Omarchy izvēlnē sadaļā _Noņemt > Drošība > Fido2_.
