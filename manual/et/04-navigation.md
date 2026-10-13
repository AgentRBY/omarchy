# Navigeerimine

Kõik Omarchys toimub klaviatuuri kaudu — _KÕIK!_ Kui süsteem esimest korda käivitub, ei saa sa sõna otseses mõttes ainuüksi hiirega midagi teha. Kuid saad vajutada `Super + Space`, et avada Omarchy menüü, ja siit saad teha peaaegu kõike.

Kuid Omarchy menüü ei olegi enamasti mõeldud süsteemi kasutamise peamiseks viisiks. Saame kiiremini! Kõik kõige olulisemad rakendused on seotud otse üksikute kiirklahvidega. Käivitad terminali `Super + Return` ja brauseri `Super + Shift + Return`. Proovi teha ühte teise järel ja näed Hyprlandi plaatide võlu tegutsemas:

 ![navigation-browser-terminal](images/navigation-browser-terminal.webp)

Seejärel saad vajutada `Super + J`, et need üksteise peale virnastada, mitte kõrvuti:

 ![navigation-stacked](images/navigation-stacked.webp)

Vajuta `Super + J` uuesti, et need kõrvuti asendisse tagasi panna. Seejärel proovi `Super + Shift + Arrow Right`, kui oled brauseril, et aknad vahetada.

Nüüd proovi `Super + Ctrl + T`, et käivitada Activity monitor. See ilmub ujuva aknana. Saad selle paigutada `Super + T` abil (ja vajuta seda uuesti, et see taas ujukiks teha). Nüüd vajuta `Super + Shift + F`, et avada failihaldur. Sul on kena neljapoolne paigutus:

 ![navigation-fourway-tiling](images/navigation-fourway-tiling.webp)

Navigeerid akende vahel, mida soovid aktiivseks muuta, `Super + Arrow` abil. See vahetab fookust ja liigutab kursori uue rakenduse keskele.

Kui vajutad `Super + Shift + 2`, liigutad parasjagu fookuses oleva rakenduse teisele tööalale. `Super + Shift + 1` liigutab selle tagasi. (Ja `Super + Shift + Alt + 2` liigutab parasjagu fookuses oleva rakenduse teisele tööalale, ilma sellele lülitumata).

Kui hoiad `Super` all ja kasutad hiirt aknal klõpsamiseks, saad ümber paigutada, kus see asub. Kui hoiad `Super` all ja kasutad hiire paremat nuppu, saad akna suurust vabalt muuta.

Sulged akna `Super + W` või `Super + Q` pealt (ja sulged kõik aknad `Ctrl + Alt + Delete` pealt).

Saad minna ka täisekraanile `Super + F` abil või isegi lihtsalt täislaiusesse (menüüriba säilitades) `Super + Alt + F` abil või täisekraanile akna sees `Super + Ctrl + F` abil (hea YouTube'i jaoks!).

### Dwindle vs kerimise paigutus

Omarchy vaikepaigutust nimetatakse dwindle'iks. See hoiab kõik aknad, mille ühel tööalal avad, kogu aeg nähtavana, isegi kui peab neid väiksemaks kahandama.

 ![navigation-dwindle-layout](images/navigation-dwindle-layout.webp)

Kuid saad valida ka tööala kerimise paigutuseks muutmise, kus aknad on rivistatud kõrvuti, ekraani nähtavast servast kaugemal. Muudad ühe tööala selleks paigutuseks `Super + L` kaudu.

`Super + L` uuesti vajutamine muudab tööala ujuvaks, kus aknad katuvad vabalt ja sa paigutad need ise, ja kolmas vajutus viib selle tagasi dwindle'i juurde. `Super + Alt + L` käib need läbi teistpidi. Aken, mis niikuinii ujub — üks, mille `Super + T` abil välja hüppasid, või rakendus, mis avaneb alati ujuvana — jääb ujuma, kui tööala läheb plaatide juurde tagasi. Menüüriba tähistab tööala, millel oled, selle paigutusega: ruut dwindle'i puhul, ring kerimise puhul ja kolmnurk ujuva puhul. Sellel tähisel klõpsamine vahetab ka paigutust.

 ![navigation-scrolling-layout](images/navigation-scrolling-layout.webp)

Valik on tööalaspetsiifiline ja see jääb püsima. Nii saad tööala 1 hoida dwindle'il sirvimiseks ja tööala 2 kerimisel koodi jaoks ning need tulevad pärast taaskäivitust samamoodi tagasi.

Kui soovid kasutada kerimise paigutust vaikimisi, saad selle seada failis `~/.config/hypr/looknfeel.lua`:

```lua
hl.config({
  general = {
    layout = "scrolling",
  },
})
```

### Ujuvad tööalad

Ujuv tööala töötab nagu traditsiooniline töölaud: aknad katuvad ja sa liigutad ning muudad nende suurust ise. Iga aken saab tiitliriba sinu teema värvides, nuppudega minimeerimiseks, maksimeerimiseks ja sulgemiseks. `Super + M` minimeerib fookuses oleva akna samuti. Minimeeritud aken ootab dokis; klõpsa selle rakendust, et see tagasi tuua. Klõpsa akent, et see ette tuua. Muuda selle suurust mis tahes servast või nurgast. Tee tiitliribal topeltklõps, et aken maksimeerida, hoides menüüriba nähtaval, ja uuesti, et selle vana suurus tagasi saada.

Ujuv tööala näitab ka dokki koos kinnitatud rakendustega, kõigega, mis töötab, ja ruudustikuga igast rakendusest rakenduste nupu taga, mille `Super + Alt + Space` ja Omarchy menüüs _Rakendused_ samuti avavad. Tee rakendusel ruudustikul paremklõps või vajuta `Delete`, et see desinstallida. Klõpsa rakendust, et see avada või selle aken ette tuua; klõpsa uuesti, et selle akende vahel ringelda. Keskmine klõps avab uue akna. Lohista ikooni mööda dokki, et seda liigutada; töötava rakenduse lohistamine teiste sekka hoiab selle seal. Tee paremklõps, et rakendus dokis hoida, see sealt välja võtta või sellest väljuda. Dokk läheb täisekraani akna eest kõrvale. Tee rakenduste nupul paremklõps, et dokk teise serva liigutada või lasta sellel peituda, kuni kursor selle servani jõuab. Asukoht on ka _Käivita > Välimus > Dokk > Doki asukoht_ all ning `omarchy dock position left` ja `omarchy dock autohide on` seavad mõlemad terminalist. Rakendused, mida dokis hoiad, on tuhmistatud, kui need ei tööta.

Uued tööalad ja kõik, millele sa pole `Super + L` abil oma paigutust andnud, kasutavad vaikepaigutust. Vaikepaigutuse muutmine lähtestab iga akendeta tööala sellele, samas kui akendega tööala säilitab paigutuse, mis sellel on. Vali see _Käivita > Välimus > Tööala paigutus_ alt: Plaaditud, Kerimine või Ujuv. `omarchy-hyprland-workspace-layout-default scrolling` seab selle terminalist.

### Akende rühmitamine

Aknaid saab rühmitada `Super + G` abil. Kui oled rühmas, kuulub iga aken, mille selle aktiivsusel käivitad, rühma. Nende rühmitatud akende vahel saad liikuda `Super + Ctrl + Arrow Left/Right` või `Super + Alt + 1/2/3/4` abil, et minna otse rühmitatud akna juurde järjestuses.

Saad akna rühmitusest välja liigutada `Super + Alt + G` abil või kogu rühma lahti võtta, vajutades `Super + G` uuesti. Lõpuks saad rühma välised aknad selle sisse liigutada `Super + Alt + Arrows` abil.

### Akende väljahüppamine

Saad akna selle tööala jaotusest välja hüppata `Super + O` abil. See kinnitab selle ujuva aknana, mis järgneb sulle, mis tahes tööalale lähed. Suurepärane videopleierite ja muu sarnase jaoks.

 ![navigation-popped-window](images/navigation-popped-window.webp)

### Scratchpadi tööala

Lõpuks on olemas spetsiaalne scratchpadi tööala, mis langeb alla selle tööala peale, millel parasjagu oled, paljuski nagu Quake'i konsool. Lülita seda `Super + Grave` või `Super + S` abil ja paiguta aken sinna `Super + Shift + Grave` või `Super + Alt + S` abil.

See töötab eriti hästi terminali korral, mis käitab agenti, või juhtelementide korral, millega soovid kiiresti suhelda, lahkumata praeguselt tööalalt. Akna scratchpadilt ära liigutamiseks saada see otse teisele tööalale millegi sellisega nagu `Super + Shift + 1`.

Kui scratchpadil on üks aken, langeb see alla keskele asetatud paneelina, mitte ei ulatu üle ekraani. Pane sellele teine rakendus ja see läheb tagasi täislaiusesse, nii et kahel on ruumi kõrvuti istuda.

### Sellega harjumine võtab aega!

Töölaual niimoodi navigeerimisega harjumine võtab veidi aega, kuid kui sellega harjud, on raske traditsioonilise hiirega juhitava töölauakogemuse juurde tagasi minna!
