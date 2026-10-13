# 入門指南

Omarchy 使用 ISO 來安裝。你可以選擇全磁碟安裝，也就是接管整顆硬碟；或是可用空間安裝，也就是把 Omarchy 裝進硬碟上未配置的空間——那就是你與 Windows 或另一個作業系統雙重開機的方法（見[雙重開機安裝](50-dual-boot-install.md)——請注意，你需要先在 Windows 中關閉 BitLocker）。無論哪一種，安裝都預設為全機加密，而全磁碟選項會清除所選的硬碟，所以使用現有硬碟之前，務必先備份！

先[下載 Omarchy ISO](https://omarchy.org/)，把它放到 USB 隨身碟上（在 Mac/Windows 上使用 [balenaEtcher](https://etcher.balena.io/)，在 Linux 上使用 [caligula](https://github.com/ifd3f/caligula)），然後從隨身碟開機。

_你必須在 BIOS 中關閉 Secure Boot 及/或 TPM。你必須關閉這些才能安裝 Omarchy。它們是 Microsoft 為 Windows 以及與 Microsoft 有關聯的 Linux 發行版設計的安全方案。_

接著回答設定問題，並像這樣確認它們：

 ![install-config](images/install-config.webp)

然後選擇一顆硬碟進行安裝，坐下來看安裝表演開始。在最快的現代機器上，不到一分鐘就能完成；即使在較舊的電腦上，也不該花超過 5 分鐘。

 ![install-done](images/install-done.webp)

現在你準備好使用 Omarchy 了！

### 使用有線或 2.4ghz 鍵盤！

全磁碟加密不允許你在開機時用藍牙鍵盤輸入密碼。就像你無法用藍牙鍵盤進入 PC 的 BIOS 一樣。你需要一把使用 2.4ghz 接收器或有線連接的鍵盤（延遲表現也好得多！）。我個人非常喜歡 [Lofree Flow84](https://www.lofree.co/products/lofree-flow-the-smoothest-mechanical-keyboard)！

### 為另一位擁有者安裝

如果你是在為別人——家人、新員工、買家——設定一台機器，你不應該代替他們回答個人問題。在安裝程式的第一個畫面（鍵盤選取）按下 `Ctrl + C`，Omarchy 就會提供改為另一位擁有者準備機器的選項。系統會立即安裝，但所有個人設定——鍵盤配置、使用者名稱、密碼——都會延遲到機器第一次開機時再處理。硬碟仍預設加密，而新擁有者在那第一次開機時選的密碼，也會成為加密密碼。（一台你已經在使用的機器，也可以不經重新安裝就交接——見[重置電腦](48-security.md)。）

### 無人值守安裝

當 ISO 在第二顆硬碟上獲得它的設定時，它也可以完全自行安裝——無需鍵盤、無需精靈。那就是把 Omarchy 當作 VM 和機群機器基礎映像的方法。見[無人值守安裝](51-unattended-installs.md)。

### 無加密安裝

Omarchy 預設以加密方式安裝。對於任何可能遺失或被竊的電腦來說，這是安全、負責任的選擇。你不會希望任何拿到你硬體的人都能取得你的資料！

但在特殊情況下，例如在受保護的電腦上進行遠端 Omarchy 安裝，或是沒有敏感資料的拋棄式安裝，你可能會想要不安裝加密。你可以在磁碟格式化確認畫面上按下 `Ctrl + C`，切換到無加密安裝。

### 語言

Omarchy 支援 50 種語言——與 omarchy.org 相同的集合——而 English 是預設語言。若要切換，請開啟 Omarchy 選單並前往 _設定 > 語言_，或在終端機中執行 `omarchy language <code>`（`omarchy language list` 會顯示代碼）。選單、桌面以及 Omarchy 自己的通知會立即切換語言，系統地區設定也會被設為相符，因此你的其他應用程式會在你下次登入時跟進。

### 卡關時尋求協助

如果你卡住了，通常可以在[社群 Discord](https://omarchy.org/discord) 的 _#omarchy-help_ 頻道找到願意幫忙的人。
