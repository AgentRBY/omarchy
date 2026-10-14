# 开始使用

Omarchy 使用 ISO 安装。你可以选择全盘安装，它会占用整个驱动器；也可以选择空闲空间安装，它会把 Omarchy 装到驱动器上未分配的空间里——与 Windows 或另一个操作系统双启动就是这么做的（参见[双启动安装](50-dual-boot-install.md)——注意，你得先在 Windows 中关闭 BitLocker）。无论选哪种，安装默认都会启用全盘加密，而全盘选项会抹除所选驱动器，所以使用已有驱动器之前，务必先做好备份！

先[下载 Omarchy ISO](https://omarchy.org/)，把它写入 U 盘（在 Mac/Windows 上用 [balenaEtcher](https://etcher.balena.io/)，在 Linux 上用 [caligula](https://github.com/ifd3f/caligula)），然后从 U 盘启动。

_你必须在 BIOS 中关闭 Secure Boot 和/或 TPM。你必须关掉它们才能安装 Omarchy。它们是 Microsoft 为 Windows 以及与 Microsoft 有关联的 Linux 发行版设计的安全机制。_

然后回答配置问题，并像这样确认它们：

 ![install-config](images/install-config.webp)

然后为安装选择一个驱动器，坐下来看安装表演开始吧。在最快的现代机器上，不到一分钟就能完成；即便在较旧的电脑上，也不该超过 5 分钟。

 ![install-done](images/install-done.webp)

现在你准备好 Omarchy 了！

### 使用有线或 2.4ghz 键盘！

全盘加密不允许你在启动时用 Bluetooth 键盘输入密码。就像你没法用 Bluetooth 键盘进入 PC 的 BIOS 一样。你需要一把使用 2.4ghz 接收器或线缆的键盘（线缆的延迟体验反正也好得多！）。我个人非常喜欢 [Lofree Flow84](https://www.lofree.co/products/lofree-flow-the-smoothest-mechanical-keyboard)！

### 为另一位主人安装

如果你是在为别人——家人、新员工、买家——设置一台机器，你不应该替他们回答那些个人问题。在安装程序的第一个界面（键盘选择）按 `Ctrl + C`，Omarchy 就会提出改为这台机器为另一位主人做准备。系统会立即安装，但所有个人设置——键盘布局、用户名、密码——都会推迟到机器首次启动时再进行。驱动器默认仍然会加密，而新主人在首次启动时选择的密码也会成为加密密码。（你已经在使用的一台机器也可以不用重装直接交接——参见[重置电脑](48-security.md)。）

### 无人值守安装

ISO 也可以完全自行安装——不需要键盘，不需要向导——前提是在第二个驱动器上把配置交给它。这就是把 Omarchy 当作 VM 和机群机器基础镜像的做法。参见[无人值守安装](51-unattended-installs.md)。

### 无加密安装

Omarchy 默认带加密安装。对于任何有可能丢失或被盗的电脑来说，这是安全、负责任的选择。你可不想让任何能接触到你硬件的人都能拿到你的数据！

但在特殊情况下，比如在受保护的电脑上远程安装 Omarchy，或是没有敏感数据的一次性安装，你可能想不加密地安装。你可以在磁盘格式化确认界面按 `Ctrl + C`，切换到无加密安装。

### 语言

Omarchy 会说 50 种语言——与 omarchy.org 相同的语言集合——默认是英语。要切换，打开 Omarchy 菜单并前往 _设置 > 语言_，或在终端中运行 `omarchy language <code>`（`omarchy language list` 会显示语言代码）。菜单、桌面和 Omarchy 自己的通知会立即切换语言，你之后打开的每个应用程序也会跟随切换。已经打开的应用在你重启它们后切换。

### 卡住时寻求帮助

如果你卡住了，通常可以在[社区 Discord](https://omarchy.org/discord) 的 _#omarchy-help_ 频道里找到愿意帮忙的人。
