# Navigatsiya

Omarchyda hamma narsa klaviatura orqali boʻladi — _HAMMA NARSA!_ Tizim birinchi marta ishga tushganda, siz sichqoncha bilan hech narsa qilolmaysiz. Lekin Omarchy menyusini ochish uchun `Super + Space` ni bosishingiz mumkin va shu yerdan deyarli hamma narsani qilishingiz mumkin.

Lekin Omarchy menyusi hatto tizimni koʻp vaqt davomida boshqarishning asosiy usuli boʻlishi uchun ham moʻljallanmagan. Biz undan tezroq boʻlishimiz mumkin! Barcha eng muhim ilovalar bevosita alohida hotkeylarga bogʻlangan. Terminalni `Super + Return` va brauzerni `Super + Shift + Return` bilan boshlaysiz. Birin-ketin qilib koʻring va Hyprland mozaikasining sehrini harakatda koʻrasiz:

 ![navigation-browser-terminal](images/navigation-browser-terminal.webp)

Keyin ularni yonma-yon emas, bir-birining ustiga qoʻyish uchun `Super + J` ni bosishingiz mumkin:

 ![navigation-stacked](images/navigation-stacked.webp)

Ularni yonma-yon holatlariga qaytarish uchun yana `Super + J` ni bosing. Keyin brauzerda boʻlganingizda oynalarni almashtirish uchun `Super + Shift + Arrow Right` ni sinab koʻring.

Endi Activity monitorini boshlash uchun `Super + Ctrl + T` ni sinab koʻring. Bu suzuvchi oyna sifatida paydo boʻladi. Uni `Super + T` yordamida mozaikaga qoʻyishingiz mumkin (va yana suzuvchi qilish uchun yana bosing). Endi fayllar boshqaruvchisini ochish uchun `Super + Shift + F` ni bosing. Sizda toza toʻrt tomonlama sozlama boʻladi:

 ![navigation-fourway-tiling](images/navigation-fourway-tiling.webp)

Faol boʻlishini xohlagan oynalar orasida `Super + Arrow` bilan harakatlanasiz. Bu fokusni almashtirib, kursorni yangi ilovaning markaziga koʻchiradi.

Agar `Super + Shift + 2` ni bossangiz, joriy fokuslangan ilovani ikkinchi ish maydoniga koʻchirasiz. `Super + Shift + 1` uni orqaga koʻchiradi. (Va `Super + Shift + Alt + 2` joriy fokuslangan ilovani ikkinchi ish maydoniga unga oʻtmasdan koʻchiradi).

Agar `Super` ni bosib turib oynani sichqoncha bilan bossangiz, u turgan joyni qayta tartibga solishingiz mumkin boʻladi. Agar `Super` ni bosib turib sichqonchaning oʻng tugmasini ishlatsangiz, oyna oʻlchamini erkin oʻzgartirishingiz mumkin.

Oynani `Super + W` yoki `Super + Q` da yopasiz (va barcha oynalarni `Ctrl + Alt + Delete` da).

`Super + F` bilan toʻliq ekranga yoki hattoki `Super + Alt + F` bilan shunchaki toʻliq kenglikka (yuqori panelni saqlab) yoki `Super + Ctrl + F` bilan oyna ichida toʻliq ekranga (YouTube uchun yaxshi!) ham oʻtishingiz mumkin.

### Dwindle va siljitish tartibi

Omarchyning standart tartibi dwindle deb ataladi. U bitta ish maydonida ochgan barcha oynalaringizni har doim koʻrinishda saqlaydi, hattoki ularni kichraytirishi kerak boʻlsa ham.

 ![navigation-dwindle-layout](images/navigation-dwindle-layout.webp)

Lekin ish maydonini oynalar displeyning koʻrinadigan chetidan tashqarida yonma-yon qatorlangan siljitish tartibiga aylantirishni ham tanlashingiz mumkin. Bitta ish maydonini `Super + L` orqali bu tartibga aylantirasiz.

Yana `Super + L` ni bosish ish maydonini suzuvchiga aylantiradi, u yerda oynalar erkin ustma-ust tushadi va siz ularni oʻzingiz joylashtirasiz, uchinchi bosish uni dwindlega qaytaradi. `Super + Alt + L` ularni boshqa yoʻnalishda oʻtkazadi. Baribir suzadigan oyna — siz `Super + T` bilan chiqargan yoki har doim suzuvchi ochiladigan ilova — ish maydoni mozaikaga qaytganda suzishda davom etadi. Yuqori panel siz turgan ish maydonini uning tartibi bilan belgilaydi: dwindle uchun kvadrat, siljitish uchun doira va suzuvchi uchun uchburchak. Oʻsha belgini bosish tartibni ham aylantiradi.

 ![navigation-scrolling-layout](images/navigation-scrolling-layout.webp)

Tanlov ish maydoni boʻyicha boʻladi va u qoladi. Demak 1-ish maydonini koʻrish uchun dwindleda va 2-ish maydonini kod uchun siljitishda saqlashingiz mumkin va ular qayta ishga tushgandan keyin ham shunday qaytadi.

Agar siljitish tartibidan standart sifatida foydalanmoqchi boʻlsangiz, uni `~/.config/hypr/looknfeel.lua` da oʻrnatishingiz mumkin:

```lua
hl.config({
  general = {
    layout = "scrolling",
  },
})
```

### Suzuvchi ish maydonlari

Suzuvchi ish maydoni anʼanaviy ish stoli kabi ishlaydi: oynalar ustma-ust tushadi va siz ularni oʻzingiz koʻchirasiz va oʻlchaysiz. Har bir oyna mavzuingiz ranglarida sarlavha paneli oladi, kichiklashtirish, kattalashtirish va yopish tugmalari bilan. `Super + M` fokuslangan oynani ham kichiklashtiradi. Kichiklashtirilgan oyna dockda kutadi; uni qaytarish uchun ilovasini bosing. Oynani oldinga olib kelish uchun uni bosing. Uni istalgan chet yoki burchakdan oʻlchamini oʻzgartiring. Yuqori panelni koʻrinishda saqlagan holda oynani kattalashtirish uchun sarlavha panelini ikki marta bosing va eski oʻlchamini qaytarish uchun yana.

Suzuvchi ish maydoni dockni ham koʻrsatadi, mahkamlangan ilovalaringiz, ishlayotgan hamma narsa va ilovalar tugmasi orqasidagi har bir ilovaning panjarasi bilan, uni `Super + Alt + Space` va Omarchy menyusidagi _Ilovalar_ ham ochadi. Panjaradagi ilovani oʻng bosish yoki `Delete` ni bosish uni oʻchirib tashlaydi. Ilovani ochish yoki uning oynasini oldinga olib kelish uchun bosing; uning oynalari orasida aylanish uchun yana bosing. Oʻrta bosish yangi oyna ochadi. Ikonkani koʻchirish uchun dock boʻylab sudrab boring; ishlayotgan ilovani boshqalar orasiga sudrab borish uni u yerda qoldiradi. Ilovani dockda saqlash, undan chiqarib olish yoki undan chiqish uchun oʻng bosing. Dock toʻliq ekran oynasidan chetga chiqadi. Dockni boshqa chetga koʻchirish yoki koʻrsatkich uning chetiga yetguncha yashirin turishi uchun ilovalar tugmasini oʻng bosing. Joylashuv _Ishga tushirish > Koʻrinish > Dock > Dock joyi_ ostida ham bor va `omarchy dock position left` va `omarchy dock autohide on` ikkalasini ham terminaldan oʻrnatadi. Dockda saqlagan ilovalaringiz ishlamayotgan paytda xira boʻladi.

Yangi ish maydonlari va `Super + L` bilan oʻz tartibini bermagan har qanday ish maydoni standart tartibni ishlatadi. Standartni oʻzgartirish oynalarsiz har bir ish maydonini unga tiklaydi, oynalari bor ish maydoni esa bor tartibni saqlab qoladi. Uni _Ishga tushirish > Koʻrinish > Ish maydoni tartibi_ ostida tanlang: Mozaika, Siljitish yoki Suzuvchi. `omarchy-hyprland-workspace-layout-default scrolling` uni terminaldan oʻrnatadi.

### Oynalarni guruhlash

Oynalarni `Super + G` yordamida guruhlash mumkin. Guruhga kirganingizdan keyin, bu faol boʻlgan paytda boshlagan har bir oynangiz guruhga tegishli boʻladi. Bu guruhlangan oynalar orasida `Super + Ctrl + Arrow Left/Right` yoki tartibda guruhlangan oynaga toʻgʻridan-toʻgʻri borish uchun `Super + Alt + 1/2/3/4` yordamida harakatlanishingiz mumkin.

Oynani `Super + Alt + G` bilan guruhdan chiqarishingiz yoki yana `Super + G` ni bosib butun guruhni ajratishingiz mumkin. Va nihoyat, guruh tashqarisidagi oynalarni `Super + Alt + Arrows` bilan uning ichiga koʻchirish mumkin.

### Oynalarni chiqarib olish

Oynani `Super + O` bilan ish maydoniga ajratilishidan chiqarib olishingiz mumkin. Bu uni siz borgan har qanday ish maydonida sizga ergashadigan suzuvchi oyna sifatida mahkamlaydi. Video pleyerlar va shunga oʻxshashlar uchun ajoyib.

 ![navigation-popped-window](images/navigation-popped-window.webp)

### Scratchpad ish maydoni

Va nihoyat, hozir qaysi ish maydonida boʻlsangiz, uning ustiga Quake konsoli kabi tushadigan maxsus scratchpad ish maydoni bor. Uni `Super + Grave` yoki `Super + S` bilan almashtiring va `Super + Shift + Grave` yoki `Super + Alt + S` yordamida u yerga oyna joylashtiring.

Bu, ayniqsa, agent ishlatadigan terminal yoki joriy ish maydonidan chiqmasdan tez oʻzaro taʼsir qilmoqchi boʻlgan boshqaruvlar uchun yaxshi ishlaydi. Oynani scratchpaddan koʻchirish uchun, uni `Super + Shift + 1` kabi narsa bilan toʻgʻridan-toʻgʻri boshqa ish maydoniga yuboring.

Scratchpad bitta oyna saqlagan paytda, u ekranni qoplamasdan, markazlashtirilgan panel sifatida tushadi. Unga ikkinchi ilova qoʻysangiz, u toʻliq kenglikka qaytadi, shuning uchun ikkisi yonma-yon oʻtirishga joy topadi.

### Bunga oʻrganish vaqt oladi!

Ish stolingizda bunday harakatlanishga oʻrganish biroz vaqt oladi, lekin oʻrganganingizdan keyin anʼanaviy sichqoncha bilan boshqariladigan ish stoli tajribasiga qaytish qiyin boʻladi!
