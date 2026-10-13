# Navigacija

Sve u Omarchyju događa se putem tipkovnice — _SVE!_ Kada se sustav prvi put pokrene, doslovno ne možete učiniti ništa samo mišem. Ali možete pritisnuti `Super + Space` da otkrijete Omarchy izbornik i odavde radite gotovo sve.

Ali Omarchy izbornik čak ni nije zamišljen kao glavni način upravljanja sustavom većinu vremena. Možemo brže od toga! Sve najvažnije aplikacije vezane su izravno na pojedinačne prečace. Terminal pokrećete prečacom `Super + Return`, a preglednik prečacom `Super + Shift + Return`. Pokušajte napraviti jedno za drugim i vidjet ćete čaroliju Hyprlandova popločavanja u akciji:

 ![navigation-browser-terminal](images/navigation-browser-terminal.webp)

Zatim možete pritisnuti `Super + J` da ih naslažete jedan na drugi umjesto jedan pored drugoga:

 ![navigation-stacked](images/navigation-stacked.webp)

Ponovno pritisnite `Super + J` da ih vratite u položaj jedan pored drugoga. Zatim pokušajte `Super + Shift + Arrow Right` dok ste na pregledniku da zamijenite prozore.

Sada pokušajte `Super + Ctrl + T` da pokrenete monitor aktivnosti. Pojavit će se kao plutajući prozor. Možete ga popločati prečacom `Super + T` (i ponovno ga pritisnuti da opet postane plutajući). Sada pritisnite `Super + Shift + F` da otvorite upravitelj datoteka. Imat ćete uredan četverostruki raspored:

 ![navigation-fourway-tiling](images/navigation-fourway-tiling.webp)

Između prozora kojega želite učiniti aktivnim krećete se prečacom `Super + Arrow`. To će prebaciti fokus i pomaknuti pokazivač u središte nove aplikacije.

Ako pritisnete `Super + Shift + 2`, premjestit ćete trenutačno fokusiranu aplikaciju na drugi radni prostor. `Super + Shift + 1` vraća je natrag. (A `Super + Shift + Alt + 2` premjestit će trenutačno fokusiranu aplikaciju na drugi radni prostor bez prebacivanja na njega).

Ako držite `Super` i mišem kliknete na prozor, moći ćete preurediti mjesto gdje sjedi. Ako držite `Super` i koristite desnu tipku miša, možete slobodno mijenjati veličinu prozora.

Prozor zatvarate prečacom `Super + W` ili `Super + Q` (a sve prozore zatvarate prečacom `Ctrl + Alt + Delete`).

Možete ići i na cijeli zaslon prečacom `Super + F` ili čak samo na cijelu širinu (zadržavajući gornju traku) prečacom `Super + Alt + F` ili na cijeli zaslon unutar prozora prečacom `Super + Ctrl + F` (dobro za YouTube!).

### Dwindle u odnosu na raspored s pomicanjem

Omarchyjev zadani raspored naziva se dwindle. Svi prozori koje otvorite na jednome radnome prostoru u svakom trenutku ostaju vidljivi, čak i ako ih mora smanjiti.

 ![navigation-dwindle-layout](images/navigation-dwindle-layout.webp)

Ali radni prostor možete pretvoriti i u raspored s pomicanjem, u kojemu su prozori poredani jedan pored drugoga, izvan vidljivoga ruba zaslona. Jedan radni prostor u taj raspored pretvarate prečacom `Super + L`.

Ponovni pritisak na `Super + L` pretvara radni prostor u plutajući, u kojemu se prozori slobodno preklapaju i sami ih smještate, a treći pritisak vraća ga na dwindle. `Super + Alt + L` prolazi kroz njih drugim smjerom. Prozor koji ionako pluta — onaj koji ste izbacili prečacom `Super + T` ili aplikacija koja se uvijek otvara plutajući — nastavlja plutati kada se radni prostor vrati na popločavanje. Gornja traka označava radni prostor na kojemu se nalazite njegovim rasporedom: kvadrat za dwindle, krug za pomicanje i trokut za plutanje. Klikom na tu oznaku također se kruži kroz rasporede.

 ![navigation-scrolling-layout](images/navigation-scrolling-layout.webp)

Odabir je po radnome prostoru i ostaje. Dakle radni prostor 1 možete držati na dwindle za pregledavanje, a radni prostor 2 na pomicanju za kod, i takvi će se vratiti nakon ponovnoga pokretanja.

Ako raspored s pomicanjem želite koristiti kao zadani, to možete postaviti u `~/.config/hypr/looknfeel.lua`:

```lua
hl.config({
  general = {
    layout = "scrolling",
  },
})
```

### Plutajući radni prostori

Plutajući radni prostor radi poput tradicionalne radne površine: prozori se preklapaju, a vi ih sami pomičete i mijenjate im veličinu. Svaki prozor dobiva naslovnu traku u bojama vaše teme, s tipkama za minimiziranje, maksimiziranje i zatvaranje. `Super + M` također minimizira fokusirani prozor. Minimizirani prozor čeka u docku; kliknite njegovu aplikaciju da ga vratite. Kliknite prozor da ga izvučete naprijed. Mijenjajte mu veličinu s bilo kojega ruba ili kuta. Dvaput kliknite naslovnu traku da maksimizirate prozor zadržavajući gornju traku u vidiku, a ponovno da vratite njegovu staru veličinu.

Plutajući radni prostor također prikazuje dock, s vašim prikvačenim aplikacijama, svime što se izvodi i mrežom svake aplikacije iza tipke za aplikacije, što `Super + Alt + Space` i _Aplikacije_ u Omarchy izborniku također otvaraju. Desnom tipkom miša kliknite aplikaciju na mreži ili pritisnite `Delete` da je deinstalirate. Kliknite aplikaciju da je otvorite ili da njezin prozor izvučete naprijed; kliknite ponovno da kružite kroz njezine prozore. Srednji klik otvara novi prozor. Povucite ikonu duž docka da je pomaknete; povlačenje pokrenute aplikacije među ostale zadržava je ondje. Desnom tipkom miša kliknite da aplikaciju zadržite u docku, izvadite je ili je zatvorite. Dock se miče s puta prozoru na cijelom zaslonu. Desnom tipkom miša kliknite tipku za aplikacije da dock premjestite na drugi rub ili da se skriva dok pokazivač ne dosegne njegov rub. Položaj se nalazi i pod _Pokreni > Izgled > Dock > Položaj docka_, a `omarchy dock position left` i `omarchy dock autohide on` postavljaju oboje iz terminala. Aplikacije koje držite u docku izblijedjele su dok se ne izvode.

Novi radni prostori i svi kojima niste dali vlastiti raspored prečacom `Super + L` koriste zadani raspored. Promjena zadanoga vraća svaki radni prostor bez prozora na njega, dok onaj s prozorima zadržava raspored koji ima. Odaberite ga pod _Pokreni > Izgled > Raspored radnog prostora_: Popločavanje, Pomicanje ili Plutanje. `omarchy-hyprland-workspace-layout-default scrolling` postavlja ga iz terminala.

### Grupiranje prozora

Prozori se mogu grupirati pomoću `Super + G`. Jednom kada ste u grupi, svaki prozor koji pokrenete dok je to aktivno pripadat će grupi. Između tih grupiranih prozora možete se kretati pomoću `Super + Ctrl + Arrow Left/Right` ili `Super + Alt + 1/2/3/4` za izravan odlazak na grupirani prozor po redu.

Prozor možete pomaknuti iz grupiranja prečacom `Super + Alt + G` ili rastaviti cijelu grupu ponovnim pritiskom na `Super + G`. Na kraju, prozore izvan grupe možete u nju pomaknuti prečacom `Super + Alt + Arrows`.

### Izbacivanje prozora

Prozor možete izbaciti iz njegove radne prostorne dodjele prečacom `Super + O`. To će ga prikvačiti kao plutajući prozor koji vas prati na koji god radni prostor odete. Sjajno za videoplayere i slično.

 ![navigation-popped-window](images/navigation-popped-window.webp)

### Radni prostor bilježnice

Na kraju, tu je posebni radni prostor bilježnice koji se spušta preko radnoga prostora na kojemu se trenutačno nalazite, poput Quake konzole. Prebacujte ga prečacom `Super + Grave` ili `Super + S`, a prozor ondje smjestite prečacom `Super + Shift + Grave` ili `Super + Alt + S`.

Posebno dobro radi za terminal u kojemu se izvodi agent ili za kontrole s kojima želite brzo komunicirati bez napuštanja trenutačnoga radnoga prostora. Da prozor pomaknete s bilježnice, pošaljite ga izravno na drugi radni prostor nečim poput `Super + Shift + 1`.

Dok bilježnica drži jedan prozor, spušta se kao središnja ploča, a ne da se proteže preko zaslona. Stavite drugu aplikaciju na nju i vraća se na punu širinu, pa njih dvoje imaju prostora sjediti jedan pored drugoga.

### Treba se malo naviknuti!

Treba malo vremena da se naviknete na ovakvu navigaciju radnom površinom, ali jednom kada to učinite, bit će teško vratiti se tradicionalnome iskustvu radne površine vođenu mišem!
