# Hårdvaruautentisering

### Fingeravtrycksautentisering

Många bärbara datorer kommer med en fingeravtryckssensor för autentisering. Du kan använda den med Omarchy genom att köra _Installation > Security > Fingerprint_ i Omarchy-menyn (`Super + Space`).

Det installerar fingeravtryckspaketet, samlar in ditt avtryck, verifierar det, och du är redo att använda ditt fingeravtryck för att låsa upp från låsskärmen (som du kan utlösa med `Super + Ctrl + L`), gå in i sudo-läge och auktorisera systemfrågor.

När locket på din bärbara dator är stängt hoppas fingeravtrycksfrågan automatiskt över, så du går direkt till lösenordsfrågan i stället för att vänta på en sensor du inte kan nå. Om du annars behöver arbeta på ett externt tangentbord utan sensor trycker du bara på `CTRL + C` när du får frågan om ditt fingeravtryck under `sudo`.

Du kan ta bort fingeravtrycksautentiseringen under _Ta bort > Security > Fingerprint_ i Omarchy-menyn.

### Fido2-autentisering

Om du använder en Fido2-enhet kan du konfigurera den för `sudo`-autentisering med _Installation > Security > Fido2_ i Omarchy-menyn (`Super + Space`). Det täcker `sudo` och systemauktoriseringsfrågor, dock inte upplåsning av din dator.

Du kan ta bort fido2-autentiseringen under _Ta bort > Security > Fido2_ i Omarchy-menyn.
