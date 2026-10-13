# Xác thực phần cứng

### Xác thực bằng vân tay

Rất nhiều laptop đi kèm cảm biến vân tay để xác thực. Bạn có thể dùng tính năng này với Omarchy bằng cách chạy _Thiết lập > Bảo mật > Vân tay_ trong menu Omarchy (`Super + Space`).

Việc đó sẽ cài đặt gói vân tay, thu thập dấu vân tay của bạn, xác minh nó, và bạn sẽ sẵn sàng dùng vân tay để mở khóa từ màn hình khóa (mà bạn có thể kích hoạt bằng `Super + Ctrl + L`), vào chế độ sudo và cấp quyền cho các lời nhắc của hệ thống.

Khi nắp laptop của bạn đóng, lời nhắc vân tay sẽ tự động bị bỏ qua, nên bạn đi thẳng tới lời nhắc mật khẩu thay vì chờ một cảm biến mà bạn không với tới được. Nếu bạn cần làm việc trên một bàn phím ngoài không có cảm biến, chỉ cần nhấn `CTRL + C` khi bạn được nhắc nhập vân tay trong lúc dùng `sudo`.

Bạn có thể gỡ bỏ xác thực bằng vân tay dưới _Gỡ bỏ > Bảo mật > Vân tay_ trong menu Omarchy.

### Xác thực Fido2

Nếu bạn đang dùng một thiết bị Fido2, bạn có thể thiết lập nó cho xác thực `sudo` bằng _Thiết lập > Bảo mật > Fido2_ trong menu Omarchy (`Super + Space`). Tuy nhiên, nó bao quát `sudo` và các lời nhắc cấp quyền của hệ thống, chứ không phải mở khóa máy tính của bạn.

Bạn có thể gỡ bỏ xác thực fido2 dưới _Gỡ bỏ > Bảo mật > Fido2_ trong menu Omarchy.
