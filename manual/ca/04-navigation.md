# Navegació

Tot a Omarchy passa pel teclat — _TOT!_ Quan el sistema s'inicia per primera vegada, literalment no podeu fer res només amb el ratolí. Però podeu prémer `Super + Space` per revelar el menú d'Omarchy i des d'aquí podeu fer pràcticament tot.

Però el menú d'Omarchy ni tan sols està pensat per ser la manera principal d'operar el sistema la majoria del temps. Podem anar més ràpid que això! Totes les aplicacions més importants estan assignades directament a dreceres individuals. Inicieu el terminal amb `Super + Return` i un navegador amb `Super + Shift + Return`. Proveu de fer-ne una rere l'altra i veureu la màgia del mosaic de Hyprland en acció:

 ![navigation-browser-terminal](images/navigation-browser-terminal.webp)

Després podeu prémer `Super + J` per apilar-les una damunt de l'altra en lloc de posar-les una al costat de l'altra:

 ![navigation-stacked](images/navigation-stacked.webp)

Premeu `Super + J` de nou per tornar-les a les seves posicions una al costat de l'altra. Després proveu `Super + Shift + Arrow Right` mentre sou al navegador per intercanviar les finestres.

Ara proveu `Super + Ctrl + T` per iniciar el monitor d'activitat. Això apareixerà com una finestra flotant. La podeu posar en mosaic amb `Super + T` (i torneu-ho a prémer per fer-la flotant de nou). Ara premeu `Super + Shift + F` per obrir el gestor de fitxers. Tindreu una configuració ordenada de quatre finestres:

 ![navigation-fourway-tiling](images/navigation-fourway-tiling.webp)

Navegueu entre la finestra que voleu que estigui activa amb `Super + Arrow`. Això canviarà el focus i mourà el cursor al centre de la nova aplicació.

Si premeu `Super + Shift + 2`, moureu l'aplicació enfocada actualment al segon espai de treball. `Super + Shift + 1` la torna. (I `Super + Shift + Alt + 2` mourà l'aplicació enfocada actualment al segon espai de treball sense canviar-hi).

Si manteniu premuda `Super` i feu clic amb el ratolí en una finestra, podreu reordenar on se situa. Si manteniu `Super` i feu servir el botó dret del ratolí, podeu redimensionar la finestra lliurement.

Tanqueu una finestra amb `Super + W` o `Super + Q` (i tanqueu totes les finestres amb `Ctrl + Alt + Delete`).

També podeu anar a pantalla completa amb `Super + F` o fins i tot només a amplada completa (mantenint la barra superior) amb `Super + Alt + F` o a pantalla completa dins d'una finestra amb `Super + Ctrl + F` (ideal per a YouTube!).

### Disposició dwindle enfront de disposició de desplaçament

La disposició per defecte d'Omarchy s'anomena dwindle. Manté totes les finestres que obriu en un sol espai de treball visibles en tot moment, encara que les hagi d'encongir.

 ![navigation-dwindle-layout](images/navigation-dwindle-layout.webp)

Però també podeu triar convertir un espai de treball en la disposició de desplaçament, on les finestres s'alineen una al costat de l'altra, més enllà de la vora visible de la pantalla. Convertiu un espai de treball concret a aquesta disposició amb `Super + L`.

Prémer `Super + L` de nou fa l'espai de treball flotant, on les finestres se superposen lliurement i les col·loqueu vosaltres mateixos, i una tercera pressió el retorna a dwindle. `Super + Alt + L` hi passa en l'altre sentit. Una finestra que de totes maneres flota — una que heu tret amb `Super + T`, o una aplicació que sempre s'obre flotant — continua flotant quan l'espai de treball torna al mosaic. La barra superior marca l'espai de treball en què sou amb la seva disposició: un quadrat per a dwindle, un cercle per al desplaçament i un triangle per al flotant. Fer clic en aquesta marca també fa rotar la disposició.

 ![navigation-scrolling-layout](images/navigation-scrolling-layout.webp)

L'elecció és per espai de treball, i es manté. Així podeu mantenir l'espai de treball 1 a dwindle per navegar i l'espai de treball 2 a desplaçament per al codi, i tornaran així després d'un reinici.

Si voleu fer servir la disposició de desplaçament com a predeterminada, podeu definir-ho a `~/.config/hypr/looknfeel.lua`:

```lua
hl.config({
  general = {
    layout = "scrolling",
  },
})
```

### Espais de treball flotants

Un espai de treball flotant funciona com un escriptori tradicional: les finestres se superposen i les moveu i les dimensioneu vosaltres mateixos. Cada finestra rep una barra de títol amb els colors del vostre tema, amb botons per minimitzar, maximitzar i tancar. `Super + M` també minimitza la finestra enfocada. Una finestra minimitzada espera al dock; feu clic a la seva aplicació per recuperar-la. Feu clic en una finestra per portar-la al davant. Redimensioneu-la des de qualsevol vora o cantonada. Feu doble clic en una barra de títol per maximitzar la finestra mantenint la barra superior a la vista, i de nou per recuperar la seva mida antiga.

Un espai de treball flotant també mostra un dock, amb les vostres aplicacions fixades, tot el que s'està executant i una graella de totes les aplicacions darrere del botó d'aplicacions, que `Super + Alt + Space` i _Aplicacions_ al menú d'Omarchy també obren. Feu clic amb el botó dret en una aplicació de la graella, o premeu `Delete`, per desinstal·lar-la. Feu clic en una aplicació per obrir-la, o per portar la seva finestra al davant; torneu a fer clic per recórrer les seves finestres. El clic del mig obre una finestra nova. Arrossegueu una icona pel dock per moure-la; arrossegar una aplicació en execució entre les altres la manté allà. Feu clic amb el botó dret per mantenir una aplicació al dock, treure-la'n o tancar-la. El dock s'aparta d'una finestra a pantalla completa. Feu clic amb el botó dret al botó d'aplicacions per moure el dock a una altra vora o perquè s'amagui fins que el punter arribi a la seva vora. La posició també és a _Activa > Aparença > Dock > Posició del Dock_, i `omarchy dock position left` i `omarchy dock autohide on` defineixen tots dos valors des d'un terminal. Les aplicacions que manteniu al dock es mostren atenuades mentre no s'estan executant.

Els espais de treball nous, i els que no heu donat una disposició pròpia amb `Super + L`, fan servir la disposició per defecte. Canviar la predeterminada restableix a aquesta tots els espais de treball sense finestres, mentre que un que en té manté la disposició que té. Trieu-la a _Activa > Aparença > Disposició dels espais_: Mosaic, Desplaçament o Flotant. `omarchy-hyprland-workspace-layout-default scrolling` la defineix des d'un terminal.

### Agrupar finestres

Les finestres es poden agrupar amb `Super + G`. Un cop sou en un grup, cada finestra que inicieu mentre aquest estigui actiu pertanyerà al grup. Podeu moure-us entre aquestes finestres agrupades amb `Super + Ctrl + Arrow Left/Right` o `Super + Alt + 1/2/3/4` per anar directament a la finestra agrupada en ordre.

Podeu treure una finestra de l'agrupament amb `Super + Alt + G` o desmuntar tot el grup prement `Super + G` de nou. Finalment, podeu moure finestres de fora del grup cap a dins amb `Super + Alt + Arrows`.

### Extreure finestres

Podeu extreure una finestra de l'assignació del seu espai de treball amb `Super + O`. Això la fixarà com a finestra flotant que us seguirà a qualsevol espai de treball on aneu. Ideal per a reproductors de vídeo i coses semblants.

 ![navigation-popped-window](images/navigation-popped-window.webp)

### Espai de treball d'esborrany

Finalment, hi ha un espai de treball d'esborrany especial que cau damunt de l'espai de treball en què sigueu, molt semblant a una consola de Quake. Activeu-lo amb `Super + Grave` o `Super + S`, i col·loqueu-hi una finestra amb `Super + Shift + Grave` o `Super + Alt + S`.

Funciona especialment bé per a un terminal que executi un agent, o per a controls amb què voleu interactuar ràpidament sense deixar l'espai de treball actual. Per moure una finestra fora de l'esborrany, envieu-la directament a un altre espai de treball amb una cosa com `Super + Shift + 1`.

Mentre l'esborrany conté una sola finestra, cau com un panell centrat en lloc d'abastar tota la pantalla. Poseu-hi una segona aplicació i torna a l'amplada completa, perquè les dues tinguin espai per seure una al costat de l'altra.

### Cal acostumar-s'hi una mica!

Cal una estona per acostumar-se a navegar per l'escriptori així, però un cop ho feu, serà difícil tornar a una experiència d'escriptori tradicional guiada pel ratolí!
