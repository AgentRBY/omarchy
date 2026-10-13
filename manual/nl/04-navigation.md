# Navigatie

Alles in Omarchy gebeurt via het toetsenbord — _ALLES!_ Wanneer het systeem voor het eerst start, kun je letterlijk niets doen met alleen de muis. Maar je kunt op `Super + Space` drukken om het Omarchy-menu te onthullen en van hieruit kun je zo'n beetje alles doen.

Maar het Omarchy-menu is niet eens bedoeld als de belangrijkste manier om het systeem meestal te bedienen. We kunnen sneller dan dat! Alle belangrijkste applicaties zijn direct gebonden aan individuele sneltoetsen. Je start de terminal met `Super + Return` en een browser met `Super + Shift + Return`. Probeer het een na het ander te doen, en je ziet de magie van Hyprlands tegelen in actie:

 ![navigation-browser-terminal](images/navigation-browser-terminal.webp)

Je kunt dan op `Super + J` drukken om ze op elkaar te stapelen in plaats van naast elkaar:

 ![navigation-stacked](images/navigation-stacked.webp)

Druk opnieuw op `Super + J` om ze terug te zetten naar hun naast-elkaar posities. Probeer vervolgens `Super + Shift + Arrow Right` terwijl je in de browser bent om de vensters te verwisselen.

Probeer nu `Super + Ctrl + T` om de Activiteitenmonitor te starten. Die verschijnt als een zwevend venster. Je kunt hem tegelen met `Super + T` (en druk daar nog een keer op om hem weer zwevend te maken). Druk nu op `Super + Shift + F` om de bestandsbeheerder te openen. Je hebt een nette vierweg-opstelling:

 ![navigation-fourway-tiling](images/navigation-fourway-tiling.webp)

Je navigeert tussen het venster dat je actief wilt hebben met `Super + Arrow`. Dit wisselt de focus en verplaatst de cursor naar het midden van de nieuwe applicatie.

Als je op `Super + Shift + 2` drukt, verplaats je de huidige gefocuste applicatie naar het tweede werkblad. `Super + Shift + 1` verplaatst hem terug. (En `Super + Shift + Alt + 2` verplaatst de huidige gefocuste applicatie naar het tweede werkblad zonder ernaartoe te schakelen).

Als je `Super` ingedrukt houdt en met de muis op een venster klikt, kun je herschikken waar het zit. Als je `Super` ingedrukt houdt en de rechtermuisknop gebruikt, kun je het venster vrij resizen.

Je sluit een venster met `Super + W` of `Super + Q` (en sluit alle vensters met `Ctrl + Alt + Delete`).

Je kunt ook volledig scherm gaan met `Super + F` of zelfs alleen volledige breedte (met behoud van de bovenbalk) met `Super + Alt + F` of volledig scherm binnen een venster met `Super + Ctrl + F` (goed voor YouTube!).

### Dwindle vs scrollende indeling

Omarchy's standaardindeling heet dwindle. Het houdt alle vensters die je opent op een enkel werkblad te allen tijde zichtbaar, zelfs als het ze moet verkleinen.

 ![navigation-dwindle-layout](images/navigation-dwindle-layout.webp)

Maar je kunt er ook voor kiezen om een werkblad om te zetten naar de scrollende indeling waarbij vensters naast elkaar zijn opgesteld, voorbij de zichtbare rand van het scherm. Je zet een enkel werkblad om naar deze indeling via `Super + L`.

Opnieuw op `Super + L` drukken maakt het werkblad zwevend, waarbij vensters vrij overlappen en je ze zelf plaatst, en een derde druk brengt het terug naar dwindle. `Super + Alt + L` doorloopt ze de andere kant op. Een venster dat toch al zweeft — een dat je hebt uitgeklapt met `Super + T`, of een app die altijd zwevend opent — blijft zweven wanneer het werkblad teruggaat naar tegelen. De bovenbalk markeert het werkblad waarop je je bevindt met zijn indeling: een vierkant voor dwindle, een cirkel voor scrollen en een driehoek voor zwevend. Op dat merkteken klikken doorloopt de indeling ook.

 ![navigation-scrolling-layout](images/navigation-scrolling-layout.webp)

De keuze is per werkblad, en hij blijft. Dus je kunt werkblad 1 op dwindle houden voor browsen en werkblad 2 op scrollen voor code, en ze komen na een herstart zo terug.

Als je de scrollende indeling als standaard wilt gebruiken, kun je dat instellen in `~/.config/hypr/looknfeel.lua`:

```lua
hl.config({
  general = {
    layout = "scrolling",
  },
})
```

### Zwevende werkbladen

Een zwevend werkblad werkt als een traditioneel bureaublad: vensters overlappen, en je verplaatst en dimensioneert ze zelf. Elk venster krijgt een titelbalk in de kleuren van je thema, met knoppen om te minimaliseren, maximaliseren en sluiten. `Super + M` minimaliseert het gefocuste venster ook. Een geminimaliseerd venster wacht in het dock; klik op zijn app om het terug te brengen. Klik op een venster om het naar voren te brengen. Resize het vanaf elke rand of hoek. Dubbelklik op een titelbalk om het venster te maximaliseren terwijl de bovenbalk in beeld blijft, en opnieuw om zijn oude grootte terug te krijgen.

Een zwevend werkblad toont ook een dock, met je vastgepinde apps, alles wat draait, en een raster van elke app achter de Apps-knop, die `Super + Alt + Space` en _Apps_ in het Omarchy-menu ook openen. Rechtsklik op een app in het raster, of druk op `Delete`, om hem te verwijderen. Klik op een app om hem te openen of zijn venster naar voren te brengen; klik opnieuw om door zijn vensters te bladeren. Middenklik opent een nieuw venster. Sleep een pictogram langs het dock om het te verplaatsen; een draaiende app tussen de andere slepen houdt hem daar. Rechtsklik om een app in het dock te houden, eruit te halen of af te sluiten. Het dock maakt plaats voor een venster op volledig scherm. Rechtsklik op de Apps-knop om het dock naar een andere rand te verplaatsen of het te laten verbergen totdat de aanwijzer zijn rand bereikt. De positie staat ook onder _Activeren > Weergave > Dock > Dockpositie_, en `omarchy dock position left` en `omarchy dock autohide on` stellen beide in vanuit een terminal. Apps die je in het dock houdt, zijn vervaagd terwijl ze niet draaien.

Nieuwe werkbladen, en alle werkbladen waaraan je geen eigen indeling hebt gegeven met `Super + L`, gebruiken de standaardindeling. De standaard veranderen reset elk werkblad zonder vensters daarnaar, terwijl een werkblad met vensters de indeling behoudt die het heeft. Kies het onder _Activeren > Weergave > Werkbladindeling_: Tegelen, Scrollen of Zwevend. `omarchy-hyprland-workspace-layout-default scrolling` stelt het in vanuit een terminal.

### Vensters groeperen

Vensters kunnen worden gegroepeerd met `Super + G`. Zodra je in een groep zit, behoort elk venster dat je start terwijl die actief is tot de groep. Je kunt tussen deze gegroepeerde vensters bewegen met `Super + Ctrl + Arrow Left/Right` of `Super + Alt + 1/2/3/4` om direct naar een gegroepeerd venster in volgorde te gaan.

Je kunt een venster uit de groepering halen met `Super + Alt + G` of de hele groep ontmantelen door opnieuw op `Super + G` te drukken. Ten slotte kun je vensters buiten de groep erin verplaatsen met `Super + Alt + Arrows`.

### Vensters uitklappen

Je kunt een venster uit zijn werkbladtoewijzing klappen met `Super + O`. Dat pint het vast als een zwevend venster dat je volgt naar welk werkblad je ook gaat. Geweldig voor videospelers en dergelijke.

 ![navigation-popped-window](images/navigation-popped-window.webp)

### Kladblok-werkblad

Ten slotte is er een speciaal kladblok-werkblad dat over het werkblad valt waarop je je momenteel bevindt, net als een Quake-console. Schakel het met `Super + Grave` of `Super + S`, en plaats er een venster met `Super + Shift + Grave` of `Super + Alt + S`.

Het werkt bijzonder goed voor een terminal die een agent draait, of voor bedieningselementen waarmee je snel wilt interacteren zonder het huidige werkblad te verlaten. Om een venster van het kladblok af te halen, stuur je het direct naar een ander werkblad met iets als `Super + Shift + 1`.

Terwijl het kladblok een enkel venster bevat, valt het neer als een gecentreerd paneel in plaats van het scherm te overspannen. Zet er een tweede app op en het gaat terug naar de volledige breedte, zodat de twee ruimte hebben om naast elkaar te zitten.

### Het vergt even wennen!

Het duurt even om te wennen aan het navigeren op je bureaublad op deze manier, maar zodra je dat doet, zal het moeilijk zijn om terug te gaan naar een traditionele muisgestuurde bureaubladervaring!
