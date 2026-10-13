# Að byrja

Omarchy er sett upp með ISO-skrá. Þú getur valið á milli uppsetningar á allan diskinn, sem tekur yfir allan drifið, eða uppsetningar í laust pláss, sem setur Omarchy í óúthlutað pláss á drifi — þannig tvístígur þú (dual boot) við hlið Windows eða annars stýrikerfis (sjá [tvístígsuppsetningu](50-dual-boot-install.md) — athugaðu að þú þarft að slökkva á BitLocker í Windows fyrst). Hvort sem er er uppsetningin sjálfgefin með fullri dulritun, og valmöguleikinn fyrir allan diskinn þurrkar út valið drif, svo vertu viss um að taka afrit áður en þú notar núverandi drif!

[Sæktu Omarchy ISO-skrána](https://omarchy.org/) fyrst, settu hana á USB-lykil (nota [balenaEtcher](https://etcher.balena.io/) á Mac/Windows eða [caligula](https://github.com/ifd3f/caligula) á Linux) og ræstu af lyklinum.

_Þú verður að slökkva á Secure Boot og/eða TPM í BIOS. Þú verður að slökkva á þessu til að geta sett upp Omarchy. Þetta eru öryggiskerfi frá Microsoft sem eru ætluð fyrir Windows og Linux-dreifingar tengdar Microsoft._

Svaraðu síðan stillingarspurningunum og staðfestu þær svona:

 ![install-config](images/install-config.webp)

Veldu síðan drif fyrir uppsetninguna og halladu þér aftur og horfðu á uppsetningarsýninguna. Hún getur klárast á innan við mínútu á hraðskreiðustu nútímavélum, en hún ætti ekki að taka meira en 5 mínútur jafnvel á eldri tölvu.

 ![install-done](images/install-done.webp)

Nú ertu tilbúinn að Omarchy-a!

### Notaðu lyklaborð með snúru eða 2,4 GHz!

Full dulritun disksins leyfir þér ekki að slá inn lykilorðið af Bluetooth-lyklaborði við ræsingu. Rétt eins og þú getur ekki notað Bluetooth-lyklaborð til að fara inn í BIOS á PC-tölvu. Þú þarft lyklaborð sem notar annaðhvort 2,4 GHz-móttakara eða snúru (sem er hvort sem er miklu betra hvað varðar töf!). Persónulega elska ég [Lofree Flow84](https://www.lofree.co/products/lofree-flow-the-smoothest-mechanical-keyboard)!

### Að setja upp fyrir annan eiganda

Ef þú ert að setja upp vél fyrir einhvern annan — fjölskyldumeðlim, nýjan starfsmann, kaupanda — ættir þú ekki að svara persónulegu spurningunum fyrir þeirra hönd. Ýttu á `Ctrl + C` á allra fyrsta skjá uppsetningarforritsins (lyklaborðsvalið) og Omarchy býður þér að undirbúa vélina fyrir annan eiganda í staðinn. Kerfið setur sig upp strax, en allri persónulegri uppsetningu — lyklaborðsskipan, notendanafn, lykilorð — er frestað þar til vélin ræsist í fyrsta skipti. Drifið er enn dulritað sjálfgefið, og lykilorðið sem nýi eigandinn velur við þá fyrstu ræsingu verður dulritunarlykilorðið líka. (Vél sem þú hefur þegar notað er líka hægt að afhenda án enduruppsetningar — sjá [að endurstilla tölvuna](48-security.md).)

### Sjálfvirkar uppsetningar án aðkomu

ISO-skráin getur einnig sett sig upp alveg sjálf — ekkert lyklaborð, enginn leiðarvísir — þegar henni er afhent stillingin á öðru drifi. Það er leiðin til að nota Omarchy sem grunnmynd fyrir sýndarvélar og flotavélar. Sjá [sjálfvirkar uppsetningar án aðkomu](51-unattended-installs.md).

### Uppsetningar án dulritunar

Omarchy er sett upp með dulritun sjálfgefið. Það er öruggur og ábyrgur valkostur fyrir allar tölvur sem gætu hugsanlega týnst eða verið stolið. Þú vilt ekki að neinn með aðgang að vélbúnaðinum þínum geti komist í gögnin þín!

En við sérstakar aðstæður, eins og Omarchy-uppsetningar á vernduðum fjartölvum eða fyrir einnota uppsetningar án viðkvæmra gagna, gætir þú viljað setja upp án dulritunar. Þú getur ýtt á `Ctrl + C` við staðfestingu á disksniði til að skipta yfir í uppsetningu án dulritunar.

### Tungumál

Omarchy talar 50 tungumál — sama mengi og omarchy.org — og enska er sjálfgefin. Til að skipta skaltu opna Omarchy-valmyndina og fara í _Uppsetning > Tungumál_, eða keyra `omarchy language <code>` í terminal (`omarchy language list` sýnir kóðana). Valmyndin, skjáborðið og tilkynningar Omarchy sjálfs skipta um tungumál samstundis, og kerfistungumálið (locale) er stillt til samræmis, svo önnur forrit fylgja með næst þegar þú skráir þig inn.

### Hjálp ef þú festist

Ef þú festist geturðu yfirleitt fundið einhvern sem er fús til að hjálpa í _#omarchy-help_ rásinni á [samfélags-Discord-inu](https://omarchy.org/discord).
