# Navigointi

Kaikki Omarchyssa tapahtuu näppäimistön kautta — _KAIKKI!_ Kun järjestelmä käynnistyy ensimmäisen kerran, et kirjaimellisesti voi tehdä mitään pelkällä hiirellä. Mutta voit painaa `Super + Space` paljastaaksesi Omarchy-valikon, ja täältä voit tehdä oikeastaan kaiken.

Mutta Omarchy-valikon ei ole tarkoituskaan olla pääasiallinen tapa käyttää järjestelmää suurimman osan ajasta. Pääsemme siitä nopeammin! Kaikki tärkeimmät sovellukset on sidottu suoraan yksittäisiin pikanäppäimiin. Käynnistät päätteen yhdistelmällä `Super + Return` ja selaimen yhdistelmällä `Super + Shift + Return`. Yritä tehdä ne peräkkäin, ja näet Hyprlandin laatoituksen taian toiminnassa:

 ![navigation-browser-terminal](images/navigation-browser-terminal.webp)

Voit sitten painaa `Super + J` pinotaksesi ne päällekkäin vierekkäisyyden sijaan:

 ![navigation-stacked](images/navigation-stacked.webp)

Paina `Super + J` uudelleen palauttaaksesi ne vierekkäisiin asemiinsa. Kokeile sitten yhdistelmää `Super + Shift + Arrow Right` selaimessa ollessasi vaihtaaksesi ikkunat.

Kokeile nyt yhdistelmää `Super + Ctrl + T` käynnistääksesi Aktiivisuusnäytön. Se ilmestyy kelluvana ikkunana. Voit laatoittaa sen yhdistelmällä `Super + T` (ja painaa sitä uudelleen tehdäksesi siitä taas kelluvan). Paina nyt `Super + Shift + F` avataksesi tiedostojenhallinnan. Saat siistin neliosaisen kokoonpanon:

 ![navigation-fourway-tiling](images/navigation-fourway-tiling.webp)

Navigoit ikkunan välillä, jonka haluat olevan aktiivinen, yhdistelmällä `Super + Arrow`. Tämä vaihtaa kohdistuksen ja siirtää kohdistimen uuden sovelluksen keskelle.

Jos painat `Super + Shift + 2`, siirrät tällä hetkellä kohdistetun sovelluksen toiseen työtilaan. `Super + Shift + 1` siirtää sen takaisin. (Ja `Super + Shift + Alt + 2` siirtää tällä hetkellä kohdistetun sovelluksen toiseen työtilaan vaihtamatta siihen.)

Jos pidät `Super` pohjassa ja käytät hiirtä napsauttaaksesi ikkunaa, voit järjestellä sen sijainnin uudelleen. Jos pidät `Super` pohjassa ja käytät hiiren oikeaa painiketta, voit vapaasti muuttaa ikkunan kokoa.

Suljet ikkunan yhdistelmällä `Super + W` tai `Super + Q` (ja kaikki ikkunat yhdistelmällä `Ctrl + Alt + Delete`).

Voit myös mennä koko ruutuun yhdistelmällä `Super + F` tai jopa vain koko leveyteen (pitämällä yläpalkin) yhdistelmällä `Super + Alt + F` tai koko ruutuun ikkunan sisällä yhdistelmällä `Super + Ctrl + F` (hyvä YouTubeen!).

### Dwindle vastaan vieritys-asettelu

Omarchyn oletusasettelua kutsutaan dwindleksi. Se pitää kaikki yhdessä työtilassa avaamasi ikkunat koko ajan näkyvissä, vaikka sen täytyisikin kutistaa niitä.

 ![navigation-dwindle-layout](images/navigation-dwindle-layout.webp)

Mutta voit myös valita työtilan muuttamisen vieritys-asetteluksi, jossa ikkunat on asetettu vierekkäin näytön näkyvän reunan ulkopuolelle. Muutat yhden työtilan tähän asetteluun yhdistelmällä `Super + L`.

Yhdistelmän `Super + L` painaminen uudelleen tekee työtilasta kelluvan, jossa ikkunat limittyvät vapaasti ja sijoitat ne itse, ja kolmas painallus palauttaa sen dwindleen. `Super + Alt + L` käy ne läpi toiseen suuntaan. Ikkuna, joka kelluu joka tapauksessa — sellainen, jonka ponnautit ulos yhdistelmällä `Super + T`, tai sovellus, joka aina avautuu kelluvana — jatkaa kellumista, kun työtila palaa laatoitukseen. Yläpalkki merkitsee työtilasi sen asettelulla: neliö dwindlelle, ympyrä vieritykselle ja kolmio kelluvalle. Merkin napsauttaminen myös kiertää asettelua.

 ![navigation-scrolling-layout](images/navigation-scrolling-layout.webp)

Valinta on työtilakohtainen, ja se pysyy. Joten voit pitää työtilan 1 dwindlessä selailua varten ja työtilan 2 vierityksessä koodia varten, ja ne palaavat niin uudelleenkäynnistyksen jälkeen.

Jos haluat käyttää vieritys-asettelua oletuksena, voit asettaa sen tiedostoon `~/.config/hypr/looknfeel.lua`:

```lua
hl.config({
  general = {
    layout = "scrolling",
  },
})
```

### Kelluvat työtilat

Kelluva työtila toimii kuin perinteinen työpöytä: ikkunat limittyvät, ja siirrät ja mitoitat ne itse. Jokainen ikkuna saa otsikkopalkin teemasi väreissä, jossa on painikkeet pienentämistä, suurentamista ja sulkemista varten. `Super + M` pienentää myös kohdistetun ikkunan. Pienennetty ikkuna odottaa dockissa; napsauta sen sovellusta tuodaksesi sen takaisin. Napsauta ikkunaa tuodaksesi sen eteen. Muuta sen kokoa mistä tahansa reunasta tai kulmasta. Kaksoisnapsauta otsikkopalkkia suurentaksesi ikkunaa pitäen yläpalkin näkyvissä, ja uudelleen saadaksesi sen vanhan koon takaisin.

Kelluva työtila näyttää myös dockin, jossa on kiinnittämäsi sovellukset, kaikki käynnissä olevat ja ruudukko jokaisesta sovelluksesta sovelluspainikkeen takana, jonka myös `Super + Alt + Space` ja _Sovellukset_ Omarchy-valikossa avaavat. Napsauta ruudukossa sovellusta oikealla painikkeella tai paina `Delete` poistaaksesi sen. Napsauta sovellusta avataksesi sen tai tuodaksesi sen ikkunan eteen; napsauta uudelleen kiertääksesi sen ikkunoita. Keskipainikkeen napsautus avaa uuden ikkunan. Vedä kuvaketta dockia pitkin siirtääksesi sitä; käynnissä olevan sovelluksen vetäminen muiden joukkoon pitää sen siellä. Napsauta oikealla painikkeella pitääksesi sovelluksen dockissa, ottaaksesi sen pois tai sulkeaksesi sen. Dock väistää koko ruudun ikkunan edestä. Napsauta oikealla painikkeella sovelluspainiketta siirtääksesi dockin toiseen reunaan tai saadaksesi se piiloutumaan, kunnes osoitin saavuttaa sen reunan. Sijainti on myös kohdassa _Käynnistä > Ulkoasu > Dock > Dockin sijainti_, ja komennot `omarchy dock position left` ja `omarchy dock autohide on` asettavat molemmat pääätteestä. Sovellukset, joita pidät dockissa, ovat himmennettyjä, kun ne eivät ole käynnissä.

Uudet työtilat ja kaikki työtilat, joille et ole antanut omaa asettelua yhdistelmällä `Super + L`, käyttävät oletusasettelua. Oletuksen vaihtaminen nollaa jokaisen ilman ikkunoita olevan työtilan siihen, kun taas ikkunoita sisältävä pitää jo omistamansa asettelun. Valitse se kohdasta _Käynnistä > Ulkoasu > Työtilan asettelu_: Laatoitus, Vieritys tai Kelluva. `omarchy-hyprland-workspace-layout-default scrolling` asettaa sen pääätteestä.

### Ikkunoiden ryhmittäminen

Ikkunoita voi ryhmitellä yhdistelmällä `Super + G`. Kun olet ryhmässä, jokainen silloin käynnistämäsi ikkuna kuuluu ryhmään. Voit siirtyä näiden ryhmiteltyjen ikkunoiden välillä yhdistelmillä `Super + Ctrl + Arrow Left/Right` tai `Super + Alt + 1/2/3/4` mennäksesi suoraan ryhmiteltyyn ikkunaan järjestyksessä.

Voit siirtää ikkunan pois ryhmästä yhdistelmällä `Super + Alt + G` tai purkaa koko ryhmän painamalla uudelleen `Super + G`. Lopuksi voit siirtää ikkunoita ryhmän ulkopuolelta siihen yhdistelmällä `Super + Alt + Arrows`.

### Ikkunoiden ponnauttaminen

Voit ponnauttaa ikkunan pois työtilakohtaisesta allokoinnistaan yhdistelmällä `Super + O`. Se kiinnittää sen kelluvaksi ikkunaksi, joka seuraa sinua mihin tahansa työtilaan menet. Erinomainen videosoittimille ja vastaaville.

 ![navigation-popped-window](images/navigation-popped-window.webp)

### Scratchpad-työtila

Lopuksi on erityinen scratchpad-työtila, joka putoaa sen työtilan päälle, jossa olet tällä hetkellä, paljon Quake-konsolin tapaan. Vaihda se yhdistelmillä `Super + Grave` tai `Super + S` ja sijoita ikkuna sinne yhdistelmillä `Super + Shift + Grave` tai `Super + Alt + S`.

Se toimii erityisen hyvin agenttia pyörittävälle pääätteelle tai säätimille, joiden kanssa haluat toimia nopeasti poistumatta nykyisestä työtilasta. Siirtääksesi ikkunan pois scratchpadista lähetä se suoraan toiseen työtilaan esimerkiksi yhdistelmällä `Super + Shift + 1`.

Kun scratchpad sisältää yhden ikkunan, se putoaa keskitettynä paneelina sen sijaan, että ulottuisi ruudun poikki. Laita siihen toinen sovellus, ja se palaa koko leveyteen, jotta molemmilla on tilaa olla vierekkäin.

### Siihen tottuu hetki!

Työpöydälläsi navigoimiseen tällä tavalla tottumiseen menee hetki, mutta kun totut, perinteiseen hiiriohjautuvaan työpöytäkokemukseen palaaminen on vaikeaa!
