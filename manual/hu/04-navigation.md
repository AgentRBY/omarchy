# Navigáció

Az Omarchyban minden a billentyűzeten keresztül történik — _MINDEN!_ Amikor a rendszer először elindul, szó szerint semmit sem tudsz kezdeni egyedül az egérrel. De megnyomhatod a `Super + Space` kombinációt, hogy előhívd az Omarchy menüt, és innen szinte mindent meg tudsz csinálni.

Az Omarchy menü azonban a legtöbbször még csak nem is a rendszer kezelésének fő módjának készült. Annál is gyorsabbak tudunk lenni! Minden legfontosabb alkalmazás közvetlenül egyes billentyűparancsokhoz van kötve. A terminált a `Super + Return`, a böngészőt a `Super + Shift + Return` kombinációval indítod. Próbáld meg őket egymás után, és meglátod a Hyprland csempézésének varázsát működés közben:

 ![navigation-browser-terminal](images/navigation-browser-terminal.webp)

Ezután megnyomhatod a `Super + J` kombinációt, hogy egymásra rakd őket ahelyett, hogy egymás mellett lennének:

 ![navigation-stacked](images/navigation-stacked.webp)

Nyomd meg újra a `Super + J` kombinációt, hogy visszakerüljenek az egymás melletti helyükre. Ezután próbáld ki a `Super + Shift + Arrow Right` kombinációt a böngészőn állva, hogy felcseréld az ablakokat.

Most próbáld ki a `Super + Ctrl + T` kombinációt az Activity monitor elindításához. Ez lebegő ablakként jelenik meg. A `Super + T` kombinációval becsempézheted (és újra megnyomva ismét lebegővé teszed). Most nyomd meg a `Super + Shift + F` kombinációt a fájlkezelő megnyitásához. Egy csinos négyes elrendezésed lesz:

 ![navigation-fourway-tiling](images/navigation-fourway-tiling.webp)

A `Super + Arrow` kombinációval navigálsz az aktív ablakok között. Ez átviszi a fókuszt, és a kurzort az új alkalmazás közepére mozgatja.

Ha megnyomod a `Super + Shift + 2` kombinációt, az aktuálisan fókuszált alkalmazást a második munkaterületre mozgatod. A `Super + Shift + 1` visszaviszi. (A `Super + Shift + Alt + 2` pedig az aktuálisan fókuszált alkalmazást a második munkaterületre mozgatja anélkül, hogy átváltana rá).

Ha lenyomva tartod a `Super` billentyűt, és az egérrel egy ablakra kattintasz, átrendezheted, hol helyezkedjen el. Ha lenyomva tartod a `Super` billentyűt, és az egér jobb gombját használod, szabadon átméretezheted az ablakot.

Egy ablakot a `Super + W` vagy a `Super + Q` kombinációval zársz be (és minden ablakot a `Ctrl + Alt + Delete` kombinációval).

Teljes képernyősre is válthatsz a `Super + F`, vagy akár csak teljes szélességűre (a felső sávot megtartva) a `Super + Alt + F` kombinációval, vagy ablakon belüli teljes képernyősre a `Super + Ctrl + F` kombinációval (jó a YouTube-hoz!).

### Dwindle vs scrolling kiosztás

Az Omarchy alapértelmezett kiosztását dwindle-nek hívják. Mindig láthatóan tartja az összes ablakot, amelyet egy munkaterületen megnyitsz, még akkor is, ha össze kell őket zsugorítania.

 ![navigation-dwindle-layout](images/navigation-dwindle-layout.webp)

De azt is választhatod, hogy egy munkaterületet scrolling kiosztásra kapcsolsz, ahol az ablakok egymás mellett sorakoznak, a kijelző látható szélén túl. Egy munkaterületet a `Super + L` kombinációval kapcsolsz erre a kiosztásra.

A `Super + L` újabb megnyomása lebegővé teszi a munkaterületet, ahol az ablakok szabadon fedik egymást, és te magad helyezi el őket, egy harmadik megnyomás pedig visszahozza a dwindle-re. A `Super + Alt + L` a másik irányba megy át rajtuk. Egy ablak, amely amúgy is lebeg — egy, amelyet a `Super + T` kombinációval pattintottál ki, vagy egy app, amely mindig lebegően nyílik meg — lebegve marad, amikor a munkaterület visszatér a csempézéshez. A felső sáv a munkaterület kiosztásával jelöli azt a munkaterületet, amelyiken vagy: négyzet a dwindle-höz, kör a scrollinghoz és háromszög a lebegőhöz. A jelre kattintás is váltja a kiosztást.

 ![navigation-scrolling-layout](images/navigation-scrolling-layout.webp)

A választás munkaterületenkénti, és megmarad. Így tarthatod az 1. munkaterületet dwindle-ön böngészéshez és a 2. munkaterületet scrollingon kódoláshoz, és újraindítás után is így térnek vissza.

Ha a scrolling kiosztást szeretnéd alapértelmezettként használni, azt a `~/.config/hypr/looknfeel.lua` fájlban állíthatod be:

```lua
hl.config({
  general = {
    layout = "scrolling",
  },
})
```

### Lebegő munkaterületek

Egy lebegő munkaterület úgy működik, mint egy hagyományos asztal: az ablakok fedik egymást, és te magad mozgatod és méretezed őket. Minden ablak címsort kap a témád színeivel, gombokkal a minimalizáláshoz, maximalizáláshoz és bezáráshoz. A `Super + M` a fókuszált ablakot is minimalizálja. Egy minimalizált ablak a dokkban várakozik; kattints az appjára a visszahozásához. Kattints egy ablakra, hogy előtérbe hozd. Méretezd át bármelyik széléről vagy sarkából. Kattints duplán egy címsorra, hogy maximalizáld az ablakot úgy, hogy a felső sáv látható maradjon, és ismét, hogy visszakapd a régi méretét.

Egy lebegő munkaterület dokkot is mutat, a rögzített appjaiddal, minden futó alkalmazással, és az appok gombja mögött minden app rácsával, amelyet a `Super + Alt + Space` és az Omarchy menüben az _Appok_ is megnyit. Kattints jobb gombbal egy appra a rácson, vagy nyomd meg a `Delete` billentyűt az eltávolításához. Kattints egy appra a megnyitásához, vagy hogy az ablakát előtérbe hozd; kattints ismét, hogy végiglépegess az ablakain. A középső kattintás új ablakot nyit. Húzz egy ikont a dokkon a mozgatásához; egy futó app behúzása a többiek közé ott tartja. Kattints jobb gombbal, hogy egy appot a dokkban tarts, kivegyél onnan, vagy kilépj belőle. A dokk utat enged egy teljes képernyős ablaknak. Kattints jobb gombbal az appok gombjára, hogy a dokkot egy másik szélre mozdítsd, vagy elrejtesd, amíg a mutató el nem éri a szélét. A pozíció a _Trigger > Appearance > Dock > Dock Position_ alatt is ott van, és az `omarchy dock position left` és az `omarchy dock autohide on` mindkettőt beállítja terminálból. Az appok, amelyeket a dokkban tartasz, elhalványulnak, amíg nem futnak.

Az új munkaterületek és azok, amelyeknek nem adtál saját kiosztást a `Super + L` kombinációval, az alapértelmezett kiosztást használják. Az alapértelmezett módosítása minden ablak nélküli munkaterületet erre állít vissza, míg egy ablakokkal ellátott megtartja a kiosztását. Válaszd ki a _Trigger > Appearance > Workspace Layout_ alatt: Tiling, Scrolling vagy Floating. Az `omarchy-hyprland-workspace-layout-default scrolling` terminálból állítja be.

### Ablakok csoportosítása

Az ablakok a `Super + G` kombinációval csoportosíthatók. Ha egy csoportba kerültél, minden ablak, amelyet aktív állapotában indítasz, a csoporthoz fog tartozni. A csoportosított ablakok között a `Super + Ctrl + Arrow Left/Right` kombinációval mozoghatsz, vagy a `Super + Alt + 1/2/3/4` kombinációval egyenesen a csoportosított ablakhoz ugorhatsz sorrendben.

Egy ablakot a `Super + Alt + G` kombinációval vehetsz ki a csoportosításból, vagy a `Super + G` ismételt megnyomásával a teljes csoportot szétbonthatod. Végül a csoporton kívüli ablakokat a `Super + Alt + Arrows` kombinációval mozgathatod be a csoportba.

### Ablakok kipattintása

A `Super + O` kombinációval egy ablakot kipattinthatsz a munkaterületi kiosztásából. Ez lebegő ablakként rögzíti, amely követ téged bármelyik munkaterületre, ahova mész. Nagyszerű videolejátszókhoz és hasonlókhoz.

 ![navigation-popped-window](images/navigation-popped-window.webp)

### Scratchpad munkaterület

Végül van egy speciális scratchpad munkaterület, amely bármelyik munkaterület fölé legördül, amelyiken épp vagy, sokban egy Quake-konzolra emlékeztetve. A `Super + Grave` vagy a `Super + S` kombinációval kapcsolhatod, és a `Super + Shift + Grave` vagy a `Super + Alt + S` kombinációval tehetsz rá ablakot.

Különösen jól működik egy agentet futtató terminálhoz, vagy olyan vezérlőkhöz, amelyekkel gyorsan akarsz dolgozni anélkül, hogy elhagynád az aktuális munkaterületet. Egy ablak scratchpadről való levételéhez küldd közvetlenül egy másik munkaterületre például a `Super + Shift + 1` kombinációval.

Amíg a scratchpad egyetlen ablakot tart, középre igazított panelként gördül le, ahelyett, hogy átfeszülne a képernyőn. Tégy rá egy második appot, és visszatér a teljes szélességre, így a kettőnek van helye egymás mellett ülni.

### Némi megszokást igényel!

Kis időbe telik megszokni, hogy így navigálj az asztalodon, de ha egyszer megszokod, nehéz lesz visszatérni a hagyományos, egérvezérelt asztali élményhez!
