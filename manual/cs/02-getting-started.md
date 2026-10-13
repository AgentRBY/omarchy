# Začínáme

Omarchy se instaluje pomocí ISO. Můžete si vybrat mezi instalací na celý disk, která převezme celé úložiště, nebo instalací do volného místa, která umístí Omarchy do nepřiděleného prostoru na disku — takto dual bootujete vedle Windows nebo jiného operačního systému (viz [dual-boot instalace](50-dual-boot-install.md) — upozorňujeme, že ve Windows budete muset nejdřív vypnout BitLocker). V obou případech instalace ve výchozím nastavení používá úplné šifrování a možnost celého disku vybraný disk vymaže, takže si před použitím existujícího disku udělejte zálohu!

Nejprve si [stáhněte ISO Omarchy](https://omarchy.org/), nahrajte ho na USB flash disk (na Macu/Windows použijte [balenaEtcher](https://etcher.balena.io/) nebo na Linuxu [caligulu](https://github.com/ifd3f/caligula)) a nabootujte z flash disku.

_V BIOSu musíte vypnout Secure Boot a/nebo TPM. Musíte je vypnout, abyste mohli Omarchy nainstalovat. Jsou to bezpečnostní schémata Microsoftu určená pro Windows a linuxové distribuce přidružené k Microsoftu._

Poté odpovězte na konfigurační otázky a potvrďte je takto:

 ![install-config](images/install-config.webp)

Poté vyberte disk pro instalaci, pohodlně se usaďte a sledujte instalační show. Na nejrychlejších moderních počítačích může být hotovo za méně než minutu, ale ani na starším počítači by to nemělo trvat déle než 5 minut.

 ![install-done](images/install-done.webp)

Teď jste připraveni na Omarchy!

### Použijte kabelovou nebo 2,4GHz klávesnici!

Úplné šifrování disku vám nedovolí zadat heslo z Bluetooth klávesnice při spuštění. Stejně jako nemůžete použít Bluetooth klávesnici pro vstup do BIOSu na PC. Budete potřebovat klávesnici, která používá buď 2,4GHz dongle, nebo kabel (což je každopádně mnohem příjemnější kvůli latenci!). Osobně mám rád [Lofree Flow84](https://www.lofree.co/products/lofree-flow-the-smoothest-mechanical-keyboard)!

### Instalace pro jiného vlastníka

Pokud připravujete počítač pro někoho jiného — člena rodiny, nového zaměstnance, kupce — neměli byste za něj odpovídat na osobní otázky. Stiskněte `Ctrl + C` na úplně první obrazovce instalátoru (výběr klávesnice) a Omarchy nabídne přípravu počítače pro jiného vlastníka. Systém se nainstaluje okamžitě, ale veškeré osobní nastavení — rozložení klávesnice, uživatelské jméno, heslo — je odloženo, dokud se počítač poprvé nespustí. Disk je stále ve výchozím nastavení zašifrovaný a heslo, které si nový vlastník při prvním spuštění zvolí, se stane také šifrovacím heslem. (Počítač, který už používáte, lze předat i bez přeinstalování — viz [resetování počítače](48-security.md).)

### Bezobslužné instalace

ISO se může nainstalovat také úplně samo — bez klávesnice, bez průvodce — když mu na druhém disku předáte jeho konfiguraci. Takto lze Omarchy používat jako základní image pro virtuální stroje a flotily počítačů. Viz [bezobslužné instalace](51-unattended-installs.md).

### Instalace bez šifrování

Omarchy se ve výchozím nastavení instaluje se šifrováním. Je to bezpečná a zodpovědná volba pro každý počítač, který může být ztracen nebo ukraden. Nechcete přece, aby kdokoli s přístupem k vašemu hardwaru získal vaše data!

Ale za zvláštních okolností, například u vzdálených instalací Omarchy na chráněných počítačích nebo u jednorázových instalací bez citlivých dat, můžete chtít instalovat bez šifrování. Při potvrzení formátování disku můžete stisknout `Ctrl + C` a přepnout na instalaci bez šifrování.

### Jazyk

Omarchy mluví 50 jazyky — stejnou sadou jako omarchy.org — a výchozí je angličtina. Pro přepnutí otevřete nabídku Omarchy a přejděte na _Nastavení > Jazyk_, nebo spusťte `omarchy language <code>` v terminálu (`omarchy language list` zobrazí kódy). Nabídka, plocha a vlastní oznámení Omarchy změní jazyk okamžitě a systémové locale se nastaví tak, aby odpovídalo, takže vaše ostatní aplikace budou následovat při příštím přihlášení.

### Pomoc, když se zaseknete

Pokud se zaseknete, obvykle najdete někoho ochotného pomoci v kanálu _#omarchy-help_ na [komunitním Discordu](https://omarchy.org/discord).
