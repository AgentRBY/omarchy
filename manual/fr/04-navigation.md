# Navigation

Tout dans Omarchy se fait au clavier — _TOUT !_ Au premier démarrage du système, vous ne pouvez littéralement rien faire avec la souris seule. Mais vous pouvez faire `Super + Space` pour révéler le menu Omarchy, et de là, faire à peu près tout.

Mais le menu Omarchy n'est même pas destiné à être la façon principale d'utiliser le système la plupart du temps. On peut aller plus vite ! Toutes les applications les plus importantes sont liées directement à des raccourcis individuels. Vous démarrez le terminal avec `Super + Return` et un navigateur avec `Super + Shift + Return`. Essayez l'un après l'autre, et vous verrez la magie de la mosaïque de Hyprland en action :

 ![navigation-browser-terminal](images/navigation-browser-terminal.webp)

Vous pouvez ensuite faire `Super + J` pour les empiler l'un sur l'autre au lieu de côte à côte :

 ![navigation-stacked](images/navigation-stacked.webp)

Faites à nouveau `Super + J` pour les remettre côte à côte. Essayez ensuite `Super + Shift + Arrow Right` lorsque vous êtes sur le navigateur pour échanger les fenêtres.

Essayez maintenant `Super + Ctrl + T` pour démarrer le moniteur d'activité. Il apparaîtra comme une fenêtre flottante. Vous pouvez la mettre en mosaïque avec `Super + T` (et refaire la même chose pour la rendre à nouveau flottante). Faites maintenant `Super + Shift + F` pour ouvrir le gestionnaire de fichiers. Vous aurez un bel arrangement en quatre parties :

 ![navigation-fourway-tiling](images/navigation-fourway-tiling.webp)

Vous naviguez entre les fenêtres pour choisir celle que vous voulez active avec `Super + Arrow`. Cela changera le focus et déplacera le curseur au centre de la nouvelle application.

Si vous faites `Super + Shift + 2`, vous déplacerez l'application active vers le deuxième espace de travail. `Super + Shift + 1` la ramène. (Et `Super + Shift + Alt + 2` déplacera l'application active vers le deuxième espace de travail sans y basculer.)

Si vous maintenez `Super` et utilisez la souris pour cliquer sur une fenêtre, vous pourrez réorganiser sa position. Si vous maintenez `Super` et utilisez le bouton droit de la souris, vous pouvez redimensionner librement la fenêtre.

Vous fermez une fenêtre avec `Super + W` ou `Super + Q` (et fermez toutes les fenêtres avec `Ctrl + Alt + Delete`).

Vous pouvez aussi passer en plein écran avec `Super + F`, ou même simplement en pleine largeur (en gardant la barre supérieure) avec `Super + Alt + F`, ou en plein écran à l'intérieur d'une fenêtre avec `Super + Ctrl + F` (idéal pour YouTube !).

### Disposition dwindle ou défilement

La disposition par défaut d'Omarchy s'appelle dwindle. Elle garde toutes les fenêtres que vous ouvrez sur un même espace de travail visibles en permanence, même si elle doit les réduire.

 ![navigation-dwindle-layout](images/navigation-dwindle-layout.webp)

Mais vous pouvez aussi choisir de transformer un espace de travail en disposition défilement, où les fenêtres sont alignées côte à côte, au-delà du bord visible de l'écran. Vous basculez un seul espace de travail vers cette disposition via `Super + L`.

Faire à nouveau `Super + L` rend l'espace de travail flottant, où les fenêtres se chevauchent librement et où vous les placez vous-même, et une troisième pression le ramène à dwindle. `Super + Alt + L` les parcourt dans l'autre sens. Une fenêtre qui flotte de toute façon — une que vous avez sortie avec `Super + T`, ou une appli qui s'ouvre toujours en flottant — reste flottante lorsque l'espace de travail revient en mosaïque. La barre supérieure marque l'espace de travail sur lequel vous êtes par sa disposition : un carré pour dwindle, un cercle pour défilement, et un triangle pour flottant. Cliquer sur cette marque fait aussi défiler la disposition.

 ![navigation-scrolling-layout](images/navigation-scrolling-layout.webp)

Le choix se fait par espace de travail, et il persiste. Vous pouvez donc garder l'espace 1 en dwindle pour naviguer et l'espace 2 en défilement pour le code, et ils reviendront ainsi après un redémarrage.

Si vous souhaitez utiliser la disposition défilement par défaut, vous pouvez le définir dans `~/.config/hypr/looknfeel.lua` :

```lua
hl.config({
  general = {
    layout = "scrolling",
  },
})
```

### Espaces de travail flottants

Un espace de travail flottant fonctionne comme un bureau traditionnel : les fenêtres se chevauchent, et vous les déplacez et les dimensionnez vous-même. Chaque fenêtre reçoit une barre de titre aux couleurs de votre thème, avec des boutons pour réduire, agrandir et fermer. `Super + M` réduit aussi la fenêtre active. Une fenêtre réduite attend dans le dock ; cliquez sur son appli pour la ramener. Cliquez sur une fenêtre pour la mettre au premier plan. Redimensionnez-la depuis n'importe quel bord ou coin. Double-cliquez sur une barre de titre pour agrandir la fenêtre tout en gardant la barre supérieure visible, et à nouveau pour retrouver son ancienne taille.

Un espace de travail flottant affiche aussi un dock, avec vos applis épinglées, tout ce qui tourne, et une grille de toutes les applis derrière le bouton applis, que `Super + Alt + Space` et _Applis_ dans le menu Omarchy ouvrent aussi. Faites un clic droit sur une appli de la grille, ou appuyez sur `Delete`, pour la désinstaller. Cliquez sur une appli pour l'ouvrir, ou pour mettre sa fenêtre au premier plan ; cliquez à nouveau pour parcourir ses fenêtres. Le clic central ouvre une nouvelle fenêtre. Faites glisser une icône le long du dock pour la déplacer ; faire glisser une appli en cours d'exécution parmi les autres la garde là. Faites un clic droit pour garder une appli dans le dock, l'en sortir, ou la quitter. Le dock s'écarte devant une fenêtre plein écran. Faites un clic droit sur le bouton applis pour déplacer le dock vers un autre bord ou le masquer jusqu'à ce que le pointeur atteigne son bord. La position se trouve aussi sous _Déclencher > Apparence > Dock > Position du dock_, et `omarchy dock position left` et `omarchy dock autohide on` définissent les deux depuis un terminal. Les applis que vous gardez dans le dock sont estompées lorsqu'elles ne tournent pas.

Les nouveaux espaces de travail, et ceux auxquels vous n'avez pas donné leur propre disposition avec `Super + L`, utilisent la disposition par défaut. Changer la valeur par défaut réinitialise chaque espace de travail sans fenêtre à cette valeur, tandis qu'un espace avec des fenêtres conserve la disposition qu'il a. Choisissez-la sous _Déclencher > Apparence > Disposition des espaces_ : Mosaïque, Défilement, ou Flottant. `omarchy-hyprland-workspace-layout-default scrolling` la définit depuis un terminal.

### Regrouper les fenêtres

Les fenêtres peuvent être regroupées avec `Super + G`. Une fois dans un groupe, chaque fenêtre que vous démarrez pendant qu'il est actif appartiendra au groupe. Vous pouvez naviguer entre ces fenêtres regroupées avec `Super + Ctrl + Arrow Left/Right` ou `Super + Alt + 1/2/3/4` pour aller directement à la fenêtre regroupée dans l'ordre.

Vous pouvez sortir une fenêtre du groupe avec `Super + Alt + G` ou démonter tout le groupe en refaisant `Super + G`. Enfin, vous pouvez déplacer des fenêtres extérieures au groupe vers celui-ci avec `Super + Alt + Arrows`.

### Détacher des fenêtres

Vous pouvez détacher une fenêtre de son espace de travail avec `Super + O`. Cela l'épinglera comme fenêtre flottante qui vous suit sur l'espace de travail où vous allez. Idéal pour les lecteurs vidéo et ce genre de choses.

 ![navigation-popped-window](images/navigation-popped-window.webp)

### Espace de travail scratchpad

Enfin, il y a un espace de travail scratchpad spécial qui se déploie par-dessus l'espace sur lequel vous êtes, un peu comme une console Quake. Basculez-le avec `Super + Grave` ou `Super + S`, et placez-y une fenêtre avec `Super + Shift + Grave` ou `Super + Alt + S`.

Il fonctionne particulièrement bien pour un terminal faisant tourner un agent, ou pour des contrôles avec lesquels vous voulez interagir rapidement sans quitter l'espace de travail actuel. Pour déplacer une fenêtre hors du scratchpad, envoyez-la directement vers un autre espace avec quelque chose comme `Super + Shift + 1`.

Lorsque le scratchpad contient une seule fenêtre, il se déploie comme un panneau centré plutôt que de couvrir tout l'écran. Mettez-y une deuxième appli et il revient en pleine largeur, de sorte que les deux aient la place de se mettre côte à côte.

### Il faut un peu de temps pour s'y habituer !

Il faut un peu de temps pour s'habituer à naviguer sur son bureau ainsi, mais une fois que vous y serez, il sera difficile de revenir à une expérience de bureau traditionnelle pilotée à la souris !
