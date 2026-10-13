# Bắt đầu

Omarchy được cài đặt bằng một tệp ISO. Bạn có thể chọn giữa cài đặt toàn ổ đĩa, chiếm toàn bộ ổ đĩa, hoặc cài đặt vào vùng trống, đặt Omarchy vào vùng chưa được phân bổ trên ổ đĩa — đó là cách bạn khởi động kép cùng với Windows hoặc một hệ điều hành khác (xem [cài đặt khởi động kép](50-dual-boot-install.md) — lưu ý rằng trước tiên bạn cần tắt BitLocker trong Windows). Dù bằng cách nào, quá trình cài đặt cũng mặc định mã hóa toàn bộ, và tùy chọn toàn ổ đĩa sẽ xóa sạch ổ đĩa đã chọn, vì vậy hãy chắc chắn sao lưu trước khi sử dụng một ổ đĩa hiện có!

Trước tiên hãy [tải tệp ISO của Omarchy](https://omarchy.org/), chép nó vào một thẻ USB (dùng [balenaEtcher](https://etcher.balena.io/) trên Mac/Windows hoặc [caligula](https://github.com/ifd3f/caligula) trên Linux), và khởi động từ thẻ USB.

_Bạn phải tắt Secure Boot và/hoặc TPM trong BIOS. Bạn phải tắt những thứ này mới có thể cài đặt Omarchy. Chúng là các cơ chế bảo mật của Microsoft dành cho Windows và các bản phân phối Linux liên kết với Microsoft._

Sau đó trả lời các câu hỏi cấu hình, và xác nhận chúng như thế này:

 ![install-config](images/install-config.webp)

Sau đó chọn một ổ đĩa cho quá trình cài đặt của bạn, ngồi lại và xem màn trình diễn cài đặt diễn ra. Nó có thể hoàn thành trong chưa đầy một phút trên những máy hiện đại nhanh nhất, nhưng ngay cả trên một máy tính cũ hơn cũng không nên mất quá 5 phút.

 ![install-done](images/install-done.webp)

Giờ bạn đã sẵn sàng để dùng Omarchy!

### Hãy dùng bàn phím có dây hoặc bàn phím 2.4ghz!

Mã hóa toàn ổ đĩa sẽ không cho phép bạn nhập mật khẩu từ bàn phím Bluetooth khi khởi động. Giống như bạn không thể dùng bàn phím Bluetooth để vào BIOS trên PC vậy. Bạn sẽ cần một bàn phím dùng đầu thu 2.4ghz hoặc dây cáp (dù sao thì cách này cũng tốt hơn nhiều về độ trễ!). Cá nhân tôi rất thích [Lofree Flow84](https://www.lofree.co/products/lofree-flow-the-smoothest-mechanical-keyboard)!

### Cài đặt cho một chủ sở hữu khác

Nếu bạn đang thiết lập máy cho người khác — một thành viên gia đình, một nhân viên mới, một người mua — bạn không nên trả lời các câu hỏi cá nhân thay cho họ. Nhấn `Ctrl + C` ngay trên màn hình đầu tiên của trình cài đặt (phần chọn bàn phím), và Omarchy sẽ đề nghị chuẩn bị máy cho một chủ sở hữu khác thay vào đó. Hệ thống được cài đặt ngay lập tức, nhưng mọi thiết lập cá nhân — bố cục bàn phím, tên người dùng, mật khẩu — được hoãn lại cho đến khi máy khởi động lần đầu tiên. Ổ đĩa vẫn được mã hóa theo mặc định, và mật khẩu mà chủ sở hữu mới chọn trong lần khởi động đầu tiên đó cũng trở thành mật khẩu mã hóa. (Một máy mà bạn đã sử dụng cũng có thể được bàn giao mà không cần cài đặt lại — xem [đặt lại máy tính](48-security.md).)

### Cài đặt không cần giám sát

Tệp ISO cũng có thể tự cài đặt hoàn toàn — không cần bàn phím, không cần trình hướng dẫn — khi nó được cung cấp cấu hình trên một ổ đĩa thứ hai. Đó là cách để coi Omarchy như một hình ảnh cơ sở cho các máy ảo và dàn máy. Xem [cài đặt không cần giám sát](51-unattended-installs.md).

### Cài đặt không mã hóa

Omarchy được cài đặt với mã hóa theo mặc định. Đó là lựa chọn an toàn và có trách nhiệm cho bất kỳ máy tính nào có thể bị mất hoặc bị đánh cắp. Bạn không muốn bất kỳ ai có quyền truy cập vào phần cứng của mình cũng có thể lấy được dữ liệu của bạn!

Nhưng trong những hoàn cảnh đặc biệt, như cài đặt Omarchy từ xa trên các máy tính được bảo vệ hoặc cho các cài đặt dùng một lần không có dữ liệu nhạy cảm, bạn có thể muốn cài đặt mà không mã hóa. Bạn có thể nhấn `Ctrl + C` tại bước xác nhận định dạng ổ đĩa để chuyển sang cài đặt không mã hóa.

### Ngôn ngữ

Omarchy nói được 50 ngôn ngữ — cùng bộ ngôn ngữ như omarchy.org — và tiếng Anh là ngôn ngữ mặc định. Để chuyển đổi, mở menu Omarchy và đi tới _Thiết lập > Ngôn ngữ_, hoặc chạy `omarchy language <code>` trong terminal (`omarchy language list` hiển thị các mã). Menu, desktop và các thông báo của riêng Omarchy thay đổi ngôn ngữ ngay lập tức, và ngôn ngữ hệ thống được đặt cho khớp, vì vậy các ứng dụng khác của bạn sẽ theo sau vào lần đăng nhập tiếp theo.

### Trợ giúp nếu bạn bị kẹt

Nếu bạn bị kẹt, bạn thường có thể tìm thấy ai đó sẵn lòng giúp đỡ trong kênh _#omarchy-help_ trên [Discord cộng đồng](https://omarchy.org/discord).
