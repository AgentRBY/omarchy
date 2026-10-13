# Laitteistotodennus

### Sormenjälkitodennus

Monissa kannettavissa on sormenjälkitunnistin todentamista varten. Voit käyttää sitä Omarchyssa valitsemalla Omarchy-valikosta (`Super + Space`) _Asetukset > Turvallisuus > Sormenjälki_.

Se asentaa sormenjälkipaketin, kerää jälkesi, tarkistaa sen, ja olet valmis käyttämään sormenjälkeäsi lukitusruudulta avaamiseen (jonka voit käynnistää näppäimillä `Super + Ctrl + L`), sudo-tilaan siirtymiseen ja järjestelmän kehotteiden valtuuttamiseen.

Kun kannettavan kansi on kiinni, sormenjälkikehote ohitetaan automaattisesti, joten siirryt suoraan salasanakehotteeseen sen sijaan, että odottaisit tunnistinta, johon et pääse käsiksi. Jos muuten joudut työskentelemään ulkoisella näppäimistöllä, jossa ei ole tunnistinta, paina vain `CTRL + C`, kun sinulta pyydetään sormenjälkeä `sudo`-käytön aikana.

Voit poistaa sormenjälkitodennuksen Omarchy-valikosta kohdasta _Poista > Turvallisuus > Sormenjälki_.

### Fido2-todennus

Jos käytät Fido2-laitetta, voit asettaa sen `sudo`-todennukseen Omarchy-valikosta (`Super + Space`) kohdasta _Asetukset > Turvallisuus > Fido2_. Se kattaa kuitenkin `sudo`- ja järjestelmän valtuutuskehotteet, ei tietokoneen lukituksen avaamista.

Voit poistaa fido2-todennuksen Omarchy-valikosta kohdasta _Poista > Turvallisuus > Fido2_.
