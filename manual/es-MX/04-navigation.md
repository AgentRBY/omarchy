# Navegación

Todo en Omarchy sucede con el teclado — ¡_TODO_! Cuando el sistema arranca por primera vez, literalmente no puedes hacer nada solo con el ratón. Pero puedes presionar `Super + Space` para mostrar el menú de Omarchy y desde ahí hacer prácticamente todo.

Pero el menú de Omarchy ni siquiera pretende ser la forma principal de operar el sistema la mayor parte del tiempo. ¡Podemos ser más rápidos que eso! Todas las aplicaciones más importantes están asignadas directamente a atajos individuales. Abres la terminal con `Super + Return` y un navegador con `Super + Shift + Return`. Prueba hacer uno tras otro y verás la magia del mosaico de Hyprland en acción:

 ![navigation-browser-terminal](images/navigation-browser-terminal.webp)

Luego puedes presionar `Super + J` para apilarlas una encima de la otra en lugar de lado a lado:

 ![navigation-stacked](images/navigation-stacked.webp)

Presiona `Super + J` otra vez para regresarlas a sus posiciones lado a lado. Luego prueba `Super + Shift + Arrow Right` estando en el navegador para intercambiar las ventanas.

Ahora prueba `Super + Ctrl + T` para abrir el monitor de actividad. Aparecerá como una ventana flotante. Puedes ponerla en mosaico con `Super + T` (y presionarlo de nuevo para hacerla flotante otra vez). Ahora presiona `Super + Shift + F` para abrir el administrador de archivos. Tendrás una bonita configuración de cuatro partes:

 ![navigation-fourway-tiling](images/navigation-fourway-tiling.webp)

Navegas entre las ventanas para activar la que quieres con `Super + Arrow`. Eso cambiará el enfoque y moverá el cursor al centro de la aplicación nueva.

Si presionas `Super + Shift + 2`, moverás la aplicación enfocada actual al segundo espacio de trabajo. `Super + Shift + 1` la trae de vuelta. (Y `Super + Shift + Alt + 2` moverá la aplicación enfocada actual al segundo espacio de trabajo sin cambiar a él).

Si mantienes presionado `Super` y usas el ratón para hacer clic en una ventana, podrás reacomodar dónde queda. Si mantienes `Super` y usas el botón derecho del ratón, puedes redimensionar la ventana libremente.

Cierras una ventana con `Super + W` o `Super + Q` (y cierras todas las ventanas con `Ctrl + Alt + Delete`).

También puedes ir a pantalla completa con `Super + F`, o solo a ancho completo (manteniendo la barra superior) con `Super + Alt + F`, o pantalla completa dentro de una ventana con `Super + Ctrl + F` (¡bueno para YouTube!).

### Distribución dwindle frente a desplazamiento

La distribución predeterminada de Omarchy se llama dwindle. Mantiene visibles en todo momento todas las ventanas que abres en un mismo espacio de trabajo, aunque tenga que encogerlas.

 ![navigation-dwindle-layout](images/navigation-dwindle-layout.webp)

Pero también puedes elegir convertir un espacio de trabajo a la distribución de desplazamiento, donde las ventanas se alinean lado a lado más allá del borde visible de la pantalla. Conviertes un solo espacio de trabajo a esta distribución con `Super + L`.

Presionar `Super + L` otra vez vuelve el espacio de trabajo flotante, donde las ventanas se enciman libremente y tú las colocas, y una tercera pulsación lo regresa a dwindle. `Super + Alt + L` recorre las opciones en el orden contrario. Una ventana que de por sí flota — una que sacaste con `Super + T`, o una app que siempre se abre flotante — sigue flotando cuando el espacio de trabajo vuelve al mosaico. La barra superior marca el espacio de trabajo en el que estás con su distribución: un cuadrado para dwindle, un círculo para desplazamiento y un triángulo para flotante. Hacer clic en esa marca también cambia la distribución.

 ![navigation-scrolling-layout](images/navigation-scrolling-layout.webp)

La elección es por espacio de trabajo y se mantiene. Así puedes dejar el espacio de trabajo 1 en dwindle para navegar y el espacio de trabajo 2 en desplazamiento para código, y así volverán después de un reinicio.

Si quieres usar la distribución de desplazamiento como predeterminada, puedes configurarlo en `~/.config/hypr/looknfeel.lua`:

```lua
hl.config({
  general = {
    layout = "scrolling",
  },
})
```

### Espacios de trabajo flotantes

Un espacio de trabajo flotante funciona como un escritorio tradicional: las ventanas se enciman y tú las mueves y dimensionas. Cada ventana obtiene una barra de título en los colores de tu tema, con botones para minimizar, maximizar y cerrar. `Super + M` también minimiza la ventana enfocada. Una ventana minimizada espera en el dock; haz clic en su app para traerla de vuelta. Haz clic en una ventana para traerla al frente. Redimensiónala desde cualquier borde o esquina. Haz doble clic en la barra de título para maximizar la ventana manteniendo visible la barra superior, y otra vez para recuperar su tamaño anterior.

Un espacio de trabajo flotante también muestra un dock, con tus apps fijadas, todo lo que está en ejecución y una cuadrícula de todas las apps detrás del botón de aplicaciones, que `Super + Alt + Space` y _Aplicaciones_ en el menú de Omarchy también abren. Haz clic derecho en una app de la cuadrícula, o presiona `Delete`, para desinstalarla. Haz clic en una app para abrirla o para traer su ventana al frente; haz clic otra vez para recorrer sus ventanas. El clic central abre una ventana nueva. Arrastra un icono a lo largo del dock para moverlo; arrastrar una app en ejecución entre las demás la deja ahí. Haz clic derecho para mantener una app en el dock, sacarla o cerrarla. El dock se quita del camino de una ventana en pantalla completa. Haz clic derecho en el botón de aplicaciones para mover el dock a otro borde o hacer que se oculte hasta que el puntero llegue a su borde. La posición también está en _Activar > Apariencia > Dock > Posición del dock_, y `omarchy dock position left` y `omarchy dock autohide on` fijan ambas cosas desde una terminal. Las apps que dejas en el dock se atenúan mientras no están en ejecución.

Los espacios de trabajo nuevos, y cualquiera al que no le hayas dado su propia distribución con `Super + L`, usan la distribución predeterminada. Cambiar el predeterminado restablece a esa distribución todo espacio de trabajo sin ventanas, mientras que uno con ventanas conserva la distribución que tiene. Elígela en _Activar > Apariencia > Distribución de espacios_: Mosaico, Desplazamiento o Flotante. `omarchy-hyprland-workspace-layout-default scrolling` la fija desde una terminal.

### Agrupar ventanas

Las ventanas se pueden agrupar con `Super + G`. Una vez que estás en un grupo, cada ventana que abras mientras esté activo pertenecerá al grupo. Puedes moverte entre estas ventanas agrupadas con `Super + Ctrl + Arrow Left/Right` o `Super + Alt + 1/2/3/4` para ir directo a una ventana agrupada en orden.

Puedes sacar una ventana del grupo con `Super + Alt + G` o desarmar todo el grupo presionando `Super + G` otra vez. Por último, puedes mover ventanas de fuera del grupo hacia él con `Super + Alt + Arrows`.

### Despegar ventanas

Puedes despegar una ventana de la asignación a su espacio de trabajo con `Super + O`. Eso la fijará como una ventana flotante que te sigue a cualquier espacio de trabajo al que vayas. Genial para reproductores de video y cosas así.

 ![navigation-popped-window](images/navigation-popped-window.webp)

### Espacio de trabajo scratchpad

Por último, hay un espacio de trabajo especial scratchpad que cae sobre el espacio de trabajo en el que estés, parecido a una consola estilo Quake. Actívalo o desactívalo con `Super + Grave` o `Super + S`, y coloca una ventana ahí con `Super + Shift + Grave` o `Super + Alt + S`.

Funciona especialmente bien para una terminal que ejecuta un agente, o para controles con los que quieres interactuar rápido sin salir del espacio de trabajo actual. Para sacar una ventana del scratchpad, mándala directo a otro espacio de trabajo con algo como `Super + Shift + 1`.

Mientras el scratchpad contiene una sola ventana, cae como un panel centrado en lugar de abarcar toda la pantalla. Pon una segunda app en él y vuelve al ancho completo, para que las dos tengan espacio de estar lado a lado.

### ¡Hay que acostumbrarse!

Toma un poco de tiempo acostumbrarse a navegar así por tu escritorio, pero una vez que lo logras, ¡será difícil volver a una experiencia de escritorio tradicional manejada con el ratón!
