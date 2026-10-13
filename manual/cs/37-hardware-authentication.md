# Hardwarové ověřování

### Ověřování otiskem prstu

Mnoho notebooků má senzor otisků prstů pro ověřování. V Omarchy ho můžete používat spuštěním volby _Nastavení > Security > Fingerprint_ v nabídce Omarchy (`Super + Space`).

Tím se nainstaluje balíček pro otisky prstů, načte se váš otisk, ověří se a budete mít hotovo — otisk prstu pak využijete k odemknutí ze zamykací obrazovky (kterou vyvoláte zkratkou `Super + Ctrl + L`), ke vstupu do režimu sudo a k autorizaci systémových výzev.

Když je víko notebooku zavřené, výzva k otisku prstu se automaticky přeskočí, takže přejdete rovnou k výzvě k zadání hesla, místo abyste čekali na senzor, na který nedosáhnete. Pokud jinak potřebujete pracovat na externí klávesnici bez senzoru, stačí při výzvě k otisku prstu během příkazu `sudo` stisknout `CTRL + C`.

Ověřování otiskem prstu odstraníte v nabídce Omarchy v části _Odebrat > Security > Fingerprint_.

### Ověřování pomocí Fido2

Pokud používáte zařízení Fido2, můžete ho nastavit pro ověřování příkazu `sudo` pomocí volby _Nastavení > Security > Fido2_ v nabídce Omarchy (`Super + Space`). Pokrývá však výzvy pro `sudo` a autorizaci systému, nikoli odemykání počítače.

Ověřování pomocí fido2 odstraníte v nabídce Omarchy v části _Odebrat > Security > Fido2_.
