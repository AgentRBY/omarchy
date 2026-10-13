# Hardveres hitelesítés

### Ujjlenyomatos hitelesítés

Sok laptop rendelkezik ujjlenyomat-érzékelővel a hitelesítéshez. Ezt az Omarchyval az Omarchy menüben (`Super + Space`) található _Beállítás > Biztonság > Ujjlenyomat_ pont futtatásával használhatod.

Ez telepíti az ujjlenyomat-csomagot, beolvassa a lenyomatod, ellenőrzi, és máris használhatod az ujjlenyomatod a zárolási képernyőről való feloldáshoz (amelyet a `Super + Ctrl + L` kombinációval indíthatsz), a sudo módba lépéshez és a rendszerkérések engedélyezéséhez.

Amikor a laptopod fedele le van zárva, az ujjlenyomat-kérés automatikusan kimarad, így egyenesen a jelszókéréshez jutsz, ahelyett, hogy egy elérhetetlen érzékelőre várnál. Ha más okból külső, érzékelő nélküli billentyűzeten kell dolgoznod, csak nyomd meg a `CTRL + C` billentyűket, amikor a `sudo` során ujjlenyomatot kérnek tőled.

Az ujjlenyomatos hitelesítést az Omarchy menü _Eltávolítás > Biztonság > Ujjlenyomat_ pontjában távolíthatod el.

### Fido2-hitelesítés

Ha Fido2-eszközt használsz, az Omarchy menüben (`Super + Space`) található _Beállítás > Biztonság > Fido2_ ponttal beállíthatod `sudo` hitelesítéshez. Ez azonban a `sudo` és a rendszerengedélyezési kérésekre terjed ki, nem a számítógép feloldására.

A fido2-hitelesítést az Omarchy menü _Eltávolítás > Biztonság > Fido2_ pontjában távolíthatod el.
