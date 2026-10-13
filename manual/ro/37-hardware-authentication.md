# Autentificare hardware

### Autentificare cu amprentă

Multe laptopuri vin cu un senzor de amprentă pentru autentificare. Poți folosi asta cu Omarchy rulând _Configurare > Securitate > Amprentă_ în meniul Omarchy (`Super + Space`).

Asta va instala pachetul pentru amprentă, îți va colecta amprenta, o va verifica, și vei fi gata să-ți folosești amprenta ca să deblochezi din ecranul de blocare (pe care îl poți declanșa cu `Super + Ctrl + L`), să intri în modul sudo și să autorizezi solicitările sistemului.

Când capacul laptopului este închis, solicitarea amprentei este omisă automat, astfel încât ajungi direct la solicitarea parolei în loc să aștepți un senzor la care nu poți ajunge. Dacă altfel trebuie să lucrezi pe o tastatură externă care nu are senzor, apasă pur și simplu `CTRL + C` când ți se cere amprenta în timpul `sudo`.

Poți elimina autentificarea cu amprentă sub _Elimină > Securitate > Amprentă_ în meniul Omarchy.

### Autentificare Fido2

Dacă folosești un dispozitiv Fido2, îl poți configura pentru autentificarea `sudo` folosind _Configurare > Securitate > Fido2_ în meniul Omarchy (`Super + Space`). Totuși, acoperă `sudo` și solicitările de autorizare ale sistemului, nu deblocarea computerului.

Poți elimina autentificarea fido2 sub _Elimină > Securitate > Fido2_ în meniul Omarchy.
