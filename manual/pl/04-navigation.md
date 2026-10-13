# Nawigacja

W Omarchy wszystko dzieje się z klawiatury — _WSZYSTKO!_ Gdy system startuje po raz pierwszy, dosłownie nie da się niczego zrobić samą myszą. Ale możesz nacisnąć `Super + Space`, żeby odsłonić menu Omarchy, i z niego zrobić niemal wszystko.

Ale menu Omarchy nawet nie ma być przez większość czasu głównym sposobem obsługi systemu. Możemy być szybsi! Najważniejsze aplikacje są przypisane bezpośrednio do pojedynczych skrótów. Terminal uruchamiasz przez `Super + Return`, a przeglądarkę przez `Super + Shift + Return`. Spróbuj zrobić jedno po drugim, a zobaczysz magię kafelkowego układania Hyprland w akcji:

 ![navigation-browser-terminal](images/navigation-browser-terminal.webp)

Potem możesz nacisnąć `Super + J`, żeby ułożyć je jedno na drugim zamiast obok siebie:

 ![navigation-stacked](images/navigation-stacked.webp)

Naciśnij `Super + J` ponownie, żeby wróciły do ułożenia obok siebie. Następnie spróbuj `Super + Shift + Arrow Right` będąc na przeglądarce, żeby zamienić okna miejscami.

Teraz spróbuj `Super + Ctrl + T`, żeby uruchomić monitor aktywności. Pojawi się jako pływające okno. Możesz je ukafelkować przez `Super + T` (i nacisnąć to ponownie, żeby znów pływało). Teraz naciśnij `Super + Shift + F`, żeby otworzyć menedżer plików. Dostaniesz zgrabny układ na cztery:

 ![navigation-fourway-tiling](images/navigation-fourway-tiling.webp)

Pomiędzy oknami, które chcesz mieć aktywne, poruszasz się przez `Super + Arrow`. Przełącza to fokus i przenosi kursor na środek nowej aplikacji.

Jeśli naciśniesz `Super + Shift + 2`, przeniesiesz aktualnie skupioną aplikację na drugi obszar roboczy. `Super + Shift + 1` przenosi ją z powrotem. (A `Super + Shift + Alt + 2` przeniesie aktualnie skupioną aplikację na drugi obszar roboczy bez przełączania się na niego).

Jeśli przytrzymasz `Super` i klikniesz myszą na okno, będziesz mógł zmienić jego położenie. Jeśli przytrzymasz `Super` i użyjesz prawego przycisku myszy, możesz swobodnie zmieniać rozmiar okna.

Okno zamykasz przez `Super + W` lub `Super + Q` (a wszystkie okna przez `Ctrl + Alt + Delete`).

Możesz też przejść na pełny ekran przez `Super + F`, a nawet tylko na pełną szerokość (z zachowaniem górnego paska) przez `Super + Alt + F` albo na pełny ekran wewnątrz okna przez `Super + Ctrl + F` (dobre dla YouTube!).

### Układ dwindle a układ przewijany

Domyślny układ Omarchy nazywa się dwindle. Trzyma wszystkie okna otwarte na jednym obszarze roboczym zawsze widoczne, nawet jeśli musi je przy tym pomniejszyć.

 ![navigation-dwindle-layout](images/navigation-dwindle-layout.webp)

Ale możesz też zmienić obszar roboczy w układ przewijany, w którym okna ustawiają się obok siebie poza widoczną krawędź ekranu. Pojedynczy obszar roboczy zmieniasz w ten układ przez `Super + L`.

Ponowne naciśnięcie `Super + L` zmienia obszar roboczy w pływający, w którym okna swobodnie się nakładają, a ty rozmieszczasz je samodzielnie, a trzecie naciśnięcie wraca do dwindle. `Super + Alt + L` przechodzi je w odwrotną stronę. Okno, które i tak pływa — takie, które wyrzuciłeś przez `Super + T`, albo aplikacja zawsze otwierająca się jako pływająca — pozostaje pływające, gdy obszar roboczy wraca do kafelków. Górny pasek oznacza obszar roboczy, na którym jesteś, jego układem: kwadrat dla dwindle, koło dla przewijanego i trójkąt dla pływającego. Kliknięcie tego znaczka też przełącza układ.

 ![navigation-scrolling-layout](images/navigation-scrolling-layout.webp)

Wybór jest per obszar roboczy i się utrzymuje. Możesz więc trzymać obszar 1 na dwindle do przeglądania, a obszar 2 na przewijanym do pisania kodu, i po restarcie wrócą dokładnie tak.

Jeśli chcesz używać układu przewijanego jako domyślnego, ustaw to w `~/.config/hypr/looknfeel.lua`:

```lua
hl.config({
  general = {
    layout = "scrolling",
  },
})
```

### Pływające obszary robocze

Pływający obszar roboczy działa jak tradycyjny pulpit: okna się nakładają, a ty sam je przesuwasz i zmieniasz ich rozmiar. Każde okno dostaje pasek tytułu w kolorach twojego motywu, z przyciskami minimalizacji, maksymalizacji i zamknięcia. `Super + M` też minimalizuje skupione okno. Zminimalizowane okno czeka w docku; kliknij jego aplikację, żeby je przywołać. Kliknij okno, żeby wysunąć je na wierzch. Zmień jego rozmiar od dowolnej krawędzi lub narożnika. Kliknij dwukrotnie pasek tytułu, żeby zmaksymalizować okno przy zachowaniu górnego paska w widoku, i ponownie, żeby odzyskać dawny rozmiar.

Pływający obszar roboczy pokazuje też dock z twoimi przypiętymi aplikacjami, wszystkim co działa oraz siatką wszystkich aplikacji pod przyciskiem aplikacji, który otwierają też `Super + Alt + Space` i _Aplikacje_ w menu Omarchy. Kliknij prawym przyciskiem aplikację na siatce albo naciśnij `Delete`, żeby ją odinstalować. Kliknij aplikację, żeby ją otworzyć albo wysunąć jej okno na wierzch; kliknij ponownie, żeby przechodzić między jej oknami. Kliknięcie środkowym przyciskiem otwiera nowe okno. Przeciągnij ikonę wzdłuż docka, żeby ją przenieść; przeciągnięcie działającej aplikacji między inne pozostawia ją tam. Kliknij prawym przyciskiem, żeby zachować aplikację w docku, usunąć ją stamtąd albo ją zamknąć. Dock ustępuje okna pełnoekranowemu. Kliknij prawym przyciskiem przycisk aplikacji, żeby przenieść dock na inną krawędź albo sprawić, że będzie się ukrywał, dopóki wskaźnik nie dotrze do jego krawędzi. Położenie jest też pod _Akcje > Wygląd > Dock > Położenie docka_, a `omarchy dock position left` i `omarchy dock autohide on` ustawiają obie rzeczy z terminala. Aplikacje, które trzymasz w docku, są przygaszone, gdy nie działają.

Nowe obszary robocze oraz wszystkie, którym nie nadałeś własnego układu przez `Super + L`, używają układu domyślnego. Zmiana domyślnego resetuje do niego każdy obszar roboczy bez okien, natomiast obszar z oknami zachowuje swój układ. Wybierasz go pod _Akcje > Wygląd > Układ obszarów_: Kafelki, Przewijanie albo Pływające. `omarchy-hyprland-workspace-layout-default scrolling` ustawia go z terminala.

### Grupowanie okien

Okna można grupować przez `Super + G`. Gdy jesteś w grupie, każde okno, które uruchomisz, póki grupa jest aktywna, będzie do niej należeć. Między pogrupowanymi oknami poruszasz się przez `Super + Ctrl + Arrow Left/Right` albo `Super + Alt + 1/2/3/4`, żeby przejść wprost do pogrupowanego okna w kolejności.

Możesz przenieść okno poza grupę przez `Super + Alt + G` albo rozebrać całą grupę, ponownie naciskając `Super + G`. Na koniec możesz przenieść okna spoza grupy do niej przez `Super + Alt + Arrows`.

### Wyskakujące okna

Możesz wyrzucić okno z przydziału obszaru roboczego przez `Super + O`. Przypnie je to jako pływające okno, które podąża za tobą na każdym obszarze roboczym, na jaki przejdziesz. Świetne dla odtwarzaczy wideo i tym podobnych.

 ![navigation-popped-window](images/navigation-popped-window.webp)

### Obszar roboczy podręczny (scratchpad)

Na koniec jest specjalny obszar roboczy podręczny, który opada nad bieżący obszar roboczy, podobnie jak konsola w grze Quake. Przełączasz go przez `Super + Grave` lub `Super + S`, a okno umieszczasz tam przez `Super + Shift + Grave` lub `Super + Alt + S`.

Sprawdza się szczególnie dobrze dla terminala z uruchomionym agentem albo dla kontrolek, z którymi chcesz szybko wejść w interakcję, nie opuszczając bieżącego obszaru roboczego. Aby przenieść okno z obszaru podręcznego, wyślij je bezpośrednio na inny obszar roboczy, na przykład przez `Super + Shift + 1`.

Gdy obszar podręczny trzyma jedno okno, opada jako wyśrodkowany panel, zamiast obejmować cały ekran. Dodaj na nim drugą aplikację, a wróci do pełnej szerokości, żeby obie miały miejsce, by siedzieć obok siebie.

### Trzeba się trochę przyzwyczaić!

Przyzwyczajenie się do poruszania się po pulpicie w ten sposób zajmuje trochę czasu, ale gdy już się przyzwyczaisz, trudno będzie wrócić do tradycyjnego, sterowanego myszą pulpitu!
