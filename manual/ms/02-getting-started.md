# Bermula

Omarchy dipasang menggunakan ISO. Anda boleh memilih antara pemasangan cakera penuh, yang mengambil alih keseluruhan pemacu, atau pemasangan ruang kosong, yang meletakkan Omarchy dalam ruang yang tidak diperuntukkan pada pemacu — begitulah cara anda melakukan but dwi di samping Windows atau OS lain (lihat [pemasangan but dwi](50-dual-boot-install.md) — ambil perhatian bahawa anda perlu mematikan BitLocker dalam Windows terlebih dahulu). Walau apa pun, pemasangan lalai kepada penyulitan penuh, dan pilihan cakera penuh akan memadam pemacu yang dipilih, jadi pastikan anda membuat sandaran sebelum menggunakan pemacu sedia ada!

[Muat turun ISO Omarchy](https://omarchy.org/) terlebih dahulu, letakkannya pada pemacu USB (gunakan [balenaEtcher](https://etcher.balena.io/) pada Mac/Windows atau [caligula](https://github.com/ifd3f/caligula) pada Linux), dan but daripadanya.

_Anda mesti mematikan Secure Boot dan/atau TPM dalam BIOS. Anda perlu mematikan ini untuk dapat memasang Omarchy. Ia ialah skim keselamatan Microsoft yang dimaksudkan untuk Windows dan edaran Linux yang bersekutu dengan Microsoft._

Kemudian jawab soalan konfigurasi, dan sahkannya seperti ini:

 ![install-config](images/install-config.webp)

Kemudian pilih pemacu untuk pemasangan anda, dan duduk berehat sambil menyaksikan persembahan pemasangan berlangsung. Ia boleh disiapkan dalam masa kurang daripada seminit pada mesin moden terpantas, tetapi ia tidak sepatutnya mengambil masa lebih daripada 5 minit walaupun pada komputer yang lebih lama.

 ![install-done](images/install-done.webp)

Kini anda bersedia untuk menggunakan Omarchy!

### Gunakan papan kekunci berwayar atau 2.4ghz!

Penyulitan cakera penuh tidak akan membenarkan anda memasukkan kata laluan daripada papan kekunci Bluetooth semasa permulaan. Sama seperti anda tidak boleh menggunakan papan kekunci Bluetooth untuk memasuki BIOS pada PC. Anda memerlukan papan kekunci yang menggunakan sama ada dongle 2.4ghz atau kabel (yang jauh lebih baik untuk kependaman walau apa pun!). Saya sendiri sangat menyukai [Lofree Flow84](https://www.lofree.co/products/lofree-flow-the-smoothest-mechanical-keyboard)!

### Memasang untuk pemilik lain

Jika anda menyediakan mesin untuk orang lain — ahli keluarga, pekerja baharu, pembeli — anda tidak sepatutnya menjawab soalan peribadi bagi pihak mereka. Tekan `Ctrl + C` pada skrin pertama pemasang (pemilihan papan kekunci), dan Omarchy akan menawarkan untuk menyediakan mesin bagi pemilik lain sebagai gantinya. Sistem dipasang serta-merta, tetapi semua persediaan peribadi — susun atur papan kekunci, nama pengguna, kata laluan — ditangguhkan sehingga mesin dibut buat kali pertama. Pemacu masih disulitkan secara lalai, dan kata laluan yang dipilih oleh pemilik baharu pada but pertama itu juga menjadi kata laluan penyulitan. (Mesin yang telah anda gunakan juga boleh diserahkan tanpa pemasangan semula — lihat [menetapkan semula komputer](48-security.md).)

### Pemasangan tanpa pengawasan

ISO juga boleh memasang sepenuhnya dengan sendirinya — tanpa papan kekunci, tanpa wizard — apabila konfigurasinya diserahkan padanya pada pemacu kedua. Itulah cara untuk menganggap Omarchy sebagai imej asas untuk VM dan mesin armada. Lihat [pemasangan tanpa pengawasan](51-unattended-installs.md).

### Pemasangan tanpa penyulitan

Omarchy dipasang dengan penyulitan secara lalai. Ia ialah pilihan yang selamat dan bertanggungjawab untuk mana-mana komputer yang mungkin hilang atau dicuri. Anda tidak mahu sesiapa yang mempunyai akses kepada perkakasan anda dapat mendapatkan data anda!

Tetapi dalam keadaan khas, seperti pemasangan Omarchy jauh pada komputer yang dilindungi atau untuk pemasangan pakai buang tanpa data sensitif, anda mungkin mahu memasang tanpa penyulitan. Anda boleh menekan `Ctrl + C` pada pengesahan pemformatan cakera untuk beralih kepada pemasangan tanpa penyulitan.

### Bahasa

Omarchy bertutur dalam 50 bahasa — set yang sama dengan omarchy.org — dan Bahasa Inggeris ialah lalainya. Untuk menukar, buka menu Omarchy dan pergi ke _Persediaan > Bahasa_, atau jalankan `omarchy language <code>` dalam terminal (`omarchy language list` memaparkan kod tersebut). Menu, desktop, dan pemberitahuan Omarchy sendiri menukar bahasa serta-merta, dan lokal sistem ditetapkan untuk memadani, jadi aplikasi anda yang lain mengikutinya pada kali berikutnya anda log masuk.

### Bantuan jika anda tersekat

Jika anda tersekat, anda biasanya boleh mencari seseorang yang sudi membantu dalam saluran _#omarchy-help_ di [Discord komuniti](https://omarchy.org/discord).
