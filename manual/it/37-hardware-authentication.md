# Autenticazione hardware

### Autenticazione con impronta digitale

Molti portatili hanno un sensore di impronte digitali per l'autenticazione. Puoi usarlo con Omarchy aprendo _Impostazioni > Sicurezza > Impronta digitale_ nel menu di Omarchy (`Super + Space`).

Questo installerà il pacchetto per le impronte, registrerà la tua impronta, la verificherà e sarai pronto a usare l'impronta per sbloccare dalla schermata di blocco (che puoi attivare con `Super + Ctrl + L`), entrare in modalità sudo e autorizzare le richieste di sistema.

Quando il coperchio del portatile è chiuso, la richiesta di impronta viene saltata automaticamente, così vai dritto alla richiesta della password invece di aspettare un sensore che non puoi raggiungere. Se invece devi lavorare con una tastiera esterna senza sensore, premi semplicemente `CTRL + C` quando ti viene chiesta l'impronta durante `sudo`.

Puoi rimuovere l'autenticazione con impronta in _Rimuovi > Sicurezza > Impronta digitale_ nel menu di Omarchy.

### Autenticazione Fido2

Se usi un dispositivo Fido2, puoi configurarlo per l'autenticazione `sudo` con _Impostazioni > Sicurezza > Fido2_ nel menu di Omarchy (`Super + Space`). Copre `sudo` e le richieste di autorizzazione di sistema, ma non lo sblocco del computer.

Puoi rimuovere l'autenticazione Fido2 in _Rimuovi > Sicurezza > Fido2_ nel menu di Omarchy.
