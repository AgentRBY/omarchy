# Primeros pasos

Omarchy se instala usando una ISO. Puedes elegir entre una instalación en todo el disco, que se apodera de la unidad completa, o una instalación en espacio libre, que coloca Omarchy en el espacio sin asignar de una unidad — así es como haces arranque dual junto a Windows u otro sistema operativo (consulta [instalación con arranque dual](50-dual-boot-install.md) — ten en cuenta que primero tendrás que desactivar BitLocker en Windows). De cualquier forma, la instalación usa cifrado completo de manera predeterminada, y la opción de disco completo borrará la unidad seleccionada, así que ¡asegúrate de hacer un respaldo antes de usar una unidad existente!

Primero [descarga la ISO de Omarchy](https://omarchy.org/), ponla en una memoria USB (usa [balenaEtcher](https://etcher.balena.io/) en Mac/Windows o [caligula](https://github.com/ifd3f/caligula) en Linux) y arranca desde la memoria.

_Debes desactivar Secure Boot y/o TPM en el BIOS. Tienes que desactivarlos para poder instalar Omarchy. Son esquemas de seguridad de Microsoft pensados para Windows y para distribuciones de Linux afiliadas a Microsoft._

Luego responde las preguntas de configuración y confírmalas así:

 ![install-config](images/install-config.webp)

Después selecciona una unidad para tu instalación, relájate y mira el espectáculo de la instalación. Puede terminar en menos de un minuto en las máquinas modernas más rápidas, pero no debería tardar más de 5 minutos ni siquiera en una computadora más vieja.

 ![install-done](images/install-done.webp)

¡Ya estás listo para usar Omarchy!

### ¡Usa un teclado con cable o de 2.4 GHz!

El cifrado de disco completo no te permitirá ingresar la contraseña desde un teclado Bluetooth al arrancar. Igual que no puedes usar un teclado Bluetooth para entrar al BIOS en una PC. Necesitarás un teclado que use un dongle de 2.4 GHz o un cable (que además es mucho mejor para la latencia). A mí en lo personal me encanta el [Lofree Flow84](https://www.lofree.co/products/lofree-flow-the-smoothest-mechanical-keyboard).

### Instalar para otro dueño

Si estás preparando una máquina para alguien más — un familiar, un empleado nuevo, un comprador — no deberías responder las preguntas personales en su nombre. Presiona `Ctrl + C` en la primera pantalla del instalador (la selección de teclado) y Omarchy te ofrecerá preparar la máquina para otro dueño. El sistema se instala de inmediato, pero toda la configuración personal — distribución de teclado, nombre de usuario, contraseña — se pospone hasta que la máquina arranca por primera vez. La unidad sigue cifrada de manera predeterminada, y la contraseña que elija el nuevo dueño en ese primer arranque también se convierte en la contraseña de cifrado. (Una máquina que ya has estado usando también se puede entregar sin reinstalar — consulta [restablecer la computadora](48-security.md)).

### Instalaciones desatendidas

La ISO también puede instalarse completamente sola — sin teclado, sin asistente — cuando se le entrega su configuración en una segunda unidad. Esa es la manera de tratar a Omarchy como una imagen base para VMs y máquinas de flota. Consulta [instalaciones desatendidas](51-unattended-installs.md).

### Instalaciones sin cifrado

Omarchy se instala con cifrado de manera predeterminada. Es la opción segura y responsable para cualquier computadora que pueda perderse o ser robada. ¡No quieres que cualquiera con acceso a tu hardware pueda obtener tus datos!

Pero en circunstancias especiales, como instalaciones remotas de Omarchy en computadoras protegidas o instalaciones desechables sin datos sensibles, quizá quieras instalar sin cifrado. Puedes presionar `Ctrl + C` en la confirmación de formateo del disco para cambiar a una instalación sin cifrado.

### Idioma

Omarchy habla 50 idiomas — el mismo conjunto que omarchy.org — y el inglés es el predeterminado. Para cambiarlo, abre el menú de Omarchy y ve a _Configurar > Idioma_, o ejecuta `omarchy language <code>` en una terminal (`omarchy language list` muestra los códigos). El menú, el escritorio y las notificaciones propias de Omarchy cambian de idioma de inmediato, y la configuración regional del sistema se ajusta para coincidir, así que tus demás aplicaciones seguirán el cambio la próxima vez que inicies sesión.

### Ayuda si te atoras

Si te atoras, normalmente puedes encontrar a alguien dispuesto a ayudar en el canal _#omarchy-help_ en [el Discord de la comunidad](https://omarchy.org/discord).
