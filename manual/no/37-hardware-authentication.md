# Maskinvareautentisering

### Fingeravtrykksautentisering

Mange bærbare kommer med en fingeravtrykkssensor til autentisering. Du kan bruke denne med Omarchy ved å kjøre _Oppsett > Sikkerhet > Fingeravtrykk_ i Omarchy-menyen (`Super + Space`).

Det installerer fingeravtrykkspakken, samler inn avtrykket ditt, verifiserer det, og du er klar til å bruke fingeravtrykket til å låse opp fra låseskjermen (som du kan utløse med `Super + Ctrl + L`), gå inn i sudo-modus og godkjenne systemforespørsler.

Når lokket på den bærbare er lukket, hoppes fingeravtrykksforespørselen automatisk over, så du går rett til passordforespørselen i stedet for å vente på en sensor du ikke når. Hvis du ellers må jobbe på et eksternt tastatur som ikke har en sensor, trykk bare `CTRL + C` når du blir bedt om fingeravtrykket under `sudo`.

Du kan fjerne fingeravtrykksautentiseringen under _Fjern > Sikkerhet > Fingeravtrykk_ i Omarchy-menyen.

### Fido2-autentisering

Hvis du bruker en Fido2-enhet, kan du sette den opp for `sudo`-autentisering med _Oppsett > Sikkerhet > Fido2_ i Omarchy-menyen (`Super + Space`). Den dekker imidlertid `sudo` og systemautorisasjonsforespørsler, ikke opplåsing av datamaskinen.

Du kan fjerne fido2-autentiseringen under _Fjern > Sikkerhet > Fido2_ i Omarchy-menyen.
