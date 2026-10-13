# Komma igång

Omarchy installeras med en ISO. Du kan välja mellan en fullständig diskinstallation, som tar över hela enheten, eller en installation i ledigt utrymme, som placerar Omarchy i det oallokerade utrymmet på en enhet — det är så du dualbootar tillsammans med Windows eller ett annat operativsystem (se [dual-boot-installation](50-dual-boot-install.md) — observera att du först måste stänga av BitLocker i Windows). I båda fallen är installationens standard fullständig kryptering, och alternativet för full disk kommer att radera den valda enheten, så se till att ta en säkerhetskopia innan du använder en befintlig enhet!

[Ladda ner Omarchy-ISO](https://omarchy.org/) först, lägg den på ett USB-minne (använd [balenaEtcher](https://etcher.balena.io/) på Mac/Windows eller [caligula](https://github.com/ifd3f/caligula) på Linux) och boota från minnet.

_Du måste stänga av Secure Boot och/eller TPM i BIOS. Du måste stänga av dessa för att kunna installera Omarchy. De är Microsofts säkerhetssystem avsedda för Windows och Microsoft-anknutna Linuxdistributioner._

Besvara sedan konfigurationsfrågorna och bekräfta dem så här:

 ![install-config](images/install-config.webp)

Välj sedan en enhet för din installation och luta dig tillbaka och se installationsshowen. Det kan göras på under en minut på de snabbaste moderna maskinerna, men det bör inte ta mer än 5 minuter ens på en äldre dator.

 ![install-done](images/install-done.webp)

Nu är du redo att Omarchy!

### Använd ett trådbundet eller 2.4ghz tangentbord!

Fullständig diskkryptering tillåter inte att du anger lösenordet från ett Bluetooth-tangentbord vid uppstart. Precis som du inte kan använda ett Bluetooth-tangentbord för att öppna BIOS på en PC. Du behöver ett tangentbord som antingen använder en 2.4ghz-dongel eller en kabel (vilket ändå är mycket bättre för latensen!). Jag personligen älskar [Lofree Flow84](https://www.lofree.co/products/lofree-flow-the-smoothest-mechanical-keyboard)!

### Installera för en annan ägare

Om du ställer in en maskin för någon annan — en familjemedlem, en ny anställd, en köpare — bör du inte besvara de personliga frågorna å deras vägnar. Tryck på `Ctrl + C` på installatörens allra första skärm (tangentbordsurvalet), så erbjuder Omarchy att förbereda maskinen för en annan ägare i stället. Systemet installeras direkt, men all personlig installation — tangentbordslayout, användarnamn, lösenord — skjuts upp tills maskinen startar för första gången. Enheten är fortfarande krypterad som standard, och lösenordet som den nya ägaren väljer vid den första uppstarten blir också krypteringslösenordet. (En maskin du redan har använt kan också överlämnas utan ominstallation — se [återställa datorn](48-security.md).)

### Obevakade installationer

ISO:n kan också installera helt på egen hand — inget tangentbord, ingen guide — när den får sin konfiguration på en andra enhet. Det är sättet att behandla Omarchy som en basavbild för virtuella maskiner och flottmaskiner. Se [obevakade installationer](51-unattended-installs.md).

### Installationer utan kryptering

Omarchy installeras med kryptering som standard. Det är det säkra, ansvarsfulla valet för alla datorer som möjligen kan tappas bort eller stjälas. Du vill inte att någon med tillgång till din hårdvara ska kunna få tag på dina data!

Men under speciella omständigheter, som fjärrinstallationer av Omarchy på skyddade datorer eller för engångsinstallationer utan känsliga data, kanske du vill installera utan kryptering. Du kan trycka på `Ctrl + C` vid bekräftelsen av diskformatering för att växla till en installation utan kryptering.

### Språk

Omarchy talar 50 språk — samma uppsättning som omarchy.org — och engelska är standard. För att byta, öppna Omarchy-menyn och gå till _Setup > Language_, eller kör `omarchy language <code>` i en terminal (`omarchy language list` visar koderna). Menyn, skrivbordet och Omarchys egna aviseringar byter språk omedelbart, och systemspråket ställs in för att matcha, så dina andra applikationer följer med nästa gång du loggar in.

### Hjälp om du kör fast

Om du kör fast kan du vanligtvis hitta någon som vill hjälpa till i kanalen _#omarchy-help_ på [community-Discorden](https://omarchy.org/discord).
