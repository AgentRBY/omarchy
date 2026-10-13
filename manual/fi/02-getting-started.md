# Aloitus

Omarchy asennetaan ISO-tiedoston avulla. Voit valita koko levyn asennuksen, joka ottaa koko levyn käyttöön, tai vapaan tilan asennuksen, joka sijoittaa Omarchyn levyn varaamattomaan tilaan — näin teet kaksoiskäynnistyksen Windowsin tai jonkin muun käyttöjärjestelmän rinnalla (katso [kaksoiskäynnistysasennus](50-dual-boot-install.md) — huomaa, että sinun on ensin kytkettävä BitLocker pois päältä Windowsissa). Joka tapauksessa asennus käyttää oletuksena täyttä salausta, ja koko levyn vaihtoehto pyyhkii valitun levyn, joten muista tehdä varmuuskopio ennen kuin käytät olemassa olevaa levyä!

[Lataa Omarchy ISO](https://omarchy.org/) ensin, laita se USB-tikulle (käytä ohjelmaa [balenaEtcher](https://etcher.balena.io/) Macilla/Windowsissa tai ohjelmaa [caligula](https://github.com/ifd3f/caligula) Linuxissa) ja käynnistä tikulta.

_Sinun on kytkettävä Secure Boot ja/tai TPM pois päältä BIOSissa. Sinun on kytkettävä ne pois päältä voidaksesi asentaa Omarchyn. Ne ovat Microsoftin suojausjärjestelmiä, jotka on tarkoitettu Windowsille ja Microsoftiin kytköksissä oleville Linux-jakeluille._

Vastaa sitten määrityskysymyksiin ja vahvista ne näin:

 ![install-config](images/install-config.webp)

Valitse sitten levy asennustasi varten ja nojaa taaksepäin katselemaan asennusnäytöstä. Se voi valmistua alle minuutissa nopeimmilla nykyaikaisilla koneilla, mutta sen ei pitäisi kestää yli viittä minuuttia edes vanhemmalla tietokoneella.

 ![install-done](images/install-done.webp)

Nyt olet valmis Omarchyyn!

### Käytä langallista tai 2,4 GHz:n näppäimistöä!

Koko levyn salaus ei salli salasanan syöttämistä Bluetooth-näppäimistöstä käynnistyksen yhteydessä. Aivan kuten et voi käyttää Bluetooth-näppäimistöä PC:n BIOSiin pääsyyn. Tarvitset näppäimistön, joka käyttää joko 2,4 GHz:n sovitinta tai kaapelia (mikä on joka tapauksessa paljon mukavampi viiveen kannalta!). Itse rakastan [Lofree Flow84:ää](https://www.lofree.co/products/lofree-flow-the-smoothest-mechanical-keyboard)!

### Asentaminen toiselle omistajalle

Jos olet ottamassa konetta käyttöön jollekulle muulle — perheenjäsenelle, uudelle työntekijälle, ostajalle — sinun ei pitäisi vastata henkilökohtaisiin kysymyksiin heidän puolestaan. Paina `Ctrl + C` asentajan aivan ensimmäisellä ruudulla (näppäimistön valinta), ja Omarchy tarjoaa koneen valmistelua toiselle omistajalle sen sijaan. Järjestelmä asennetaan heti, mutta kaikki henkilökohtainen käyttöönotto — näppäimistöasettelu, käyttäjänimi, salasana — lykätään siihen, kunnes kone käynnistetään ensimmäisen kerran. Levy on silti oletuksena salattu, ja salasanasta, jonka uusi omistaja valitsee ensimmäisellä käynnistyskerralla, tulee myös salauksen salasana. (Jo käytössä olleen koneen voi myös luovuttaa ilman uudelleenasennusta — katso [tietokoneen nollaaminen](48-security.md).)

### Valvomattomat asennukset

ISO voi myös asentua kokonaan itsestään — ei näppäimistöä, ei ohjattua toimintoa — kun sille annetaan määritys toisella levyllä. Näin Omarchyä käytetään VM:ien ja konekansojen pohjakuvana. Katso [valvomattomat asennukset](51-unattended-installs.md).

### Salauksettomat asennukset

Omarchy asennetaan oletuksena salattuna. Se on turvallinen ja vastuullinen valinta jokaiselle tietokoneelle, joka voi mahdollisesti kadota tai tulla varastetuksi. Et halua kenenkään, joka pääsee käsiksi laitteistoosi, pystyvän saamaan tietojasi!

Mutta erityisolosuhteissa, kuten etäasennuksissa suojatuilla tietokoneilla tai kertakäyttöasennuksissa ilman arkaluonteisia tietoja, saatat haluta asentaa ilman salausta. Voit painaa `Ctrl + C` levyn alustuksen vahvistuksessa vaihtaaksesi salauksettomaan asennukseen.

### Kieli

Omarchy puhuu 50 kieltä — samat kuin omarchy.org — ja englanti on oletus. Vaihtaaksesi avaa Omarchy-valikko ja siirry kohtaan _Asetukset > Kieli_ tai aja pääätteessä `omarchy language <code>` (`omarchy language list` näyttää koodit). Valikko, työpöytä ja Omarchyn omat ilmoitukset vaihtavat kielen heti, ja järjestelmän kielialue asetetaan vastaamaan, joten muut sovelluksesi seuraavat mukana seuraavalla kirjautumiskerralla.

### Apua, jos juutut

Jos juutut, löydät yleensä jonkun halukkaan auttamaan kanavalta _#omarchy-help_ [yhteisön Discordissa](https://omarchy.org/discord).
