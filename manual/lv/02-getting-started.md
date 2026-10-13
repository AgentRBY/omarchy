# Darba sākums

Omarchy instalē, izmantojot ISO. Tu vari izvēlēties starp pilna diska instalēšanu, kas pārņem visu disku, vai brīvās vietas instalēšanu, kas ievieto Omarchy nepiešķirtajā vietā diskā — tā tu veic dubultsāknēšanu līdzās Windows vai citai OS (skat. [dubultsāknēšanas instalēšana](50-dual-boot-install.md) — ņem vērā, ka vispirms Windows ir jāizslēdz BitLocker). Jebkurā gadījumā instalēšana pēc noklusējuma izmanto pilnu šifrēšanu, un pilna diska opcija izdzēsīs atlasīto disku, tāpēc pirms esoša diska izmantošanas noteikti izveido dublējumu!

[Lejupielādē Omarchy ISO](https://omarchy.org/) vispirms, ieliec to USB atmiņā (izmanto [balenaEtcher](https://etcher.balena.io/) Mac/Windows vai [caligula](https://github.com/ifd3f/caligula) Linux) un sāknē no atmiņas.

_Tev BIOS ir jāizslēdz Secure Boot un/vai TPM. Tev tie ir jāizslēdz, lai varētu instalēt Omarchy. Tās ir Microsoft drošības shēmas, kas paredzētas Windows un ar Microsoft saistītiem Linux izplatījumiem._

Pēc tam atbildi uz konfigurācijas jautājumiem un apstiprini tos šādi:

 ![install-config](images/install-config.webp)

Pēc tam atlasī disku savai instalēšanai un atslābinies, skatoties instalēšanas izrādi. Ātrākajās mūsdienu iekārtās to var izdarīt mazāk nekā minūtē, bet pat vecākā datorā tam nevajadzētu aizņemt vairāk par 5 minūtēm.

 ![install-done](images/install-done.webp)

Tagad tu esi gatavs Omarchy!

### Izmanto vadu vai 2.4 GHz tastatūru!

Pilnā diska šifrēšana neļaus tev startēšanas laikā ievadīt paroli no Bluetooth tastatūras. Tāpat kā tu nevari izmantot Bluetooth tastatūru, lai iekļūtu datora BIOS. Tev būs nepieciešama tastatūra, kas izmanto vai nu 2.4 GHz spraudni, vai kabeli (kas jebkurā gadījumā ir daudz patīkamāks latentuma ziņā!). Man personīgi ļoti patīk [Lofree Flow84](https://www.lofree.co/products/lofree-flow-the-smoothest-mechanical-keyboard)!

### Instalēšana citam īpašniekam

Ja tu iestati iekārtu kādam citam — ģimenes loceklim, jaunam darbiniekam, pircējam — tev nevajadzētu atbildēt uz personīgajiem jautājumiem viņa vietā. Nospied `Ctrl + C` instalētāja pašā pirmajā ekrānā (tastatūras atlasē), un Omarchy piedāvās tā vietā sagatavot iekārtu citam īpašniekam. Sistēma instalējas uzreiz, bet visa personiskā iestatīšana — tastatūras izkārtojums, lietotājvārds, parole — tiek atlikta līdz iekārtas pirmajai sāknēšanai. Disks joprojām pēc noklusējuma tiek šifrēts, un parole, ko jaunais īpašnieks izvēlas pirmajā sāknēšanas reizē, kļūst arī par šifrēšanas paroli. (Iekārtu, ko tu jau esi lietojis, var nodot arī bez pārinstalēšanas — skat. [datora atiestatīšana](48-security.md).)

### Bezuzraudzības instalēšana

ISO var arī instalēt pilnīgi pats — bez tastatūras, bez vedņa —, kad tam otrajā diskā nodod tā konfigurāciju. Tā Omarchy var izmantot kā bāzes attēlu virtuālajām mašīnām un iekārtu parkam. Skat. [bezuzraudzības instalēšana](51-unattended-installs.md).

### Instalēšana bez šifrēšanas

Omarchy pēc noklusējuma tiek instalēts ar šifrēšanu. Tā ir droša, atbildīga izvēle jebkuram datoram, ko var pazaudēt vai nozagt. Tu nevēlies, lai ikviens, kuram ir piekļuve tavai aparatūrai, varētu tikt pie taviem datiem!

Bet īpašos apstākļos, piemēram, attālās Omarchy instalācijās aizsargātos datoros vai vienreizējās instalācijās bez sensitīviem datiem, tu varētu vēlēties instalēt bez šifrēšanas. Diska formatēšanas apstiprinājumā vari nospiest `Ctrl + C`, lai pārslēgtos uz instalēšanu bez šifrēšanas.

### Valoda

Omarchy runā 50 valodās — tajā pašā kopā kā omarchy.org — un angļu valoda ir noklusējuma. Lai pārslēgtu, atver Omarchy izvēlni un ej uz _Iestatīšana > Valoda_ vai terminālī palaid `omarchy language <code>` (`omarchy language list` rāda kodus). Izvēlne, darbvirsma un paša Omarchy paziņojumi maina valodu uzreiz, un sistēmas lokāle tiek iestatīta atbilstoši, tāpēc tavas pārējās lietotnes sekos nākamajā pieteikšanās reizē.

### Palīdzība, ja esi iestrēdzis

Ja iestrēgsti, parasti vari atrast kādu, kas vēlas palīdzēt, kanālā _#omarchy-help_ [kopienas Discord](https://omarchy.org/discord).
