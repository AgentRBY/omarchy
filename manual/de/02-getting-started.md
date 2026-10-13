# Erste Schritte

Omarchy wird mit einem ISO installiert. Du kannst zwischen einer Installation auf der gesamten Platte, die das ganze Laufwerk übernimmt, und einer Installation im freien Speicherplatz wählen, die Omarchy in den nicht zugewiesenen Speicherplatz auf einem Laufwerk legt — so machst du Dual-Boot neben Windows oder einem anderen Betriebssystem (siehe [Dual-Boot-Installation](50-dual-boot-install.md) — beachte, dass du vorher BitLocker unter Windows deaktivieren musst). In beiden Fällen ist die Installation standardmäßig vollständig verschlüsselt, und die Option für die gesamte Platte löscht das ausgewählte Laufwerk, also erstelle unbedingt ein Backup, bevor du ein vorhandenes Laufwerk verwendest!

[Lade zuerst das Omarchy-ISO herunter](https://omarchy.org/), kopiere es auf einen USB-Stick (verwende [balenaEtcher](https://etcher.balena.io/) auf Mac/Windows oder [caligula](https://github.com/ifd3f/caligula) unter Linux) und boote vom Stick.

_Du musst Secure Boot und/oder TPM im BIOS deaktivieren. Du musst diese deaktivieren, um Omarchy installieren zu können. Das sind Microsoft-Sicherheitsschemata, die für Windows und Microsoft-nahe Linux-Distributionen gedacht sind._

Beantworte dann die Konfigurationsfragen und bestätige sie so:

 ![install-config](images/install-config.webp)

Wähle dann ein Laufwerk für deine Installation aus, lehne dich zurück und sieh dir die Installationsshow an. Auf den schnellsten modernen Maschinen kann sie in unter einer Minute erledigt sein, aber selbst auf einem älteren Computer sollte sie nicht mehr als 5 Minuten dauern.

 ![install-done](images/install-done.webp)

Jetzt bist du bereit für Omarchy!

### Verwende eine kabelgebundene oder 2,4-GHz-Tastatur!

Die Vollverschlüsselung der Platte erlaubt es dir nicht, das Passwort beim Start über eine Bluetooth-Tastatur einzugeben. Genauso wie du keine Bluetooth-Tastatur verwenden kannst, um auf einem PC ins BIOS zu gelangen. Du brauchst eine Tastatur, die entweder einen 2,4-GHz-Dongle oder ein Kabel verwendet (was für die Latenz ohnehin viel schöner ist!). Ich persönlich liebe die [Lofree Flow84](https://www.lofree.co/products/lofree-flow-the-smoothest-mechanical-keyboard)!

### Für einen anderen Besitzer installieren

Wenn du eine Maschine für jemand anderen einrichtest — ein Familienmitglied, einen neuen Mitarbeiter, einen Käufer — solltest du die persönlichen Fragen nicht in seinem Namen beantworten. Drücke `Ctrl + C` auf dem allerersten Bildschirm des Installers (der Tastaturauswahl), und Omarchy bietet an, die Maschine stattdessen für einen anderen Besitzer vorzubereiten. Das System wird sofort installiert, aber die gesamte persönliche Einrichtung — Tastaturlayout, Benutzername, Passwort — wird verschoben, bis die Maschine zum ersten Mal bootet. Das Laufwerk ist weiterhin standardmäßig verschlüsselt, und das Passwort, das der neue Besitzer bei diesem ersten Boot wählt, wird auch zum Verschlüsselungspasswort. (Eine Maschine, die du bereits benutzt hast, kann auch ohne Neuinstallation übergeben werden — siehe [Computer zurücksetzen](48-security.md).)

### Unbeaufsichtigte Installationen

Das ISO kann auch völlig allein installieren — keine Tastatur, kein Assistent — wenn ihm seine Konfiguration auf einem zweiten Laufwerk übergeben wird. So behandelst du Omarchy als Basis-Image für VMs und Flottenmaschinen. Siehe [unbeaufsichtigte Installationen](51-unattended-installs.md).

### Installationen ohne Verschlüsselung

Omarchy wird standardmäßig mit Verschlüsselung installiert. Das ist die sichere, verantwortungsvolle Wahl für jeden Computer, der möglicherweise verloren gehen oder gestohlen werden kann. Du willst nicht, dass jemand mit Zugriff auf deine Hardware an deine Daten kommt!

Aber unter besonderen Umständen, wie bei Remote-Omarchy-Installationen auf geschützten Computern oder bei Wegwerf-Installationen ohne sensible Daten, möchtest du vielleicht ohne Verschlüsselung installieren. Du kannst bei der Bestätigung der Plattenformatierung `Ctrl + C` drücken, um zu einer Installation ohne Verschlüsselung zu wechseln.

### Sprache

Omarchy spricht 50 Sprachen — dieselbe Auswahl wie omarchy.org — und Englisch ist der Standard. Um zu wechseln, öffne das Omarchy-Menü und gehe zu _Einrichtung > Sprache_, oder führe `omarchy language <code>` in einem Terminal aus (`omarchy language list` zeigt die Codes). Das Menü, der Desktop und Omarchys eigene Benachrichtigungen wechseln sofort die Sprache, und das System-Gebietsschema wird entsprechend gesetzt, sodass deine anderen Anwendungen beim nächsten Anmelden folgen.

### Hilfe, wenn du nicht weiterkommst

Wenn du nicht weiterkommst, findest du normalerweise jemanden, der dir im Kanal _#omarchy-help_ auf [dem Community-Discord](https://omarchy.org/discord) helfen will.
