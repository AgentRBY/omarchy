# Kuanza

Omarchy husakinishwa kwa kutumia ISO. Unaweza kuchagua kati ya usakinishaji wa diski yote, unaotwaa kiendeshaji chote, au usakinishaji wa nafasi tupu, unaoweka Omarchy katika nafasi ambayo haijatengwa kwenye kiendeshaji — hiyo ndiyo njia ya kuwasha pamoja na Windows au OS nyingine (tazama [usakinishaji wa kuwasha mara mbili](50-dual-boot-install.md) — kumbuka kwamba utahitaji kuzima BitLocker katika Windows kwanza). Kwa njia yoyote, usakinishaji huwa na usimbaji kamili kwa chaguomsingi, na chaguo la diski yote litafuta kiendeshaji kilichochaguliwa, kwa hiyo hakikisha unachukua hifadhi rudufu kabla ya kutumia kilichopo!

[Pakua ISO ya Omarchy](https://omarchy.org/) kwanza, iweke kwenye kifimbo cha USB (tumia [balenaEtcher](https://etcher.balena.io/) kwenye Mac/Windows au [caligula](https://github.com/ifd3f/caligula) kwenye Linux), na uwashe kutoka kifimboni.

_Lazima uzime Secure Boot na/au TPM katika BIOS. Lazima uzime hivi ili uweze kusakinisha Omarchy. Ni mipango ya usalama ya Microsoft iliyokusudiwa kwa Windows na usambazaji wa Linux unaoshirikiana na Microsoft._

Kisha jibu maswali ya usanidi, na uyathibitishe kama hivi:

 ![install-config](images/install-config.webp)

Kisha chagua kiendeshaji cha usakinishaji wako, na ukae utazame onyesho la usakinishaji likiendelea. Unaweza kukamilika kwa chini ya dakika moja kwenye mashine za kisasa zenye kasi zaidi, lakini haupaswi kuchukua zaidi ya dakika 5 hata kwenye kompyuta ya zamani.

 ![install-done](images/install-done.webp)

Sasa uko tayari kwa Omarchy!

### Tumia kibodi ya waya au 2.4ghz!

Usimbaji wa diski yote hautakuruhusu kuingiza nenosiri kutoka kibodi ya Bluetooth wakati wa kuwasha. Kama vile huwezi kutumia kibodi ya Bluetooth kuingia BIOS kwenye PC. Utahitaji kibodi inayotumia dongle ya 2.4ghz au kebo (ambayo ni nzuri zaidi kwa kuchelewa hata hivyo!). Binafsi ninaipenda sana [Lofree Flow84](https://www.lofree.co/products/lofree-flow-the-smoothest-mechanical-keyboard)!

### Kusakinisha kwa mmiliki mwingine

Ikiwa unaandaa mashine kwa mtu mwingine — mwanafamilia, mfanyakazi mpya, mnunuzi — hupaswi kujibu maswali ya kibinafsi kwa niaba yake. Bonyeza `Ctrl + C` kwenye skrini ya kwanza kabisa ya kisakinishi (uteuzi wa kibodi), na Omarchy itatoa kuandaa mashine kwa mmiliki mwingine badala yake. Mfumo husakinishwa mara moja, lakini usanidi wote wa kibinafsi — umbo la kibodi, jina la mtumiaji, nenosiri — huahirishwa hadi mashine iwashe kwa mara ya kwanza. Kiendeshaji bado kimesimbwa kwa chaguomsingi, na nenosiri ambalo mmiliki mpya huchagua wakati huo wa kuwasha wa kwanza huwa nenosiri la usimbaji pia. (Mashine ambayo tayari umekuwa ukiitumia inaweza kukabidhiwa bila kusakinisha upya pia — tazama [kuweka upya kompyuta](48-security.md).)

### Usakinishaji usio na uangalizi

ISO inaweza pia kusakinisha kabisa peke yake — bila kibodi, bila mchawi — inapopewa usanidi wake kwenye kiendeshaji cha pili. Hiyo ndiyo njia ya kutumia Omarchy kama picha ya msingi kwa VMs na mashine za kundi. Tazama [usakinishaji usio na uangalizi](51-unattended-installs.md).

### Usakinishaji bila usimbaji

Omarchy husakinishwa na usimbaji kwa chaguomsingi. Ni chaguo salama na la kuwajibika kwa kompyuta yoyote ambayo inaweza kupotea au kuibiwa. Hutaki mtu yeyote mwenye ufikiaji wa vifaa vyako aweze kupata data yako!

Lakini katika hali maalumu, kama usakinishaji wa Omarchy wa mbali kwenye kompyuta zilizolindwa au kwa usakinishaji wa kutupa bila data nyeti, unaweza kutaka kusakinisha bila usimbaji. Unaweza kubonyeza `Ctrl + C` kwenye uthibitisho wa umbizo la diski ili kubadili hadi usakinishaji usio na usimbaji.

### Lugha

Omarchy huzungumza lugha 50 — seti sawa na omarchy.org — na Kiingereza ndicho chaguomsingi. Ili kubadili, fungua menyu ya Omarchy na uende _Sanidi > Lugha_, au endesha `omarchy language <code>` kwenye terminali (`omarchy language list` huonyesha misimbo). Menyu, eneo-kazi, na arifa za Omarchy yenyewe hubadilika lugha mara moja, na eneo la mfumo huwekwa kulingana, hivyo programu zako nyingine hufuata wakati mwingine unapoingia.

### Msaada kama umekwama

Ikiwa umekwama, kwa kawaida unaweza kumpata mtu anayetaka kusaidia katika kituo cha _#omarchy-help_ kwenye [Discord ya jumuiya](https://omarchy.org/discord).
