# Hardware-godkendelse

### Fingeraftryksgodkendelse

Mange bærbare leveres med en fingeraftrykssensor til godkendelse. Du kan bruge den med Omarchy ved at køre _Opsætning > Sikkerhed > Fingeraftryk_ i Omarchy-menuen (`Super + Space`).

Det installerer fingeraftrykspakken, indsamler dit aftryk, verificerer det, og så er du klar til at bruge dit fingeraftryk til at låse op fra låseskærmen (som du kan udløse med `Super + Ctrl + L`), gå i sudo-tilstand og autorisere systemprompter.

Når låget på din bærbare er lukket, springes fingeraftryksprompten automatisk over, så du går direkte til adgangskodeprompten i stedet for at vente på en sensor, du ikke kan nå. Hvis du ellers har brug for at arbejde på et eksternt tastatur, der ikke har en sensor, skal du bare trykke `CTRL + C`, når du bliver bedt om dit fingeraftryk under `sudo`.

Du kan fjerne fingeraftryksgodkendelsen under _Fjern > Sikkerhed > Fingeraftryk_ i Omarchy-menuen.

### Fido2-godkendelse

Hvis du bruger en Fido2-enhed, kan du sætte den op til `sudo`-godkendelse ved hjælp af _Opsætning > Sikkerhed > Fido2_ i Omarchy-menuen (`Super + Space`). Den dækker dog `sudo` og systemautorisationsprompter, ikke oplåsning af din computer.

Du kan fjerne Fido2-godkendelsen under _Fjern > Sikkerhed > Fido2_ i Omarchy-menuen.
