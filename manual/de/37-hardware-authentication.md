# Hardware-Authentifizierung

### Fingerabdruck-Authentifizierung

Viele Laptops haben einen Fingerabdrucksensor zur Authentifizierung. Du kannst ihn mit Omarchy nutzen, indem du im Omarchy-Menü (`Super + Space`) _Einrichtung > Security > Fingerprint_ ausführst.

Das installiert das Fingerabdruck-Paket, erfasst deinen Abdruck, überprüft ihn, und schon kannst du mit deinem Fingerabdruck den Sperrbildschirm entsperren (den du mit `Super + Ctrl + L` auslöst), in den sudo-Modus wechseln und Systemabfragen autorisieren.

Wenn der Laptopdeckel geschlossen ist, wird die Fingerabdruck-Abfrage automatisch übersprungen, sodass du direkt zur Passwortabfrage kommst, statt auf einen Sensor zu warten, den du nicht erreichen kannst. Wenn du an einer externen Tastatur ohne Sensor arbeiten musst, drückst du einfach `CTRL + C`, wenn du während `sudo` nach deinem Fingerabdruck gefragt wirst.

Die Fingerabdruck-Authentifizierung entfernst du im Omarchy-Menü unter _Entfernen > Security > Fingerprint_.

### Fido2-Authentifizierung

Wenn du ein Fido2-Gerät nutzt, kannst du es für die `sudo`-Authentifizierung über _Einrichtung > Security > Fido2_ im Omarchy-Menü (`Super + Space`) einrichten. Es deckt aber `sudo` und System-Autorisierungsabfragen ab, nicht das Entsperren deines Computers.

Die fido2-Authentifizierung entfernst du im Omarchy-Menü unter _Entfernen > Security > Fido2_.
