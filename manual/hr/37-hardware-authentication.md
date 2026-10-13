# Hardverska autentifikacija

### Autentifikacija otiskom prsta

Mnoga prijenosna računala dolaze sa senzorom otiska prsta za autentifikaciju. To možete koristiti s Omarchyjem pokretanjem _Postavke > Security > Fingerprint_ u Omarchy izborniku (`Super + Space`).

Time se instalira paket za otisak prsta, prikuplja vaš otisak, provjerava ga i spremni ste koristiti otisak prsta za otključavanje sa zaslona za zaključavanje (koji možete pokrenuti s `Super + Ctrl + L`), ulazak u sudo način i odobravanje upita sustava.

Kad je poklopac vašeg prijenosnog računala zatvoren, upit za otisak prsta automatski se preskače, pa idete izravno na upit za lozinku umjesto da čekate senzor koji ne možete dosegnuti. Ako inače trebate raditi na vanjskoj tipkovnici koja nema senzor, samo pritisnite `CTRL + C` kad vam se zatraži otisak prsta tijekom `sudo`.

Autentifikaciju otiskom prsta možete ukloniti pod _Ukloni > Security > Fingerprint_ u Omarchy izborniku.

### Fido2 autentifikacija

Ako koristite Fido2 uređaj, možete ga postaviti za `sudo` autentifikaciju pomoću _Postavke > Security > Fido2_ u Omarchy izborniku (`Super + Space`). Pokriva, doduše, `sudo` i upite za odobrenje sustava, ali ne i otključavanje računala.

Fido2 autentifikaciju možete ukloniti pod _Ukloni > Security > Fido2_ u Omarchy izborniku.
