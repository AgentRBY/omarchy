# Aan de slag

Omarchy wordt geïnstalleerd met een ISO. Je kunt kiezen tussen een installatie op de volledige schijf, die de hele schijf overneemt, of een installatie in vrije ruimte, die Omarchy in de niet-toegewezen ruimte op een schijf plaatst — zo dual-boot je naast Windows of een ander besturingssysteem (zie [dual-boot installatie](50-dual-boot-install.md) — merk op dat je BitLocker in Windows eerst moet uitschakelen). Hoe dan ook wordt de installatie standaard volledig versleuteld, en de optie voor de volledige schijf wist de geselecteerde schijf, dus maak zeker een back-up voordat je een bestaande schijf gebruikt!

[Download eerst de Omarchy ISO](https://omarchy.org/), zet hem op een USB-stick (gebruik [balenaEtcher](https://etcher.balena.io/) op Mac/Windows of [caligula](https://github.com/ifd3f/caligula) op Linux) en start op vanaf de stick.

_Je moet Secure Boot en/of TPM uitschakelen in de BIOS. Je moet deze uitschakelen om Omarchy te kunnen installeren. Het zijn Microsoft-beveiligingsmechanismen bedoeld voor Windows en aan Microsoft gelieerde Linux-distributies._

Beantwoord vervolgens de configuratievragen en bevestig ze als volgt:

 ![install-config](images/install-config.webp)

Selecteer vervolgens een schijf voor je installatie en leun achterover en kijk hoe de installatieshow verloopt. Het kan in minder dan een minuut klaar zijn op de snelste moderne machines, maar het zou zelfs op een oudere computer niet meer dan 5 minuten moeten duren.

 ![install-done](images/install-done.webp)

Nu ben je klaar om Omarchy te gebruiken!

### Gebruik een bedraad of 2.4GHz-toetsenbord!

De volledige schijfversleuteling staat niet toe dat je het wachtwoord invoert vanaf een Bluetooth-toetsenbord bij het opstarten. Net zoals je geen Bluetooth-toetsenbord kunt gebruiken om de BIOS op een pc te openen. Je hebt een toetsenbord nodig dat ofwel een 2.4GHz-dongle of een kabel gebruikt (wat sowieso veel beter is voor de latentie!). Zelf ben ik dol op de [Lofree Flow84](https://www.lofree.co/products/lofree-flow-the-smoothest-mechanical-keyboard)!

### Installeren voor een andere eigenaar

Als je een machine instelt voor iemand anders — een familielid, een nieuwe werknemer, een koper — moet je de persoonlijke vragen niet namens hen beantwoorden. Druk op `Ctrl + C` op het allereerste scherm van het installatieprogramma (de toetsenbordselectie), en Omarchy zal aanbieden om de machine in plaats daarvan voor een andere eigenaar voor te bereiden. Het systeem installeert meteen, maar alle persoonlijke instellingen — toetsenbordindeling, gebruikersnaam, wachtwoord — worden uitgesteld tot de machine voor het eerst opstart. De schijf is nog steeds standaard versleuteld, en het wachtwoord dat de nieuwe eigenaar bij die eerste start kiest, wordt ook het versleutelingswachtwoord. (Een machine die je al hebt gebruikt, kan ook worden overgedragen zonder herinstallatie — zie [de computer resetten](48-security.md).)

### Onbeheerde installaties

De ISO kan ook volledig zelfstandig installeren — geen toetsenbord, geen wizard — wanneer de configuratie op een tweede schijf wordt meegegeven. Dat is de manier om Omarchy te behandelen als een basisimage voor VMs en vlootmachines. Zie [onbeheerde installaties](51-unattended-installs.md).

### Installaties zonder versleuteling

Omarchy wordt standaard met versleuteling geïnstalleerd. Het is de veilige, verantwoorde keuze voor elke computer die verloren kan gaan of gestolen kan worden. Je wilt niet dat iemand met toegang tot je hardware bij je gegevens kan!

Maar in speciale omstandigheden, zoals externe Omarchy-installaties op beveiligde computers of voor wegwerpinstanties zonder gevoelige gegevens, wil je misschien installeren zonder versleuteling. Je kunt op `Ctrl + C` drukken bij de bevestiging van de schijfformattering om over te schakelen naar een installatie zonder versleuteling.

### Taal

Omarchy spreekt 50 talen — dezelfde set als omarchy.org — en Engels is de standaard. Om te wisselen open je het Omarchy-menu en ga je naar _Instellen > Taal_, of voer je `omarchy language <code>` uit in een terminal (`omarchy language list` toont de codes). Het menu, de desktop en Omarchy's eigen meldingen veranderen direct van taal, en de systeemtaalinstelling wordt bijpassend ingesteld, zodat je andere applicaties volgen bij de volgende keer dat je inlogt.

### Hulp als je vastzit

Als je vastzit, kun je meestal iemand vinden die wil helpen in het _#omarchy-help_-kanaal op [de community-Discord](https://omarchy.org/discord).
