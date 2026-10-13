# Navigasjon

Alt i Omarchy skjer via tastaturet — _ALT!_ Når systemet først starter, kan du bokstavelig talt ikke gjøre en ting med musen alene. Men du kan trykke `Super + Space` for å vise Omarchy-menyen, og herfra kan du gjøre omtrent alt.

Men Omarchy-menyen er ikke engang ment å være hovedmåten å betjene systemet på mesteparten av tiden. Vi kan bli raskere enn det! Alle de viktigste applikasjonene er bundet direkte til individuelle snarveier. Du starter terminalen med `Super + Return` og en nettleser med `Super + Shift + Return`. Prøv å gjøre det ene etter det andre, og du ser magien i Hyprlands flislegging i aksjon:

 ![navigation-browser-terminal](images/navigation-browser-terminal.webp)

Du kan deretter trykke `Super + J` for å stable dem oppå hverandre i stedet for side ved side:

 ![navigation-stacked](images/navigation-stacked.webp)

Trykk `Super + J` igjen for å returnere dem til side-ved-side-posisjonene. Prøv deretter `Super + Shift + Arrow Right` mens du er på nettleseren for å bytte vinduer.

Prøv nå `Super + Ctrl + T` for å starte aktivitetsmonitoren. Den dukker opp som et flytende vindu. Du kan flislegge den med `Super + T` (og trykke det igjen for å gjøre den flytende igjen). Trykk nå `Super + Shift + F` for å åpne filbehandleren. Da får du et ryddig firedelt oppsett:

 ![navigation-fourway-tiling](images/navigation-fourway-tiling.webp)

Du navigerer mellom vinduet du vil ha aktivt med `Super + Arrow`. Det bytter fokus og flytter markøren til midten av den nye applikasjonen.

Hvis du trykker `Super + Shift + 2`, flytter du den gjeldende fokuserte applikasjonen til det andre arbeidsområdet. `Super + Shift + 1` flytter den tilbake. (Og `Super + Shift + Alt + 2` flytter den gjeldende fokuserte applikasjonen til det andre arbeidsområdet uten å bytte til det).

Hvis du holder nede `Super` og bruker musen til å klikke på et vindu, kan du omorganisere hvor det sitter. Hvis du holder `Super` og bruker høyre museknapp, kan du fritt endre størrelsen på vinduet.

Du lukker et vindu med `Super + W` eller `Super + Q` (og lukker alle vinduer med `Ctrl + Alt + Delete`).

Du kan også gå til fullskjerm med `Super + F`, eller til og med bare full bredde (og beholde menylinjen) med `Super + Alt + F`, eller fullskjerm inne i et vindu med `Super + Ctrl + F` (godt for YouTube!).

### Dwindle- kontra rullelayout

Omarchys standardlayout kalles dwindle. Den holder alle vinduene du åpner på ett enkelt arbeidsområde synlige til enhver tid, selv om den må krympe dem.

 ![navigation-dwindle-layout](images/navigation-dwindle-layout.webp)

Men du kan også velge å gjøre et arbeidsområde til rullelayouten, der vinduene stilles opp side ved side, utenfor den synlige kanten av skjermen. Du gjør ett enkelt arbeidsområde til denne layouten via `Super + L`.

Å trykke `Super + L` igjen gjør arbeidsområdet flytende, der vinduer overlapper fritt og du plasserer dem selv, og et tredje trykk returnerer det til dwindle. `Super + Alt + L` går gjennom dem den andre veien. Et vindu som uansett flyter — ett du har sprettet ut med `Super + T`, eller en app som alltid åpnes flytende — fortsetter å flyte når arbeidsområdet går tilbake til flislegging. Menylinjen markerer arbeidsområdet du er på med layouten dets: en firkant for dwindle, en sirkel for rulling, og en trekant for flytende. Å klikke det merket veksler også layouten.

 ![navigation-scrolling-layout](images/navigation-scrolling-layout.webp)

Valget er per arbeidsområde, og det holder seg. Så du kan holde arbeidsområde 1 på dwindle for surfing og arbeidsområde 2 på rulling for kode, og de kommer tilbake slik etter en omstart.

Hvis du ønsker å bruke rullelayouten som standard, kan du sette det i `~/.config/hypr/looknfeel.lua`:

```lua
hl.config({
  general = {
    layout = "scrolling",
  },
})
```

### Flytende arbeidsområder

Et flytende arbeidsområde fungerer som et tradisjonelt skrivebord: vinduer overlapper, og du flytter og dimensjonerer dem selv. Hvert vindu får en tittellinje i temaets farger, med knapper for å minimere, maksimere og lukke. `Super + M` minimerer også det fokuserte vinduet. Et minimert vindu venter i docken; klikk på appen dets for å hente det tilbake. Klikk et vindu for å bringe det frem. Endre størrelsen fra en hvilken som helst kant eller hjørne. Dobbeltklikk en tittellinje for å maksimere vinduet mens menylinjen holdes synlig, og igjen for å få tilbake den gamle størrelsen.

Et flytende arbeidsområde viser også en dock, med de festede appene dine, alt som kjører, og et rutenett av hver app bak apper-knappen, som `Super + Alt + Space` og _Apper_ i Omarchy-menyen også åpner. Høyreklikk en app på rutenettet, eller trykk `Delete`, for å avinstallere den. Klikk en app for å åpne den, eller for å bringe vinduet dets frem; klikk igjen for å bla gjennom vinduene dets. Midtklikk åpner et nytt vindu. Dra et ikon langs docken for å flytte det; å dra en kjørende app inn blant de andre beholder den der. Høyreklikk for å beholde en app i docken, ta den ut, eller avslutte den. Docken går av veien for et fullskjermsvindu. Høyreklikk apper-knappen for å flytte docken til en annen kant eller la den skjule seg til pekeren når kanten dens. Posisjonen er også under _Utløs > Utseende > Dock > Dockplassering_, og `omarchy dock position left` og `omarchy dock autohide on` setter begge fra en terminal. Apper du beholder i docken er falmet mens de ikke kjører.

Nye arbeidsområder, og alle du ikke har gitt en egen layout med `Super + L`, bruker standardlayouten. Å endre standarden nullstiller hvert arbeidsområde uten vinduer til den, mens ett med vinduer på seg beholder layouten det har. Velg den under _Utløs > Utseende > Arbeidsområdeoppsett_: Flislegging, Rulling eller Flytende. `omarchy-hyprland-workspace-layout-default scrolling` setter den fra en terminal.

### Gruppering av vinduer

Vinduer kan grupperes med `Super + G`. Når du først er i en gruppe, tilhører hvert vindu du starter mens det er aktivt gruppen. Du kan flytte mellom disse grupperte vinduene med `Super + Ctrl + Arrow Left/Right` eller `Super + Alt + 1/2/3/4` for å gå direkte til grupperte vinduer i rekkefølge.

Du kan flytte et vindu ut av grupperingen med `Super + Alt + G`, eller demontere hele gruppen ved å trykke `Super + G` igjen. Til slutt kan du flytte vinduer utenfor gruppen inn i den med `Super + Alt + Arrows`.

### Sprette ut vinduer

Du kan sprette et vindu ut av arbeidsområdeallokeringen med `Super + O`. Det fester det som et flytende vindu som følger deg til det arbeidsområdet du går til. Flott for videospillere og lignende.

 ![navigation-popped-window](images/navigation-popped-window.webp)

### Skrappute-arbeidsområde

Til slutt finnes det et spesielt skrappute-arbeidsområde som faller ned over det arbeidsområdet du er på, mye som en Quake-konsoll. Veksle det med `Super + Grave` eller `Super + S`, og plasser et vindu der med `Super + Shift + Grave` eller `Super + Alt + S`.

Det fungerer spesielt godt for en terminal som kjører en agent, eller for kontroller du vil samhandle raskt med uten å forlate gjeldende arbeidsområde. For å flytte et vindu av skrapputa, sender du det direkte til et annet arbeidsområde med noe slikt som `Super + Shift + 1`.

Mens skrapputa holder ett enkelt vindu, faller den ned som et sentrert panel i stedet for å spenne over skjermen. Legg en annen app på den, og den går tilbake til full bredde, slik at de to har plass til å sitte side ved side.

### Det tar litt å venne seg til!

Det tar litt tid å venne seg til å navigere skrivebordet på denne måten, men når du gjør det, blir det vanskelig å gå tilbake til en tradisjonell musdrevet skrivebordsopplevelse!
