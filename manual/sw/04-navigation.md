# Urambazaji

Kila kitu katika Omarchy hufanyika kupitia kibodi — _KILA KITU!_ Mfumo ukianza mara ya kwanza, kwa kweli huwezi kufanya jambo lolote kwa kipanya pekee. Lakini unaweza kubonyeza `Super + Space` kufungua Menyu ya Omarchy na kutoka hapa unaweza kufanya karibu kila kitu.

Lakini menyu ya Omarchy haikukusudiwa hata kuwa njia kuu ya kuendesha mfumo mara nyingi. Tunaweza kuwa na kasi zaidi ya hiyo! Programu zote muhimu zaidi zimefungwa moja kwa moja kwenye mikato ya vitufe moja moja. Unaanzisha terminali kwa `Super + Return` na kivinjari kwa `Super + Shift + Return`. Jaribu kufanya moja baada ya jingine, na utaona uchawi wa vigae vya Hyprland vikifanya kazi:

 ![navigation-browser-terminal](images/navigation-browser-terminal.webp)

Kisha unaweza kubonyeza `Super + J` kuziweka moja juu ya nyingine badala ya kando kwa kando:

 ![navigation-stacked](images/navigation-stacked.webp)

Bonyeza `Super + J` tena kuzirudisha kwenye nafasi zao za kando kwa kando. Kisha jaribu `Super + Shift + Arrow Right` ukiwa kwenye kivinjari kubadilishana madirisha.

Sasa jaribu `Super + Ctrl + T` kuanzisha kiangaliaji cha Activity. Hiyo itaonekana kama dirisha linaloelea. Unaweza kuliweka kwenye vigae ukitumia `Super + T` (na kubonyeza hiyo tena kulifanya lielee tena). Sasa bonyeza `Super + Shift + F` kufungua kidhibiti cha faili. Utakuwa na mpangilio mzuri wa njia nne:

 ![navigation-fourway-tiling](images/navigation-fourway-tiling.webp)

Unasogeza kati ya dirisha unalotaka liwe linalotumika kwa `Super + Arrow`. Hii itabadilisha mzingatio na kusogeza kishale hadi katikati ya programu mpya.

Ukibonyeza `Super + Shift + 2`, utahamisha programu iliyozingatiwa sasa hadi nafasi ya pili ya kazi. `Super + Shift + 1` huirudisha. (Na `Super + Shift + Alt + 2` itahamisha programu iliyozingatiwa sasa hadi nafasi ya pili ya kazi bila kubadili kwenda huko).

Ukishikilia `Super` na kutumia kipanya kubofya dirisha, utaweza kupanga upya mahali lilipo. Ukishikilia `Super` na kutumia kitufe cha kulia cha kipanya, unaweza kubadilisha ukubwa wa dirisha kwa uhuru.

Unafunga dirisha kwa `Super + W` au `Super + Q` (na kufunga madirisha yote kwa `Ctrl + Alt + Delete`).

Unaweza pia kwenda skrini kamili kwa `Super + F` au hata upana kamili tu (ukiweka upau wa juu) kwa `Super + Alt + F` au skrini kamili ndani ya dirisha kwa `Super + Ctrl + F` (nzuri kwa YouTube!).

### Mpangilio wa dwindle dhidi ya kusogeza

Mpangilio chaguomsingi wa Omarchy unaitwa dwindle. Huweka madirisha yote unayofungua kwenye nafasi moja ya kazi yaonekane wakati wote, hata kama lazima yapunguzwe ukubwa.

 ![navigation-dwindle-layout](images/navigation-dwindle-layout.webp)

Lakini unaweza pia kuchagua kubadilisha nafasi ya kazi kuwa mpangilio wa kusogeza ambapo madirisha yamepangwa kando kwa kando, zaidi ya ukingo unaoonekana wa skrini. Unabadilisha nafasi moja ya kazi kuwa mpangilio huu kupitia `Super + L`.

Kubonyeza `Super + L` tena huifanya nafasi ya kazi ielee, ambapo madirisha huingiana kwa uhuru na wewe mwenyewe unayaweka, na kubonyeza kwa tatu huirudisha kwenye dwindle. `Super + Alt + L` hupitia kwa njia nyingine. Dirisha linaloelea hata hivyo — moja ulilotoa kwa `Super + T`, au programu ambayo daima hufunguka ikielea — hubaki likielea nafasi ya kazi irudipo kwenye vigae. Upau wa juu hutia alama nafasi ya kazi uliyoipata na mpangilio wake: mraba kwa dwindle, duara kwa kusogeza, na pembetatu kwa kuelea. Kubofya alama hiyo hubadilisha mpangilio pia.

 ![navigation-scrolling-layout](images/navigation-scrolling-layout.webp)

Chaguo ni kwa kila nafasi ya kazi, na hudumu. Kwa hiyo unaweza kuweka nafasi ya kazi 1 kwenye dwindle kwa kuvinjari na nafasi ya kazi 2 kwenye kusogeza kwa msimbo, na zitarudi hivyo baada ya kuwasha upya.

Ikiwa unataka kutumia mpangilio wa kusogeza kama chaguomsingi, unaweza kuuweka katika `~/.config/hypr/looknfeel.lua`:

```lua
hl.config({
  general = {
    layout = "scrolling",
  },
})
```

### Nafasi za kazi zinazoelea

Nafasi ya kazi inayoelea hufanya kazi kama eneo-kazi la jadi: madirisha huingiana, na wewe unayasogeza na kuyaweka ukubwa mwenyewe. Kila dirisha hupata upau wa kichwa katika rangi za mandhari yako, na vitufe vya kupunguza, kupanua, na kufunga. `Super + M` hupunguza dirisha lililozingatiwa pia. Dirisha lililopunguzwa hungoja katika dock; bofya programu yake kulirejesha. Bofya dirisha kulileta mbele. Badilisha ukubwa wake kutoka ukingo au kona yoyote. Bofya mara mbili upau wa kichwa kupanua dirisha huku ukiweka upau wa juu uonekane, na tena kurudisha ukubwa wake wa awali.

Nafasi ya kazi inayoelea pia huonyesha dock, na programu zako zilizobanwa, kila kinachoendeshwa, na gridi ya kila programu nyuma ya kitufe cha programu, ambayo `Super + Alt + Space` na _Programu_ katika menyu ya Omarchy hufungua pia. Bofya kulia programu kwenye gridi, au bonyeza `Delete`, kuisanidua. Bofya programu kuifungua, au kuleta dirisha lake mbele; bofya tena kupitia madirisha yake. Kubofya katikati hufungua dirisha jipya. Buruta aikoni kwenye dock kuisogeza; kuburuta programu inayoendeshwa kati ya nyingine huiweka hapo. Bofya kulia kuweka programu katika dock, kuitoa, au kuiacha. Dock huondoka njia ya dirisha la skrini kamili. Bofya kulia kitufe cha programu kusogeza dock hadi ukingo mwingine au kuifanya ifichike hadi kishale kifike ukingoni mwake. Nafasi iko pia chini ya _Anzisha > Muonekano > Dock > Nafasi ya Dock_, na `omarchy dock position left` na `omarchy dock autohide on` huweka zote mbili kutoka terminali. Programu unazoziweka katika dock hazionekani vyema wakati haziendeshwi.

Nafasi mpya za kazi, na yoyote ambayo hujaipa mpangilio wake mwenyewe kwa `Super + L`, hutumia mpangilio chaguomsingi. Kubadilisha chaguomsingi huweka upya kila nafasi ya kazi isiyo na madirisha kwake, ilhali yenye madirisha hubaki na mpangilio wake. Ichague chini ya _Anzisha > Muonekano > Mpangilio wa Nafasi ya Kazi_: Vigae, Kusogeza, au Kuelea. `omarchy-hyprland-workspace-layout-default scrolling` huiweka kutoka terminali.

### Kuweka madirisha katika vikundi

Madirisha yanaweza kuwekwa katika vikundi ukitumia `Super + G`. Ukiwa katika kundi, kila dirisha unaloanzisha hali hiyo ikiwa inatumika litakuwa la kundi. Unaweza kusogeza kati ya madirisha haya ya kundi ukitumia `Super + Ctrl + Arrow Left/Right` au `Super + Alt + 1/2/3/4` kwenda moja kwa moja kwenye dirisha la kundi kwa mpangilio.

Unaweza kusogeza dirisha kutoka kwenye kundi kwa `Super + Alt + G` au kuvunja kundi lote kwa kubonyeza `Super + G` tena. Mwishowe, unaweza kusogeza madirisha ya nje ya kundi kuingia ndani kwa `Super + Alt + Arrows`.

### Kutoa madirisha

Unaweza kutoa dirisha kutoka mgawo wake wa nafasi ya kazi kwa `Super + O`. Hiyo itabanwa kama dirisha linaloelea linalokufuata popote unapoenda kwenye nafasi ya kazi. Nzuri kwa vicheza video na kadhalika.

 ![navigation-popped-window](images/navigation-popped-window.webp)

### Nafasi ya kazi ya scratchpad

Mwishowe, kuna nafasi maalumu ya kazi ya scratchpad inayoshuka juu ya nafasi yoyote ya kazi uliyopo kwa sasa, kama konsoli ya Quake. Ibadihe kwa `Super + Grave` au `Super + S`, na kuweka dirisha huko ukitumia `Super + Shift + Grave` au `Super + Alt + S`.

Inafanya kazi vizuri hasa kwa terminali inayoendesha ajenti, au kwa vidhibiti unavyotaka kuingiliana navyo haraka bila kuondoka nafasi ya kazi ya sasa. Kusogeza dirisha kutoka scratchpad, litume moja kwa moja hadi nafasi nyingine ya kazi kwa kitu kama `Super + Shift + 1`.

Wakati scratchpad ina dirisha moja, hushuka kama paneli iliyowekwa katikati badala ya kutanda skrini. Weka programu ya pili juu yake na hurudi kwenye upana kamili, ili hizo mbili zipate nafasi ya kukaa kando kwa kando.

### Inahitaji kuzoea kidogo!

Inachukua muda kidogo kuzoea kusogeza eneo-kazi lako kama hivi, lakini ukizoea, itakuwa vigumu kurudi kwenye uzoefu wa kitamaduni wa eneo-kazi unaoendeshwa na kipanya!
