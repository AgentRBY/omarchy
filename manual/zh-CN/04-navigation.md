# 导航

Omarchy 中的一切都通过键盘进行——_一切！_ 系统首次启动时，你光靠鼠标真的什么也做不了。但你可以按 `Super + Space` 呼出 Omarchy 菜单，从这里你可以做几乎所有事情。

但 Omarchy 菜单甚至并不打算成为日常操作系统的主要方式。我们可以更快！所有最重要的应用都直接绑定到单独的快捷键上。你用 `Super + Return` 启动终端，用 `Super + Shift + Return` 启动浏览器。试着先后执行这两个操作，你就会看到 Hyprland 平铺的魔力：

 ![navigation-browser-terminal](images/navigation-browser-terminal.webp)

然后你可以按 `Super + J` 将它们上下堆叠，而不是并排放置：

 ![navigation-stacked](images/navigation-stacked.webp)

再次按 `Super + J` 可将它们恢复到并排位置。然后在浏览器上尝试 `Super + Shift + Arrow Right` 来交换窗口。

现在尝试 `Super + Ctrl + T` 启动活动监视器。它会显示为浮动窗口。你可以使用 `Super + T` 将其平铺（再次按该组合可使其重新浮动）。现在按 `Super + Shift + F` 打开文件管理器。你会得到一个整洁的四分屏布局：

 ![navigation-fourway-tiling](images/navigation-fourway-tiling.webp)

你使用 `Super + Arrow` 在要激活的窗口之间导航。这会切换焦点并将光标移动到新应用的中心。

如果你按 `Super + Shift + 2`，你会将当前聚焦的应用移动到第二个工作区。`Super + Shift + 1` 将其移回来。（`Super + Shift + Alt + 2` 会将当前聚焦的应用移动到第二个工作区，但不切换到该工作区）。

如果你按住 `Super` 并用鼠标点击窗口，你就能重新排列它的位置。如果你按住 `Super` 并使用鼠标右键，你可以自由调整窗口大小。

你可以用 `Super + W` 或 `Super + Q` 关闭窗口（用 `Ctrl + Alt + Delete` 关闭所有窗口）。

你还可以用 `Super + F` 进入全屏，甚至只使用 `Super + Alt + F` 进入全宽（保留菜单栏），或使用 `Super + Ctrl + F` 在窗口内全屏（非常适合 YouTube！）。

### Dwindle 与滚动布局

Omarchy 的默认布局称为 dwindle。它让你在单个工作区中打开的所有窗口始终可见，即使必须缩小它们。

 ![navigation-dwindle-layout](images/navigation-dwindle-layout.webp)

但你也可以选择将工作区变成滚动布局，其中窗口并排排列，超出显示器的可见边缘。你可以通过 `Super + L` 将单个工作区转换为此布局。

再次按 `Super + L` 会将工作区变为浮动，其中窗口自由重叠且由你自己放置，第三次按则将其恢复为 dwindle。`Super + Alt + L` 以相反的顺序循环。用 `Super + T` 弹出的窗口，或始终以浮动方式打开的应用——当工作区回到平铺时，会保持浮动。菜单栏用其布局标记你所在的工作区：正方形代表 dwindle，圆形代表滚动，三角形代表浮动。点击该标记也会循环布局。

 ![navigation-scrolling-layout](images/navigation-scrolling-layout.webp)

这一选择是按工作区进行的，而且会保留。所以你可以让工作区 1 使用 dwindle 进行浏览，工作区 2 使用滚动进行代码编写，重启后它们仍会保持这样。

如果你希望将滚动布局用作默认，你可以在 `~/.config/hypr/looknfeel.lua` 中设置：

```lua
hl.config({
  general = {
    layout = "scrolling",
  },
})
```

### 浮动工作区

浮动工作区像传统桌面一样工作：窗口重叠，由你自己移动和调整大小。每个窗口都有一个使用你主题颜色的标题栏，并带有最小化、最大化和关闭按钮。`Super + M` 也会最小化聚焦的窗口。最小化的窗口停留在程序坞中；点击其应用即可将其带回来。点击窗口可将其置于前台。从任意边缘或角落调整大小。双击标题栏可最大化窗口，同时保持菜单栏可见；再次双击可恢复其旧大小。

浮动工作区还显示一个程序坞，其中有你固定的应用、所有正在运行的应用，以及位于应用按钮后面的每个应用的网格，`Super + Alt + Space` 和 Omarchy 菜单中的_应用_也会打开它。在网格上右键单击某个应用，或按 `Delete`，即可将其卸载。单击某个应用可打开它，或将其窗口置于前台；再次单击可循环浏览其窗口。中键单击可打开新窗口。沿程序坞拖动图标可移动它；将正在运行的应用拖到其他应用之间可使其留在那里。右键单击可将应用保留在程序坞中、将其移除或退出它。程序坞会为全屏窗口让路。右键单击应用按钮可将程序坞移动到另一条边缘，或让它隐藏，直到指针到达其边缘。位置也位于_触发 > 外观 > 程序坞 > 程序坞位置_下，`omarchy dock position left` 和 `omarchy dock autohide on` 可从终端设置这两个选项。你保留在程序坞中的应用在未运行时会变淡。

新的工作区，以及任何你还没有用 `Super + L` 为其设置自己布局的工作区，都会使用默认布局。更改默认布局会将每个没有窗口的工作区重置为该布局，而有窗口的工作区会保留其现有布局。在_触发 > 外观 > 工作区布局_下选择：平铺、滚动或浮动。`omarchy-hyprland-workspace-layout-default scrolling` 可从终端设置它。

### 窗口分组

可以使用 `Super + G` 对窗口进行分组。进入分组后，你在该状态下启动的每个窗口都将属于该组。你可以使用 `Super + Ctrl + Arrow Left/Right` 在这些分组窗口之间移动，或使用 `Super + Alt + 1/2/3/4` 按顺序直接转到分组窗口。

你可以用 `Super + Alt + G` 将窗口移出分组，或再次按 `Super + G` 拆散整个组。最后，你可以用 `Super + Alt + Arrows` 将组外的窗口移入组内。

### 弹出窗口

你可以用 `Super + O` 将窗口弹出其工作区分配。这会将其固定为浮动窗口，跟随你到任何工作区。非常适合视频播放器之类的东西。

 ![navigation-popped-window](images/navigation-popped-window.webp)

### Scratchpad 工作区

最后，有一个特殊的 scratchpad 工作区，它会覆盖在你当前所在的工作区之上，很像 Quake 控制台。用 `Super + Grave` 或 `Super + S` 切换它，用 `Super + Shift + Grave` 或 `Super + Alt + S` 将窗口放在那里。

它尤其适合运行智能体的终端，或者适合你想快速交互而不离开当前工作区的控件。要将窗口移出 scratchpad，可用类似 `Super + Shift + 1` 的组合直接将其发送到另一个工作区。

当 scratchpad 只包含单个窗口时，它会以居中面板的形式下拉，而不是跨越整个屏幕。在其上放入第二个应用，它就会恢复全宽，这样两者就有空间并排放置。

### 需要一些时间适应！

适应这种桌面导航方式需要一点时间，但一旦你适应了，就很难回到传统的鼠标驱动桌面体验了！
