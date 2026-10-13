# Početak rada

Omarchy se instalira pomoću ISO-a. Možete odabrati instalaciju na cijeli disk, koja preuzima cijeli pogon, ili instalaciju u slobodan prostor, koja Omarchy smješta u nedodijeljeni prostor na pogonu — tako se izvodi dvostruko pokretanje uz Windows ili drugi OS (pogledajte [instalaciju s dvostrukim pokretanjem](50-dual-boot-install.md) — imajte na umu da ćete prvo morati isključiti BitLocker u Windowsu). U svakom slučaju instalacija prema zadanim postavkama koristi potpuno šifriranje, a opcija cijeloga diska obrisat će odabrani pogon, pa prije korištenja postojećega svakako napravite sigurnosnu kopiju!

Prvo [preuzmite Omarchy ISO](https://omarchy.org/), stavite ga na USB memoriju (na Macu/Windowsu koristite [balenaEtcher](https://etcher.balena.io/), a na Linuxu [caligulu](https://github.com/ifd3f/caligula)) i pokrenite sustav s memorije.

_Morate isključiti Secure Boot i/ili TPM u BIOS-u. Morate ih isključiti da biste mogli instalirati Omarchy. To su Microsoftove sigurnosne sheme namijenjene Windowsu i Linux distribucijama povezanim s Microsoftom._

Zatim odgovorite na konfiguracijska pitanja i potvrdite ih ovako:

 ![install-config](images/install-config.webp)

Zatim odaberite pogon za instalaciju, zavalite se i uživajte u instalacijskoj predstavi. Na najbržim suvremenim strojevima može biti gotova za manje od minute, ali ni na starijem računalu ne bi trebala trajati dulje od 5 minuta.

 ![install-done](images/install-done.webp)

Sada ste spremni za Omarchy!

### Koristite žičanu ili tipkovnicu na 2,4 ghz!

Potpuno šifriranje diska neće vam dopustiti unos lozinke s Bluetooth tipkovnice pri pokretanju. Kao što na PC-u ne možete koristiti Bluetooth tipkovnicu za ulazak u BIOS. Trebat će vam tipkovnica koja koristi prijamnik na 2,4 ghz ili kabel (što je ionako puno bolje za latenciju!). Osobno obožavam [Lofree Flow84](https://www.lofree.co/products/lofree-flow-the-smoothest-mechanical-keyboard)!

### Instaliranje za drugoga vlasnika

Ako postavljate stroj za nekoga drugoga — člana obitelji, novoga zaposlenika, kupca — ne biste trebali odgovarati na osobna pitanja u njihovo ime. Pritisnite `Ctrl + C` na samome prvome zaslonu instalacijskoga programa (odabir tipkovnice) i Omarchy će umjesto toga ponuditi pripremu stroja za drugoga vlasnika. Sustav se odmah instalira, ali sva osobna postavljanja — raspored tipkovnice, korisničko ime, lozinka — odgađaju se do prvoga pokretanja stroja. Pogon je i dalje prema zadanim postavkama šifriran, a lozinka koju novi vlasnik odabere pri tome prvome pokretanju postaje i lozinka za šifriranje. (Stroj koji ste već koristili također se može predati bez ponovne instalacije — pogledajte [resetiranje računala](48-security.md).)

### Instalacije bez nadzora

ISO se također može instalirati potpuno sam — bez tipkovnice, bez čarobnjaka — kada mu se konfiguracija preda na drugome pogonu. Tako se Omarchy tretira kao osnovna slika za virtualne strojeve i flote strojeva. Pogledajte [instalacije bez nadzora](51-unattended-installs.md).

### Instalacije bez šifriranja

Omarchy se prema zadanim postavkama instalira sa šifriranjem. To je siguran, odgovoran izbor za svako računalo koje se može izgubiti ili biti ukradeno. Ne želite da itko s pristupom vašem hardveru može doći do vaših podataka!

Ali u posebnim okolnostima, poput udaljenih Omarchy instalacija na zaštićenim računalima ili za jednokratne instalacije bez osjetljivih podataka, možda ćete htjeti instalirati bez šifriranja. Na potvrdi formatiranja diska možete pritisnuti `Ctrl + C` da biste se prebacili na instalaciju bez šifriranja.

### Jezik

Omarchy govori 50 jezika — isti skup kao omarchy.org — a engleski je zadani. Za promjenu otvorite Omarchy izbornik i idite na _Postavke > Jezik_ ili pokrenite `omarchy language <code>` u terminalu (`omarchy language list` prikazuje kodove). Izbornik, radna površina i Omarchyjeve vlastite obavijesti odmah mijenjaju jezik, a lokalizacija sustava postavlja se tako da odgovara, pa vaše ostale aplikacije slijede pri sljedećoj prijavi.

### Pomoć ako zapnete

Ako zapnete, obično možete pronaći nekoga voljnoga pomoći u kanalu _#omarchy-help_ na [Discord serveru zajednice](https://omarchy.org/discord).
