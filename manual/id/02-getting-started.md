# Memulai

Omarchy dipasang menggunakan ISO. Anda dapat memilih antara pemasangan disk penuh, yang mengambil alih seluruh drive, atau pemasangan ruang kosong, yang menempatkan Omarchy di ruang yang belum dialokasikan pada sebuah drive — begitulah cara Anda melakukan dual boot bersama Windows atau OS lain (lihat [pemasangan dual-boot](50-dual-boot-install.md) — perlu dicatat bahwa Anda harus mematikan BitLocker di Windows terlebih dahulu). Bagaimanapun juga, pemasangan secara bawaan menggunakan enkripsi penuh, dan opsi disk penuh akan menghapus drive yang dipilih, jadi pastikan untuk membuat cadangan sebelum menggunakan drive yang sudah ada!

[Unduh ISO Omarchy](https://omarchy.org/) terlebih dahulu, taruh di stik USB (gunakan [balenaEtcher](https://etcher.balena.io/) di Mac/Windows atau [caligula](https://github.com/ifd3f/caligula) di Linux), dan boot dari stik tersebut.

_Anda harus mematikan Secure Boot dan/atau TPM di BIOS. Anda harus mematikan ini agar dapat memasang Omarchy. Keduanya adalah skema keamanan Microsoft yang dimaksudkan untuk Windows dan distribusi Linux yang berafiliasi dengan Microsoft._

Lalu jawab pertanyaan konfigurasinya, dan konfirmasikan seperti ini:

 ![install-config](images/install-config.webp)

Lalu pilih drive untuk pemasangan Anda, dan duduk santai sambil menonton pertunjukan pemasangannya berjalan. Pemasangan dapat selesai dalam waktu kurang dari satu menit pada mesin modern tercepat, tetapi seharusnya tidak memakan waktu lebih dari 5 menit bahkan pada komputer yang lebih tua.

 ![install-done](images/install-done.webp)

Sekarang Anda siap untuk Omarchy!

### Gunakan keyboard berkabel atau 2.4ghz!

Enkripsi disk penuh tidak akan mengizinkan Anda memasukkan kata sandi dari keyboard Bluetooth saat startup. Sama seperti Anda tidak dapat menggunakan keyboard Bluetooth untuk masuk ke BIOS pada PC. Anda memerlukan keyboard yang menggunakan dongle 2.4ghz atau kabel (yang jauh lebih baik untuk latensi!). Saya pribadi sangat menyukai [Lofree Flow84](https://www.lofree.co/products/lofree-flow-the-smoothest-mechanical-keyboard)!

### Memasang untuk pemilik lain

Jika Anda menyiapkan mesin untuk orang lain — anggota keluarga, karyawan baru, pembeli — Anda tidak boleh menjawab pertanyaan pribadi atas nama mereka. Tekan `Ctrl + C` pada layar pertama pemasang (pemilihan keyboard), dan Omarchy akan menawarkan untuk menyiapkan mesin untuk pemilik lain sebagai gantinya. Sistem langsung terpasang, tetapi semua penyiapan pribadi — tata letak keyboard, nama pengguna, kata sandi — ditunda hingga mesin boot untuk pertama kalinya. Drive tetap terenkripsi secara bawaan, dan kata sandi yang dipilih pemilik baru pada boot pertama tersebut juga menjadi kata sandi enkripsi. (Mesin yang sudah pernah Anda gunakan juga dapat diserahkan tanpa pemasangan ulang — lihat [mengatur ulang komputer](48-security.md).)

### Pemasangan tanpa pengawasan

ISO juga dapat memasang sepenuhnya sendiri — tanpa keyboard, tanpa wizard — ketika diberi konfigurasinya pada drive kedua. Itulah cara memperlakukan Omarchy sebagai image dasar untuk VM dan mesin armada. Lihat [pemasangan tanpa pengawasan](51-unattended-installs.md).

### Pemasangan tanpa enkripsi

Omarchy dipasang dengan enkripsi secara bawaan. Ini adalah pilihan yang aman dan bertanggung jawab untuk komputer mana pun yang mungkin hilang atau dicuri. Anda tidak ingin siapa pun yang memiliki akses ke perangkat keras Anda dapat mengambil data Anda!

Namun dalam keadaan khusus, seperti pemasangan Omarchy jarak jauh pada komputer yang terlindungi atau untuk pemasangan sekali pakai tanpa data sensitif, Anda mungkin ingin memasang tanpa enkripsi. Anda dapat menekan `Ctrl + C` pada konfirmasi pemformatan disk untuk beralih ke pemasangan tanpa enkripsi.

### Bahasa

Omarchy mendukung 50 bahasa — set yang sama dengan omarchy.org — dan bahasa Inggris adalah bawaannya. Untuk beralih, buka menu Omarchy dan buka _Pengaturan > Bahasa_, atau jalankan `omarchy language <code>` di terminal (`omarchy language list` menunjukkan kodenya). Menu, desktop, dan notifikasi Omarchy sendiri langsung berubah bahasa, dan lokal sistem diatur agar cocok, sehingga aplikasi Anda yang lain akan mengikuti saat Anda masuk berikutnya.

### Bantuan jika Anda mandek

Jika Anda mandek, Anda biasanya dapat menemukan seseorang yang bersedia membantu di saluran _#omarchy-help_ di [Discord komunitas](https://omarchy.org/discord).
