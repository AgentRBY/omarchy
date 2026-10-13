# 入门

Omarchy 使用 ISO 安装。你可以选择全盘安装（接管整个驱动器），或者空闲空间安装（将 Omarchy 放入驱动器上未分配的空间——这就是与 Windows 或其他操作系统双启动的方式，参见[双启动安装](50-dual-boot-install.md)——注意你需要先在 Windows 中关闭 BitLocker）。无论哪种方式，安装默认使用全盘加密，而全盘选项会擦除所选驱动器，所以在使用已有驱动器之前务必备份！

先[下载 Omarchy ISO](https://omarchy.org/)，将其写入 U 盘（在 Mac/Windows 上使用 [balenaEtcher](https://etcher.balena.io/)，在 Linux 上使用 [caligula](https://github.com/ifd3f/caligula)），然后从 U 盘启动。

_你必须在 BIOS 中关闭 Secure Boot 和/或 TPM。你必须关闭这些才能安装 Omarchy。它们是为 Windows 和与微软关联的 Linux 发行版设计的微软安全方案。_

然后回答配置问题，并像这样确认：

 ![install-config](images/install-config.webp)

然后为你的安装选择一个驱动器，坐下来观看安装过程。在最快的现代机器上不到一分钟即可完成，即使在较老的计算机上也不应超过 5 分钟。

 ![install-done](images/install-done.webp)

现在你就可以开始使用 Omarchy 了！

### 使用有线或 2.4ghz 键盘！

全盘加密不允许你在启动时从蓝牙键盘输入密码。就像你不能用蓝牙键盘进入 PC 的 BIOS 一样。你需要一个使用 2.4ghz 接收器或线缆的键盘（无论如何，线缆在延迟方面要好得多！）。我个人非常喜欢 [Lofree Flow84](https://www.lofree.co/products/lofree-flow-the-smoothest-mechanical-keyboard)！

### 为他人安装

如果你是在为其他人设置机器——家人、新员工、买家——你不应该代他们回答个人问题。在安装程序的第一个屏幕（键盘选择）上按 `Ctrl + C`，Omarchy 就会提议改为另一位所有者准备机器。系统会立即安装，但所有个人设置——键盘布局、用户名、密码——都会推迟到机器首次启动时。驱动器默认仍会加密，新所有者在首次启动时选择的密码也会成为加密密码。（你已经用过的机器也可以在不重装的情况下移交——参见[重置计算机](48-security.md)。）

### 无人值守安装

当 ISO 在第二个驱动器上获得其配置时，它也可以完全自行安装——无需键盘，无需向导。这是将 Omarchy 视为虚拟机和批量机器的基础镜像的方式。参见[无人值守安装](51-unattended-installs.md)。

### 无加密安装

Omarchy 默认安装时带加密。对于任何可能丢失或被盗的计算机，这是安全、负责任的选择。你可不想让任何能接触到你硬件的人都能获取你的数据！

但在特殊情况下，例如在受保护计算机上远程安装 Omarchy，或者用于没有敏感数据的临时安装，你可能希望在没有加密的情况下安装。你可以在磁盘格式化确认时按 `Ctrl + C` 切换到无加密安装。

### 语言

Omarchy 支持 50 种语言——与 omarchy.org 相同的集合——默认是英语。要切换，打开 Omarchy 菜单并转到_设置 > 语言_，或在终端中运行 `omarchy language <code>`（`omarchy language list` 显示代码）。菜单、桌面和 Omarchy 自己的通知会立即更改语言，系统区域设置也会相应设置，这样你的其他应用在下次登录时就会跟随。

### 卡住时求助

如果你卡住了，通常可以在[社区 Discord](https://omarchy.org/discord) 的 _#omarchy-help_ 频道找到愿意帮忙的人。
