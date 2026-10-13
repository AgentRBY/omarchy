# Navigácia

Všetko v Omarchy sa deje cez klávesnicu — _VŠETKO!_ Keď sa systém prvýkrát spustí, doslova nemôžete urobiť nič len s myšou. Ale môžete stlačiť `Super + Space`, aby ste odhalili menu Omarchy, a odtiaľto môžete robiť takmer všetko.

Ale menu Omarchy väčšinou ani nemá byť hlavným spôsobom obsluhy systému. Môžeme byť rýchlejší než to! Všetky najdôležitejšie aplikácie sú viazané priamo na jednotlivé klávesové skratky. Terminál spustíte pomocou `Super + Return` a prehliadač pomocou `Super + Shift + Return`. Skúste urobiť jedno po druhom a uvidíte mágiu dlaždíc Hyprlandu v akcii:

 ![navigation-browser-terminal](images/navigation-browser-terminal.webp)

Potom môžete stlačiť `Super + J`, aby ste ich naskladali na seba namiesto vedľa seba:

 ![navigation-stacked](images/navigation-stacked.webp)

Znova stlačte `Super + J`, aby ste ich vrátili do ich pozícií vedľa seba. Potom skúste `Super + Shift + Arrow Right`, kým ste v prehliadači, aby ste okná vymenili.

Teraz skúste `Super + Ctrl + T` na spustenie monitora aktivity. Ten sa objaví ako plávajúce okno. Môžete ho vydláždicovať pomocou `Super + T` (a znova to stlačiť, aby znova plávalo). Teraz stlačte `Super + Shift + F` na otvorenie správcu súborov. Budete mať pekné štvorcestné usporiadanie:

 ![navigation-fourway-tiling](images/navigation-fourway-tiling.webp)

Medzi oknami, ktoré chcete mať aktívne, sa pohybujete pomocou `Super + Arrow`. To prepne zameranie a presunie kurzor do stredu novej aplikácie.

Ak stlačíte `Super + Shift + 2`, presuniete aktuálne zameranú aplikáciu na druhú pracovnú plochu. `Super + Shift + 1` ju presunie späť. (A `Super + Shift + Alt + 2` presunie aktuálne zameranú aplikáciu na druhú pracovnú plochu bez prepnutia na ňu).

Ak podržíte `Super` a myšou kliknete na okno, budete môcť preusporiadať, kde sedí. Ak podržíte `Super` a použijete pravé tlačidlo myši, môžete voľne meniť veľkosť okna.

Okno zatvoríte pomocou `Super + W` alebo `Super + Q` (a všetky okná zatvoríte pomocou `Ctrl + Alt + Delete`).

Môžete tiež prejsť na celú obrazovku pomocou `Super + F` alebo dokonca len na celú šírku (pri zachovaní hornej lišty) pomocou `Super + Alt + F` alebo na celú obrazovku v rámci okna pomocou `Super + Ctrl + F` (dobré pre YouTube!).

### Rozloženie dwindle vs posúvanie

Predvolené rozloženie Omarchy sa nazýva dwindle. Udržiava všetky okná, ktoré otvoríte na jednej pracovnej ploche, vždy viditeľné, aj keď ich musí zmenšiť.

 ![navigation-dwindle-layout](images/navigation-dwindle-layout.webp)

Ale môžete si tiež vybrať premeniť pracovnú plochu na posúvacie rozloženie, kde sú okná zoradené vedľa seba za viditeľný okraj displeja. Jednotlivú pracovnú plochu na toto rozloženie prepnete pomocou `Super + L`.

Opätovné stlačenie `Super + L` prepne pracovnú plochu na plávajúcu, kde sa okná voľne prekrývajú a umiestňujete ich sami, a tretie stlačenie ju vráti na dwindle. `Super + Alt + L` ním prechádza opačným smerom. Okno, ktoré aj tak pláva — to, ktoré ste vysunuli pomocou `Super + T`, alebo aplikácia, ktorá sa vždy otvára plávajúca — zostane plávať, keď sa pracovná plocha vráti k dlaždiciam. Horná lišta označuje pracovnú plochu, na ktorej ste, jej rozložením: štvorec pre dwindle, kruh pre posúvanie a trojuholník pre plávanie. Kliknutie na túto značku tiež cykluje rozloženie.

 ![navigation-scrolling-layout](images/navigation-scrolling-layout.webp)

Voľba je pre každú pracovnú plochu a drží sa. Takže pracovnú plochu 1 môžete nechať na dwindle na prehliadanie a pracovnú plochu 2 na posúvaní na kód a po reštarte sa tak vrátia.

Ak chcete používať posúvacie rozloženie ako predvolené, môžete to nastaviť v `~/.config/hypr/looknfeel.lua`:

```lua
hl.config({
  general = {
    layout = "scrolling",
  },
})
```

### Plávajúce pracovné plochy

Plávajúca pracovná plocha funguje ako tradičná pracovná plocha: okná sa prekrývajú a sami ich presúvate a meníte ich veľkosť. Každé okno dostane záhlavie vo farbách vašej témy s tlačidlami na minimalizáciu, maximalizáciu a zatvorenie. `Super + M` tiež minimalizuje zamerané okno. Minimalizované okno čaká v docku; kliknite na jeho aplikáciu, aby ste ho priniesli späť. Kliknite na okno, aby ste ho priniesli dopredu. Zmeňte jeho veľkosť z ľubovoľného okraja alebo rohu. Dvakrát kliknite na záhlavie, aby ste okno maximalizovali pri zachovaní hornej lišty v dohľade, a znova, aby ste získali späť jeho starú veľkosť.

Plávajúca pracovná plocha tiež zobrazuje dock s vašimi pripnutými aplikáciami, všetkým, čo beží, a mriežkou každej aplikácie za tlačidlom aplikácií, ktoré otvárajú aj `Super + Alt + Space` a _Aplikácie_ v menu Omarchy. Pravým tlačidlom kliknite na aplikáciu v mriežke alebo stlačte `Delete`, aby ste ju odinštalovali. Kliknite na aplikáciu, aby ste ju otvorili alebo priniesli jej okno dopredu; kliknite znova, aby ste prechádzali jej oknami. Kliknutie stredným tlačidlom otvorí nové okno. Potiahnite ikonu pozdĺž docku, aby ste ju presunuli; potiahnutie bežiacej aplikácie medzi ostatné ju tam nechá. Pravým tlačidlom kliknite, aby ste aplikáciu nechali v docku, vybrali ju alebo ju ukončili. Dock sa stiahne z cesty celobrazovkového okna. Pravým tlačidlom kliknite na tlačidlo aplikácií, aby ste dock presunuli k inému okraju alebo ho nechali skryť, kým ukazovateľ nedosiahne jeho okraj. Poloha je tiež pod _Akcie > Vzhľad > Dock > Poloha docku_ a `omarchy dock position left` a `omarchy dock autohide on` nastavujú obe z terminálu. Aplikácie, ktoré necháte v docku, sú vyblednuté, kým nebežia.

Nové pracovné plochy a všetky, ktorým ste nedali vlastné rozloženie pomocou `Super + L`, používajú predvolené rozloženie. Zmena predvoleného resetuje každú pracovnú plochu bez okien na ňu, zatiaľ čo tá s oknami si zachová rozloženie, ktoré má. Vyberte si ho pod _Akcie > Vzhľad > Rozloženie plôch_: Dlaždice, Posúvanie alebo Plávajúce. `omarchy-hyprland-workspace-layout-default scrolling` ho nastaví z terminálu.

### Zoskupovanie okien

Okná možno zoskupiť pomocou `Super + G`. Keď ste raz v skupine, každé okno, ktoré spustíte, kým je táto aktívna, bude patriť do skupiny. Medzi týmito zoskupenými oknami sa môžete pohybovať pomocou `Super + Ctrl + Arrow Left/Right` alebo `Super + Alt + 1/2/3/4`, aby ste prešli priamo na zoskupené okno v poradí.

Okno môžete presunúť zo zoskupenia pomocou `Super + Alt + G` alebo rozložiť celú skupinu opätovným stlačením `Super + G`. Nakoniec môžete okná mimo skupiny presunúť do nej pomocou `Super + Alt + Arrows`.

### Vyskakovanie okien

Okno môžete vysunúť z jeho pridelenia pracovnej ploche pomocou `Super + O`. To ho pripne ako plávajúce okno, ktoré vás nasleduje na akejkoľvek pracovnej ploche, na ktorú idete. Skvelé pre videoprehrávače a podobne.

 ![navigation-popped-window](images/navigation-popped-window.webp)

### Pracovná plocha scratchpad

Nakoniec existuje špeciálna pracovná plocha scratchpad, ktorá sa spustí cez akúkoľvek pracovnú plochu, na ktorej práve ste, podobne ako konzola Quake. Prepnite ju pomocou `Super + Grave` alebo `Super + S` a umiestnite tam okno pomocou `Super + Shift + Grave` alebo `Super + Alt + S`.

Funguje obzvlášť dobre pre terminál, na ktorom beží agent, alebo pre ovládacie prvky, s ktorými chcete rýchlo interagovať bez opustenia aktuálnej pracovnej plochy. Ak chcete okno presunúť zo scratchpadu, pošlite ho priamo na inú pracovnú plochu niečím ako `Super + Shift + 1`.

Kým scratchpad drží jedno okno, spustí sa ako centrovaný panel, namiesto aby pokrýval obrazovku. Dajte naň druhú aplikáciu a vráti sa na celú šírku, takže tie dve majú miesto sedieť vedľa seba.

### Chce to trochu zvykania!

Chvíľu trvá, kým si zvyknete na takúto navigáciu po pracovnej ploche, ale keď si zvyknete, bude ťažké vrátiť sa k tradičnému zážitku z pracovnej plochy ovládanej myšou!
