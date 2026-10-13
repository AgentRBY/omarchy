# Kom godt i gang

Omarchy installeres med en ISO. Du kan vælge mellem en fuld-disk-installation, som overtager hele drevet, eller en installation på ledig plads, som placerer Omarchy i den ikke-allokerede plads på et drev — det er sådan, du dual-booter ved siden af Windows eller et andet operativsystem (se [dual-boot-installation](50-dual-boot-install.md) — bemærk, at du først skal slå BitLocker fra i Windows). Begge dele bruger som standard fuld kryptering, og fuld-disk-indstillingen sletter det valgte drev, så sørg for at tage en sikkerhedskopi, før du bruger et eksisterende drev!

[Hent Omarchy ISO'en](https://omarchy.org/) først, læg den på en USB-nøgle (brug [balenaEtcher](https://etcher.balena.io/) på Mac/Windows eller [caligula](https://github.com/ifd3f/caligula) på Linux), og boot fra nøglen.

_Du skal slå Secure Boot og/eller TPM fra i BIOS'en. Du er nødt til at slå dem fra for at kunne installere Omarchy. Det er Microsoft-sikkerhedsordninger beregnet til Windows og Microsoft-tilknyttede Linux-distributioner._

Svar derefter på konfigurationsspørgsmålene, og bekræft dem sådan her:

 ![install-config](images/install-config.webp)

Vælg derefter et drev til din installation, læn dig tilbage, og se installationsshowet køre. Det kan klares på under et minut på de hurtigste moderne maskiner, men det bør ikke tage mere end 5 minutter selv på en ældre computer.

 ![install-done](images/install-done.webp)

Nu er du klar til at Omarchy!

### Brug et kablet tastatur eller et 2,4 GHz-tastatur!

Den fulde diskkryptering tillader dig ikke at indtaste adgangskoden fra et Bluetooth-tastatur ved opstart. Ligesom du ikke kan bruge et Bluetooth-tastatur til at komme ind i BIOS'en på en PC. Du skal bruge et tastatur, der enten bruger en 2,4 GHz-dongle eller et kabel (hvilket under alle omstændigheder er meget bedre for latenstiden!). Jeg er personligt vild med [Lofree Flow84](https://www.lofree.co/products/lofree-flow-the-smoothest-mechanical-keyboard)!

### Installation til en anden ejer

Hvis du sætter en maskine op til en anden — et familiemedlem, en ny ansat, en køber — skal du ikke besvare de personlige spørgsmål på vedkommendes vegne. Tryk på `Ctrl + C` på installatørens allerførste skærm (tastaturvalget), og Omarchy vil tilbyde at forberede maskinen til en anden ejer i stedet. Systemet installeres med det samme, men al den personlige opsætning — tastaturlayout, brugernavn, adgangskode — udskydes, indtil maskinen booter for første gang. Drevet er stadig krypteret som standard, og den adgangskode, som den nye ejer vælger ved den første opstart, bliver også krypteringsadgangskoden. (En maskine, du allerede har brugt, kan også overdrages uden en geninstallation — se [nulstilling af computeren](48-security.md).)

### Uovervågede installationer

ISO'en kan også installere helt på egen hånd — intet tastatur, ingen guide — når den får sin konfiguration på et andet drev. Det er måden at behandle Omarchy som et basisaftryk til VM'er og flådemaskiner på. Se [uovervågede installationer](51-unattended-installs.md).

### Installationer uden kryptering

Omarchy installeres med kryptering som standard. Det er det sikre, ansvarlige valg for enhver computer, der overhovedet kan blive tabt eller stjålet. Du vil ikke have, at nogen med adgang til din hardware skal kunne få fat i dine data!

Men under særlige omstændigheder, f.eks. ved eksterne Omarchy-installationer på beskyttede computere eller ved engangsinstallationer uden følsomme data, kan du ønske at installere uden kryptering. Du kan trykke på `Ctrl + C` ved bekræftelsen af diskformateringen for at skifte til en installation uden kryptering.

### Sprog

Omarchy taler 50 sprog — det samme sæt som omarchy.org — og engelsk er standarden. For at skifte skal du åbne Omarchy-menuen og gå til _Opsætning > Sprog_ eller køre `omarchy language <code>` i en terminal (`omarchy language list` viser koderne). Menuen, skrivebordet og Omarchys egne notifikationer skifter sprog med det samme, og systemlokalet sættes til at matche, så dine andre programmer følger med, næste gang du logger ind.

### Hjælp, hvis du sidder fast

Hvis du sidder fast, kan du som regel finde nogen, der vil hjælpe, i kanalen _#omarchy-help_ på [fællesskabets Discord](https://omarchy.org/discord).
