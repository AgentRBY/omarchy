# Nabigasyon

Lahat ng bagay sa Omarchy ay nangyayari sa pamamagitan ng keyboard — _LAHAT!_ Kapag unang nagsimula ang sistema, literal na wala kang magagawa gamit lang ang mouse. Pero maaari mong pindutin ang `Super + Space` para ipakita ang Menu ng Omarchy at mula rito magagawa mo ang halos lahat ng bagay.

Ngunit ang menu ng Omarchy ay hindi man lang nilayon na maging pangunahing paraan ng pagpapatakbo ng sistema sa karamihan ng oras. Maaari tayong maging mas mabilis kaysa roon! Ang lahat ng pinakamahalagang application ay direktang naka-bind sa mga indibidwal na hotkey. Sinisimulan mo ang terminal gamit ang `Super + Return` at ang browser gamit ang `Super + Shift + Return`. Subukan mong gawin ang isa pagkatapos ng isa pa, at makikita mo ang mahika ng tiling ng Hyprland sa aksyon:

 ![navigation-browser-terminal](images/navigation-browser-terminal.webp)

Maaari mo pagkatapos pindutin ang `Super + J` para ipatong ang mga ito sa ibabaw ng isa't isa sa halip na magkatabi:

 ![navigation-stacked](images/navigation-stacked.webp)

Pindutin muli ang `Super + J` para ibalik ang mga ito sa kanilang magkatabing posisyon. Pagkatapos subukan ang `Super + Shift + Arrow Right` habang nasa browser para ipagpalit ang mga bintana.

Ngayon subukan ang `Super + Ctrl + T` para simulan ang Activity monitor. Lalabas iyon bilang isang lumulutang na bintana. Maaari mo itong i-tile gamit ang `Super + T` (at pindutin iyon muli para gawin itong lumulutang ulit). Ngayon pindutin ang `Super + Shift + F` para buksan ang file manager. Magkakaroon ka ng isang maayos na four-way setup:

 ![navigation-fourway-tiling](images/navigation-fourway-tiling.webp)

Nag-navigate ka sa pagitan ng bintanang gusto mong maging aktibo gamit ang `Super + Arrow`. Lilipat nito ang focus at ililipat ang cursor sa gitna ng bagong application.

Kung pipindutin mo ang `Super + Shift + 2`, ililipat mo ang kasalukuyang naka-focus na application sa pangalawang workspace. Ibinabalik ito ng `Super + Shift + 1`. (At ililipat ng `Super + Shift + Alt + 2` ang kasalukuyang naka-focus na application sa pangalawang workspace nang hindi lumilipat dito).

Kung pipindutin mo nang matagal ang `Super` at gagamitin ang mouse para mag-click sa isang bintana, maaari mong ayusin muli kung saan ito nakaupo. Kung pipindutin mo nang matagal ang `Super` at gagamitin ang kanang button ng mouse, malaya mong mai-resize ang bintana.

Isinasara mo ang isang bintana sa `Super + W` o `Super + Q` (at isinasara ang lahat ng bintana sa `Ctrl + Alt + Delete`).

Maaari ka ring mag-full screen gamit ang `Super + F` o full-width lang (pinapanatili ang top bar) gamit ang `Super + Alt + F` o full-screen sa loob ng isang bintana gamit ang `Super + Ctrl + F` (mainam para sa YouTube!).

### Layout na dwindle laban sa scrolling

Ang default na layout ng Omarchy ay tinatawag na dwindle. Pinapanatili nitong nakikita sa lahat ng oras ang lahat ng bintanang binubuksan mo sa isang workspace, kahit kailangan nitong paliitin ang mga ito.

 ![navigation-dwindle-layout](images/navigation-dwindle-layout.webp)

Ngunit maaari mo ring piliing gawing scrolling layout ang isang workspace kung saan magkakatabi ang mga bintana, lampas sa nakikitang gilid ng display. Ginagawa mong ganitong layout ang isang workspace sa pamamagitan ng `Super + L`.

Ang pagpindot muli sa `Super + L` ay ginagawang lumulutang ang workspace, kung saan malayang nagpapatong-patong ang mga bintana at ikaw mismo ang naglalagay sa mga ito, at ang ikatlong pagpindot ay ibinabalik ito sa dwindle. Dumadaan ang `Super + Alt + L` sa mga ito sa kabaligtarang direksyon. Ang isang bintanang lumulutang pa rin naman — isa na inilabas mo gamit ang `Super + T`, o isang app na palaging bumubukas nang lumulutang — ay nananatiling lumulutang kapag bumalik ang workspace sa tiling. Minamarkahan ng top bar ang workspace na kinaroroonan mo ng layout nito: isang parisukat para sa dwindle, isang bilog para sa scrolling, at isang tatsulok para sa lumulutang. Ini-cycle din ng pag-click sa markang iyon ang layout.

 ![navigation-scrolling-layout](images/navigation-scrolling-layout.webp)

Ang pagpipilian ay bawat workspace, at nananatili ito. Kaya maaari mong panatilihin ang workspace 1 sa dwindle para sa pag-browse at ang workspace 2 sa scrolling para sa code, at babalik ang mga ito nang ganoon pagkatapos ng restart.

Kung nais mong gamitin ang scrolling layout bilang default, maaari mo itong itakda sa `~/.config/hypr/looknfeel.lua`:

```lua
hl.config({
  general = {
    layout = "scrolling",
  },
})
```

### Mga lumulutang na workspace

Gumagana ang isang lumulutang na workspace tulad ng isang tradisyonal na desktop: nagpapatong-patong ang mga bintana, at ikaw mismo ang naglilipat at nagsusukat sa mga ito. Nakakakuha ang bawat bintana ng titlebar sa mga kulay ng iyong tema, na may mga button para i-minimize, i-maximize, at isara. Imina-minimize din ng `Super + M` ang naka-focus na bintana. Naghihintay ang isang naka-minimize na bintana sa dock; i-click ang app nito para ibalik ito. I-click ang isang bintana para dalhin ito sa harap. I-resize ito mula sa anumang gilid o sulok. I-double-click ang isang titlebar para i-maximize ang bintana habang pinapanatiling nakikita ang top bar, at muli para mabalik ang dati nitong sukat.

Nagpapakita rin ang isang lumulutang na workspace ng dock, kasama ang iyong mga naka-pin na app, lahat ng tumatakbo, at isang grid ng bawat app sa likod ng button ng mga app, na binubuksan din ng `Super + Alt + Space` at ng _Mga App_ sa menu ng Omarchy. I-right-click ang isang app sa grid, o pindutin ang `Delete`, para i-uninstall ito. I-click ang isang app para buksan ito, o para dalhin ang bintana nito sa harap; i-click muli para umikot sa mga bintana nito. Ang middle-click ay nagbubukas ng bagong bintana. I-drag ang isang icon sa kahabaan ng dock para ilipat ito; ang pag-drag ng isang tumatakbong app sa gitna ng iba ay nagpapanatili rito roon. I-right-click para panatilihin ang isang app sa dock, alisin ito, o isara ito. Umiwas ang dock sa isang fullscreen na bintana. I-right-click ang button ng mga app para ilipat ang dock sa ibang gilid o para itago ito hanggang maabot ng pointer ang gilid nito. Ang posisyon ay nasa ilalim din ng _Mag-trigger > Hitsura > Dock > Posisyon ng Dock_, at itinatakda ng `omarchy dock position left` at `omarchy dock autohide on` ang dalawa mula sa isang terminal. Kupas ang mga app na pinapanatili mo sa dock habang hindi sila tumatakbo.

Ginagamit ng mga bagong workspace, at ng anumang hindi mo binigyan ng sariling layout gamit ang `Super + L`, ang default na layout. Ang pagbabago ng default ay nagre-reset sa bawat workspace na walang bintana papunta rito, habang ang isang may mga bintana ay pinapanatili ang layout na mayroon ito. Piliin ito sa ilalim ng _Mag-trigger > Hitsura > Layout ng Workspace_: Pag-tile, Pag-scroll, o Lumulutang. Itinatakda ito ng `omarchy-hyprland-workspace-layout-default scrolling` mula sa isang terminal.

### Pagpapangkat ng mga bintana

Maaaring ipangkat ang mga bintana gamit ang `Super + G`. Kapag nasa isang pangkat ka na, ang bawat bintanang sisimulan mo habang aktibo iyon ay mapapabilang sa pangkat. Maaari kang lumipat sa pagitan ng mga nakapangkat na bintanang ito gamit ang `Super + Ctrl + Arrow Left/Right` o `Super + Alt + 1/2/3/4` para direktang pumunta sa nakapangkat na bintana nang magkakasunod.

Maaari mong ilipat ang isang bintana palabas ng pagpapangkat gamit ang `Super + Alt + G` o buwagin ang buong pangkat sa pamamagitan ng pagpindot muli sa `Super + G`. Sa wakas, maaari mong ilipat ang mga bintanang nasa labas ng pangkat papasok dito gamit ang `Super + Alt + Arrows`.

### Pag-pop ng mga bintana

Maaari mong i-pop ang isang bintana palabas ng alokasyon nito sa workspace gamit ang `Super + O`. Ipi-pin nito ito bilang isang lumulutang na bintana na sumusunod sa iyo sa anumang workspace na pupuntahan mo. Mainam para sa mga video player at katulad nito.

 ![navigation-popped-window](images/navigation-popped-window.webp)

### Workspace na scratchpad

Sa wakas, mayroong isang espesyal na workspace na scratchpad na bumababa sa ibabaw ng anumang workspace na kinaroroonan mo, tulad ng isang Quake console. I-toggle ito gamit ang `Super + Grave` o `Super + S`, at maglagay ng bintana roon gamit ang `Super + Shift + Grave` o `Super + Alt + S`.

Partikular itong gumagana nang mahusay para sa isang terminal na nagpapatakbo ng isang agent, o para sa mga kontrol na gusto mong makipag-ugnayan nang mabilis nang hindi umaalis sa kasalukuyang workspace. Para ilipat ang isang bintana palabas ng scratchpad, ipadala ito nang diretso sa ibang workspace gamit ang isang bagay tulad ng `Super + Shift + 1`.

Habang ang scratchpad ay naglalaman ng isang bintana, bumababa ito bilang isang naka-center na panel sa halip na sakupin ang screen. Maglagay ng pangalawang app dito at babalik ito sa buong lapad, para may espasyo ang dalawa na umupo nang magkatabi.

### Kailangan ng kaunting pagkasasanay!

Kailangan ng kaunting panahon para masanay sa pag-navigate ng iyong desktop nang ganito, ngunit kapag nasanay ka na, mahirap nang bumalik sa isang tradisyonal na karanasan sa desktop na hinimok ng mouse!
