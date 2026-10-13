# Navigazione

In Omarchy tutto avviene tramite tastiera — _TUTTO!_ Quando il sistema si avvia per la prima volta, letteralmente non puoi fare nulla col solo mouse. Ma puoi premere `Super + Space` per mostrare il menu Omarchy e da qui fare praticamente tutto.

Ma il menu Omarchy non è nemmeno pensato per essere il modo principale di usare il sistema la maggior parte del tempo. Possiamo essere più veloci di così! Tutte le applicazioni più importanti sono legate direttamente a singole scorciatoie. Avvii il terminale con `Super + Return` e un browser con `Super + Shift + Return`. Prova a farne una dopo l'altra, e vedrai la magia dell'affiancamento di Hyprland in azione:

 ![navigation-browser-terminal](images/navigation-browser-terminal.webp)

Puoi poi premere `Super + J` per impilarle una sopra l'altra invece che fianco a fianco:

 ![navigation-stacked](images/navigation-stacked.webp)

Premi di nuovo `Super + J` per riportarle nelle posizioni fianco a fianco. Poi prova `Super + Shift + Arrow Right` mentre sei sul browser per scambiare le finestre.

Ora prova `Super + Ctrl + T` per avviare il monitor Attività. Apparirà come finestra flottante. Puoi affiancarla usando `Super + T` (e premerlo di nuovo per renderla di nuovo flottante). Ora premi `Super + Shift + F` per aprire il gestore file. Avrai una bella disposizione a quattro:

 ![navigation-fourway-tiling](images/navigation-fourway-tiling.webp)

Navighi tra le finestre che vuoi rendere attiva con `Super + Arrow`. Questo sposterà il focus e sposterà il cursore al centro della nuova applicazione.

Se premi `Super + Shift + 2`, sposterai l'applicazione attualmente focalizzata sul secondo workspace. `Super + Shift + 1` la riporta indietro. (E `Super + Shift + Alt + 2` sposterà l'applicazione attualmente focalizzata sul secondo workspace senza passare a esso).

Se tieni premuto `Super` e usi il mouse per cliccare su una finestra, potrai riposizionarla dove sta. Se tieni premuto `Super` e usi il pulsante destro del mouse, puoi ridimensionare liberamente la finestra.

Chiudi una finestra con `Super + W` o `Super + Q` (e chiudi tutte le finestre con `Ctrl + Alt + Delete`).

Puoi anche andare a schermo intero con `Super + F` o anche solo a piena larghezza (mantenendo la barra superiore) con `Super + Alt + F` o a schermo intero dentro una finestra con `Super + Ctrl + F` (ottimo per YouTube!).

### Layout dwindle contro scorrimento

Il layout predefinito di Omarchy si chiama dwindle. Mantiene visibili in ogni momento tutte le finestre che apri su un singolo workspace, anche se deve rimpicciolirle.

 ![navigation-dwindle-layout](images/navigation-dwindle-layout.webp)

Ma puoi anche scegliere di trasformare un workspace nel layout a scorrimento, dove le finestre sono allineate fianco a fianco, oltre il bordo visibile del display. Trasformi un singolo workspace in questo layout tramite `Super + L`.

Premendo di nuovo `Super + L` il workspace diventa flottante, dove le finestre si sovrappongono liberamente e le posizioni tu, e una terza pressione lo riporta a dwindle. `Super + Alt + L` li attraversa nell'altro verso. Una finestra che fluttua comunque — una che hai estratto con `Super + T`, o un'app che si apre sempre flottante — continua a fluttuare quando il workspace torna all'affiancamento. La barra superiore segna il workspace su cui sei con il suo layout: un quadrato per dwindle, un cerchio per lo scorrimento e un triangolo per le flottanti. Cliccando quel segno si cambia layout a ciclo.

 ![navigation-scrolling-layout](images/navigation-scrolling-layout.webp)

La scelta è per workspace, e resta. Quindi puoi tenere il workspace 1 su dwindle per navigare e il workspace 2 a scorrimento per il codice, e torneranno così dopo un riavvio.

Se desideri usare il layout a scorrimento come predefinito, puoi impostarlo in `~/.config/hypr/looknfeel.lua`:

```lua
hl.config({
  general = {
    layout = "scrolling",
  },
})
```

### Workspace flottanti

Un workspace flottante funziona come un desktop tradizionale: le finestre si sovrappongono, e le sposti e ridimensioni tu. Ogni finestra ha una barra del titolo nei colori del tuo tema, con pulsanti per minimizzare, massimizzare e chiudere. Anche `Super + M` minimizza la finestra focalizzata. Una finestra minimizzata aspetta nel dock; clicca la sua app per riportarla. Clicca una finestra per portarla in primo piano. Ridimensionala da qualsiasi bordo o angolo. Fai doppio clic su una barra del titolo per massimizzare la finestra mantenendo visibile la barra superiore, e di nuovo per riottenere la vecchia dimensione.

Un workspace flottante mostra anche un dock, con le tue app fissate, tutto ciò che è in esecuzione e una griglia di ogni app dietro il pulsante app, che si apre anche con `Super + Alt + Space` e _App_ nel menu Omarchy. Fai clic destro su un'app nella griglia, o premi `Delete`, per disinstallarla. Clicca un'app per aprirla, o per portare in primo piano la sua finestra; clicca di nuovo per scorrere le sue finestre. Il clic centrale apre una nuova finestra. Trascina un'icona lungo il dock per spostarla; trascinare un'app in esecuzione tra le altre la mantiene lì. Fai clic destro per tenere un'app nel dock, toglierla o chiuderla. Il dock si toglie di mezzo a una finestra a schermo intero. Fai clic destro sul pulsante app per spostare il dock su un altro bordo o farlo nascondere finché il puntatore non raggiunge il suo bordo. La posizione è anche sotto _Azioni > Aspetto > Dock > Posizione dock_, e `omarchy dock position left` e `omarchy dock autohide on` impostano entrambe da un terminale. Le app che tieni nel dock sono sbiadite mentre non sono in esecuzione.

I nuovi workspace, e quelli a cui non hai dato un layout proprio con `Super + L`, usano il layout predefinito. Cambiare il predefinito reimposta a esso ogni workspace senza finestre, mentre uno con finestre mantiene il layout che ha. Sceglilo sotto _Azioni > Aspetto > Layout workspace_: Affiancamento, Scorrimento o Flottanti. `omarchy-hyprland-workspace-layout-default scrolling` lo imposta da un terminale.

### Raggruppare le finestre

Le finestre possono essere raggruppate usando `Super + G`. Una volta in un gruppo, ogni finestra che avvii mentre è attivo apparterrà al gruppo. Puoi spostarti tra queste finestre raggruppate usando `Super + Ctrl + Arrow Left/Right` o `Super + Alt + 1/2/3/4` per andare direttamente a una finestra raggruppata in ordine.

Puoi spostare una finestra fuori dal gruppo con `Super + Alt + G` o smontare l'intero gruppo premendo di nuovo `Super + G`. Infine, puoi spostare finestre fuori dal gruppo al suo interno con `Super + Alt + Arrows`.

### Estrarre le finestre

Puoi estrarre una finestra dalla sua allocazione di workspace con `Super + O`. La fisserà come finestra flottante che ti segue su qualsiasi workspace tu vada. Ottimo per i lettori video e simili.

 ![navigation-popped-window](images/navigation-popped-window.webp)

### Workspace scratchpad

Infine, c'è uno speciale workspace scratchpad che scende sopra qualsiasi workspace su cui sei al momento, molto simile a una console di Quake. Attivalo con `Super + Grave` o `Super + S`, e metti una finestra lì usando `Super + Shift + Grave` o `Super + Alt + S`.

Funziona particolarmente bene per un terminale che esegue un agente, o per controlli con cui vuoi interagire rapidamente senza lasciare il workspace corrente. Per spostare una finestra fuori dallo scratchpad, mandala direttamente a un altro workspace con qualcosa come `Super + Shift + 1`.

Mentre lo scratchpad contiene una singola finestra, scende come un pannello centrato invece di coprire lo schermo. Mettici una seconda app e torna a piena larghezza, così le due hanno spazio per stare fianco a fianco.

### Ci vuole un po' per abituarsi!

Ci vuole un po' di tempo per abituarsi a navigare il desktop in questo modo, ma una volta fatto, sarà difficile tornare a un'esperienza desktop tradizionale guidata dal mouse!
