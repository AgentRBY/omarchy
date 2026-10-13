# Boshlash

Omarchy ISO yordamida oʻrnatiladi. Siz butun diskni egallaydigan toʻliq disk oʻrnatishini yoki Omarchyni diskdagi ajratilmagan boʻsh joyga joylashtiradigan boʻsh joy oʻrnatishini tanlashingiz mumkin — shu tariqa Windows yoki boshqa OT yonida dual boot qilasiz ([dual-boot oʻrnatish](50-dual-boot-install.md) ga qarang — esda tuting, avval Windowsda BitLockerni oʻchirib qoʻyishingiz kerak boʻladi). Har holda, oʻrnatish standartda toʻliq shifrlash bilan keladi va toʻliq disk varianti tanlangan diskni oʻchirib tashlaydi, shuning uchun mavjud diskni ishlatishdan oldin zaxira nusxa olishni unutmang!

Avval [Omarchy ISO ni yuklab oling](https://omarchy.org/), uni USB fleshkasiga yozing (Mac/Windowsda [balenaEtcher](https://etcher.balena.io/) yoki Linuxda [caligula](https://github.com/ifd3f/caligula) ishlating) va fleshkaning oʻzidan yuklaning.

_Siz BIOSda Secure Boot va/yoki TPM ni oʻchirib qoʻyishingiz shart. Omarchy ni oʻrnata olish uchun bularni oʻchirishingiz kerak. Bular Windows va Microsoftga aloqador Linux distributivlari uchun moʻljallangan Microsoft xavfsizlik sxemalaridir._

Keyin konfiguratsiya savollariga javob bering va ularni mana bunday tasdiqlang:

 ![install-config](images/install-config.webp)

Keyin oʻrnatish uchun disk tanlang va oʻrningizga oʻtirib oʻrnatish shousini kuzating. Eng tezkor zamonaviy mashinalarda bu bir daqiqadan kam vaqtda tugashi mumkin, lekin eski kompyuterda ham 5 daqiqadan oshmasligi kerak.

 ![install-done](images/install-done.webp)

Endi siz Omarchyga tayyorsiz!

### Simli yoki 2.4ghz klaviaturadan foydalaning!

Toʻliq disk shifrlashi ishga tushganda Bluetooth klaviaturadan parol kiritishga ruxsat bermaydi. Kompyuterda BIOSga kirishda Bluetooth klaviaturani ishlata olmaganingiz kabi. Sizga 2.4ghz dongle yoki kabel ishlatadigan klaviatura kerak boʻladi (bu kechikish uchun baribir ancha yaxshi!). Menga shaxsan [Lofree Flow84](https://www.lofree.co/products/lofree-flow-the-smoothest-mechanical-keyboard) juda yoqadi!

### Boshqa egasi uchun oʻrnatish

Agar siz mashinani birov — oila aʼzosi, yangi xodim, xaridor — uchun sozlayotgan boʻlsangiz, shaxsiy savollarga ularning oʻrniga javob bermasligingiz kerak. Oʻrnatuvchining birinchi ekranida (klaviatura tanlovi) `Ctrl + C` ni bosing va Omarchy mashinani boshqa egasi uchun tayyorlashni taklif qiladi. Tizim darhol oʻrnatiladi, lekin barcha shaxsiy sozlashlar — klaviatura tartibi, foydalanuvchi nomi, parol — mashina birinchi marta yuklanguncha qoldiriladi. Disk baribir standartda shifrlangan va yangi egasi oʻsha birinchi yuklanishda tanlagan parol shifrlash paroli ham boʻladi. (Allaqachon ishlatgan mashinangizni qayta oʻrnatmasdan ham topshirishingiz mumkin — [kompyuterni tozalash](48-security.md) ga qarang.)

### Ishtiroksiz oʻrnatishlar

ISO ikkinchi diskda konfiguratsiyasi berilganda — klaviaturasiz, sehrgarsiz — mutlaqo oʻz-oʻzidan ham oʻrnatilishi mumkin. Omarchyni VM va park mashinalari uchun baza obraz sifatida ishlatishning yoʻli shu. [Ishtiroksiz oʻrnatishlar](51-unattended-installs.md) ga qarang.

### Shifrlashsiz oʻrnatishlar

Omarchy standartda shifrlash bilan oʻrnatiladi. Bu yoʻqolishi yoki oʻgʻirlanishi mumkin boʻlgan har qanday kompyuter uchun xavfsiz, masʼuliyatli tanlov. Uskunangizga kira oladigan birov maʼlumotlaringizga erishishini xohlamaysiz!

Lekin maxsus sharoitlarda, masalan himoyalangan kompyuterlarga masofaviy Omarchy oʻrnatishlari yoki maxfiy maʼlumotlarsiz bir martalik oʻrnatishlar uchun, shifrlashsiz oʻrnatishni xohlashingiz mumkin. Diskni formatlash tasdigʻida shifrlashsiz oʻrnatishga oʻtish uchun `Ctrl + C` ni bosishingiz mumkin.

### Til

Omarchy 50 tilda gaplashadi — omarchy.org dagi toʻplam bilan bir xil — va ingliz tili standart hisoblanadi. Almashtirish uchun Omarchy menyusini ochib _Sozlash > Til_ ga oʻting yoki terminalda `omarchy language <code>` ni ishga tushiring (`omarchy language list` kodlarni koʻrsatadi). Menyu, ish stoli va Omarchyning oʻz bildirishnomalari darhol tilni almashtiradi va tizim lokali ham moslab oʻrnatiladi, shuning uchun boshqa ilovalaringiz keyingi kirishingizda ergashadi.

### Qotib qolsangiz yordam

Agar qotib qolsangiz, odatda [hamjamiyat Discord](https://omarchy.org/discord) dagi _#omarchy-help_ kanalida yordam berishga tayyor birovni topishingiz mumkin.
