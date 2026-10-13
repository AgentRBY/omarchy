# Riistvaraline autentimine

### Sõrmejäljega autentimine

Paljudel sülearvutitel on autentimiseks sõrmejäljeskanner. Sa saad seda Omarchyga kasutada, käivitades Omarchy menüüs (`Super + Space`) jaotise _Seaded > Turvalisus > Sõrmejälg_.

See paigaldab sõrmejälje paketi, kogub sinu jälje, kinnitab selle ja saad sõrmejälge kasutada lukuekraanilt avamiseks (mille saad käivitada klahvikombinatsiooniga `Super + Ctrl + L`), sudo režiimi sisenemiseks ja süsteemipäringute volitamiseks.

Kui sinu sülearvuti kaas on suletud, jäetakse sõrmejälje päring automaatselt vahele, nii et jõuad otse parooli päringuni, selle asemel et oodata skannerit, millele ligi ei pääse. Kui pead muul põhjusel töötama välise klaviatuuriga, millel skannerit pole, vajuta lihtsalt `CTRL + C`, kui `sudo` ajal sinult sõrmejälge küsitakse.

Sõrmejäljega autentimise saad eemaldada Omarchy menüüs jaotise _Eemalda > Turvalisus > Sõrmejälg_ all.

### Fido2 autentimine

Kui kasutad Fido2 seadet, saad selle seadistada `sudo` autentimiseks Omarchy menüüs (`Super + Space`) jaotise _Seaded > Turvalisus > Fido2_ kaudu. See katab `sudo` ja süsteemi autoriseerimise päringuid, aga mitte arvuti avamist.

Fido2 autentimise saad eemaldada Omarchy menüüs jaotise _Eemalda > Turvalisus > Fido2_ all.
