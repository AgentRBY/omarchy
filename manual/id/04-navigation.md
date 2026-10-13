# Navigasi

Segalanya di Omarchy terjadi melalui keyboard — _SEMUANYA!_ Ketika sistem pertama kali menyala, Anda benar-benar tidak dapat melakukan apa pun hanya dengan mouse. Namun Anda dapat menekan `Super + Space` untuk menampilkan Menu Omarchy dan dari sini Anda dapat melakukan hampir segalanya.

Namun menu Omarchy bahkan tidak dimaksudkan untuk menjadi cara utama mengoperasikan sistem sebagian besar waktu. Kita bisa lebih cepat dari itu! Semua aplikasi terpenting terikat langsung ke hotkey individual. Anda memulai terminal dengan `Super + Return` dan browser dengan `Super + Shift + Return`. Coba lakukan satu demi satu, dan Anda akan melihat keajaiban tiling Hyprland beraksi:

 ![navigation-browser-terminal](images/navigation-browser-terminal.webp)

Anda kemudian dapat menekan `Super + J` untuk menumpuk keduanya di atas satu sama lain alih-alih berdampingan:

 ![navigation-stacked](images/navigation-stacked.webp)

Tekan `Super + J` lagi untuk mengembalikannya ke posisi berdampingan. Lalu coba `Super + Shift + Arrow Right` saat berada di browser untuk menukar jendelanya.

Sekarang coba `Super + Ctrl + T` untuk memulai monitor Aktivitas. Itu akan muncul sebagai jendela melayang. Anda dapat mengubinnya menggunakan `Super + T` (dan tekan lagi untuk menjadikannya melayang kembali). Sekarang tekan `Super + Shift + F` untuk membuka manajer berkas. Anda akan memiliki pengaturan empat arah yang rapi:

 ![navigation-fourway-tiling](images/navigation-fourway-tiling.webp)

Anda menavigasi di antara jendela yang ingin Anda aktifkan dengan `Super + Arrow`. Ini akan mengalihkan fokus dan memindahkan kursor ke tengah aplikasi baru.

Jika Anda menekan `Super + Shift + 2`, Anda akan memindahkan aplikasi yang sedang fokus ke ruang kerja kedua. `Super + Shift + 1` memindahkannya kembali. (Dan `Super + Shift + Alt + 2` akan memindahkan aplikasi yang sedang fokus ke ruang kerja kedua tanpa beralih ke sana).

Jika Anda menahan `Super` dan menggunakan mouse untuk mengklik sebuah jendela, Anda akan dapat mengatur ulang tempatnya berada. Jika Anda menahan `Super` dan menggunakan tombol kanan pada mouse, Anda dapat dengan bebas mengubah ukuran jendela.

Anda menutup jendela dengan `Super + W` atau `Super + Q` (dan menutup semua jendela dengan `Ctrl + Alt + Delete`).

Anda juga dapat tampil layar penuh dengan `Super + F` atau bahkan hanya lebar penuh (mempertahankan bilah atas) dengan `Super + Alt + F` atau layar penuh di dalam jendela dengan `Super + Ctrl + F` (bagus untuk YouTube!).

### Tata letak dwindle vs gulir

Tata letak bawaan Omarchy disebut dwindle. Ia menjaga semua jendela yang Anda buka pada satu ruang kerja tetap terlihat sepanjang waktu, bahkan jika ia harus mengecilkannya.

 ![navigation-dwindle-layout](images/navigation-dwindle-layout.webp)

Namun Anda juga dapat memilih untuk mengubah ruang kerja menjadi tata letak gulir di mana jendela berderet berdampingan, melampaui tepi tampilan yang terlihat. Anda mengubah satu ruang kerja ke tata letak ini via `Super + L`.

Menekan `Super + L` lagi mengubah ruang kerja menjadi melayang, di mana jendela bebas tumpang tindih dan Anda menempatkannya sendiri, dan penekanan ketiga mengembalikannya ke dwindle. `Super + Alt + L` melaluinya ke arah sebaliknya. Jendela yang memang melayang — yang Anda keluarkan dengan `Super + T`, atau aplikasi yang selalu membuka melayang — tetap melayang ketika ruang kerja kembali ke tiling. Bilah atas menandai ruang kerja Anda dengan tata letaknya: kotak untuk dwindle, lingkaran untuk gulir, dan segitiga untuk melayang. Mengklik tanda itu juga menggilir tata letaknya.

 ![navigation-scrolling-layout](images/navigation-scrolling-layout.webp)

Pilihan ini per ruang kerja, dan ia bertahan. Jadi Anda dapat menjaga ruang kerja 1 pada dwindle untuk browsing dan ruang kerja 2 pada gulir untuk kode, dan keduanya akan kembali seperti itu setelah mulai ulang.

Jika Anda ingin menggunakan tata letak gulir sebagai bawaan, Anda dapat mengaturnya di `~/.config/hypr/looknfeel.lua`:

```lua
hl.config({
  general = {
    layout = "scrolling",
  },
})
```

### Ruang kerja melayang

Ruang kerja melayang bekerja seperti desktop tradisional: jendela tumpang tindih, dan Anda memindahkan serta mengubah ukurannya sendiri. Setiap jendela mendapatkan bilah judul dalam warna tema Anda, dengan tombol untuk meminimalkan, memaksimalkan, dan menutup. `Super + M` juga meminimalkan jendela yang fokus. Jendela yang diminimalkan menunggu di dock; klik aplikasinya untuk membawanya kembali. Klik sebuah jendela untuk membawanya ke depan. Ubah ukurannya dari tepi atau sudut mana pun. Klik dua kali bilah judul untuk memaksimalkan jendela sambil menjaga bilah atas tetap terlihat, dan lagi untuk mendapatkan kembali ukuran lamanya.

Ruang kerja melayang juga menunjukkan dock, dengan aplikasi yang Anda sematkan, semua yang sedang berjalan, dan kisi setiap aplikasi di belakang tombol aplikasi, yang juga dibuka oleh `Super + Alt + Space` dan _Aplikasi_ di menu Omarchy. Klik kanan aplikasi pada kisi, atau tekan `Delete`, untuk menghapus pemasangannya. Klik sebuah aplikasi untuk membukanya, atau untuk membawa jendelanya ke depan; klik lagi untuk menggilir jendelanya. Klik tengah membuka jendela baru. Seret ikon di sepanjang dock untuk memindahkannya; menyeret aplikasi yang sedang berjalan di antara yang lain menjaganya di sana. Klik kanan untuk menyimpan aplikasi di dock, mengeluarkannya, atau keluar darinya. Dock menyingkir dari jendela layar penuh. Klik kanan tombol aplikasi untuk memindahkan dock ke tepi lain atau membuatnya tersembunyi sampai pointer mencapai tepinya. Posisi juga ada di bawah _Pemicu > Tampilan > Dock > Posisi Dock_, dan `omarchy dock position left` serta `omarchy dock autohide on` mengatur keduanya dari terminal. Aplikasi yang Anda simpan di dock menjadi pudar saat mereka tidak berjalan.

Ruang kerja baru, dan yang belum Anda beri tata letak sendiri dengan `Super + L`, menggunakan tata letak bawaan. Mengubah bawaan mengatur ulang setiap ruang kerja tanpa jendela ke tata letak itu, sementara yang memiliki jendela di atasnya mempertahankan tata letak yang dimilikinya. Pilih di bawah _Pemicu > Tampilan > Tata Letak Ruang Kerja_: Ubin, Gulir, atau Melayang. `omarchy-hyprland-workspace-layout-default scrolling` mengaturnya dari terminal.

### Mengelompokkan jendela

Jendela dapat dikelompokkan menggunakan `Super + G`. Setelah Anda berada dalam sebuah grup, setiap jendela yang Anda mulai saat grup itu aktif akan termasuk dalam grup. Anda dapat berpindah di antara jendela-jendela yang dikelompokkan ini menggunakan `Super + Ctrl + Arrow Left/Right` atau `Super + Alt + 1/2/3/4` untuk langsung ke jendela yang dikelompokkan secara berurutan.

Anda dapat memindahkan jendela keluar dari pengelompokan dengan `Super + Alt + G` atau membongkar seluruh grup dengan menekan `Super + G` lagi. Terakhir, Anda dapat memindahkan jendela di luar grup ke dalamnya dengan `Super + Alt + Arrows`.

### Meletuskan jendela

Anda dapat meletuskan jendela keluar dari alokasi ruang kerjanya dengan `Super + O`. Itu akan menyematkannya sebagai jendela melayang yang mengikuti Anda ke ruang kerja mana pun yang Anda tuju. Bagus untuk pemutar video dan semacamnya.

 ![navigation-popped-window](images/navigation-popped-window.webp)

### Ruang kerja scratchpad

Terakhir, ada ruang kerja scratchpad khusus yang turun menimpa ruang kerja apa pun yang sedang Anda gunakan, sangat mirip konsol Quake. Alihkan dengan `Super + Grave` atau `Super + S`, dan tempatkan jendela di sana menggunakan `Super + Shift + Grave` atau `Super + Alt + S`.

Ini bekerja sangat baik untuk terminal yang menjalankan agen, atau untuk kontrol yang ingin Anda interaksikan dengan cepat tanpa meninggalkan ruang kerja saat ini. Untuk memindahkan jendela dari scratchpad, kirim langsung ke ruang kerja lain dengan sesuatu seperti `Super + Shift + 1`.

Saat scratchpad menampung satu jendela, ia turun sebagai panel terpusat alih-alih membentang di layar. Taruh aplikasi kedua di atasnya dan ia kembali ke lebar penuh, sehingga keduanya memiliki ruang untuk duduk berdampingan.

### Perlu waktu untuk terbiasa!

Perlu sedikit waktu untuk terbiasa menavigasi desktop Anda seperti ini, tetapi begitu Anda terbiasa, akan sulit untuk kembali ke pengalaman desktop tradisional yang digerakkan mouse!
