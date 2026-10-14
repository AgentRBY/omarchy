# Bắt đầu

Omarchy được cài đặt bằng một ISO. Bạn có thể chọn giữa cài đặt toàn bộ đĩa, chiếm toàn bộ ổ đĩa, hoặc cài đặt vào không gian trống, đặt Omarchy vào phần không gian chưa được phân bổ trên ổ đĩa — đó là cách bạn khởi động song song cùng Windows hoặc một hệ điều hành khác (xem [cài đặt dual boot](50-dual-boot-install.md) — lưu ý rằng trước tiên bạn sẽ cần tắt BitLocker trong Windows). Dù bằng cách nào, cài đặt cũng mặc định mã hóa toàn bộ, và tùy chọn toàn bộ đĩa sẽ xóa sạch ổ đĩa đã chọn, vì vậy hãy nhớ sao lưu trước khi dùng một ổ đĩa hiện có!

[Tải xuống ISO của Omarchy](https://omarchy.org/) trước, ghi nó vào một USB (dùng [balenaEtcher](https://etcher.balena.io/) trên Mac/Windows hoặc [caligula](https://github.com/ifd3f/caligula) trên Linux), và khởi động từ USB đó.

_Bạn phải tắt Secure Boot và/hoặc TPM trong BIOS. Bạn phải tắt chúng mới có thể cài đặt Omarchy. Chúng là các cơ chế bảo mật của Microsoft dành cho Windows và các bản phân phối Linux liên kết với Microsoft._

Sau đó trả lời các câu hỏi cấu hình, và xác nhận chúng như thế này:

 ![install-config](images/install-config.webp)

Sau đó chọn một ổ đĩa cho cài đặt của bạn, và ngồi thư giãn xem màn trình diễn cài đặt diễn ra. Quá trình này có thể xong trong chưa đầy một phút trên những máy hiện đại nhanh nhất, nhưng ngay cả trên một máy tính cũ hơn cũng không nên mất quá 5 phút.

 ![install-done](images/install-done.webp)

Giờ bạn đã sẵn sàng dùng Omarchy!

### Hãy dùng bàn phím có dây hoặc 2.4ghz!

Mã hóa toàn bộ đĩa sẽ không cho phép bạn nhập mật khẩu từ bàn phím Bluetooth khi khởi động. Cũng giống như bạn không thể dùng bàn phím Bluetooth để vào BIOS trên PC. Bạn sẽ cần một bàn phím dùng đầu thu 2.4ghz hoặc cáp (dù sao thì độ trễ cũng tốt hơn nhiều!). Cá nhân tôi rất thích [Lofree Flow84](https://www.lofree.co/products/lofree-flow-the-smoothest-mechanical-keyboard)!

### Cài đặt cho một chủ sở hữu khác

Nếu bạn đang thiết lập một chiếc máy cho người khác — một thành viên gia đình, một nhân viên mới, một người mua — bạn không nên trả lời các câu hỏi cá nhân thay cho họ. Nhấn `Ctrl + C` ngay tại màn hình đầu tiên của trình cài đặt (chọn bàn phím), và Omarchy sẽ đề nghị chuẩn bị máy cho một chủ sở hữu khác thay vào đó. Hệ thống sẽ cài đặt ngay lập tức, nhưng toàn bộ thiết lập cá nhân — bố cục bàn phím, tên người dùng, mật khẩu — sẽ được hoãn lại cho đến khi máy khởi động lần đầu tiên. Ổ đĩa vẫn được mã hóa theo mặc định, và mật khẩu chủ sở hữu mới chọn trong lần khởi động đầu tiên đó cũng trở thành mật khẩu mã hóa. (Một chiếc máy bạn đã dùng cũng có thể được bàn giao mà không cần cài đặt lại — xem [đặt lại máy tính](48-security.md).)

### Cài đặt không cần giám sát

ISO cũng có thể tự cài đặt hoàn toàn — không cần bàn phím, không cần trình hướng dẫn — khi nó được cung cấp cấu hình trên một ổ đĩa thứ hai. Đó là cách để coi Omarchy như một ảnh cơ sở cho các VM và các máy trong đội máy. Xem [cài đặt không cần giám sát](51-unattended-installs.md).

### Cài đặt không mã hóa

Omarchy được cài đặt kèm mã hóa theo mặc định. Đó là lựa chọn an toàn, có trách nhiệm cho bất kỳ máy tính nào có thể bị mất hoặc bị đánh cắp. Bạn không muốn bất kỳ ai tiếp cận được phần cứng của bạn cũng có thể lấy được dữ liệu của bạn!

Nhưng trong những trường hợp đặc biệt, như cài đặt Omarchy từ xa trên các máy tính được bảo vệ hoặc cho các cài đặt dùng xong rồi bỏ không chứa dữ liệu nhạy cảm, bạn có thể muốn cài đặt mà không mã hóa. Bạn có thể nhấn `Ctrl + C` tại bước xác nhận định dạng đĩa để chuyển sang cài đặt không mã hóa.

### Ngôn ngữ

Omarchy nói được 50 ngôn ngữ — cùng bộ ngôn ngữ như omarchy.org — và tiếng Anh là mặc định. Để chuyển đổi, hãy mở menu Omarchy và vào _Thiết lập > Ngôn ngữ_, hoặc chạy `omarchy language <code>` trong terminal (`omarchy language list` hiển thị các mã). Menu, desktop, và thông báo của chính Omarchy sẽ đổi ngôn ngữ ngay lập tức, và mọi ứng dụng bạn mở sau đó cũng sẽ theo đó. Các ứng dụng đã mở rồi sẽ chuyển đổi khi bạn khởi động lại chúng.

### Trợ giúp khi bạn bị kẹt

Nếu bạn bị kẹt, bạn thường có thể tìm thấy ai đó sẵn lòng giúp đỡ trong kênh _#omarchy-help_ trên [Discord của cộng đồng](https://omarchy.org/discord).
