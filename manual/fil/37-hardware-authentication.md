# Pag-authenticate gamit ang hardware

### Pag-authenticate gamit ang fingerprint

Maraming laptop ang may kasamang sensor ng fingerprint para sa pag-authenticate. Maaari mo itong gamitin sa Omarchy sa pamamagitan ng pagpapatakbo ng _Pag-setup > Seguridad > Fingerprint_ sa menu ng Omarchy (`Super + Space`).

I-i-install niyon ang pakete para sa fingerprint, kokolektahin ang print mo, ive-verify ito, at handa ka nang gamitin ang fingerprint mo para mag-unlock mula sa lock screen (na maaari mong i-trigger gamit ang `Super + Ctrl + L`), pumasok sa sudo mode, at mag-awtorisa ng mga prompt ng sistema.

Kapag nakasara ang takip ng laptop mo, awtomatikong nilalaktawan ang prompt para sa fingerprint, kaya dumidiretso ka sa prompt para sa password imbes na maghintay sa isang sensor na hindi mo maabot. Kung kailangan mo namang magtrabaho sa isang panlabas na keyboard na walang sensor, pindutin mo lang ang `CTRL + C`, kapag na-prompt ka para sa fingerprint mo habang nag-`sudo`.

Maaari mong alisin ang pag-authenticate gamit ang fingerprint sa ilalim ng _Alisin > Seguridad > Fingerprint_ sa menu ng Omarchy.

### Pag-authenticate gamit ang Fido2

Kung gumagamit ka ng device na Fido2, maaari mo itong i-setup para sa pag-authenticate ng `sudo` gamit ang _Pag-setup > Seguridad > Fido2_ sa menu ng Omarchy (`Super + Space`). Sakop nito ang `sudo` at mga prompt ng awtorisasyon ng sistema, pero hindi ang pag-unlock ng computer mo.

Maaari mong alisin ang pag-authenticate gamit ang fido2 sa ilalim ng _Alisin > Seguridad > Fido2_ sa menu ng Omarchy.
