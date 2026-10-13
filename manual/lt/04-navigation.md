# Naršymas

Viskas Omarchy vyksta per klaviatūrą — _VISKAS!_ Kai sistema pirmą kartą paleidžiama, jūs tiesiogine prasme nieko negalite padaryti vien pele. Bet galite paspausti `Super + Space`, kad atidengtumėte Omarchy meniu, ir iš čia galite padaryti beveik viską.

Tačiau Omarchy meniu net nėra numatytas kaip pagrindinis būdas valdyti sistemą didžiąją laiko dalį. Galime būti greitesni! Visos svarbiausios programos yra tiesiogiai susietos su atskirais sparčiaisiais klavišais. Terminalą paleidžiate su `Super + Return`, o naršyklę su `Super + Shift + Return`. Pabandykite tai padaryti vieną po kito ir pamatysite Hyprland plytelių išdėstymo magiją veikiant:

 ![navigation-browser-terminal](images/navigation-browser-terminal.webp)

Tada galite paspausti `Super + J`, kad sukrautumėte juos vieną ant kito, o ne greta:

 ![navigation-stacked](images/navigation-stacked.webp)

Paspauskite `Super + J` dar kartą, kad grąžintumėte juos į padėtį greta. Tada, būdami naršyklėje, pabandykite `Super + Shift + Arrow Right`, kad sukeistumėte langus.

Dabar pabandykite `Super + Ctrl + T`, kad paleistumėte Activity monitorių. Jis pasirodys kaip plūduriuojantis langas. Galite jį pridėti prie plytelių naudodami `Super + T` (ir paspausti tai dar kartą, kad vėl taptų plūduriuojantis). Dabar paspauskite `Super + Shift + F`, kad atidarytumėte failų tvarkyklę. Turėsite tvarkingą keturių dalių sąranką:

 ![navigation-fourway-tiling](images/navigation-fourway-tiling.webp)

Tarp langų, kuriuos norite matyti aktyvius, naršote su `Super + Arrow`. Tai perjungs fokusą ir perkels žymeklį į naujos programos centrą.

Jei paspausite `Super + Shift + 2`, dabartinę sufokusuotą programą perkelsite į antrą darbo sritį. `Super + Shift + 1` perkelia ją atgal. (O `Super + Shift + Alt + 2` perkels dabartinę sufokusuotą programą į antrą darbo sritį nepereinant į ją).

Jei laikysite nuspaudę `Super` ir pele spustelėsite langą, galėsite pertvarkyti, kur jis yra. Jei laikysite `Super` ir naudosite dešinįjį pelės mygtuką, galėsite laisvai keisti lango dydį.

Langą uždarote su `Super + W` arba `Super + Q` (o visus langus uždarote su `Ctrl + Alt + Delete`).

Taip pat galite pereiti į visą ekraną su `Super + F` arba net tiesiog į visą plotį (paliekant viršutinę juostą) su `Super + Alt + F`, arba į visą ekraną lango viduje su `Super + Ctrl + F` (gerai YouTube!).

### Dwindle ir slenkantis išdėstymas

Numatytasis Omarchy išdėstymas vadinamas dwindle. Jis visą laiką laiko visus langus, kuriuos atidarote vienoje darbo srityje, matomus, net jei turi juos sumažinti.

 ![navigation-dwindle-layout](images/navigation-dwindle-layout.webp)

Tačiau taip pat galite pasirinkti darbo sritį paversti slenkančiu išdėstymu, kuriame langai išrikiuojami greta, už matomo ekrano krašto. Vieną darbo sritį į šį išdėstymą perjungiate per `Super + L`.

Pakartotinis `Super + L` paspaudimas darbo sritį paverčia plūduriuojančia, kurioje langai laisvai persidengia ir juos išdėstote patys, o trečias paspaudimas grąžina ją į dwindle. `Super + Alt + L` pereina per juos kita kryptimi. Langas, kuris vis tiek plūduriuoja — toks, kurį išstūmėte su `Super + T`, arba programa, kuri visada atsidaro plūduriuojanti — toliau plūduriuoja, kai darbo sritis grįžta į plytelių išdėstymą. Viršutinė juosta pažymi darbo sritį, kurioje esate, jos išdėstymu: kvadratas dwindle, apskritimas slinkimui ir trikampis plūduriuojantiems. Spustelėjus tą ženklą, išdėstymas taip pat keičiasi cikliškai.

 ![navigation-scrolling-layout](images/navigation-scrolling-layout.webp)

Pasirinkimas yra atskiros darbo srities ir jis išlieka. Taigi galite 1 darbo sritį laikyti dwindle naršymui, o 2 darbo sritį slinkimui kodui, ir jos taip sugrįš po paleidimo iš naujo.

Jei norite naudoti slenkantį išdėstymą kaip numatytąjį, galite tai nustatyti `~/.config/hypr/looknfeel.lua`:

```lua
hl.config({
  general = {
    layout = "scrolling",
  },
})
```

### Plūduriuojančios darbo sritys

Plūduriuojanti darbo sritis veikia kaip tradicinis darbalaukis: langai persidengia, o jūs juos perkeliate ir keičiate jų dydį patys. Kiekvienas langas gauna pavadinimo juostą jūsų temos spalvomis su mygtukais sumažinti, padidinti ir uždaryti. `Super + M` taip pat sumažina sufokusuotą langą. Sumažintas langas laukia dock; spustelėkite jo programą, kad jį sugrąžintumėte. Spustelėkite langą, kad jį iškeltumėte į priekį. Keiskite jo dydį iš bet kurio krašto ar kampo. Dukart spustelėkite pavadinimo juostą, kad padidintumėte langą paliekant viršutinę juostą matomą, ir dar kartą, kad sugrąžintumėte seną jo dydį.

Plūduriuojanti darbo sritis taip pat rodo dock su prisegtomis jūsų programomis, viskuo, kas veikia, ir visų programų tinkleliu už programų mygtuko, kurį taip pat atidaro `Super + Alt + Space` ir _Programos_ Omarchy meniu. Dešiniuoju mygtuku spustelėkite programą tinklelyje arba paspauskite `Delete`, kad ją pašalintumėte. Spustelėkite programą, kad ją atidarytumėte arba iškeltumėte jos langą į priekį; spustelėkite dar kartą, kad cikliškai pereitumėte per jos langus. Vidurinis spustelėjimas atidaro naują langą. Vilkite piktogramą palei dock, kad ją perkeltumėte; įtraukus veikiančią programą tarp kitų, ji ten lieka. Dešiniuoju mygtuku spustelėkite, kad programą paliktumėte dock, išimtumėte ją arba ją uždarytumėte. Dock pasitraukia nuo viso ekrano lango. Dešiniuoju mygtuku spustelėkite programų mygtuką, kad perkeltumėte dock prie kito krašto arba kad jis slėptųsi, kol žymeklis pasieks jo kraštą. Padėtis taip pat yra _Veiksmai > Išvaizda > Dock > Dock padėtis_, o `omarchy dock position left` ir `omarchy dock autohide on` abu nustato iš terminalo. Programos, kurias laikote dock, yra išblukusios, kol jos neveikia.

Naujos darbo sritys ir visos, kurioms su `Super + L` nesuteikėte savo išdėstymo, naudoja numatytąjį išdėstymą. Numatytojo keitimas atstato į jį kiekvieną darbo sritį be langų, o turinti langų išlaiko turimą išdėstymą. Pasirinkite jį _Veiksmai > Išvaizda > Darbo srities išdėstymas_: Plytelės, Slinkimas arba Plūduriuojantys. `omarchy-hyprland-workspace-layout-default scrolling` nustato tai iš terminalo.

### Langų grupavimas

Langus galima grupuoti naudojant `Super + G`. Kai esate grupėje, kiekvienas langas, kurį paleisite, kol tai aktyvu, priklausys grupei. Tarp šių sugrupuotų langų galite judėti naudodami `Super + Ctrl + Arrow Left/Right` arba `Super + Alt + 1/2/3/4`, kad iš eilės pereitumėte tiesiai į sugrupuotą langą.

Langą iš grupavimo galite perkelti su `Super + Alt + G` arba išardyti visą grupę dar kartą paspaudus `Super + G`. Galiausiai su `Super + Alt + Arrows` galite perkelti langus, esančius už grupės, į ją.

### Langų išstūmimas

Langą iš jo darbo srities paskyrimo galite išstumti su `Super + O`. Tai prisegs jį kaip plūduriuojantį langą, kuris seka jus į bet kurią darbo sritį, į kurią eisite. Puiku vaizdo grotuvams ir panašiems.

 ![navigation-popped-window](images/navigation-popped-window.webp)

### Scratchpad darbo sritis

Galiausiai yra speciali scratchpad darbo sritis, kuri nusileidžia ant bet kurios darbo srities, kurioje šiuo metu esate, panašiai kaip Quake konsolė. Perjunkite ją su `Super + Grave` arba `Super + S` ir padėkite ten langą naudodami `Super + Shift + Grave` arba `Super + Alt + S`.

Ji ypač gerai tinka terminalui, kuriame veikia agentas, arba valdikliams, su kuriais norite greitai sąveikauti nepalikdami dabartinės darbo srities. Norėdami perkelti langą iš scratchpad, nusiųskite jį tiesiai į kitą darbo sritį su kažkuo panašiu į `Super + Shift + 1`.

Kol scratchpad laiko vieną langą, jis nusileidžia kaip centruotas skydelis, o ne apima visą ekraną. Padėkite ant jo antrą programą ir jis sugrįš į visą plotį, kad abiem būtų vietos sėdėti greta.

### Reikia šiek tiek priprasti!

Prie tokio naršymo darbalaukyje reikia šiek tiek laiko priprasti, bet kai priprasite, bus sunku grįžti prie tradicinės, pele valdomos darbalaukio patirties!
