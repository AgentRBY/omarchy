# 導覽

Omarchy 中的一切都透過鍵盤進行——_一切！_當系統剛啟動時，你光靠滑鼠真的什麼也做不了。但你可以按下 `Super + Space` 叫出 Omarchy 選單，從這裡你就能做到幾乎所有事情。

但 Omarchy 選單甚至不是設計來在大多數時候作為操作系統的主要方式。我們還能更快！所有最重要的應用程式都直接綁定到個別的快捷鍵上。你用 `Super + Return` 啟動終端機，用 `Super + Shift + Return` 啟動瀏覽器。試著一個接一個地做，你就會看到 Hyprland 平鋪的魔力在運作：

 ![navigation-browser-terminal](images/navigation-browser-terminal.webp)

接著你可以按下 `Super + J`，把它們上下堆疊，而不是左右並排：

 ![navigation-stacked](images/navigation-stacked.webp)

再按一次 `Super + J`，把它們送回左右並排的位置。然後在瀏覽器上試著按下 `Super + Shift + Arrow Right` 來交換視窗。

現在試著按下 `Super + Ctrl + T` 來啟動活動監視器。那會以浮動視窗的形式出現。你可以用 `Super + T` 把它平鋪（再按一次則讓它再次浮動）。現在按下 `Super + Shift + F` 開啟檔案管理器。你會得到一個整齊的四分割佈局：

 ![navigation-fourway-tiling](images/navigation-fourway-tiling.webp)

你用 `Super + Arrow` 在想要啟用的視窗之間導覽。這會切換焦點，並把游標移到新應用程式的中央。

如果你按下 `Super + Shift + 2`，你會把目前焦點所在的應用程式移到第二個工作區。`Super + Shift + 1` 會把它移回來。（而 `Super + Shift + Alt + 2` 會把目前焦點所在的應用程式移到第二個工作區，但不跟著切換過去）。

如果你按住 `Super` 並用滑鼠點選一個視窗，你就能重新安排它所在的位置。如果你按住 `Super` 並用滑鼠右鍵，你就可以自由調整視窗大小。

你用 `Super + W` 或 `Super + Q` 關閉一個視窗（用 `Ctrl + Alt + Delete` 關閉所有視窗）。

你也可以用 `Super + F` 進入全螢幕，甚至只用 `Super + Alt + F` 進入全寬（保留選單列），或用 `Super + Ctrl + F` 在視窗內全螢幕（很適合 YouTube！）。

### Dwindle 與捲動配置

Omarchy 的預設配置稱為 dwindle。它會讓你在單一工作區上開啟的所有視窗隨時保持可見，就算必須把它們縮小也一樣。

 ![navigation-dwindle-layout](images/navigation-dwindle-layout.webp)

但你也可以選擇把一個工作區變成捲動配置，在這種配置中，視窗會左右並排排列，超出顯示器的可見邊緣。你透過 `Super + L` 把單一工作區變成這種配置。

再按一次 `Super + L` 會把工作區變成浮動，在這種狀態下視窗自由重疊、由你自行擺放；第三次按下則回到 dwindle。`Super + Alt + L` 會以相反的方向循環這些配置。一個本來就浮動的視窗——你用 `Super + T` 彈出來的，或是一個永遠以浮動方式開啟的應用程式——當工作區回到平鋪時，會繼續保持浮動。選單列會以它的配置標示你所在的工作區：正方形代表 dwindle，圓形代表捲動，三角形代表浮動。點選那個標示也會循環切換配置。

 ![navigation-scrolling-layout](images/navigation-scrolling-layout.webp)

這個選擇是依工作區而定的，而且會保留下來。所以你可以讓工作區 1 保持 dwindle 用來瀏覽，讓工作區 2 保持捲動用來寫程式，重新開機後它們還會以那個方式回來。

如果你希望使用捲動配置作為預設，你可以在 `~/.config/hypr/looknfeel.lua` 中設定：

```lua
hl.config({
  general = {
    layout = "scrolling",
  },
})
```

### 浮動工作區

浮動工作區的運作方式像傳統桌面：視窗重疊，由你自己移動和調整大小。每個視窗都會獲得一個以你主題色彩呈現的標題列，上面有最小化、最大化和關閉的按鈕。`Super + M` 也會最小化目前焦點所在的視窗。最小化的視窗會在 Dock 中等待；點選它的應用程式就能把它帶回來。點選一個視窗把它帶到前面。從任何邊緣或角落調整它的大小。雙擊標題列可以最大化視窗，同時保持選單列可見，再雙擊一次則取回舊的大小。

浮動工作區也會顯示一個 Dock，裡面有你釘選的應用程式、所有正在運行的應用程式，以及應用程式按鈕後面的一個完整應用程式格子，`Super + Alt + Space` 和 Omarchy 選單中的_應用程式_也會開啟那個格子。在格子上右鍵點選一個應用程式，或按下 `Delete`，即可將它解除安裝。點選一個應用程式來開啟它，或把它的視窗帶到前面；再點一次則循環切換它的視窗。中鍵點選會開啟一個新視窗。沿著 Dock 拖曳一個圖示來移動它；把一個正在運行的應用程式拖進其他應用程式之間，就會把它留在那裡。右鍵點選可以把一個應用程式保留在 Dock 中、把它取出來，或結束它。Dock 會為全螢幕視窗讓路。右鍵點選應用程式按鈕，可以把 Dock 移到另一個邊緣，或讓它隱藏直到指標到達它的邊緣。位置也在 _觸發 > 外觀 > Dock > Dock 位置_ 底下，而 `omarchy dock position left` 和 `omarchy dock autohide on` 可以從終端機設定這兩者。你保留在 Dock 中的應用程式，在未運行時會變淡顯示。

新的工作區，以及任何你尚未用 `Super + L` 賦予專屬配置的工作區，會使用預設配置。變更預設值會把每一個沒有視窗的工作區重設為該配置，而上面有視窗的工作區會保留它原有的配置。在 _觸發 > 外觀 > 工作區配置_ 底下選擇它：平鋪、捲動或浮動。`omarchy-hyprland-workspace-layout-default scrolling` 可以從終端機設定它。

### 分組視窗

視窗可以用 `Super + G` 進行分組。一旦你進入一個群組，在該群組作用中時啟動的每一個視窗都會屬於該群組。你可以用 `Super + Ctrl + Arrow Left/Right` 在這些分組視窗之間移動，或用 `Super + Alt + 1/2/3/4` 直接依序前往某個分組視窗。

你可以用 `Super + Alt + G` 把一個視窗移出分組，或再按一次 `Super + G` 來拆解整個群組。最後，你可以用 `Super + Alt + Arrows` 把群組外的視窗移進群組裡。

### 彈出視窗

你可以用 `Super + O` 把一個視窗從它的工作區配置中彈出來。那會把它釘選為一個浮動視窗，無論你去到哪個工作區，它都會跟著你。非常適合影片播放器之類的東西。

 ![navigation-popped-window](images/navigation-popped-window.webp)

### 暫存區工作區

最後，有一個特殊的暫存區工作區，它會在你目前所在的工作區之上拉下來，很像 Quake 主控台。用 `Super + Grave` 或 `Super + S` 切換它，用 `Super + Shift + Grave` 或 `Super + Alt + S` 把一個視窗放到那裡。

它特別適合運行代理程式的終端機，或是你想要快速互動、又不想離開目前工作區的控制項。若要把一個視窗移出暫存區，用類似 `Super + Shift + 1` 的方式把它直接送到另一個工作區。

當暫存區只容納單一視窗時，它會以一個置中的面板形式拉下來，而不是橫跨整個螢幕。在它上面放第二個應用程式，它就會回到全寬，這樣兩者就有空間左右並排坐好。

### 這需要一點時間習慣！

像這樣導覽你的桌面需要一點時間習慣，但一旦你習慣了，要回到傳統的滑鼠驅動桌面體驗就會很難了！
