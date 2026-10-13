# Navigasi

Segala-galanya dalam Omarchy berlaku melalui papan kekunci — _SEGALA-GALANYA!_ Apabila sistem mula-mula bermula, anda benar-benar tidak boleh melakukan apa-apa dengan tetikus sahaja. Tetapi anda boleh menekan `Super + Space` untuk mendedahkan Menu Omarchy dan dari sini anda boleh melakukan hampir segala-galanya.

Tetapi menu Omarchy bukanlah cara utama yang dimaksudkan untuk mengendalikan sistem pada kebanyakan masa. Kita boleh menjadi lebih pantas daripada itu! Semua aplikasi yang paling penting diikat terus kepada kekunci panas individu. Anda memulakan terminal dengan `Super + Return` dan pelayar dengan `Super + Shift + Return`. Cuba lakukan satu demi satu, dan anda akan melihat keajaiban jubinan Hyprland beraksi:

 ![navigation-browser-terminal](images/navigation-browser-terminal.webp)

Anda kemudian boleh menekan `Super + J` untuk menyusunnya di atas satu sama lain dan bukannya bersebelahan:

 ![navigation-stacked](images/navigation-stacked.webp)

Tekan `Super + J` sekali lagi untuk mengembalikannya ke kedudukan bersebelahan. Kemudian cuba `Super + Shift + Arrow Right` semasa pada pelayar untuk menukar tetingkap.

Sekarang cuba `Super + Ctrl + T` untuk memulakan monitor Aktiviti. Itu akan muncul sebagai tetingkap terapung. Anda boleh menjubinkannya menggunakan `Super + T` (dan tekan itu sekali lagi untuk menjadikannya terapung semula). Sekarang tekan `Super + Shift + F` untuk membuka pengurus fail. Anda akan mempunyai persediaan empat hala yang kemas:

 ![navigation-fourway-tiling](images/navigation-fourway-tiling.webp)

Anda menavigasi antara tetingkap yang anda mahu aktifkan dengan `Super + Arrow`. Ini akan menukar fokus dan menggerakkan kursor ke tengah aplikasi baharu.

Jika anda menekan `Super + Shift + 2`, anda akan memindahkan aplikasi yang sedang difokuskan ke ruang kerja kedua. `Super + Shift + 1` memindahkannya kembali. (Dan `Super + Shift + Alt + 2` akan memindahkan aplikasi yang sedang difokuskan ke ruang kerja kedua tanpa beralih kepadanya).

Jika anda menahan `Super` dan menggunakan tetikus untuk mengklik pada tetingkap, anda akan dapat menyusun semula tempatnya berada. Jika anda menahan `Super` dan menggunakan butang kanan pada tetikus, anda boleh mengubah saiz tetingkap dengan bebas.

Anda menutup tetingkap pada `Super + W` atau `Super + Q` (dan menutup semua tetingkap pada `Ctrl + Alt + Delete`).

Anda juga boleh pergi ke skrin penuh dengan `Super + F` atau hanya lebar penuh (mengekalkan bar atas) dengan `Super + Alt + F` atau skrin penuh di dalam tetingkap dengan `Super + Ctrl + F` (baik untuk YouTube!).

### Susun atur Dwindle lwn penatalan

Susun atur lalai Omarchy dipanggil dwindle. Ia mengekalkan semua tetingkap yang anda buka pada satu ruang kerja kelihatan pada setiap masa, walaupun ia perlu mengecilkannya.

 ![navigation-dwindle-layout](images/navigation-dwindle-layout.webp)

Tetapi anda juga boleh memilih untuk menukar ruang kerja kepada susun atur penatalan di mana tetingkap dibariskan bersebelahan, melampaui tepi paparan yang kelihatan. Anda menukar satu ruang kerja kepada susun atur ini melalui `Super + L`.

Menekan `Super + L` sekali lagi menjadikan ruang kerja terapung, di mana tetingkap bertindih dengan bebas dan anda meletakkannya sendiri, dan tekanan ketiga mengembalikannya kepada dwindle. `Super + Alt + L` melaluinya dalam arah yang lain. Tetingkap yang terapung walau apa pun — yang anda keluarkan dengan `Super + T`, atau aplikasi yang sentiasa dibuka terapung — kekal terapung apabila ruang kerja kembali kepada jubinan. Bar atas menandakan ruang kerja yang anda berada padanya dengan susunan aturnya: segi empat sama untuk dwindle, bulatan untuk penatalan, dan segi tiga untuk terapung. Mengklik tanda itu juga mengitar susun atur.

 ![navigation-scrolling-layout](images/navigation-scrolling-layout.webp)

Pilihan adalah bagi setiap ruang kerja, dan ia kekal. Jadi anda boleh mengekalkan ruang kerja 1 pada dwindle untuk pelayaran dan ruang kerja 2 pada penatalan untuk kod, dan kedua-duanya akan kembali begitu selepas dimulakan semula.

Jika anda ingin menggunakan susun atur penatalan sebagai lalai, anda boleh menetapkannya dalam `~/.config/hypr/looknfeel.lua`:

```lua
hl.config({
  general = {
    layout = "scrolling",
  },
})
```

### Ruang kerja terapung

Ruang kerja terapung berfungsi seperti desktop tradisional: tetingkap bertindih, dan anda menggerakkan dan mengubah saiznya sendiri. Setiap tetingkap mendapat bar tajuk dalam warna tema anda, dengan butang untuk mengecilkan, membesarkan, dan menutup. `Super + M` juga mengecilkan tetingkap yang difokuskan. Tetingkap yang dikecilkan menunggu dalam dok; klik aplikasinya untuk membawanya kembali. Klik tetingkap untuk membawanya ke hadapan. Ubah saiznya dari mana-mana tepi atau sudut. Klik dua kali bar tajuk untuk membesarkan tetingkap sambil mengekalkan bar atas dalam pandangan, dan sekali lagi untuk mendapatkan saiz lamanya kembali.

Ruang kerja terapung juga memaparkan dok, dengan aplikasi yang anda sematkan, semua yang sedang berjalan, dan grid setiap aplikasi di sebalik butang aplikasi, yang `Super + Alt + Space` dan _Aplikasi_ dalam menu Omarchy juga membukanya. Klik kanan aplikasi pada grid, atau tekan `Delete`, untuk menyahpasangnya. Klik aplikasi untuk membukanya, atau untuk membawa tetingkapnya ke hadapan; klik sekali lagi untuk mengitar melalui tetingkapnya. Klik tengah membuka tetingkap baharu. Seret ikon di sepanjang dok untuk menggerakkannya; menyeret aplikasi yang sedang berjalan ke antara yang lain mengekalkannya di sana. Klik kanan untuk mengekalkan aplikasi dalam dok, mengeluarkannya, atau menghentikannya. Dok menghindar daripada tetingkap skrin penuh. Klik kanan butang aplikasi untuk memindahkan dok ke tepi lain atau membuatnya bersembunyi sehingga penunjuk mencapai tepinya. Kedudukan juga berada di bawah _Pencetus > Penampilan > Dok > Kedudukan Dok_, dan `omarchy dock position left` dan `omarchy dock autohide on` menetapkan kedua-duanya dari terminal. Aplikasi yang anda kekalkan dalam dok dipudarkan semasa ia tidak berjalan.

Ruang kerja baharu, dan mana-mana yang anda belum berikan susun atur sendiri dengan `Super + L`, menggunakan susun atur lalai. Menukar lalai menetapkan semula setiap ruang kerja tanpa tetingkap kepadanya, manakala yang mempunyai tetingkap padanya mengekalkan susun atur yang dimilikinya. Pilihnya di bawah _Pencetus > Penampilan > Susun Atur Ruang Kerja_: Jubinan, Penatalan, atau Terapung. `omarchy-hyprland-workspace-layout-default scrolling` menetapkannya dari terminal.

### Mengumpulkan tetingkap

Tetingkap boleh dikumpulkan menggunakan `Super + G`. Sebaik sahaja anda berada dalam kumpulan, setiap tetingkap yang anda mulakan semasa itu aktif akan tergolong dalam kumpulan. Anda boleh bergerak antara tetingkap berkumpulan ini menggunakan `Super + Ctrl + Arrow Left/Right` atau `Super + Alt + 1/2/3/4` untuk pergi terus kepada tetingkap berkumpulan mengikut tertib.

Anda boleh memindahkan tetingkap keluar daripada kumpulan dengan `Super + Alt + G` atau membongkar keseluruhan kumpulan dengan menekan `Super + G` sekali lagi. Akhir sekali, anda boleh memindahkan tetingkap di luar kumpulan ke dalamnya dengan `Super + Alt + Arrows`.

### Mengeluarkan tetingkap

Anda boleh mengeluarkan tetingkap daripada peruntukan ruang kerjanya dengan `Super + O`. Itu akan menyematkannya sebagai tetingkap terapung yang mengikuti anda pada mana-mana ruang kerja yang anda pergi. Bagus untuk pemain video dan seumpamanya.

 ![navigation-popped-window](images/navigation-popped-window.webp)

### Ruang kerja pad conteng

Akhir sekali, terdapat ruang kerja pad conteng khas yang jatuh ke atas mana-mana ruang kerja yang anda sedang berada padanya, seperti konsol Quake. Togolnya dengan `Super + Grave` atau `Super + S`, dan letakkan tetingkap di sana menggunakan `Super + Shift + Grave` atau `Super + Alt + S`.

Ia berfungsi dengan sangat baik untuk terminal yang menjalankan ejen, atau untuk kawalan yang anda mahu berinteraksi dengannya dengan cepat tanpa meninggalkan ruang kerja semasa. Untuk memindahkan tetingkap dari pad conteng, hantarnya terus ke ruang kerja lain dengan sesuatu seperti `Super + Shift + 1`.

Semasa pad conteng memegang satu tetingkap, ia jatuh sebagai panel berpusat dan bukannya merentangi skrin. Letakkan aplikasi kedua padanya dan ia kembali kepada lebar penuh, jadi kedua-duanya mempunyai ruang untuk duduk bersebelahan.

### Ia mengambil masa untuk membiasakan diri!

Ia mengambil sedikit masa untuk membiasakan diri menavigasi desktop anda seperti ini, tetapi sebaik sahaja anda melakukannya, sukar untuk kembali kepada pengalaman desktop tradisional yang dipacu tetikus!
