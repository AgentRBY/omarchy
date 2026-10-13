# Začetek dela

Omarchy se namesti z datoteko ISO. Izberete lahko med namestitvijo na celoten disk, ki prevzame celoten pogon, ali namestitvijo v prosti prostor, ki Omarchy namesti v nedodeljeni prostor na pogonu — tako dvojno zaganjate poleg Windowsov ali drugega operacijskega sistema (glejte [namestitev z dvojnim zagonom](50-dual-boot-install.md) — upoštevajte, da boste morali v Windowsih najprej izklopiti BitLocker). Kakorkoli že, namestitev je privzeto popolnoma šifrirana, možnost za celoten disk pa bo izbrisala izbrani pogon, zato pred uporabo obstoječega poskrbite za varnostno kopijo!

Najprej [prenesite datoteko ISO za Omarchy](https://omarchy.org/), jo dajte na ključ USB (na Macu/Windowsih uporabite [balenaEtcher](https://etcher.balena.io/), na Linuxu pa [caligula](https://github.com/ifd3f/caligula)) in zaženite s ključa.

_V BIOS-u morate izklopiti Secure Boot in/ali TPM. Izklopiti ju morate, da lahko namestite Omarchy. Gre za Microsoftovi varnostni shemi, namenjeni Windowsom in z Microsoftom povezanim distribucijam Linuxa._

Nato odgovorite na konfiguracijska vprašanja in jih potrdite takole:

 ![install-config](images/install-config.webp)

Nato izberite pogon za namestitev, se usedite in opazujte namestitveno predstavo. Na najhitrejših sodobnih računalnikih je lahko končana v manj kot minuti, niti na starejšem računalniku pa ne bi smela trajati več kot 5 minut.

 ![install-done](images/install-done.webp)

Zdaj ste pripravljeni na Omarchy!

### Uporabite žično tipkovnico ali tipkovnico 2,4 GHz!

Šifriranje celotnega diska vam ob zagonu ne bo omogočilo vnosa gesla s tipkovnico Bluetooth. Tako kot s tipkovnico Bluetooth na računalniku PC ne morete vstopiti v BIOS. Potrebovali boste tipkovnico, ki uporablja bodisi vtičnik 2,4 GHz bodisi kabel (kar je sicer veliko lepše zaradi zakasnitve!). Osebno obožujem [Lofree Flow84](https://www.lofree.co/products/lofree-flow-the-smoothest-mechanical-keyboard)!

### Namestitev za drugega lastnika

Če računalnik nastavljate za nekoga drugega — družinskega člana, novega zaposlenega, kupca — osebnih vprašanj ne smete odgovarjati namesto njega. Na čisto prvem zaslonu namestitvenega programa (izbira tipkovnice) pritisnite `Ctrl + C`, in Omarchy vam bo namesto tega ponudil pripravo računalnika za drugega lastnika. Sistem se namesti takoj, vsa osebna nastavitev — razpored tipkovnice, uporabniško ime, geslo — pa se odloži, dokler se računalnik prvič ne zažene. Pogon je še vedno privzeto šifriran, geslo, ki ga novi lastnik izbere ob prvem zagonu, pa postane tudi geslo za šifriranje. (Računalnik, ki ste ga že uporabljali, lahko predate tudi brez vnovične namestitve — glejte [ponastavitev računalnika](48-security.md).)

### Nenadzorovane namestitve

Datoteka ISO se lahko namesti tudi povsem samostojno — brez tipkovnice, brez čarovnika — če ji konfiguracijo podate na drugem pogonu. Tako Omarchy obravnavate kot osnovno sliko za navidezne računalnike in stroje v floti. Glejte [nenadzorovane namestitve](51-unattended-installs.md).

### Namestitve brez šifriranja

Omarchy je privzeto nameščen s šifriranjem. To je varna in odgovorna izbira za vsak računalnik, ki ga lahko izgubite ali vam ga ukradejo. Ne želite, da bi kdorkoli z dostopom do vaše strojne opreme lahko prišel do vaših podatkov!

V posebnih okoliščinah, kot so oddaljene namestitve Omarchyja na zaščitenih računalnikih ali začasne namestitve brez občutljivih podatkov, pa boste morda želeli namestiti brez šifriranja. Ob potrditvi formatiranja diska lahko pritisnete `Ctrl + C` za preklop na namestitev brez šifriranja.

### Jezik

Omarchy govori 50 jezikov — enak nabor kot omarchy.org — privzet je angleški. Za preklop odprite meni Omarchy in pojdite na _Setup > Language_ ali v terminalu zaženite `omarchy language <code>` (`omarchy language list` prikaže kode). Meni, namizje in obvestila Omarchyja jezik zamenjajo takoj, sistemske lokalne nastavitve pa se nastavijo skladno, tako da jim vaše druge aplikacije sledijo ob naslednji prijavi.

### Pomoč, če obtrknete

Če obtrknete, v kanalu _#omarchy-help_ na [skupnostnem Discordu](https://omarchy.org/discord) običajno najdete nekoga, ki je pripravljen pomagati.
