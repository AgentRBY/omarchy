# Začíname

Omarchy sa inštaluje pomocou ISO. Môžete si vybrať medzi inštaláciou na celý disk, ktorá ovládne celý disk, alebo inštaláciou do voľného miesta, ktorá umiestni Omarchy do neprideleného miesta na disku — takto dualbootujete popri Windowse alebo inom operačnom systéme (pozrite si [inštaláciu s dual-bootom](50-dual-boot-install.md) — všimnite si, že vo Windowse budete musieť najskôr vypnúť BitLocker). V každom prípade inštalácia predvolene používa úplné šifrovanie a možnosť celého disku vybraný disk vymaže, takže si pred použitím existujúceho disku určite urobte zálohu!

Najskôr si [stiahnite Omarchy ISO](https://omarchy.org/), dajte ho na USB kľúč (na Macu/Windowse použite [balenaEtcher](https://etcher.balena.io/) alebo na Linuxe [caligula](https://github.com/ifd3f/caligula)) a nabootujte z kľúča.

_V BIOSe musíte vypnúť Secure Boot a/alebo TPM. Musíte ich vypnúť, aby ste mohli nainštalovať Omarchy. Sú to bezpečnostné schémy Microsoftu určené pre Windows a linuxové distribúcie pridružené k Microsoftu._

Potom odpovedzte na otázky týkajúce sa konfigurácie a potvrďte ich takto:

 ![install-config](images/install-config.webp)

Potom vyberte disk pre inštaláciu, sadnite si a sledujte inštalačnú šou. Na najrýchlejších moderných strojoch to môže byť hotové za menej ako minútu, ale ani na staršom počítači by to nemalo trvať viac ako 5 minút.

 ![install-done](images/install-done.webp)

Teraz ste pripravení na Omarchy!

### Použite káblovú alebo 2,4 Ghz klávesnicu!

Šifrovanie celého disku vám pri spustení nedovolí zadať heslo z Bluetooth klávesnice. Rovnako ako nemôžete použiť Bluetooth klávesnicu na vstup do BIOSu na PC. Budete potrebovať klávesnicu, ktorá používa buď 2,4 Ghz dongle, alebo kábel (čo je aj tak oveľa príjemnejšie kvôli latencii!). Ja osobne milujem [Lofree Flow84](https://www.lofree.co/products/lofree-flow-the-smoothest-mechanical-keyboard)!

### Inštalácia pre iného vlastníka

Ak nastavujete stroj pre niekoho iného — člena rodiny, nového zamestnanca, kupujúceho — nemali by ste v jeho mene odpovedať na osobné otázky. Na úplne prvej obrazovke inštalátora (výber klávesnice) stlačte `Ctrl + C` a Omarchy namiesto toho ponúkne pripraviť stroj pre iného vlastníka. Systém sa hneď nainštaluje, ale všetky osobné nastavenia — rozloženie klávesnice, používateľské meno, heslo — sa odložia, kým sa stroj prvýkrát nespustí. Disk je stále predvolene zašifrovaný a heslo, ktoré si nový vlastník vyberie pri tomto prvom spustení, sa stane aj šifrovacím heslom. (Stroj, ktorý ste už používali, možno odovzdať aj bez preinštalovania — pozrite si [resetovanie počítača](48-security.md).)

### Bezobslužné inštalácie

ISO sa môže nainštalovať aj úplne samo — bez klávesnice, bez sprievodcu — keď dostane svoju konfiguráciu na druhom disku. To je spôsob, ako zaobchádzať s Omarchy ako so základným obrazom pre virtuálne stroje a flotilné stroje. Pozrite si [bezobslužné inštalácie](51-unattended-installs.md).

### Inštalácie bez šifrovania

Omarchy sa predvolene inštaluje so šifrovaním. Je to bezpečná a zodpovedná voľba pre každý počítač, ktorý sa môže stratiť alebo byť ukradnutý. Nechcete, aby sa niekto s prístupom k vášmu hardvéru mohol dostať k vašim údajom!

Ale za osobitných okolností, ako sú vzdialené inštalácie Omarchy na chránených počítačoch alebo jednorazové inštalácie bez citlivých údajov, možno budete chcieť inštalovať bez šifrovania. Pri potvrdení formátovania disku môžete stlačiť `Ctrl + C` a prepnúť na inštaláciu bez šifrovania.

### Jazyk

Omarchy hovorí 50 jazykmi — rovnakou sadou ako omarchy.org — a angličtina je predvolená. Ak chcete prepnúť, otvorte menu Omarchy a prejdite do _Nastavenie > Jazyk_ alebo v termináli spustite `omarchy language <code>` (`omarchy language list` zobrazí kódy). Menu, pracovná plocha a vlastné upozornenia Omarchy okamžite zmenia jazyk a systémové miestne nastavenie sa nastaví tak, aby zodpovedalo, takže vaše ostatné aplikácie budú nasledovať pri ďalšom prihlásení.

### Pomoc, ak uviaznete

Ak uviaznete, zvyčajne môžete nájsť niekoho, kto je ochotný pomôcť, v kanáli _#omarchy-help_ na [komunitnom Discorde](https://omarchy.org/discord).
