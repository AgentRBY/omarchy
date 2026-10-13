# Uwierzytelnianie sprzętowe

### Uwierzytelnianie odciskiem palca

Wiele laptopów ma czytnik linii papilarnych do uwierzytelniania. Możesz go używać w Omarchy, uruchamiając _Ustawienia > Bezpieczeństwo > Odcisk palca_ w menu Omarchy (`Super + Space`).

To zainstaluje pakiet obsługi odcisku palca, zbierze twój odcisk, zweryfikuje go i będziesz mógł używać odcisku palca, aby odblokowywać ekran blokady (który możesz wywołać skrótem `Super + Ctrl + L`), wchodzić w tryb sudo i autoryzować monitory systemowe.

Gdy pokrywa laptopa jest zamknięta, monit o odcisk palca jest automatycznie pomijany, więc przechodzisz od razu do monitu o hasło, zamiast czekać na czujnik, do którego nie możesz dosięgnąć. Jeśli w innym przypadku musisz pracować na zewnętrznej klawiaturze bez czujnika, po prostu naciśnij `CTRL + C`, gdy podczas `sudo` pojawi się monit o odcisk palca.

Uwierzytelnianie odciskiem palca możesz usunąć w menu Omarchy w _Usuń > Bezpieczeństwo > Odcisk palca_.

### Uwierzytelnianie Fido2

Jeśli używasz urządzenia Fido2, możesz skonfigurować je do uwierzytelniania `sudo`, używając _Ustawienia > Bezpieczeństwo > Fido2_ w menu Omarchy (`Super + Space`). Obejmuje ono jednak `sudo` i monitory autoryzacji systemowej, a nie odblokowywanie komputera.

Uwierzytelnianie fido2 możesz usunąć w menu Omarchy w _Usuń > Bezpieczeństwo > Fido2_.
