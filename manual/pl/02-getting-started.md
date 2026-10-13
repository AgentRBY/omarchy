# Pierwsze kroki

Omarchy instaluje się z obrazu ISO. Możesz wybrać instalację na całym dysku, która przejmuje cały nośnik, albo instalację w wolnym miejscu, która umieszcza Omarchy w nieprzydzielonym obszarze dysku — tak właśnie zrobić dual boot obok Windowsa lub innego systemu (zob. [instalacja dual boot](50-dual-boot-install.md) — pamiętaj, że najpierw musisz wyłączyć BitLocker w Windowsie). Tak czy inaczej instalacja domyślnie szyfruje dysk w pełni, a opcja całego dysku wymaże wybrany nośnik, więc przed użyciem istniejącego dysku koniecznie zrób kopię zapasową!

Najpierw [pobierz obraz ISO Omarchy](https://omarchy.org/), nagraj go na pendrive (użyj [balenaEtcher](https://etcher.balena.io/) na Macu/Windowsie albo [caligula](https://github.com/ifd3f/caligula) na Linuksie) i uruchom komputer z pendrive'a.

_Musisz wyłączyć Secure Boot i/lub TPM w BIOS-ie. Musisz je wyłączyć, żeby móc zainstalować Omarchy. To mechanizmy bezpieczeństwa Microsoftu przeznaczone dla Windowsa i powiązanych z Microsoftem dystrybucji Linuksa._

Następnie odpowiedz na pytania konfiguracyjne i potwierdź je mniej więcej tak:

 ![install-config](images/install-config.webp)

Potem wybierz dysk do instalacji, usiądź wygodnie i oglądaj pokaz. Na najszybszych nowoczesnych maszynach całość da się zrobić w mniej niż minutę, a nawet na starszym komputerze nie powinno to zająć więcej niż 5 minut.

 ![install-done](images/install-done.webp)

Gotowe — możesz używać Omarchy!

### Używaj klawiatury przewodowej albo na 2,4 GHz!

Szyfrowanie całego dysku nie pozwoli ci wpisać hasła z klawiatury Bluetooth przy starcie. Tak samo jak nie wejdziesz klawiaturą Bluetooth do BIOS-u na PC. Potrzebujesz klawiatury, która używa dongla 2,4 GHz albo kabla (co i tak jest dużo lepsze pod względem opóźnień!). Osobiście uwielbiam [Lofree Flow84](https://www.lofree.co/products/lofree-flow-the-smoothest-mechanical-keyboard)!

### Instalowanie dla innego właściciela

Jeśli przygotowujesz maszynę dla kogoś innego — członka rodziny, nowego pracownika, kupującego — nie powinieneś odpowiadać na osobiste pytania w jego imieniu. Naciśnij `Ctrl + C` na samym pierwszym ekranie instalatora (wybór klawiatury), a Omarchy zaproponuje przygotowanie maszyny dla innego właściciela. System instaluje się od razu, ale cała personalizacja — układ klawiatury, nazwa użytkownika, hasło — jest odłożona do pierwszego uruchomienia maszyny. Dysk nadal jest domyślnie zaszyfrowany, a hasło, które nowy właściciel wybierze przy pierwszym starcie, staje się też hasłem szyfrowania. (Maszynę, której już używałeś, też można przekazać bez ponownej instalacji — zob. [resetowanie komputera](48-security.md).)

### Instalacje nienadzorowane

ISO może też zainstalować się całkowicie samo — bez klawiatury, bez kreatora — gdy dostanie swoją konfigurację na drugim dysku. Tak traktuje się Omarchy jako obraz bazowy dla maszyn wirtualnych i flot komputerów. Zob. [instalacje nienadzorowane](51-unattended-installs.md).

### Instalacje bez szyfrowania

Omarchy domyślnie instaluje się z szyfrowaniem. To bezpieczny i odpowiedzialny wybór dla każdego komputera, który może zostać zgubiony lub skradziony. Nie chcesz, żeby ktokolwiek z dostępem do twojego sprzętu mógł dostać się do twoich danych!

Ale w szczególnych okolicznościach, jak zdalne instalacje Omarchy na chronionych komputerach albo jednorazowe instalacje bez wrażliwych danych, możesz chcieć zainstalować system bez szyfrowania. Możesz nacisnąć `Ctrl + C` przy potwierdzeniu formatowania dysku, żeby przełączyć się na instalację bez szyfrowania.

### Język

Omarchy mówi w 50 językach — tym samym zestawie co omarchy.org — a domyślnym jest angielski. Aby go zmienić, otwórz menu Omarchy i przejdź do _Ustawienia > Język_ albo uruchom w terminalu `omarchy language <code>` (`omarchy language list` pokazuje kody). Menu, pulpit i powiadomienia Omarchy zmieniają język od razu, a ustawienia regionalne systemu są dopasowywane, więc przy następnym logowaniu pozostałe aplikacje pójdą za nimi.

### Pomoc, gdy utkniesz

Jeśli utkniesz, zwykle znajdziesz kogoś chętnego do pomocy na kanale _#omarchy-help_ na [społecznościowym Discordzie](https://omarchy.org/discord).
