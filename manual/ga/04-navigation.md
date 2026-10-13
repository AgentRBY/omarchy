# Nascleanúint

Tarlaíonn gach rud in Omarchy tríd an méarchlár — _GACH RUD!_ Nuair a thosaíonn an córas ar dtús, ní féidir leat rud ar bith a dhéanamh leis an luch amháin go litriúil. Ach is féidir leat `Super + Space` a bhualadh chun Roghchlár Omarchy a nochtadh agus as seo is féidir leat beagnach gach rud a dhéanamh.

Ach ní fiú go bhfuil roghchlár Omarchy ceaptha a bheith ina phríomhshlí chun an córas a oibriú an chuid is mó den am. Is féidir linn a bheith níos tapúla ná sin! Tá na feidhmchláir is tábhachtaí ar fad ceangailte go díreach le heochracha gasta aonair. Tosaíonn tú an teirminéal le `Super + Return` agus brabhsálaí le `Super + Shift + Return`. Bain triail as ceann a dhéanamh i ndiaidh a chéile, agus feicfidh tú draíocht thíliú Hyprland i mbun gnímh:

 ![navigation-browser-terminal](images/navigation-browser-terminal.webp)

Is féidir leat `Super + J` a bhualadh ansin chun iad a chruachadh ar bharr a chéile in ionad taobh le taobh:

 ![navigation-stacked](images/navigation-stacked.webp)

Buail `Super + J` arís chun iad a chur ar ais ina suíomhanna taobh le taobh. Ansin bain triail as `Super + Shift + Arrow Right` agus tú ar an mbrabhsálaí chun na fuinneoga a mhalartú.

Anois bain triail as `Super + Ctrl + T` chun monatóir Gníomhaíochta a thosú. Beidh sé sin le feiceáil mar fhuinneog ar foluain. Is féidir leat é a thíliú le `Super + T` (agus é sin a bhualadh arís chun é a dhéanamh ar foluain arís). Anois brúigh `Super + Shift + F` chun bainisteoir na gcomhad a oscailt. Beidh socrú néata ceithre-bhealach agat:

 ![navigation-fourway-tiling](images/navigation-fourway-tiling.webp)

Nascleanann tú idir an fhuinneog ar mhaith leat a bheith gníomhach le `Super + Arrow`. Athróidh sé seo an fócas agus bogfaidh sé an cúrsóir go lár an fheidhmchláir nua.

Má bhuaileann tú `Super + Shift + 2`, bogfaidh tú an feidhmchlár dírithe reatha chuig an dara spás oibre. Bogann `Super + Shift + 1` ar ais é. (Agus bogfaidh `Super + Shift + Alt + 2` an feidhmchlár dírithe reatha chuig an dara spás oibre gan athrú chuige).

Má choinníonn tú `Super` síos agus má úsáideann tú an luch chun cliceáil ar fhuinneog, beidh tú in ann athshocrú a dhéanamh ar an áit a suíonn sí. Má choinníonn tú `Super` agus má úsáideann tú cnaipe deas na luiche, is féidir leat an fhuinneog a athrú méid go saor.

Dúnann tú fuinneog ar `Super + W` nó `Super + Q` (agus dúnann tú gach fuinneog ar `Ctrl + Alt + Delete`).

Is féidir leat dul go lánscáileán le `Super + F` nó fiú díreach lánleithead (an barra barr á choinneáil) le `Super + Alt + F` nó lánscáileán laistigh d'fhuinneog le `Super + Ctrl + F` (go maith do YouTube!).

### Leagan amach dwindle vs scrollaithe

Tugtar dwindle ar leagan amach réamhshocraithe Omarchy. Coinníonn sé na fuinneoga uile a osclaíonn tú ar spás oibre amháin le feiceáil i gcónaí, fiú má chaithfidh sé iad a chrapadh síos.

 ![navigation-dwindle-layout](images/navigation-dwindle-layout.webp)

Ach is féidir leat a roghnú freisin spás oibre a iompú ina leagan amach scrollaithe ina bhfuil fuinneoga ar líne taobh le taobh, thar imeall infheicthe an taispeántais. Iompaíonn tú spás oibre amháin isteach sa leagan amach seo trí `Super + L`.

Iompaíonn brú `Super + L` arís an spás oibre ar foluain, áit a bhforluíonn fuinneoga go saor agus a gcuireann tú féin iad, agus cuireann an tríú brú ar ais go dwindle é. Téann `Super + Alt + L` tríothu an tslí eile. Coinníonn fuinneog a shnámhann ar aon nós — ceann a phreab tú amach le `Super + T`, nó aip a osclaíonn ar foluain i gcónaí — ar foluain nuair a théann an spás oibre ar ais go tíliú. Marcálann an barra barr an spás oibre a bhfuil tú air lena leagan amach: cearnóg do dwindle, ciorcal do scrollú, agus triantán do foluain. Timthriallann cliceáil ar an marc sin an leagan amach freisin.

 ![navigation-scrolling-layout](images/navigation-scrolling-layout.webp)

Is in aghaidh an spáis oibre an rogha, agus fanann sí. Mar sin is féidir leat spás oibre 1 a choinneáil ar dwindle don bhrabhsáil agus spás oibre 2 ar scrollú do chód, agus tiocfaidh siad ar ais mar sin tar éis atosaithe.

Más mian leat an leagan amach scrollaithe a úsáid mar an réamhshocrú, is féidir leat é sin a shocrú i `~/.config/hypr/looknfeel.lua`:

```lua
hl.config({
  general = {
    layout = "scrolling",
  },
})
```

### Spásanna oibre ar foluain

Oibríonn spás oibre ar foluain cosúil le deasc traidisiúnta: forluíonn fuinneoga, agus bogann agus méadaíonn tú féin iad. Faigheann gach fuinneog barra teidil i ndathanna do théama, le cnaipí chun íoslaghdú, uasmhéadú, agus dúnadh. Íoslaghdaíonn `Super + M` an fhuinneog dhírithe freisin. Fanann fuinneog íoslaghdaithe sa duga; cliceáil a haip chun í a thabhairt ar ais. Cliceáil fuinneog chun í a thabhairt chun tosaigh. Athraigh a méid ó aon imeall nó cúinne. Díchliceáil barra teidil chun an fhuinneog a uasmhéadú agus an barra barr á choinneáil i radharc, agus arís chun a seanmhéid a fháil ar ais.

Taispeánann spás oibre ar foluain duga freisin, le d'aipeanna greamaithe, gach rud atá ag rith, agus greille de gach aip taobh thiar de chnaipe na n-aipeanna, a osclaíonn `Super + Alt + Space` agus _Aipeanna_ i roghchlár Omarchy freisin. Cliceáil ar dheis ar aip ar an ngreille, nó brúigh `Delete`, chun í a dhíshuiteáil. Cliceáil aip chun í a oscailt, nó chun a fuinneog a thabhairt chun tosaigh; cliceáil arís chun timthriall trína fuinneoga. Osclaíonn cliceáil lár fuinneog nua. Tarraing deilbhín feadh an duga chun é a bhogadh; coinníonn tarraingt aip atá ag rith isteach i measc na cinn eile ann í. Cliceáil ar dheis chun aip a choinneáil sa duga, í a thógáil amach, nó scor di. Éiríonn an duga as an mbealach d'fhuinneog lánscáileáin. Cliceáil ar dheis ar chnaipe na n-aipeanna chun an duga a bhogadh go himeall eile nó chun é a chur i bhfolach go dtí go sroicheann an pointeoir a imeall. Tá an suíomh faoi _Spreag > Cuma > Duga > Suíomh Duga_ freisin, agus socraíonn `omarchy dock position left` agus `omarchy dock autohide on` an dá cheann ó theirminéal. Tá aipeanna a choinníonn tú sa duga maolaithe fad is nach bhfuil siad ag rith.

Úsáideann spásanna oibre nua, agus aon cheann nár thug tú leagan amach dá chuid féin dó le `Super + L`, an leagan amach réamhshocraithe. Athshocraíonn athrú an réamhshocraithe gach spás oibre gan fhuinneoga chuige, fad is a choinníonn ceann le fuinneoga air an leagan amach atá aige. Roghnaigh é faoi _Spreag > Cuma > Leagan Amach Oibre_: Tíliú, Scrollú, nó Foluaineach. Socraíonn `omarchy-hyprland-workspace-layout-default scrolling` é ó theirminéal.

### Fuinneoga a ghrúpáil

Is féidir fuinneoga a ghrúpáil le `Super + G`. Nuair a bhíonn tú i ngrúpa, beidh gach fuinneog a thosaíonn tú fad is atá sé sin gníomhach ina ball den ghrúpa. Is féidir leat bogadh idir na fuinneoga grúpáilte seo le `Super + Ctrl + Arrow Left/Right` nó `Super + Alt + 1/2/3/4` chun dul go díreach chuig fuinneog ghrúpáilte in ord.

Is féidir leat fuinneog a bhogadh amach as an ngrúpáil le `Super + Alt + G` nó an grúpa ar fad a dhíchóimeáil trí `Super + G` a bhualadh arís. Ar deireadh, is féidir leat fuinneoga lasmuigh den ghrúpa a bhogadh isteach ann le `Super + Alt + Arrows`.

### Fuinneoga a phreabadh

Is féidir leat fuinneog a phreabadh amach as a leithdháileadh spáis oibre le `Super + O`. Greamóidh sé sin í mar fhuinneog ar foluain a leanann tú ar cibé spás oibre a théann tú chuige. Iontach do sheinnteoirí físe agus a leithéid.

 ![navigation-popped-window](images/navigation-popped-window.webp)

### Spás oibre scratchpad

Ar deireadh, tá spás oibre scratchpad speisialta ann a thiteann anuas thar cibé spás oibre a bhfuil tú air faoi láthair, cosúil go mór le consól Quake. Scoránaigh é le `Super + Grave` nó `Super + S`, agus cuir fuinneog ann le `Super + Shift + Grave` nó `Super + Alt + S`.

Oibríonn sé go háirithe go maith do theirminéal atá ag rith gníomhaire, nó do rialuithe ar mhaith leat idirghníomhú leo go tapa gan an spás oibre reatha a fhágáil. Chun fuinneog a bhogadh den scratchpad, seol go díreach chuig spás oibre eile í le rud éigin cosúil le `Super + Shift + 1`.

Fad is a bhíonn fuinneog amháin sa scratchpad, titeann sé anuas mar phainéal láraithe seachas an scáileán a shíneadh. Cuir an dara aip air agus téann sé ar ais go dtí an leithead iomlán, mar sin tá seomra ag an mbeirt suí taobh le taobh.

### Tógann sé tamall dul i dtaithí air!

Tógann sé tamall beag dul i dtaithí ar do dheasc a nascleanúint mar seo, ach nuair a dhéanann tú, beidh sé deacair dul ar ais go heispéireas deisce traidisiúnta faoi thiomáint luiche!
