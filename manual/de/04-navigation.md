# Navigation

Alles in Omarchy geschieht über die Tastatur — _ALLES!_ Wenn das System zum ersten Mal startet, kannst du buchstäblich nichts allein mit der Maus tun. Aber du kannst `Super + Space` drücken, um das Omarchy-Menü zu enthüllen, und von hier aus kannst du so ziemlich alles tun.

Aber das Omarchy-Menü ist die meiste Zeit nicht einmal als Hauptweg gedacht, das System zu bedienen. Wir können schneller sein als das! Alle wichtigsten Anwendungen sind direkt an einzelne Tastenkürzel gebunden. Du startest das Terminal mit `Super + Return` und einen Browser mit `Super + Shift + Return`. Versuche, eines nach dem anderen zu tun, und du siehst die Magie von Hyprlands Tiling in Aktion:

 ![navigation-browser-terminal](images/navigation-browser-terminal.webp)

Du kannst dann `Super + J` drücken, um sie übereinander statt nebeneinander zu stapeln:

 ![navigation-stacked](images/navigation-stacked.webp)

Drücke `Super + J` erneut, um sie in ihre Nebeneinander-Positionen zurückzubringen. Versuche dann `Super + Shift + Arrow Right`, während du im Browser bist, um die Fenster zu tauschen.

Versuche jetzt `Super + Ctrl + T`, um den Aktivitätsmonitor zu starten. Der erscheint als schwebendes Fenster. Du kannst ihn mit `Super + T` kacheln (und das erneut drücken, um ihn wieder schwebend zu machen). Drücke jetzt `Super + Shift + F`, um den Dateimanager zu öffnen. Du wirst ein ordentliches Vierer-Setup haben:

 ![navigation-fourway-tiling](images/navigation-fourway-tiling.webp)

Du navigierst zwischen den Fenstern, die aktiv sein sollen, mit `Super + Arrow`. Das wechselt den Fokus und bewegt den Cursor in die Mitte der neuen Anwendung.

Wenn du `Super + Shift + 2` drückst, verschiebst du die aktuell fokussierte Anwendung auf die zweite Arbeitsfläche. `Super + Shift + 1` verschiebt sie zurück. (Und `Super + Shift + Alt + 2` verschiebt die aktuell fokussierte Anwendung auf die zweite Arbeitsfläche, ohne zu ihr zu wechseln.)

Wenn du `Super` gedrückt hältst und mit der Maus auf ein Fenster klickst, kannst du neu anordnen, wo es sitzt. Wenn du `Super` gedrückt hältst und die rechte Maustaste verwendest, kannst du das Fenster frei in der Größe ändern.

Du schließt ein Fenster mit `Super + W` oder `Super + Q` (und schließt alle Fenster mit `Ctrl + Alt + Delete`).

Du kannst auch mit `Super + F` in den Vollbildmodus gehen oder sogar nur auf volle Breite (wobei die Menüleiste bleibt) mit `Super + Alt + F` oder Vollbild innerhalb eines Fensters mit `Super + Ctrl + F` (gut für YouTube!).

### Dwindle- vs. Scroll-Layout

Omarchys Standardlayout heißt Dwindle. Es hält alle Fenster, die du auf einer einzelnen Arbeitsfläche öffnest, jederzeit sichtbar, selbst wenn es sie dafür verkleinern muss.

 ![navigation-dwindle-layout](images/navigation-dwindle-layout.webp)

Aber du kannst eine Arbeitsfläche auch in das Scroll-Layout verwandeln, in dem Fenster nebeneinander aufgereiht sind, über den sichtbaren Rand des Displays hinaus. Du verwandelst eine einzelne Arbeitsfläche über `Super + L` in dieses Layout.

Erneutes Drücken von `Super + L` macht die Arbeitsfläche schwebend, wobei sich Fenster frei überlappen und du sie selbst platzierst, und ein drittes Drücken bringt sie zurück zu Dwindle. `Super + Alt + L` geht in die andere Richtung durch sie hindurch. Ein Fenster, das ohnehin schwebt — eines, das du mit `Super + T` herausgelöst hast, oder eine App, die immer schwebend öffnet — bleibt schwebend, wenn die Arbeitsfläche zurück zum Tiling geht. Die Menüleiste markiert die Arbeitsfläche, auf der du dich befindest, mit ihrem Layout: ein Quadrat für Dwindle, ein Kreis für Scrollen und ein Dreieck für Schwebend. Ein Klick auf diese Markierung wechselt das Layout ebenfalls.

 ![navigation-scrolling-layout](images/navigation-scrolling-layout.webp)

Die Wahl gilt pro Arbeitsfläche und bleibt bestehen. So kannst du Arbeitsfläche 1 auf Dwindle zum Surfen und Arbeitsfläche 2 auf Scrollen für Code halten, und sie kommen nach einem Neustart so zurück.

Wenn du das Scroll-Layout als Standard verwenden willst, kannst du das in `~/.config/hypr/looknfeel.lua` setzen:

```lua
hl.config({
  general = {
    layout = "scrolling",
  },
})
```

### Schwebende Arbeitsflächen

Eine schwebende Arbeitsfläche funktioniert wie ein traditioneller Desktop: Fenster überlappen sich, und du verschiebst und dimensionierst sie selbst. Jedes Fenster bekommt eine Titelleiste in den Farben deines Designs, mit Schaltflächen zum Minimieren, Maximieren und Schließen. `Super + M` minimiert das fokussierte Fenster ebenfalls. Ein minimiertes Fenster wartet im Dock; klicke auf seine App, um es zurückzubringen. Klicke auf ein Fenster, um es nach vorne zu bringen. Ändere seine Größe von jeder Kante oder Ecke aus. Doppelklicke auf eine Titelleiste, um das Fenster zu maximieren, während die Menüleiste sichtbar bleibt, und erneut, um seine alte Größe zurückzubekommen.

Eine schwebende Arbeitsfläche zeigt auch ein Dock mit deinen angehefteten Apps, allem, was läuft, und einem Raster jeder App hinter der Apps-Schaltfläche, das auch `Super + Alt + Space` und _Apps_ im Omarchy-Menü öffnen. Rechtsklicke auf eine App im Raster oder drücke `Delete`, um sie zu deinstallieren. Klicke auf eine App, um sie zu öffnen oder ihr Fenster nach vorne zu bringen; klicke erneut, um durch ihre Fenster zu wechseln. Mittelklick öffnet ein neues Fenster. Ziehe ein Symbol entlang des Docks, um es zu verschieben; eine laufende App unter die anderen zu ziehen hält sie dort. Rechtsklicke, um eine App im Dock zu behalten, sie herauszunehmen oder sie zu beenden. Das Dock weicht einem Vollbildfenster aus dem Weg. Rechtsklicke auf die Apps-Schaltfläche, um das Dock an eine andere Kante zu verschieben oder es auszublenden, bis der Zeiger seine Kante erreicht. Die Position ist auch unter _Auslösen > Aussehen > Dock > Dock-Position_, und `omarchy dock position left` und `omarchy dock autohide on` setzen beides von einem Terminal aus. Apps, die du im Dock behältst, sind ausgegraut, während sie nicht laufen.

Neue Arbeitsflächen und alle, denen du mit `Super + L` kein eigenes Layout gegeben hast, verwenden das Standardlayout. Das Ändern des Standards setzt jede Arbeitsfläche ohne Fenster darauf zurück, während eine mit Fenstern darauf das Layout behält, das sie hat. Wähle es unter _Auslösen > Aussehen > Arbeitsflächenlayout_: Kacheln, Scrollen oder Schwebend. `omarchy-hyprland-workspace-layout-default scrolling` setzt es von einem Terminal aus.

### Fenster gruppieren

Fenster können mit `Super + G` gruppiert werden. Sobald du in einer Gruppe bist, gehört jedes Fenster, das du startest, während diese aktiv ist, zur Gruppe. Du kannst dich zwischen diesen gruppierten Fenstern mit `Super + Ctrl + Arrow Left/Right` oder `Super + Alt + 1/2/3/4` bewegen, um direkt zum gruppierten Fenster in der Reihenfolge zu gehen.

Du kannst ein Fenster mit `Super + Alt + G` aus der Gruppierung herausbewegen oder die gesamte Gruppe auflösen, indem du `Super + G` erneut drückst. Schließlich kannst du Fenster außerhalb der Gruppe mit `Super + Alt + Arrows` in sie hineinbewegen.

### Fenster herauslösen

Du kannst ein Fenster mit `Super + O` aus seiner Arbeitsflächenzuweisung herauslösen. Das heftet es als schwebendes Fenster an, das dir auf jede Arbeitsfläche folgt, zu der du gehst. Großartig für Videoplayer und dergleichen.

 ![navigation-popped-window](images/navigation-popped-window.webp)

### Scratchpad-Arbeitsfläche

Schließlich gibt es eine spezielle Scratchpad-Arbeitsfläche, die über die Arbeitsfläche fällt, auf der du dich gerade befindest, ähnlich wie eine Quake-Konsole. Schalte sie mit `Super + Grave` oder `Super + S` um und platziere ein Fenster dort mit `Super + Shift + Grave` oder `Super + Alt + S`.

Sie funktioniert besonders gut für ein Terminal, in dem ein Agent läuft, oder für Steuerungen, mit denen du schnell interagieren willst, ohne die aktuelle Arbeitsfläche zu verlassen. Um ein Fenster vom Scratchpad wegzubewegen, schicke es direkt auf eine andere Arbeitsfläche mit etwas wie `Super + Shift + 1`.

Während das Scratchpad ein einzelnes Fenster enthält, fällt es als zentriertes Panel herunter, anstatt sich über den Bildschirm zu spannen. Lege eine zweite App darauf, und es geht zurück zur vollen Breite, sodass die beiden Platz haben, nebeneinander zu sitzen.

### Es braucht etwas Eingewöhnung!

Es dauert ein wenig, sich daran zu gewöhnen, deinen Desktop so zu navigieren, aber sobald du es tust, wird es schwer sein, zu einem traditionellen mausgesteuerten Desktop-Erlebnis zurückzukehren!
