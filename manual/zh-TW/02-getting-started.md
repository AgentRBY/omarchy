# 開始使用

Omarchy 使用 ISO 安裝。你可以選擇全磁碟安裝，也就是接管整個磁碟機，或是自由空間安裝，也就是將 Omarchy 放在磁碟機上未配置的空間裡 — 這就是與 Windows 或其他作業系統雙重開機的方法（參見[雙重開機安裝](50-dual-boot-install.md) — 請注意，你需要先在 Windows 中關閉 BitLocker）。不論哪種方式，安裝預設都會啟用全磁碟加密，而全磁碟選項將會抹除所選的磁碟機，所以在使用現有磁碟機之前，務必先備份！

先[下載 Omarchy ISO](https://omarchy.org/)，將它放進 USB 隨身碟（在 Mac/Windows 上使用 [balenaEtcher](https://etcher.balena.io/)，或在 Linux 上使用 [caligula](https://github.com/ifd3f/caligula)），然後從隨身碟開機。

_你必須在 BIOS 中關閉 Secure Boot 和／或 TPM。你必須關閉這些功能才能安裝 Omarchy。它們是為 Windows 以及與 Microsoft 有關係的 Linux 發行版而設計的 Microsoft 安全機制。_

接著回答設定問題，並像這樣確認：

 ![install-config](images/install-config.webp)

接著為你的安裝選擇一個磁碟機，然後坐下來看安裝表演開始。在最快的現代機器上，不到一分鐘就能完成，但即使在較舊的電腦上，也不應該花超過 5 分鐘。

 ![install-done](images/install-done.webp)

現在你已經準備好進入 Omarchy 了！

### 使用有線或 2.4ghz 鍵盤！

全磁碟加密不允許你在啟動時從 Bluetooth 鍵盤輸入密碼。就像你無法在 PC 上用 Bluetooth 鍵盤進入 BIOS 一樣。你需要一個使用 2.4ghz 接收器或有線連接的鍵盤（有線連接在延遲方面本來也好得多！）。我個人非常喜歡 [Lofree Flow84](https://www.lofree.co/products/lofree-flow-the-smoothest-mechanical-keyboard)！

### 為另一位擁有者安裝

如果你是在為別人設定機器 — 家人、新員工、買家 — 你不應該代替他們回答個人問題。在安裝程式的第一個畫面（鍵盤選擇）按下 `Ctrl + C`，Omarchy 就會提供改為另一位擁有者準備機器的選項。系統會立即安裝，但所有個人設定 — 鍵盤配置、使用者名稱、密碼 — 都會延遲到機器第一次開機時才進行。磁碟機仍然預設加密，而新擁有者在第一次開機時選擇的密碼也會成為加密密碼。（你已經使用過的機器也可以不用重新安裝就交給別人 — 參見[重設電腦](48-security.md)。）

### 無人值守安裝

當 ISO 在第二個磁碟機上取得其設定時，它也可以完全自行安裝 — 不需要鍵盤，也不需要精靈。這是將 Omarchy 視為 VM 和機隊機器的基礎映像的方法。參見[無人值守安裝](51-unattended-installs.md)。

### 無加密安裝

Omarchy 預設會以加密方式安裝。對於任何可能遺失或被偷的電腦，這是安全、負責任的選擇。你不會希望任何能接觸到你硬體的人都能取得你的資料！

但在特殊情況下，例如在受保護的電腦上進行遠端 Omarchy 安裝，或是沒有敏感資料的拋棄式安裝，你可能會想要在不加密的情況下安裝。你可以在磁碟格式化確認畫面上按下 `Ctrl + C`，切換到無加密安裝。

### 語言

Omarchy 支援 50 種語言 — 與 omarchy.org 相同的語言集合 — 而英文是預設語言。要切換，請開啟 Omarchy 選單並前往 _設定 > 語言_，或在終端機中執行 `omarchy language <code>`（`omarchy language list` 會顯示這些代碼）。選單、桌面和 Omarchy 自己的通知會立即變更語言，而你之後開啟的每個應用程式也會跟著變更。已經開啟的應用程式在你重新啟動它們之後就會切換。

### 卡住時尋求協助

如果你卡住了，通常可以在[社群 Discord](https://omarchy.org/discord) 的 _#omarchy-help_ 頻道中找到願意協助的人。
