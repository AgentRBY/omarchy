# Pradžia

Omarchy diegiama naudojant ISO. Galite rinktis viso disko diegimą, kuris užima visą diską, arba diegimą į laisvą vietą, kuris Omarchy patalpina nepaskirstytoje disko vietoje — taip dvigubai paleidžiate ją kartu su Windows arba kita OS (žr. [dvigubo paleidimo diegimą](50-dual-boot-install.md) — atkreipkite dėmesį, kad pirmiausia turėsite išjungti BitLocker sistemoje Windows). Bet kuriuo atveju diegimas pagal numatytuosius nustatymus naudoja visą šifravimą, o viso disko parinktis ištrins pasirinktą diską, todėl prieš naudodami esamą būtinai pasidarykite atsarginę kopiją!

Pirmiausia [atsisiųskite Omarchy ISO](https://omarchy.org/), įrašykite jį į USB atmintinę (naudokite [balenaEtcher](https://etcher.balena.io/) sistemoje Mac/Windows arba [caligula](https://github.com/ifd3f/caligula) sistemoje Linux) ir paleiskite iš atmintinės.

_BIOS turite išjungti Secure Boot ir (arba) TPM. Turite juos išjungti, kad galėtumėte įdiegti Omarchy. Tai Microsoft saugos schemos, skirtos Windows ir su Microsoft susijusioms Linux distribucijoms._

Tada atsakykite į konfigūracijos klausimus ir patvirtinkite juos taip:

 ![install-config](images/install-config.webp)

Tada pasirinkite diską savo diegimui, atsiloškite ir stebėkite diegimo šou. Greičiausiuose šiuolaikiniuose kompiuteriuose tai galima atlikti greičiau nei per minutę, bet net ir senesniame kompiuteryje tai neturėtų užtrukti ilgiau nei 5 minutes.

 ![install-done](images/install-done.webp)

Dabar esate pasiruošę naudotis Omarchy!

### Naudokite laidinę arba 2.4ghz klaviatūrą!

Viso disko šifravimas neleis paleidžiant įvesti slaptažodžio iš Bluetooth klaviatūros. Lygiai taip pat negalite naudoti Bluetooth klaviatūros, kad PC įeitumėte į BIOS. Jums reikės klaviatūros, kuri naudoja 2.4ghz raktą arba kabelį (kuris bet kuriuo atveju daug malonesnis dėl delsos!). Asmeniškai man labai patinka [Lofree Flow84](https://www.lofree.co/products/lofree-flow-the-smoothest-mechanical-keyboard)!

### Diegimas kitam savininkui

Jei ruošiate kompiuterį kam nors kitam — šeimos nariui, naujam darbuotojui, pirkėjui — neturėtumėte atsakyti į asmeninius klausimus jų vardu. Pačiame pirmame diegimo programos ekrane (klaviatūros pasirinkime) paspauskite `Ctrl + C` ir Omarchy pasiūlys paruošti kompiuterį kitam savininkui. Sistema įdiegiama iš karto, bet visa asmeninė sąranka — klaviatūros išdėstymas, naudotojo vardas, slaptažodis — atidedama, kol kompiuteris bus paleistas pirmą kartą. Diskas vis tiek pagal numatytuosius nustatymus yra šifruojamas, o slaptažodis, kurį naujas savininkas pasirenka tą pirmą kartą paleisdamas, tampa ir šifravimo slaptažodžiu. (Kompiuterį, kurį jau naudojote, taip pat galima perduoti be perįdiegimo — žr. [kompiuterio atstatymą](48-security.md).)

### Neprižiūrimas diegimas

ISO taip pat gali įsidiegti visiškai savarankiškai — be klaviatūros, be vediklio — kai jo konfigūracija jam perduodama antrame diske. Taip Omarchy galima laikyti baziniu atvaizdu VM ir kompiuterių ūkiams. Žr. [neprižiūrimą diegimą](51-unattended-installs.md).

### Diegimas be šifravimo

Omarchy pagal numatytuosius nustatymus diegiama su šifravimu. Tai saugus ir atsakingas pasirinkimas bet kuriam kompiuteriui, kuris gali būti pamestas arba pavogtas. Juk nenorite, kad kas nors, turintis prieigą prie jūsų aparatinės įrangos, galėtų gauti jūsų duomenis!

Tačiau ypatingomis aplinkybėmis, pavyzdžiui, nuotoliniuose Omarchy diegimuose apsaugotuose kompiuteriuose arba vienkartiniuose diegimuose be jautrių duomenų, galite norėti diegti be šifravimo. Disko formatavimo patvirtinime galite paspausti `Ctrl + C`, kad pereitumėte prie diegimo be šifravimo.

### Kalba

Omarchy kalba 50 kalbų — tuo pačiu rinkiniu kaip omarchy.org — o anglų kalba yra numatytoji. Norėdami ją pakeisti, atidarykite Omarchy meniu ir eikite į _Nuostatos > Kalba_ arba terminale paleiskite `omarchy language <code>` (`omarchy language list` parodo kodus). Meniu, darbalaukis ir pačios Omarchy pranešimai kalbą pakeičia iš karto, o sistemos lokalė nustatoma atitinkamai, todėl kitos jūsų programos paseks paskui kitą kartą prisijungus.

### Pagalba, jei įstrigote

Jei įstrigsite, paprastai galite rasti žmogų, norintį padėti, kanale _#omarchy-help_ [bendruomenės Discord](https://omarchy.org/discord).
