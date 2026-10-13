# Alustamine

Omarchy paigaldatakse ISO abil. Saad valida täisketta paigalduse, mis võtab kogu draivi üle, või vaba ruumi paigalduse, mis paneb Omarchy draivi jaotamata ruumi — nii saad topeltkäivitada Windowsi või mõne muu operatsioonisüsteemi kõrval (vt [topeltkäivituse paigaldus](50-dual-boot-install.md) — pane tähele, et pead Windowsis esmalt BitLockeri välja lülitama). Mõlemal juhul on paigalduse vaikimisi valikuks täielik krüpteerimine ja täisketta valik kustutab valitud draivi, nii et tee enne olemasoleva kasutamist kindlasti varukoopia!

[Laadi Omarchy ISO alla](https://omarchy.org/) esmalt, pane see USB-mälupulgale (kasuta Macil/Windowsil [balenaEtcherit](https://etcher.balena.io/) või Linuxil [caligulat](https://github.com/ifd3f/caligula)) ja käivita pulgalt.

_Pead BIOSis välja lülitama Secure Booti ja/või TPMi. Pead need välja lülitama, et saaksid Omarchy paigaldada. Need on Microsofti turbeskeemid, mis on mõeldud Windowsile ja Microsoftiga seotud Linuxi distributsioonidele._

Seejärel vasta seadistusküsimustele ja kinnita need nii:

 ![install-config](images/install-config.webp)

Seejärel vali paigalduseks draiv ning istu maha ja vaata paigaldusetendust. See võib kiireimatel kaasaegsetel masinatel valmis saada vähem kui minutiga, kuid isegi vanemal arvutil ei tohiks see võtta rohkem kui 5 minutit.

 ![install-done](images/install-done.webp)

Nüüd oled valmis Omarchyt kasutama!

### Kasuta juhtmega või 2,4ghz klaviatuuri!

Täisketta krüpteerimine ei luba sul käivitamisel Bluetoothi klaviatuurlt parooli sisestada. Nii nagu sa ei saa arvutil Bluetoothi klaviatuuriga BIOSisse siseneda. Vajad klaviatuuri, mis kasutab kas 2,4ghz donglit või kaablit (mis on latentsuse mõttes niikuinii palju parem!). Mulle isiklikult meeldib väga [Lofree Flow84](https://www.lofree.co/products/lofree-flow-the-smoothest-mechanical-keyboard)!

### Paigaldamine teisele omanikule

Kui seadistad masinat kellelegi teisele — pereliikmele, uuele töötajale, ostjale — ei peaks sa isiklikele küsimustele tema eest vastama. Vajuta `Ctrl + C` paigaldaja päris esimesel ekraanil (klaviatuurivalik) ja Omarchy pakub masinat hoopis teisele omanikule ette valmistada. Süsteem paigaldatakse kohe, kuid kogu isiklik seadistus — klaviatuuripaigutus, kasutajanimi, parool — lükatakse edasi ajani, mil masin esimest korda käivitub. Draiv on vaikimisi endiselt krüpteeritud ja parool, mille uus omanik sellel esimesel käivitusel valib, saab ka krüpteerimisparooliks. (Masina, mida oled juba kasutanud, saab üle anda ka ilma uuesti paigaldamata — vt [arvuti lähtestamine](48-security.md).)

### Järelevalveta paigaldused

ISO saab paigaldada ka täiesti iseseisvalt — ilma klaviatuuri, ilma viisardita — kui sellele antakse seadistus teisel draivil. Nii saab Omarchyt kasutada virtuaalmasinate ja masinaparkide baaskujutisena. Vt [järelevalveta paigaldused](51-unattended-installs.md).

### Krüpteerimiseta paigaldused

Omarchy paigaldatakse vaikimisi krüpteerimisega. See on turvaline ja vastutustundlik valik iga arvuti puhul, mis võib kaduda või varastatuks osutuda. Sa ei taha, et igaüks, kellel on juurdepääs su riistvarale, saaks ligi su andmetele!

Kuid erilistes oludes, näiteks kaug-Omarchy paigalduste korral kaitstud arvutitel või äraviskamispaigalduste korral ilma tundlike andmeteta, võid soovida paigaldada ilma krüpteerimiseta. Saad vajutada `Ctrl + C` ketta vormindamise kinnitusel, et lülituda krüpteerimiseta paigaldusele.

### Keel

Omarchy räägib 50 keelt — sama valikut mis omarchy.org — ja inglise keel on vaikimisi. Vahetamiseks ava Omarchy menüü ja mine _Seaded > Keel_ või käivita terminalis `omarchy language <code>` (`omarchy language list` näitab koode). Menüü, töölaud ja Omarchy enda teavitused vahetavad keelt kohe ning süsteemi lokaat seatakse vastavaks, nii et su teised rakendused järgivad seda järgmisel sisselogimisel.

### Abi, kui jääd hätta

Kui jääd hätta, leiad tavaliselt kellegi, kes aitab, [kogukonna Discordi](https://omarchy.org/discord) kanalil _#omarchy-help_.
