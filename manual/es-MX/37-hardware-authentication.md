# Autenticación por hardware

### Autenticación con huella digital

Muchas laptops traen un sensor de huella digital para autenticarse. Puedes usarlo con Omarchy ejecutando _Configurar > Seguridad > Huella digital_ en el menú de Omarchy (`Super + Space`).

Eso instalará el paquete de huella digital, registrará tu huella, la verificará, y quedarás listo para usar tu huella digital para desbloquear desde la pantalla de bloqueo (que puedes activar con `Super + Ctrl + L`), entrar en modo sudo y autorizar solicitudes del sistema.

Cuando la tapa de tu laptop está cerrada, la solicitud de huella digital se salta automáticamente, así que vas directo a la solicitud de contraseña en lugar de esperar a un sensor que no puedes alcanzar. Si de todos modos necesitas trabajar en un teclado externo que no tiene sensor, solo presiona `CTRL + C` cuando se te pida tu huella digital durante `sudo`.

Puedes quitar la autenticación con huella digital en _Quitar > Seguridad > Huella digital_ en el menú de Omarchy.

### Autenticación Fido2

Si usas un dispositivo Fido2, puedes configurarlo para la autenticación de `sudo` usando _Configurar > Seguridad > Fido2_ en el menú de Omarchy (`Super + Space`). Sin embargo, cubre `sudo` y las solicitudes de autorización del sistema, no el desbloqueo de tu computadora.

Puedes quitar la autenticación fido2 en _Quitar > Seguridad > Fido2_ en el menú de Omarchy.
