# Leiðsögn

Allt í Omarchy gerist með lyklaborðinu — _ALLT!_ Þegar kerfið ræsist fyrst geturðu bókstaflega ekki gert neitt með músinni einni. En þú getur ýtt á `Super + Space` til að birta Omarchy-valmyndina og héðan geturðu gert nánast allt.

En Omarchy-valmyndin er ekki einu sinni ætluð til að vera aðalleiðin til að stjórna kerfinu mestan hluta tímans. Við getum gert betur en það! Öll mikilvægustu forritin eru tengd beint við einstaka flýtilykla. Þú ræsir terminal með `Super + Return` og vafra með `Super + Shift + Return`. Prófaðu að gera annað á eftir hinu og þú sérð töfra flísalagnar Hyprland í verki:

 ![navigation-browser-terminal](images/navigation-browser-terminal.webp)

Þú getur síðan ýtt á `Super + J` til að stafla þeim ofan á hvort annað í stað hlið við hlið:

 ![navigation-stacked](images/navigation-stacked.webp)

Ýttu á `Super + J` aftur til að færa þau aftur í hlið við hlið stöðuna. Prófaðu síðan `Super + Shift + Arrow Right` á meðan þú ert í vafranum til að skipta á gluggunum.

Prófaðu nú `Super + Ctrl + T` til að ræsa virkniskjáinn (Activity). Hann birtist sem fljótandi gluggi. Þú getur flísalagt hann með `Super + T` (og ýtt á það aftur til að gera hann fljótandi aftur). Ýttu nú á `Super + Shift + F` til að opna skráastjórann. Þú færð snyrtilega fjórskipta uppsetningu:

 ![navigation-fourway-tiling](images/navigation-fourway-tiling.webp)

Þú færir þig á milli gluggans sem þú vilt hafa virkan með `Super + Arrow`. Þetta skiptir um fókus og færir bendilinn í miðju nýja forritsins.

Ef þú ýtir á `Super + Shift + 2` færirðu núverandi virka forritið yfir á annað vinnusvæðið. `Super + Shift + 1` færir það til baka. (Og `Super + Shift + Alt + 2` flytur núverandi virka forritið yfir á annað vinnusvæðið án þess að skipta yfir á það).

Ef þú heldur `Super` inni og notar músina til að smella á glugga geturðu endurraðað honum. Ef þú heldur `Super` inni og notar hægri músarhnappinn geturðu breytt stærð gluggans frjálst.

Þú lokar glugga með `Super + W` eða `Super + Q` (og lokar öllum gluggum með `Ctrl + Alt + Delete`).

Þú getur líka farið í fullan skjá með `Super + F` eða jafnvel bara í fulla breidd (og haldið valmyndastikunni) með `Super + Alt + F` eða fullan skjá innan glugga með `Super + Ctrl + F` (gott fyrir YouTube!).

### Dwindle á móti skrunskipulagi

Sjálfgefið skipulag Omarchy kallast dwindle. Það heldur öllum gluggum sem þú opnar á einu vinnusvæði sýnilegum alltaf, jafnvel þótt það þurfi að minnka þá.

 ![navigation-dwindle-layout](images/navigation-dwindle-layout.webp)

En þú getur líka valið að breyta vinnusvæði í skrunskipulag þar sem gluggar eru raðaðir hlið við hlið, út fyrir sýnilegan jaðar skjásins. Þú breytir einu vinnusvæði í þetta skipulag með `Super + L`.

Að ýta á `Super + L` aftur gerir vinnusvæðið fljótandi, þar sem gluggar skarast frjálst og þú staðsetur þá sjálfur, og þriðja ýtingin skilar því í dwindle. `Super + Alt + L` fer í gegnum þau í hina áttina. Gluggi sem flýtur hvort sem er — einn sem þú tókst út með `Super + T`, eða forrit sem opnast alltaf fljótandi — heldur áfram að fljóta þegar vinnusvæðið fer aftur í flísalögn. Valmyndastikan merkir vinnusvæðið sem þú ert á með skipulagi þess: ferningur fyrir dwindle, hringur fyrir skrunun og þríhyrningur fyrir fljótandi. Að smella á það merki skiptir líka um skipulag.

 ![navigation-scrolling-layout](images/navigation-scrolling-layout.webp)

Valið gildir fyrir hvert vinnusvæði og það situr eftir. Svo þú getur haldið vinnusvæði 1 í dwindle fyrir vafra og vinnusvæði 2 í skrunun fyrir kóða, og þau koma þannig til baka eftir endurræsingu.

Ef þú vilt nota skrunskipulagið sem sjálfgefið geturðu stillt það í `~/.config/hypr/looknfeel.lua`:

```lua
hl.config({
  general = {
    layout = "scrolling",
  },
})
```

### Fljótandi vinnusvæði

Fljótandi vinnusvæði virkar eins og hefðbundið skjáborð: gluggar skarast og þú færir þá til og breytir stærð þeirra sjálfur. Hver gluggi fær titilstiku í litum þemans þíns, með hnöppum til að lágmarka, hámarka og loka. `Super + M` lágmarkar líka virka gluggann. Lágmarkaður gluggi bíður í dockinu; smelltu á forritið hans til að ná honum til baka. Smelltu á glugga til að færa hann fram. Breyttu stærð hans frá hvaða jaðri eða horni sem er. Tvísmelltu á titilstiku til að hámarka gluggann á meðan valmyndastikan er enn sýnileg, og aftur til að fá gömlu stærðina til baka.

Fljótandi vinnusvæði sýnir einnig dock, með föstum forritunum þínum, öllu sem er í gangi og neti allra forrita á bak við forritahnappinn, sem `Super + Alt + Space` og _Forrit_ í Omarchy-valmyndinni opna líka. Hægrismelltu á forrit á netinu, eða ýttu á `Delete`, til að fjarlægja það. Smelltu á forrit til að opna það eða til að færa gluggann þess fram; smelltu aftur til að fara í gegnum glugga þess. Miðjusmellur opnar nýjan glugga. Dragðu tákn eftir dockinu til að færa það; að draga forrit í gangi inn á milli hinna heldur því þar. Hægrismelltu til að halda forriti í dockinu, taka það út eða hætta í því. Dockið víkur undan glugga í fullum skjá. Hægrismelltu á forritahnappinn til að færa dockið á annan jaðar eða láta það felast þar til bendillinn nær að jaðrinum þess. Staðsetningin er einnig undir _Kveikja > Útlit > Dock > Staðsetning docks_, og `omarchy dock position left` og `omarchy dock autohide on` stilla bæði úr terminal. Forrit sem þú heldur í dockinu eru dauf á meðan þau eru ekki í gangi.

Ný vinnusvæði, og þau sem þú hefur ekki gefið eigið skipulag með `Super + L`, nota sjálfgefna skipulagið. Að breyta sjálfgefna gildinu endurstillir öll vinnusvæði án glugga á það, á meðan vinnusvæði með glugga á sér heldur skipulaginu sem það hefur. Veldu það undir _Kveikja > Útlit > Vinnusvæðaskipun_: Flísalögn, Skrunun eða Fljótandi. `omarchy-hyprland-workspace-layout-default scrolling` stillir það úr terminal.

### Að hópa glugga

Hægt er að hópa glugga með `Super + G`. Þegar þú ert kominn í hóp mun hver gluggi sem þú ræsir á meðan það er virkt tilheyra hópnum. Þú getur fært þig á milli þessara hópuðu glugga með `Super + Ctrl + Arrow Left/Right` eða `Super + Alt + 1/2/3/4` til að fara beint á hópaðan glugga í röð.

Þú getur fært glugga út úr hópnum með `Super + Alt + G` eða leyst allan hópinn upp með því að ýta á `Super + G` aftur. Loks geturðu fært glugga utan hópsins inn í hann með `Super + Alt + Arrows`.

### Að taka glugga út

Þú getur tekið glugga út úr vinnusvæðisúthlutun hans með `Super + O`. Það festir hann sem fljótandi glugga sem fylgir þér á hvaða vinnusvæði sem þú ferð á. Frábært fyrir myndbandsspilara og þess háttar.

 ![navigation-popped-window](images/navigation-popped-window.webp)

### Kladdevinnusvæði

Loks er til sérstakt kladdevinnusvæði (scratchpad) sem fellur niður yfir það vinnusvæði sem þú ert á, svipað og Quake-stjórnborð. Víxlaðu því með `Super + Grave` eða `Super + S`, og settu glugga þangað með `Super + Shift + Grave` eða `Super + Alt + S`.

Það virkar sérstaklega vel fyrir terminal sem keyrir agent, eða fyrir stjórntæki sem þú vilt eiga fljótt við án þess að yfirgefa núverandi vinnusvæði. Til að færa glugga af kladdanum skaltu senda hann beint á annað vinnusvæði með einhverju eins og `Super + Shift + 1`.

Á meðan kladdinn geymir einn glugga fellur hann niður sem miðjustillt spjald í stað þess að spanna skjáinn. Settu annað forrit á hann og hann fer aftur í fulla breidd, svo þau tvö hafi pláss til að sitja hlið við hlið.

### Þetta tekur smá tíma að venjast!

Það tekur dálítinn tíma að venjast því að fletta skjáborðinu svona, en þegar þú gerir það verður erfitt að fara aftur í hefðbundna músarstýrða skjáborðsupplifun!
