# Navigacija

Vse v Omarchyju se zgodi prek tipkovnice — _VSE!_ Ko se sistem prvič zažene, dobesedno ničesar ne morete narediti samo z miško. Lahko pa pritisnete `Super + Space`, da razkrijete meni Omarchy, in od tu naprej naredite praktično vse.

Toda meni Omarchy večinoma niti ni mišljen kot glavni način upravljanja sistema. Lahko smo hitrejši od tega! Vse najpomembnejše aplikacije so vezane neposredno na posamezne bližnjice. Terminal zaženete s `Super + Return`, brskalnik pa s `Super + Shift + Return`. Poskusite eno za drugo in videli boste čarovnijo Hyprlandovega ploščičenja v akciji:

 ![navigation-browser-terminal](images/navigation-browser-terminal.webp)

Nato lahko pritisnete `Super + J`, da ju zložite eno nad drugo namesto drugo ob drugo:

 ![navigation-stacked](images/navigation-stacked.webp)

Znova pritisnite `Super + J`, da ju vrnete v položaj drugo ob drugo. Nato med uporabo brskalnika poskusite `Super + Shift + Arrow Right`, da zamenjate okni.

Zdaj poskusite `Super + Ctrl + T`, da zaženete nadzornik dejavnosti. Pojavil se bo kot lebdeče okno. Sploščičite ga lahko s `Super + T` (in to znova pritisnete, da znova lebdi). Zdaj pritisnite `Super + Shift + F`, da odprete upravljalnik datotek. Imeli boste urejeno štiridelno postavitev:

 ![navigation-fourway-tiling](images/navigation-fourway-tiling.webp)

Med oknoma, ki naj bosta aktivni, se pomikate s `Super + Arrow`. To bo preklopilo žarišče in premaknilo kazalnik na sredino nove aplikacije.

Če pritisnete `Super + Shift + 2`, boste trenutno osredotočeno aplikacijo premaknili na drugi delovni prostor. `Super + Shift + 1` jo premakne nazaj. (In `Super + Shift + Alt + 2` bo trenutno osredotočeno aplikacijo premaknil na drugi delovni prostor, ne da bi preklopil nanj).

Če držite `Super` in z miško kliknete okno, boste lahko prereuredili, kje sedi. Če držite `Super` in uporabite desni gumb miške, lahko oknu prosto spreminjate velikost.

Okno zaprete s `Super + W` ali `Super + Q` (vsa okna pa zaprete s `Ctrl + Alt + Delete`).

Lahko greste tudi na celoten zaslon s `Super + F` ali celo samo na celotno širino (z ohranjeno menijsko vrstico) s `Super + Alt + F` ali na celoten zaslon znotraj okna s `Super + Ctrl + F` (dobro za YouTube!).

### Postavitev dwindle proti drsenju

Privzeta postavitev Omarchyja se imenuje dwindle. Vsa okna, ki jih odprete na enem delovnem prostoru, ohranja vedno vidna, tudi če jih mora skrčiti.

 ![navigation-dwindle-layout](images/navigation-dwindle-layout.webp)

Ampak delovni prostor lahko spremenite tudi v drsečo postavitev, kjer so okna postrojena drugo ob drugo, onstran vidnega roba zaslona. En delovni prostor v to postavitev spremenite s `Super + L`.

Vnovičen pritisk `Super + L` delovni prostor spremeni v lebdečega, kjer se okna prosto prekrivajo in jih postavite sami, tretji pritisk pa ga vrne v dwindle. `Super + Alt + L` gre skozi njih v drugi smeri. Okno, ki tako ali tako lebdi — tisto, ki ste ga izvlekli s `Super + T`, ali aplikacija, ki se vedno odpre lebdeče — še naprej lebdi, ko gre delovni prostor nazaj v ploščice. Menijska vrstica delovni prostor, na katerem ste, označi z njegovo postavitvijo: kvadrat za dwindle, krog za drsenje in trikotnik za lebdenje. Klik te oznake postavitev prav tako krožno menja.

 ![navigation-scrolling-layout](images/navigation-scrolling-layout.webp)

Izbira velja za vsak delovni prostor posebej in obstane. Tako lahko delovni prostor 1 obdržite na dwindlu za brskanje, delovni prostor 2 pa na drsenju za kodo, in po vnovičnem zagonu se bosta vrnila takšna.

Če želite drsečo postavitev uporabljati kot privzeto, lahko to nastavite v `~/.config/hypr/looknfeel.lua`:

```lua
hl.config({
  general = {
    layout = "scrolling",
  },
})
```

### Lebdeči delovni prostori

Lebdeči delovni prostor deluje kot tradicionalno namizje: okna se prekrivajo, premikate in velikost pa jim spreminjate sami. Vsako okno dobi naslovno vrstico v barvah vaše teme, z gumbi za minimizacijo, maksimizacijo in zapiranje. `Super + M` minimizira tudi osredotočeno okno. Minimizirano okno čaka v doku; kliknite njegovo aplikacijo, da ga vrnete. Kliknite okno, da ga prinesete naprej. Velikost mu spreminjajte s katerega koli roba ali vogala. Dvokliknite naslovno vrstico, da maksimizirate okno in ohranite menijsko vrstico na vidiku, in znova, da dobite nazaj njegovo staro velikost.

Lebdeči delovni prostor prikazuje tudi dok z vašimi pripetimi aplikacijami, vsem, kar teče, in mrežo vsake aplikacije za gumbom za aplikacije, ki ga odprejo tudi `Super + Alt + Space` in _Apps_ v meniju Omarchy. Z desnim klikom aplikacijo na mreži ali s pritiskom `Delete` jo odstranite. Kliknite aplikacijo, da jo odprete ali da njeno okno prinesete naprej; znova kliknite, da kolesarite skozi njena okna. Srednji klik odpre novo okno. Povlecite ikono vzdolž doka, da jo premaknete; če delujočo aplikacijo povlečete med druge, tam ostane. Z desnim klikom aplikacijo obdržite v doku, jo vzamete ven ali zaprete. Dok se umakne celozaslonskemu oknu. Z desnim klikom gumba za aplikacije dok premaknete na drug rob ali poskrbite, da se skrije, dokler kazalnik ne doseže njegovega roba. Položaj je tudi pod _Trigger > Appearance > Dock > Dock Position_, `omarchy dock position left` in `omarchy dock autohide on` pa oboje nastavita iz terminala. Aplikacije, ki jih obdržite v doku, so blede, medtem ko ne tečejo.

Novi delovni prostori in vsi, ki jim s `Super + L` niste dali lastne postavitve, uporabljajo privzeto postavitev. Sprememba privzete ponastavi vsak delovni prostor brez oken nanjo, tisti z okni pa obdrži postavitev, ki jo ima. Izberete jo pod _Trigger > Appearance > Workspace Layout_: Ploščice, Drsenje ali Lebdeče. `omarchy-hyprland-workspace-layout-default scrolling` jo nastavi iz terminala.

### Združevanje oken

Okna je mogoče združevati s `Super + G`. Ko ste enkrat v skupini, bo vsako okno, ki ga zaženete, medtem ko je ta aktivna, pripadalo skupini. Med temi združenimi okni se premikate s `Super + Ctrl + Arrow Left/Right` ali s `Super + Alt + 1/2/3/4`, da greste neposredno na združeno okno po vrsti.

Okno lahko iz skupine premaknete s `Super + Alt + G` ali razstavite celotno skupino z vnovičnim pritiskom `Super + G`. Nazadnje lahko okna zunaj skupine premaknete vanjo s `Super + Alt + Arrows`.

### Izskakanje oken

Okno lahko izskočite iz njegove dodelitve delovnemu prostoru s `Super + O`. To ga bo pripelo kot lebdeče okno, ki vam sledi, na kateri koli delovni prostor greste. Odlično za predvajalnike videa in podobno.

 ![navigation-popped-window](images/navigation-popped-window.webp)

### Delovni prostor scratchpad

Nazadnje obstaja posebni delovni prostor scratchpad, ki se spusti čez kateri koli delovni prostor, na katerem ste trenutno, precej podobno kot konzola v igri Quake. Preklapljate ga s `Super + Grave` ali `Super + S`, okno pa tja postavite s `Super + Shift + Grave` ali `Super + Alt + S`.

Še posebej dobro deluje za terminal z zagnanim agentom ali za kontrolnike, s katerimi želite hitro komunicirati, ne da bi zapustili trenutni delovni prostor. Okno s scratchpada premaknete tako, da ga pošljete neposredno na drug delovni prostor z nečim, kot je `Super + Shift + 1`.

Medtem ko scratchpad vsebuje eno samo okno, se spusti kot usredinjena plošča, namesto da bi se raztegnil čez zaslon. Nanj dajte drugo aplikacijo in vrne se na celotno širino, tako da imata prostor, da sedita drugo ob drugo.

### Potrebno je nekaj navajanja!

Traja nekaj časa, da se navadite na takšno navigacijo po namizju, a ko vam to uspe, se bo težko vrniti na tradicionalno izkušnjo namizja, upravljano z miško!
