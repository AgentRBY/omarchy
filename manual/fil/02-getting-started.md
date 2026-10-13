# Pagsisimula

Ini-install ang Omarchy gamit ang isang ISO. Maaari kang mamili sa pagitan ng full-disk install, na sumasakop sa buong drive, o free-space install, na naglalagay ng Omarchy sa hindi pa nagagamit na espasyo sa isang drive — iyan ang paraan para mag-dual boot kasama ng Windows o ng ibang OS (tingnan ang [dual-boot install](50-dual-boot-install.md) — tandaan na kailangan mong i-off muna ang BitLocker sa Windows). Sa alinmang paraan, naka-full encryption ang pag-install bilang default, at buburahin ng full-disk na opsyon ang napiling drive, kaya siguraduhing mag-backup ka bago gumamit ng isang umiiral na drive!

[I-download muna ang Omarchy ISO](https://omarchy.org/), ilagay ito sa isang USB stick (gamitin ang [balenaEtcher](https://etcher.balena.io/) sa Mac/Windows o ang [caligula](https://github.com/ifd3f/caligula) sa Linux), at mag-boot mula sa stick.

_Kailangan mong i-off ang Secure Boot at/o TPM sa BIOS. Kailangan mong i-off ang mga ito para mai-install ang Omarchy. Mga security scheme ito ng Microsoft na para sa Windows at sa mga distribusyon ng Linux na kaugnay ng Microsoft._

Pagkatapos, sagutin ang mga tanong sa configuration, at kumpirmahin ang mga ito nang ganito:

 ![install-config](images/install-config.webp)

Pagkatapos, pumili ng drive para sa iyong pag-install, at umupo at panoorin ang installation show. Matatapos ito sa loob ng wala pang isang minuto sa pinakamabilis na mga modernong makina, ngunit hindi ito dapat tumagal nang higit sa 5 minuto kahit sa isang mas lumang computer.

 ![install-done](images/install-done.webp)

Handa ka nang mag-Omarchy!

### Gumamit ng wired o 2.4ghz na keyboard!

Hindi ka papayagan ng full-disk encryption na ilagay ang password mula sa isang Bluetooth keyboard sa startup. Tulad ng hindi mo magagamit ang isang Bluetooth keyboard para pumasok sa BIOS sa isang PC. Kakailanganin mo ng keyboard na gumagamit ng 2.4ghz dongle o ng kable (na mas mainam naman para sa latency!). Personal kong gusto ang [Lofree Flow84](https://www.lofree.co/products/lofree-flow-the-smoothest-mechanical-keyboard)!

### Pag-install para sa ibang may-ari

Kung naghahanda ka ng makina para sa ibang tao — isang kapamilya, isang bagong empleyado, isang mamimili — hindi mo dapat sinasagot ang mga personal na tanong para sa kanila. Pindutin ang `Ctrl + C` sa pinakaunang screen ng installer (ang pagpili ng keyboard), at i-aalok ng Omarchy na ihanda ang makina para sa ibang may-ari. Mai-install kaagad ang sistema, ngunit ang lahat ng personal na pag-setup — layout ng keyboard, username, password — ay ipagpapaliban hanggang sa unang mag-boot ang makina. Naka-encrypt pa rin ang drive bilang default, at ang password na pipiliin ng bagong may-ari sa unang boot na iyon ang magiging encryption password din. (Maaari ring ibigay nang walang reinstall ang isang makinang nagamit mo na — tingnan ang [pag-reset ng computer](48-security.md).)

### Mga unattended install

Maaari ring mag-install ang ISO nang mag-isa — walang keyboard, walang wizard — kapag binigyan ito ng configuration sa pangalawang drive. Iyan ang paraan para ituring ang Omarchy bilang base image para sa mga VM at fleet machine. Tingnan ang [mga unattended install](51-unattended-installs.md).

### Mga pag-install na walang encryption

Ini-install ang Omarchy na may encryption bilang default. Ito ang ligtas at responsableng pagpipilian para sa anumang computer na maaaring mawala o manakaw. Hindi mo gugustuhing makuha ng sinumang may access sa iyong hardware ang iyong data!

Ngunit sa mga espesyal na pagkakataon, tulad ng mga remote na pag-install ng Omarchy sa mga protektadong computer o para sa mga disposable na pag-install na walang sensitibong data, maaari mong gustuhing mag-install nang walang encryption. Maaari mong pindutin ang `Ctrl + C` sa kumpirmasyon ng pag-format ng disk para lumipat sa isang pag-install na walang encryption.

### Wika

Nagsasalita ang Omarchy ng 50 wika — ang parehong set tulad ng sa omarchy.org — at Ingles ang default. Para lumipat, buksan ang menu ng Omarchy at pumunta sa _Pag-setup > Wika_, o patakbuhin ang `omarchy language <code>` sa isang terminal (ipinapakita ng `omarchy language list` ang mga code). Agad na nagbabago ng wika ang menu, desktop, at sariling mga notipikasyon ng Omarchy, at itinatakda ang locale ng sistema para tumugma, kaya susunod ang iba mong application sa susunod mong pag-log in.

### Tulong kung ma-stuck ka

Kung ma-stuck ka, karaniwan ay makakahanap ka ng taong handang tumulong sa channel na _#omarchy-help_ sa [Discord ng komunidad](https://omarchy.org/discord).
