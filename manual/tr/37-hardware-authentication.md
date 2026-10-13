# Donanım kimlik doğrulaması

### Parmak izi kimlik doğrulaması

Birçok dizüstü bilgisayar kimlik doğrulaması yapmak için bir parmak izi sensörüyle birlikte gelir. Bunu Omarchy ile, Omarchy menüsünde (`Super + Space`) _Ayarlar > Güvenlik > Parmak İzi_ yolunu çalıştırarak kullanabilirsiniz.

Bu, parmak izi paketini kuracak, izinizi toplayacak, doğrulayacak ve kilit ekranından kilidi açmak (bunu `Super + Ctrl + L` ile tetikleyebilirsiniz), sudo moduna girmek ve sistem istemlerini yetkilendirmek için parmak izinizi kullanmaya hazır olacaksınız.

Dizüstü bilgisayar kapağınız kapalı olduğunda, parmak izi istemi otomatik olarak atlanır, böylece ulaşamayacağınız bir sensörü beklemek yerine doğrudan parola istemine gidersiniz. Bunun dışında sensörü olmayan harici bir klavyede çalışmanız gerekiyorsa, `sudo` sırasında parmak iziniz istendiğinde yalnızca `CTRL + C` tuşlarına basın.

Parmak izi kimlik doğrulamasını Omarchy menüsünde _Kaldır > Güvenlik > Parmak İzi_ altından kaldırabilirsiniz.

### Fido2 kimlik doğrulaması

Bir Fido2 cihazı kullanıyorsanız, onu Omarchy menüsünde (`Super + Space`) _Ayarlar > Güvenlik > Fido2_ kullanarak `sudo` kimlik doğrulaması için kurabilirsiniz. Ancak bu, bilgisayarınızın kilidini açmayı değil, `sudo` ve sistem yetkilendirme istemlerini kapsar.

Fido2 kimlik doğrulamasını Omarchy menüsünde _Kaldır > Güvenlik > Fido2_ altından kaldırabilirsiniz.
