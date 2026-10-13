# Első lépések

Az Omarchy telepítése ISO-ból történik. Választhatsz a teljes lemezes telepítés között, amely átveszi az egész meghajtót, vagy a szabad helyre telepítés között, amely az Omarchyt a meghajtó ki nem osztott területére teszi — így tudsz dual bootolni Windows vagy egy másik operációs rendszer mellett (lásd a [dual-boot telepítést](50-dual-boot-install.md) — vedd figyelembe, hogy ehhez először ki kell kapcsolnod a BitLockert Windowsban). Akárhogy is, a telepítés alapértelmezetten teljes titkosítással történik, és a teljes lemezes opció letörli a kiválasztott meghajtót, úgyhogy mindenképpen készíts biztonsági mentést, mielőtt egy meglévőt használsz!

Először [töltsd le az Omarchy ISO-t](https://omarchy.org/), tedd egy USB-memóriára (Macen/Windowson használd a [balenaEtchert](https://etcher.balena.io/), Linuxon a [caligulát](https://github.com/ifd3f/caligula)), és arról indítsd el a gépet.

_Ki kell kapcsolnod a Secure Bootot és/vagy a TPM-et a BIOS-ban. Ezeket ki kell kapcsolnod ahhoz, hogy telepíteni tudd az Omarchyt. Ezek a Microsoft biztonsági sémái, amelyek Windowsra és a Microsofttal kapcsolatban álló Linux-disztribúciókra valók._

Ezután válaszolj a konfigurációs kérdésekre, és erősítsd meg őket így:

 ![install-config](images/install-config.webp)

Ezután válassz meghajtót a telepítéshez, dőlj hátra, és nézd végig a telepítési show-t. A leggyorsabb modern gépeken egy perc alatt megvan, de még egy régebbi számítógépen sem tart tovább 5 percnél.

 ![install-done](images/install-done.webp)

Most már készen állsz az Omarchyra!

### Használj vezetékes vagy 2.4ghz-es billentyűzetet!

A teljes lemezes titkosítás nem engedi, hogy induláskor Bluetooth-billentyűzetről írd be a jelszót. Ugyanúgy, ahogy Bluetooth-billentyűzettel nem tudsz belépni a BIOS-ba egy PC-n. Olyan billentyűzetre lesz szükséged, amely vagy 2.4ghz-es dongle-t, vagy kábelt használ (ami egyébként a késleltetés szempontjából is sokkal nicer!). Én személy szerint imádom a [Lofree Flow84-et](https://www.lofree.co/products/lofree-flow-the-smoothest-mechanical-keyboard)!

### Telepítés egy másik tulajdonosnak

Ha valaki másnak — egy családtagnak, egy új munkavállalónak, egy vevőnek — állítasz be egy gépet, nem kellene az ő személyes kérdéseikre az ő nevükben válaszolnod. Nyomd meg a `Ctrl + C` kombinációt a telepítő legelső képernyőjén (a billentyűzetválasztáson), és az Omarchy felajánlja, hogy ehelyett előkészíti a gépet egy másik tulajdonosnak. A rendszer azonnal települ, de minden személyes beállítás — billentyűzetkiosztás, felhasználónév, jelszó — addig halasztódik, amíg a gép először el nem indul. A meghajtó továbbra is alapértelmezetten titkosított, és a jelszó, amelyet az új tulajdonos az első induláskor választ, lesz a titkosítási jelszó is. (Egy már használt gép újratelepítés nélkül is átadható — lásd [a számítógép alaphelyzetbe állítását](48-security.md).)

### Felügyelet nélküli telepítések

Az ISO teljesen önállóan is tud telepíteni — billentyűzet és varázsló nélkül —, ha egy második meghajtón megkapja a konfigurációját. Így érdemes az Omarchyt VM-ek és flottagépek alapképfájljaként kezelni. Lásd a [felügyelet nélküli telepítéseket](51-unattended-installs.md).

### Titkosítás nélküli telepítések

Az Omarchy alapértelmezetten titkosítással települ. Ez a biztonságos, felelős választás minden számítógépre, amelyet esetleg elveszíthetsz vagy ellophatnak. Nem akarod, hogy bárki, aki hozzáfér a hardveredhez, hozzájusson az adataidhoz!

De különleges körülmények között, például távoli Omarchy-telepítések védett számítógépeken, vagy érzékeny adatok nélküli eldobható telepítések esetén, érdemes lehet titkosítás nélkül telepíteni. A lemezformázás megerősítésénél a `Ctrl + C` megnyomásával átválthatsz titkosítás nélküli telepítésre.

### Nyelv

Az Omarchy 50 nyelven beszél — ugyanabban a készletben, mint az omarchy.org —, és az alapértelmezett nyelv az angol. A váltáshoz nyisd meg az Omarchy menüt, és menj a _Beállítás > Nyelv_ pontra, vagy futtasd terminálban az `omarchy language <code>` parancsot (az `omarchy language list` mutatja a kódokat). A menü, az asztal és az Omarchy saját értesítései azonnal nyelvet váltanak, és a rendszer területi beállítása is ennek megfelelően állítódik be, így a többi alkalmazásod a következő bejelentkezéskor követi.

### Segítség, ha elakadsz

Ha elakadsz, általában találsz valakit, aki hajlandó segíteni a _#omarchy-help_ csatornán [a közösségi Discordon](https://omarchy.org/discord).
