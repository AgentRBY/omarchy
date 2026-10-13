# Başlangıç

Omarchy bir ISO kullanılarak kurulur. Sürücünün tamamını ele geçiren tam disk kurulumu ile Omarchy'yi bir sürücüdeki ayrılmamış alana yerleştiren boş alan kurulumu arasında seçim yapabilirsiniz — Windows veya başka bir işletim sisteminin yanında çift önyükleme böyle yapılır (bkz. [çift önyükleme kurulumu](50-dual-boot-install.md) — önce Windows'ta BitLocker'ı kapatmanız gerektiğini unutmayın). Her iki durumda da kurulum varsayılan olarak tam şifrelemedir ve tam disk seçeneği seçilen sürücüyü silecektir, bu yüzden mevcut bir sürücüyü kullanmadan önce yedek aldığınızdan emin olun!

Önce [Omarchy ISO'sunu indirin](https://omarchy.org/), bir USB belleğe yazın (Mac/Windows'ta [balenaEtcher](https://etcher.balena.io/) veya Linux'ta [caligula](https://github.com/ifd3f/caligula) kullanın) ve bellekten önyükleme yapın.

_BIOS'ta Secure Boot ve/veya TPM'yi kapatmalısınız. Omarchy'yi kurabilmek için bunları kapatmak zorundasınız. Bunlar Windows ve Microsoft bağlantılı Linux dağıtımları için tasarlanmış Microsoft güvenlik şemalarıdır._

Ardından yapılandırma sorularını yanıtlayın ve şöyle onaylayın:

 ![install-config](images/install-config.webp)

Ardından kurulumunuz için bir sürücü seçin ve arkanıza yaslanıp kurulum gösterisini izleyin. En hızlı modern makinelerde bir dakikanın altında bitebilir, ancak daha eski bir bilgisayarda bile 5 dakikadan fazla sürmemelidir.

 ![install-done](images/install-done.webp)

Artık Omarchy'ye hazırsınız!

### Kablolu veya 2.4 Ghz klavye kullanın!

Tam disk şifrelemesi, başlangıçta parolayı bir Bluetooth klavyeden girmenize izin vermez. Tıpkı bir PC'de BIOS'a girmek için Bluetooth klavye kullanamadığınız gibi. Ya 2.4 Ghz dongle ya da kablo kullanan bir klavyeye ihtiyacınız olacak (ki bu gecikme açısından zaten çok daha iyidir!). Ben [Lofree Flow84](https://www.lofree.co/products/lofree-flow-the-smoothest-mechanical-keyboard)'e bayılıyorum!

### Başka bir sahip için kurulum

Bir makineyi bir aile üyesi, yeni bir çalışan veya bir alıcı için kuruyorsanız, kişisel soruları onların adına yanıtlamamalısınız. Kurulumcunun en ilk ekranında (klavye seçimi) `Ctrl + C` tuşlarına basın, Omarchy bunun yerine makineyi başka bir sahip için hazırlamayı teklif edecektir. Sistem hemen kurulur, ancak tüm kişisel kurulum — klavye düzeni, kullanıcı adı, parola — makine ilk kez önyüklenene kadar ertelenir. Sürücü yine de varsayılan olarak şifrelenir ve yeni sahibin o ilk önyüklemede seçtiği parola şifreleme parolası da olur. (Zaten kullandığınız bir makine de yeniden kurulum olmadan teslim edilebilir — bkz. [bilgisayarı sıfırlama](48-security.md).)

### Gözetimsiz kurulumlar

ISO, yapılandırması ikinci bir sürücü üzerinden kendisine verildiğinde tamamen kendi başına da kurulabilir — klavye yok, sihirbaz yok. Omarchy'yi VM'ler ve filo makineleri için temel imaj olarak ele almanın yolu budur. Bkz. [gözetimsiz kurulumlar](51-unattended-installs.md).

### Şifrelemesiz kurulumlar

Omarchy varsayılan olarak şifrelemeyle kurulur. Kaybolma veya çalınma ihtimali olan herhangi bir bilgisayar için güvenli ve sorumlu seçim budur. Donanımınıza erişimi olan herkesin verilerinizi alabilmesini istemezsiniz!

Ancak korunan bilgisayarlardaki uzak Omarchy kurulumları veya hassas veriler içermeyen geçici kurulumlar gibi özel koşullarda, şifrelemesiz kurmak isteyebilirsiniz. Disk biçimlendirme onayında `Ctrl + C` tuşlarına basarak şifrelemesiz bir kuruluma geçebilirsiniz.

### Dil

Omarchy 50 dil konuşur — omarchy.org ile aynı küme — ve İngilizce varsayılandır. Değiştirmek için Omarchy menüsünü açın ve _Ayarlar > Dil_ yolunu izleyin veya bir terminalde `omarchy language <code>` çalıştırın (`omarchy language list` kodları gösterir). Menü, masaüstü ve Omarchy'nin kendi bildirimleri dili anında değiştirir ve sistem yerel ayarı bunu karşılayacak şekilde ayarlanır, böylece bir sonraki oturum açışınızda diğer uygulamalarınız da bunu takip eder.

### Takılırsanız yardım

Takılırsanız, genellikle [topluluk Discord'u](https://omarchy.org/discord) üzerindeki _#omarchy-help_ kanalında yardım etmeye istekli birini bulabilirsiniz.
