# Navigace

Všechno v Omarchy se děje přes klávesnici — _VŠECHNO!_ Když se systém poprvé spustí, doslova nemůžete se samotnou myší dělat vůbec nic. Ale můžete stisknout `Super + Space` a zobrazit nabídku Omarchy a odtud můžete dělat skoro všechno.

Nabídka Omarchy ale ani nemá být většinu času hlavním způsobem ovládání systému. Můžeme to zvládnout rychleji! Všechny nejdůležitější aplikace jsou navázány přímo na jednotlivé klávesové zkratky. Terminál spustíte pomocí `Super + Return` a prohlížeč pomocí `Super + Shift + Return`. Zkuste to udělat jedno po druhém a uvidíte kouzlo dlaždicového uspořádání Hyprlandu v akci:

 ![navigation-browser-terminal](images/navigation-browser-terminal.webp)

Poté můžete stisknout `Super + J` a naskládat je na sebe místo vedle sebe:

 ![navigation-stacked](images/navigation-stacked.webp)

Znovu stiskněte `Super + J` a vrátíte je do pozic vedle sebe. Poté zkuste `Super + Shift + Arrow Right`, zatímco jste v prohlížeči, a prohoďte okna.

Teď zkuste `Super + Ctrl + T` a spusťte monitor aktivity. Ten se objeví jako plovoucí okno. Můžete ho zařadit do dlaždic pomocí `Super + T` (a stisknout znovu, aby bylo zase plovoucí). Nyní stiskněte `Super + Shift + F` a otevřete správce souborů. Budete mít úhledné čtyřcestné uspořádání:

 ![navigation-fourway-tiling](images/navigation-fourway-tiling.webp)

Mezi okny, která chcete mít aktivní, se pohybujete pomocí `Super + Arrow`. Tím přepnete fokus a přesunete kurzor do středu nové aplikace.

Pokud stisknete `Super + Shift + 2`, přesunete aktuálně zaměřenou aplikaci na druhou pracovní plochu. `Super + Shift + 1` ji přesune zpět. (A `Super + Shift + Alt + 2` přesune aktuálně zaměřenou aplikaci na druhou pracovní plochu, aniž byste na ni přepnuli).

Pokud podržíte `Super` a myší kliknete na okno, budete moci změnit, kde sedí. Pokud podržíte `Super` a použijete pravé tlačítko myši, můžete volně měnit velikost okna.

Okno zavřete pomocí `Super + W` nebo `Super + Q` (a všechna okna zavřete pomocí `Ctrl + Alt + Delete`).

Můžete také přejít na celou obrazovku pomocí `Super + F` nebo jen na plnou šířku (se zachováním horního panelu) pomocí `Super + Alt + F`, nebo na celou obrazovku uvnitř okna pomocí `Super + Ctrl + F` (dobré pro YouTube!).

### Rozložení dwindle vs. posouvání

Výchozí rozložení Omarchy se nazývá dwindle. Udržuje všechna okna, která otevřete na jedné pracovní ploše, neustále viditelná, i když je musí zmenšit.

 ![navigation-dwindle-layout](images/navigation-dwindle-layout.webp)

Můžete si ale také zvolit přeměnu pracovní plochy na posouvací rozložení, kde jsou okna seřazena vedle sebe za viditelným okrajem displeje. Jednotlivou pracovní plochu do tohoto rozložení převedete pomocí `Super + L`.

Opětovným stisknutím `Super + L` se pracovní plocha stane plovoucí, kde se okna volně překrývají a umisťujete je sami, a třetí stisknutí ji vrátí do dwindle. `Super + Alt + L` jimi prochází opačným směrem. Okno, které každopádně plove — takové, které jste vysunuli pomocí `Super + T`, nebo aplikace, která se vždy otevírá jako plovoucí — zůstává plovoucí, i když se pracovní plocha vrátí k dlaždicím. Horní panel označuje pracovní plochu, na které jste, jejím rozložením: čtverec pro dwindle, kruh pro posouvání a trojúhelník pro plovoucí. Kliknutím na tuto značku se rozložení také přepíná.

 ![navigation-scrolling-layout](images/navigation-scrolling-layout.webp)

Volba je pro každou pracovní plochu zvlášť a zůstává zachována. Takže si můžete nechat pracovní plochu 1 na dwindle pro prohlížení a pracovní plochu 2 na posouvání pro kód a po restartu se tak vrátí.

Pokud chcete posouvací rozložení používat jako výchozí, můžete to nastavit v `~/.config/hypr/looknfeel.lua`:

```lua
hl.config({
  general = {
    layout = "scrolling",
  },
})
```

### Plovoucí pracovní plochy

Plovoucí pracovní plocha funguje jako tradiční plocha: okna se překrývají a sami je přesouváte a měníte jejich velikost. Každé okno dostane titulní lištu v barvách vašeho motivu s tlačítky pro minimalizaci, maximalizaci a zavření. `Super + M` minimalizuje také zaměřené okno. Minimalizované okno čeká v docku; klikněte na jeho aplikaci a přivedete ho zpět. Klikněte na okno a přivedete ho dopředu. Změňte jeho velikost z jakéhokoli okraje nebo rohu. Dvojitým kliknutím na titulní lištu okno maximalizujete při zachování horního panelu v dohledu a znovu získáte jeho starou velikost zpět.

Plovoucí pracovní plocha také zobrazuje dock s vašimi připnutými aplikacemi, vším, co běží, a mřížkou každé aplikace za tlačítkem aplikací, které otevírají také `Super + Alt + Space` a _Aplikace_ v nabídce Omarchy. Klikněte pravým tlačítkem na aplikaci v mřížce, nebo stiskněte `Delete`, a odinstalujete ji. Klikněte na aplikaci a otevřete ji, nebo přivedete její okno dopředu; klikněte znovu a procházejte jejími okny. Prostřední kliknutí otevře nové okno. Přetáhněte ikonu podél docku a přesuňte ji; přetažením běžící aplikace mezi ostatní ji tam ponecháte. Klikněte pravým tlačítkem a ponechte aplikaci v docku, vyjměte ji, nebo ji ukončete. Dock uhýbá z cesty oknu na celou obrazovku. Klikněte pravým tlačítkem na tlačítko aplikací a přesuňte dock na jiný okraj, nebo ho nechte skrýt, dokud ukazatel nedosáhne jeho okraje. Poloha je také v _Akce > Vzhled > Dock > Poloha Docku_ a `omarchy dock position left` a `omarchy dock autohide on` nastaví obojí z terminálu. Aplikace, které si v docku ponecháte, jsou vybledlé, dokud neběží.

Nové pracovní plochy a všechny, kterým jste nedali vlastní rozložení pomocí `Super + L`, používají výchozí rozložení. Změna výchozího nastavení resetuje každou pracovní plochu bez oken na toto nastavení, zatímco plocha s okny si ponechá rozložení, které má. Vyberte ho v _Akce > Vzhled > Rozložení plochy_: Dlaždice, Posouvání nebo Plovoucí. `omarchy-hyprland-workspace-layout-default scrolling` ho nastaví z terminálu.

### Seskupování oken

Okna lze seskupit pomocí `Super + G`. Jakmile jste ve skupině, každé okno, které spustíte, zatímco je aktivní, bude patřit do skupiny. Mezi těmito seskupenými okny se můžete pohybovat pomocí `Super + Ctrl + Arrow Left/Right` nebo `Super + Alt + 1/2/3/4` a přejít přímo na seskupené okno v pořadí.

Okno můžete ze seskupení přesunout pomocí `Super + Alt + G` nebo celou skupinu rozebrat opětovným stisknutím `Super + G`. Nakonec můžete okna mimo skupinu přesunout dovnitř pomocí `Super + Alt + Arrows`.

### Vysouvání oken

Okno můžete vysunout z jeho přiřazení k pracovní ploše pomocí `Super + O`. Tím ho připnete jako plovoucí okno, které vás následuje na jakoukoli pracovní plochu, kam jdete. Skvělé pro přehrávače videa a podobné.

 ![navigation-popped-window](images/navigation-popped-window.webp)

### Pracovní plocha scratchpad

Nakonec existuje speciální pracovní plocha scratchpad, která se vysune přes jakoukoli pracovní plochu, na které právě jste, podobně jako konzole ve hře Quake. Přepínejte ji pomocí `Super + Grave` nebo `Super + S` a okno tam umístěte pomocí `Super + Shift + Grave` nebo `Super + Alt + S`.

Funguje obzvlášť dobře pro terminál, ve kterém běží agent, nebo pro ovládací prvky, se kterými chcete rychle interagovat, aniž byste opustili aktuální pracovní plochu. Chcete-li okno přesunout ze scratchpadu, pošlete ho přímo na jinou pracovní plochu například pomocí `Super + Shift + 1`.

Zatímco scratchpad drží jediné okno, vysune se jako vycentrovaný panel namísto rozprostření přes obrazovku. Dejte na něj druhou aplikaci a vrátí se na plnou šířku, takže ty dvě mají místo sedět vedle sebe.

### Chce to trochu zvyku!

Chvíli trvá, než si zvyknete na navigaci po ploše tímto způsobem, ale jakmile si zvyknete, bude těžké vrátit se k tradičnímu zážitku z plochy ovládané myší!
