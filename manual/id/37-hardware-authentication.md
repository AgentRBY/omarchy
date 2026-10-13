# Autentikasi perangkat keras

### Autentikasi sidik jari

Banyak laptop dilengkapi sensor sidik jari untuk melakukan autentikasi. Kamu bisa menggunakannya dengan Omarchy dengan menjalankan _Pengaturan > Security > Fingerprint_ di menu Omarchy (`Super + Space`).

Itu akan memasang paket sidik jari, mengumpulkan sidik jarimu, memverifikasinya, dan kamu siap menggunakan sidik jarimu untuk membuka kunci dari layar kunci (yang bisa kamu picu dengan `Super + Ctrl + L`), masuk ke mode sudo, dan mengotorisasi prompt sistem.

Saat penutup laptopmu tertutup, prompt sidik jari otomatis dilewati, jadi kamu langsung menuju prompt kata sandi alih-alih menunggu sensor yang tidak bisa kamu jangkau. Jika sebaliknya kamu perlu bekerja pada keyboard eksternal yang tidak punya sensor, cukup tekan `CTRL + C`, saat kamu diminta sidik jarimu selama `sudo`.

Kamu bisa menghapus autentikasi sidik jari di _Hapus > Security > Fingerprint_ di menu Omarchy.

### Autentikasi Fido2

Jika kamu menggunakan perangkat Fido2, kamu bisa mengaturnya untuk autentikasi `sudo` menggunakan _Pengaturan > Security > Fido2_ di menu Omarchy (`Super + Space`). Namun, itu mencakup `sudo` dan prompt otorisasi sistem, bukan membuka kunci komputermu.

Kamu bisa menghapus autentikasi fido2 di _Hapus > Security > Fido2_ di menu Omarchy.
