# Gezinme

Omarchy'de her şey klavye ile olur — _HER ŞEY!_ Sistem ilk başladığında, kelimenin tam anlamıyla yalnızca fareyle bir şey yapamazsınız. Ama Omarchy Menüsünü açmak için `Super + Space` tuşuna basabilirsiniz ve buradan hemen hemen her şeyi yapabilirsiniz.

Ancak Omarchy menüsünün çoğu zaman sistemi çalıştırmanın ana yolu olması bile amaçlanmamıştır. Bundan daha hızlı olabiliriz! En önemli uygulamaların hepsi doğrudan bireysel kısayollara bağlıdır. Terminali `Super + Return` ile ve bir tarayıcıyı `Super + Shift + Return` ile başlatırsınız. Birini diğerinin ardından yapmayı deneyin, Hyprland'in döşemesinin büyüsünü iş başında göreceksiniz:

 ![navigation-browser-terminal](images/navigation-browser-terminal.webp)

Ardından `Super + J` tuşuna basarak onları yan yana yerine üst üste yığabilirsiniz:

 ![navigation-stacked](images/navigation-stacked.webp)

Onları yan yana konumlarına döndürmek için tekrar `Super + J` tuşuna basın. Ardından tarayıcıydayken `Super + Shift + Arrow Right` tuşlarını deneyin ve pencereleri değiştirin.

Şimdi Activity izleyicisini başlatmak için `Super + Ctrl + T` tuşlarını deneyin. Bu yüzen bir pencere olarak görünecektir. Onu `Super + T` ile döşeyebilirsiniz (ve tekrar yüzen yapmak için buna tekrar basın). Şimdi dosya yöneticisini açmak için `Super + Shift + F` tuşlarına basın. Düzgün bir dörtlü düzeniniz olacaktır:

 ![navigation-fourway-tiling](images/navigation-fourway-tiling.webp)

Aktif olmasını istediğiniz pencere arasında `Super + Arrow` ile gezinebilirsiniz. Bu, odağı değiştirir ve imleci yeni uygulamanın merkezine taşır.

`Super + Shift + 2` tuşlarına basarsanız, o an odaklanmış uygulamayı ikinci çalışma alanına taşırsınız. `Super + Shift + 1` onu geri taşır. (Ve `Super + Shift + Alt + 2`, o an odaklanmış uygulamayı ona geçmeden ikinci çalışma alanına taşır).

`Super` tuşuna basılı tutup fareyle bir pencereye tıklarsanız, pencerenin oturduğu yeri yeniden düzenleyebilirsiniz. `Super` tuşuna basılı tutup farenin sağ düğmesini kullanırsanız, pencereyi özgürce yeniden boyutlandırabilirsiniz.

Bir pencereyi `Super + W` veya `Super + Q` ile kapatırsınız (ve tüm pencereleri `Ctrl + Alt + Delete` ile kapatırsınız).

Ayrıca `Super + F` ile tam ekran yapabilir veya `Super + Alt + F` ile sadece tam genişlik (üst çubuğu koruyarak) ya da `Super + Ctrl + F` ile bir pencere içinde tam ekran yapabilirsiniz (YouTube için iyi!).

### Dwindle ve kayan düzen karşılaştırması

Omarchy'nin varsayılan düzeni dwindle olarak adlandırılır. Bir çalışma alanına açtığınız tüm pencereleri, onları küçültmek zorunda kalsa bile her zaman görünür tutar.

 ![navigation-dwindle-layout](images/navigation-dwindle-layout.webp)

Ancak bir çalışma alanını, pencerelerin ekranın görünür kenarının ötesinde yan yana dizildiği kayan düzene dönüştürmeyi de seçebilirsiniz. Tek bir çalışma alanını `Super + L` ile bu düzene çevirirsiniz.

`Super + L` tuşuna tekrar basmak çalışma alanını yüzer hale getirir; burada pencereler özgürce üst üste biner ve onları kendiniz yerleştirirsiniz; üçüncü bir basış onu dwindle'a döndürür. `Super + Alt + L` bunlardan diğer yönde geçer. Zaten yüzen bir pencere — `Super + T` ile dışarı çıkardığınız bir pencere veya her zaman yüzen açılan bir uygulama — çalışma alanı döşemeye döndüğünde yüzen kalır. Üst çubuk, bulunduğunuz çalışma alanını düzeniyle işaretler: dwindle için bir kare, kayan için bir daire ve yüzen için bir üçgen. Bu işarete tıklamak da düzeni döndürür.

 ![navigation-scrolling-layout](images/navigation-scrolling-layout.webp)

Seçim çalışma alanı başınadır ve kalıcıdır. Böylece 1. çalışma alanını gezinme için dwindle'da ve 2. çalışma alanını kod için kayan düzende tutabilirsiniz ve yeniden başlatmanın ardından da bu şekilde geri gelirler.

Kayan düzeni varsayılan olarak kullanmak isterseniz, bunu `~/.config/hypr/looknfeel.lua` içinde ayarlayabilirsiniz:

```lua
hl.config({
  general = {
    layout = "scrolling",
  },
})
```

### Yüzen çalışma alanları

Yüzen bir çalışma alanı geleneksel bir masaüstü gibi çalışır: pencereler üst üste biner ve onları kendiniz taşır ve boyutlandırırsınız. Her pencere, temanızın renklerinde, simge durumuna küçültme, büyütme ve kapatma düğmeleri olan bir başlık çubuğu alır. `Super + M` odaklanmış pencereyi de simge durumuna küçültür. Simge durumuna küçültülmüş bir pencere dock'ta bekler; geri getirmek için uygulamasına tıklayın. Bir pencereye tıklayarak onu öne getirin. Herhangi bir kenardan veya köşeden yeniden boyutlandırın. Üst çubuğu görünümde tutarken pencereyi büyütmek için bir başlık çubuğuna çift tıklayın ve eski boyutunu geri almak için tekrar çift tıklayın.

Yüzen bir çalışma alanı ayrıca, sabitlenmiş uygulamalarınız, çalışan her şey ve `Super + Alt + Space` ve Omarchy menüsündeki _Uygulamalar_ öğesinin de açtığı, uygulama düğmesinin arkasındaki her uygulamanın ızgarası ile bir dock gösterir. Izgaradaki bir uygulamaya sağ tıklayarak veya `Delete` tuşuna basarak onu kaldırın. Bir uygulamaya tıklayarak onu açın veya penceresini öne getirin; pencereleri arasında dolaşmak için tekrar tıklayın. Orta tıklama yeni bir pencere açar. Bir simgeyi dock boyunca sürükleyerek taşıyın; çalışan bir uygulamayı diğerlerinin arasına sürüklemek onu orada tutar. Bir uygulamayı dock'ta tutmak, çıkarmak veya kapatmak için sağ tıklayın. Dock, tam ekran bir pencerenin önünden çekilir. Dock'u başka bir kenara taşımak veya işaretçi kenarına ulaşana kadar gizlenmesini sağlamak için uygulama düğmesine sağ tıklayın. Konum ayrıca _Tetikle > Görünüm > Dock > Dock Konumu_ altındadır ve `omarchy dock position left` ile `omarchy dock autohide on` her ikisini de bir terminalden ayarlar. Dock'ta tuttuğunuz uygulamalar çalışmadıkları sırada soluk görünür.

Yeni çalışma alanları ve `Super + L` ile kendine ait bir düzen vermediğiniz herhangi biri, varsayılan düzeni kullanır. Varsayılanı değiştirmek, penceresi olmayan her çalışma alanını ona sıfırlar; penceresi olan bir çalışma alanı ise sahip olduğu düzeni korur. Onu _Tetikle > Görünüm > Çalışma Alanı Düzeni_ altında seçin: Döşeme, Kaydırma veya Yüzen. `omarchy-hyprland-workspace-layout-default scrolling` onu bir terminalden ayarlar.

### Pencereleri gruplama

Pencereler `Super + G` kullanılarak gruplandırılabilir. Bir gruba girdiğinizde, bu aktifken başlattığınız her pencere gruba ait olacaktır. Bu gruplandırılmış pencereler arasında `Super + Ctrl + Arrow Left/Right` kullanarak veya sırayla gruplandırılmış pencereye doğrudan gitmek için `Super + Alt + 1/2/3/4` ile hareket edebilirsiniz.

Bir pencereyi `Super + Alt + G` ile gruplandırmadan çıkarabilir veya `Super + G` tuşuna tekrar basarak tüm grubu dağıtabilirsiniz. Son olarak, grup dışındaki pencereleri `Super + Alt + Arrows` ile grubun içine taşıyabilirsiniz.

### Pencereleri çıkarma

Bir pencereyi `Super + O` ile çalışma alanı tahsisinden çıkarabilirsiniz. Bu, onu hangi çalışma alanına giderseniz gidin sizi takip eden yüzen bir pencere olarak sabitler. Video oynatıcılar ve benzerleri için harika.

 ![navigation-popped-window](images/navigation-popped-window.webp)

### Scratchpad çalışma alanı

Son olarak, o anda bulunduğunuz çalışma alanının üzerine, tıpkı bir Quake konsolu gibi, aşağı açılan özel bir scratchpad çalışma alanı vardır. Onu `Super + Grave` veya `Super + S` ile açıp kapatın ve `Super + Shift + Grave` veya `Super + Alt + S` kullanarak oraya bir pencere yerleştirin.

Özellikle bir ajan çalıştıran bir terminal veya geçerli çalışma alanından ayrılmadan hızla etkileşim kurmak istediğiniz denetimler için iyi çalışır. Bir pencereyi scratchpad'den taşımak için onu `Super + Shift + 1` gibi bir şeyle doğrudan başka bir çalışma alanına gönderin.

Scratchpad tek bir pencere barındırırken, ekranı kaplamak yerine ortalanmış bir panel olarak aşağı açılır. Üzerine ikinci bir uygulama koyarsanız tam genişliğe döner, böylece ikisinin yan yana oturacak alanı olur.

### Alışmak biraz zaman alıyor!

Masaüstünüzde bu şekilde gezinmeye alışmak biraz zaman alır, ancak alıştığınızda geleneksel fare odaklı masaüstü deneyimine dönmek zor olacaktır!
