# Boshlash

Omarchy ISO yordamida o‘rnatiladi. Butun diskni egallaydigan to‘liq diskka o‘rnatishni yoki Omarchy ni diskdagi ajratilmagan joyga qo‘yadigan bo‘sh joyga o‘rnatishni tanlashingiz mumkin — Windows yoki boshqa OS bilan yonma-yon ikkita tizimni yuklash shunday amalga oshiriladi (qarang [ikkita tizimni yonma-yon o‘rnatish](50-dual-boot-install.md) — eslatma: avval Windows da BitLocker ni o‘chirishingiz kerak bo‘ladi). Har qanday holatda ham o‘rnatish sukut bo‘yicha to‘liq shifrlash bilan amalga oshiriladi va to‘liq disk varianti tanlangan diskni tozalab tashlaydi, shuning uchun mavjud diskdan foydalanishdan oldin albatta zaxira nusxa oling!

Avval [Omarchy ISO sini yuklab oling](https://omarchy.org/), uni USB flesh-kartaga yozing (Mac/Windows da [balenaEtcher](https://etcher.balena.io/) yoki Linux da [caligula](https://github.com/ifd3f/caligula) dan foydalaning) va o‘sha flesh-kartadan yuklaning.

_BIOS da Secure Boot va/yoki TPM ni o‘chirishingiz shart. Omarchy ni o‘rnata olish uchun bularni o‘chirishingiz kerak. Bular Windows va Microsoft ga aloqador Linux distributivlari uchun mo‘ljallangan Microsoft xavfsizlik sxemalaridir._

So‘ngra konfiguratsiya savollariga javob bering va ularni mana bunday tasdiqlang:

 ![install-config](images/install-config.webp)

So‘ngra o‘rnatish uchun disk tanlang, orqaga suyangancha o‘tiring va o‘rnatish shousini tomosha qiling. Eng tezkor zamonaviy mashinalarda bu bir daqiqadan kam vaqtda tugashi mumkin, lekin eskiroq kompyuterda ham 5 daqiqadan ko‘proq vaqt olmasligi kerak.

 ![install-done](images/install-done.webp)

Endi siz Omarchy ga tayyorsiz!

### Simli yoki 2.4ghz klaviaturadan foydalaning!

To‘liq disk shifrlashi ishga tushishda Bluetooth klaviaturadan parolni kiritishingizga ruxsat bermaydi. Xuddi PC da BIOS ga kirish uchun Bluetooth klaviaturadan foydalana olmaganingiz kabi. Sizga yo 2.4ghz dongle ishlatadigan, yo kabel orqali ulanadigan klaviatura kerak bo‘ladi (bu baribir kechikish jihatidan ancha yaxshi!). Men shaxsan [Lofree Flow84](https://www.lofree.co/products/lofree-flow-the-smoothest-mechanical-keyboard) ni juda yaxshi ko‘raman!

### Boshqa egasi uchun o‘rnatish

Agar mashinani boshqa birov — oila a’zosi, yangi xodim, xaridor — uchun tayyorlayotgan bo‘lsangiz, shaxsiy savollarga uning nomidan javob bermasligingiz kerak. O‘rnatuvchining eng birinchi ekranida (klaviatura tanlash) `Ctrl + C` ni bosing va Omarchy uning o‘rniga mashinani boshqa egasi uchun tayyorlashni taklif qiladi. Tizim darhol o‘rnatiladi, lekin barcha shaxsiy sozlashlar — klaviatura tartibi, foydalanuvchi nomi, parol — mashina birinchi marta yuklanguncha qoldiriladi. Disk baribir sukut bo‘yicha shifrlangan bo‘ladi va yangi egasi o‘sha birinchi yuklanishda tanlagan parol shifrlash paroli ham bo‘lib qoladi. (Siz allaqachon foydalanib kelgan mashinani qayta o‘rnatishsiz ham topshirishingiz mumkin — qarang [kompyuterni asl holatiga qaytarish](48-security.md).)

### Nazoratsiz o‘rnatishlar

ISO shuningdek, unga konfiguratsiyasi ikkinchi diskda topshirilsa, butunlay o‘z-o‘zidan — klaviaturasiz, o‘rnatish yordamchisisiz — o‘rnatilishi ham mumkin. Omarchy ni VM lar va mashinalar parki uchun asosiy obraz sifatida ishlatishning yo‘li shu. Qarang [nazoratsiz o‘rnatishlar](51-unattended-installs.md).

### Shifrlashsiz o‘rnatishlar

Omarchy sukut bo‘yicha shifrlash bilan o‘rnatiladi. Bu yo‘qolishi yoki o‘g‘irlanishi mumkin bo‘lgan har qanday kompyuter uchun xavfsiz, mas’uliyatli tanlovdir. Uskunangizga kira olgan har kim ma’lumotlaringizni qo‘lga kirita olishini istamaysiz!

Lekin maxsus holatlarda, masalan, himoyalangan kompyuterlarga masofaviy Omarchy o‘rnatishlarda yoki maxfiy ma’lumotlarsiz bir martalik o‘rnatishlarda, shifrlashsiz o‘rnatishni xohlashingiz mumkin. Shifrlashsiz o‘rnatishga o‘tish uchun diskni formatlashni tasdiqlash ekranida `Ctrl + C` ni bosishingiz mumkin.

### Til

Omarchy 50 tilda gapiradi — omarchy.org dagi bilan bir xil to‘plam — va sukut bo‘yicha ingliz tili ishlatiladi. Almashtirish uchun Omarchy menyusini oching va _Sozlash > Til_ ga o‘ting yoki terminalda `omarchy language <code>` ni ishga tushiring (`omarchy language list` kodlarni ko‘rsatadi). Menyu, ish stoli va Omarchy ning o‘z bildirishnomalari darhol tilni o‘zgartiradi va undan keyin ochadigan har bir ilovangiz ham shunga ergashadi. Allaqachon ochiq bo‘lgan ilovalar ularni qayta ishga tushirganingizda almashadi.

### Tiqilib qolsangiz yordam

Agar tiqilib qolsangiz, odatda [hamjamiyat Discord](https://omarchy.org/discord) idagi _#omarchy-help_ kanalida yordam berishga tayyor kimnidir topishingiz mumkin.
