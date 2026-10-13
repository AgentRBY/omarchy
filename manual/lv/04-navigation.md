# Navigācija

Viss Omarchy notiek, izmantojot tastatūru — _VISS!_ Kad sistēma pirmo reizi startē, tu burtiski neko nevari izdarīt tikai ar peli. Bet tu vari nospiest `Super + Space`, lai atklātu Omarchy izvēlni, un no šejienes tu vari darīt gandrīz visu.

Bet Omarchy izvēlne lielāko daļu laika pat nav paredzēta kā galvenais veids, kā darbināt sistēmu. Mēs varam kļūt ātrāki par to! Visas svarīgākās lietotnes ir tieši piesaistītas atsevišķām karstajām taustiņu kombinācijām. Termināli startē ar `Super + Return` un pārlūku ar `Super + Shift + Return`. Pamēģini vienu pēc otra, un tu redzēsi Hyprland mozaīkas burvību darbībā:

 ![navigation-browser-terminal](images/navigation-browser-terminal.webp)

Pēc tam vari nospiest `Super + J`, lai sakrautu tos vienu virs otra, nevis blakus:

 ![navigation-stacked](images/navigation-stacked.webp)

Nospied `Super + J` vēlreiz, lai atgrieztu tos blakus pozīcijās. Pēc tam pamēģini `Super + Shift + Arrow Right`, atrodoties pārlūkā, lai samainītu logus.

Tagad pamēģini `Super + Ctrl + T`, lai palaistu aktivitāšu monitoru. Tas parādīsies kā peldošs logs. Tu vari to ievietot mozaīkā, izmantojot `Super + T` (un nospiest to vēlreiz, lai atkal padarītu peldošu). Tagad nospied `Super + Shift + F`, lai atvērtu failu pārvaldnieku. Tev būs kārtīgs četrdaļīgs izkārtojums:

 ![navigation-fourway-tiling](images/navigation-fourway-tiling.webp)

Tu pārvietojies starp logu, kuru vēlies aktivizēt, ar `Super + Arrow`. Tas pārslēgs fokusu un pārvietos kursoru uz jaunās lietotnes centru.

Ja nospiedīsi `Super + Shift + 2`, tu pārvietosi pašlaik fokusēto lietotni uz otro darbvietu. `Super + Shift + 1` pārvieto to atpakaļ. (Un `Super + Shift + Alt + 2` pārvietos pašlaik fokusēto lietotni uz otro darbvietu, nepārslēdzoties uz to.)

Ja turēsi `Super` un izmantosi peli, lai noklikšķinātu uz loga, tu varēsi pārkārtot, kur tas sēž. Ja turēsi `Super` un izmantosi peles labo pogu, tu vari brīvi mainīt loga izmēru.

Logu aizver ar `Super + W` vai `Super + Q` (un visus logus aizver ar `Ctrl + Alt + Delete`).

Tu vari arī iet pilnekrānā ar `Super + F` vai pat tikai pilna platuma režīmā (saglabājot augšējo joslu) ar `Super + Alt + F` vai pilnekrānā loga iekšpusē ar `Super + Ctrl + F` (labs YouTube!).

### Dwindle pret ritināšanas izkārtojumu

Omarchy noklusējuma izkārtojumu sauc dwindle. Tas visus logus, ko atver vienā darbvietā, vienmēr tur redzamus, pat ja tam tie ir jāsarauj.

 ![navigation-dwindle-layout](images/navigation-dwindle-layout.webp)

Bet tu vari arī izvēlēties pārvērst darbvietu ritināšanas izkārtojumā, kur logi ir sarindoti blakus, aiz displeja redzamās malas. Vienu darbvietu šajā izkārtojumā pārvērš ar `Super + L`.

Nospiežot `Super + L` vēlreiz, darbvieta kļūst peldoša, kur logi brīvi pārklājas un tu tos novieto pats, un trešā nospiešana atgriež to uz dwindle. `Super + Alt + L` iziet cauri tiem pretējā virzienā. Logs, kas tik un tā peld — tāds, ko tu izcēli ar `Super + T`, vai lietotne, kas vienmēr atveras peldoša —, turpina peldēt, kad darbvieta atgriežas mozaīkā. Augšējā josla atzīmē darbvietu, kurā tu atrodies, ar tās izkārtojumu: kvadrāts dwindle, aplis ritināšanai un trijstūris peldošam. Noklikšķinot uz šīs atzīmes, arī tiek ciklēts izkārtojums.

 ![navigation-scrolling-layout](images/navigation-scrolling-layout.webp)

Izvēle ir katrai darbvietai, un tā saglabājas. Tāpēc tu vari turēt 1. darbvietu uz dwindle pārlūkošanai un 2. darbvietu uz ritināšanas kodam, un tās atgriezīsies tādas pēc restartēšanas.

Ja vēlies izmantot ritināšanas izkārtojumu kā noklusējumu, tu vari to iestatīt `~/.config/hypr/looknfeel.lua`:

```lua
hl.config({
  general = {
    layout = "scrolling",
  },
})
```

### Peldošās darbvietas

Peldošā darbvieta darbojas kā tradicionālā darbvirsma: logi pārklājas, un tu tos pārvieto un izmēri pats. Katram logam ir virsraksta josla tavas tēmas krāsās ar pogām, lai minimizētu, maksimizētu un aizvērtu. `Super + M` arī minimizē fokusēto logu. Minimizēts logs gaida dokā; noklikšķini uz tā lietotnes, lai to atgrieztu. Noklikšķini uz loga, lai to izvirzītu priekšā. Maini tā izmēru no jebkuras malas vai stūra. Veic dubultklikšķi uz virsraksta joslas, lai maksimizētu logu, saglabājot augšējo joslu redzamu, un vēlreiz, lai atgūtu tā veco izmēru.

Peldošā darbvieta rāda arī doku ar tavām piespraustajām lietotnēm, visu, kas darbojas, un visu lietotņu režģi aiz lietotņu pogas, ko atver arī `Super + Alt + Space` un _Lietotnes_ Omarchy izvēlnē. Ar labo pogu noklikšķini uz lietotnes režģī vai nospied `Delete`, lai to atinstalētu. Noklikšķini uz lietotnes, lai to atvērtu vai izvirzītu tās logu priekšā; noklikšķini vēlreiz, lai ciklētu cauri tās logiem. Vidējais klikšķis atver jaunu logu. Velc ikonu gar doku, lai to pārvietotu; ievelkot strādājošu lietotni starp pārējām, tā tur paliek. Ar labo pogu noklikšķini, lai paturētu lietotni dokā, izņemtu to ārā vai aizvērtu to. Doks pazūd no ceļa pilnekrāna logam. Ar labo pogu noklikšķini uz lietotņu pogas, lai pārvietotu doku uz citu malu vai lai tas paslēptos, līdz rādītājs sasniedz tā malu. Pozīcija ir arī zem _Palaist > Izskats > Doks > Doka vieta_, un `omarchy dock position left` un `omarchy dock autohide on` iestata abus no termināla. Lietotnes, ko tu turi dokā, ir izbalējušas, kamēr tās nedarbojas.

Jaunās darbvietas un jebkura, kurai neesi devis savu izkārtojumu ar `Super + L`, izmanto noklusējuma izkārtojumu. Mainot noklusējumu, katra darbvieta bez logiem tiek atiestatīta uz to, savukārt tā, kurā ir logi, patur izkārtojumu, kas tai ir. Izvēlies to zem _Palaist > Izskats > Darbvietas izkārtojums_: Mozaīka, Ritināšana vai Peldošs. `omarchy-hyprland-workspace-layout-default scrolling` iestata to no termināļa.

### Logu grupēšana

Logus var grupēt, izmantojot `Super + G`. Kad esi grupā, katrs logs, ko startē, kamēr tā ir aktīva, piederēs grupai. Starp šiem grupētajiem logiem vari pārvietoties, izmantojot `Super + Ctrl + Arrow Left/Right` vai `Super + Alt + 1/2/3/4`, lai dotos tieši uz grupētu logu pēc kārtas.

Logu ārā no grupējuma vari pārvietot ar `Super + Alt + G` vai izjaukt visu grupu, vēlreiz nospiežot `Super + G`. Visbeidzot, logus ārpus grupas vari pārvietot tajā ar `Super + Alt + Arrows`.

### Logu izcelšana

Logu vari izcelt ārā no tās darbvietas piešķiršanas ar `Super + O`. Tas to piespraudīs kā peldošu logu, kas seko tev uz jebkuru darbvietu, uz kuru tu dodies. Lieliski piemērots video atskaņotājiem un tamlīdzīgām lietām.

 ![navigation-popped-window](images/navigation-popped-window.webp)

### Piegružu darbvieta

Visbeidzot, ir īpaša piegružu darbvieta, kas nolaidžas virs jebkuras darbvietas, kurā tu pašlaik atrodies, līdzīgi kā Quake konsole. Pārslēdz to ar `Super + Grave` vai `Super + S` un novieto tur logu, izmantojot `Super + Shift + Grave` vai `Super + Alt + S`.

Tā darbojas īpaši labi terminālim, kurā darbojas aģents, vai vadīklām, ar kurām vēlies ātri mijiedarboties, nepametot pašreizējo darbvietu. Lai pārvietotu logu no piegružu darbvietas, nosūti to tieši uz citu darbvietu ar kaut ko līdzīgu `Super + Shift + 1`.

Kamēr piegružu darbvieta satur vienu logu, tā nolaidžas kā centrēts panelis, nevis aptver ekrānu. Ieliec tajā otru lietotni, un tā atgriežas pilna platuma režīmā, tāpēc abām ir vieta sēdēt blakus.

### Pie tā ir jāpierod!

Ir nepieciešams mazliet laika, lai pierastu pie šādas navigācijas savā darbvirsmā, bet, kad būsi pieradis, būs grūti atgriezties pie tradicionālās peles vadītās darbvirsmas pieredzes!
