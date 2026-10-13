# Điều hướng

Mọi thứ trong Omarchy đều diễn ra qua bàn phím — _MỌI THỨ!_ Khi hệ thống khởi động lần đầu, bạn thực sự không thể làm gì chỉ bằng chuột. Nhưng bạn có thể nhấn `Super + Space` để hiện Menu Omarchy và từ đây bạn có thể làm hầu như mọi thứ.

Nhưng menu Omarchy thậm chí không được dự định là cách chính để vận hành hệ thống trong hầu hết thời gian. Chúng ta có thể nhanh hơn thế! Tất cả các ứng dụng quan trọng nhất đều được gán trực tiếp cho các phím tắt riêng lẻ. Bạn khởi động terminal bằng `Super + Return` và trình duyệt bằng `Super + Shift + Return`. Thử làm cái này rồi đến cái kia, và bạn sẽ thấy điều kỳ diệu của chế độ xếp ô trong Hyprland đang hoạt động:

 ![navigation-browser-terminal](images/navigation-browser-terminal.webp)

Sau đó bạn có thể nhấn `Super + J` để xếp chúng chồng lên nhau thay vì đặt cạnh nhau:

 ![navigation-stacked](images/navigation-stacked.webp)

Nhấn `Super + J` lần nữa để đưa chúng trở lại vị trí cạnh nhau. Sau đó thử `Super + Shift + Arrow Right` khi đang ở trên trình duyệt để hoán đổi các cửa sổ.

Bây giờ thử `Super + Ctrl + T` để khởi động trình giám sát Hoạt động. Nó sẽ xuất hiện dưới dạng cửa sổ nổi. Bạn có thể xếp ô nó bằng `Super + T` (và nhấn lại để biến nó thành nổi trở lại). Bây giờ nhấn `Super + Shift + F` để mở trình quản lý tệp. Bạn sẽ có một bố cục bốn ô gọn gàng:

 ![navigation-fourway-tiling](images/navigation-fourway-tiling.webp)

Bạn điều hướng giữa các cửa sổ mà bạn muốn kích hoạt bằng `Super + Arrow`. Thao tác này sẽ chuyển tiêu điểm và di chuyển con trỏ đến trung tâm của ứng dụng mới.

Nếu bạn nhấn `Super + Shift + 2`, bạn sẽ di chuyển ứng dụng đang được tập trung hiện tại sang không gian làm việc thứ hai. `Super + Shift + 1` di chuyển nó trở lại. (Và `Super + Shift + Alt + 2` sẽ di chuyển ứng dụng đang được tập trung hiện tại sang không gian làm việc thứ hai mà không chuyển sang nó).

Nếu bạn giữ `Super` và dùng chuột để nhấp vào một cửa sổ, bạn sẽ có thể sắp xếp lại vị trí của nó. Nếu bạn giữ `Super` và dùng nút phải trên chuột, bạn có thể tự do thay đổi kích thước cửa sổ.

Bạn đóng một cửa sổ bằng `Super + W` hoặc `Super + Q` (và đóng tất cả cửa sổ bằng `Ctrl + Alt + Delete`).

Bạn cũng có thể chuyển sang toàn màn hình bằng `Super + F` hoặc thậm chí chỉ toàn chiều rộng (giữ lại thanh trên cùng) bằng `Super + Alt + F` hoặc toàn màn hình bên trong một cửa sổ bằng `Super + Ctrl + F` (tốt cho YouTube!).

### Bố cục dwindle so với bố cục cuộn

Bố cục mặc định của Omarchy được gọi là dwindle. Nó giữ tất cả các cửa sổ bạn mở trên một không gian làm việc duy nhất luôn hiển thị, ngay cả khi phải thu nhỏ chúng xuống.

 ![navigation-dwindle-layout](images/navigation-dwindle-layout.webp)

Nhưng bạn cũng có thể chọn biến một không gian làm việc thành bố cục cuộn, nơi các cửa sổ được xếp cạnh nhau, vượt ra ngoài cạnh hiển thị của màn hình. Bạn biến một không gian làm việc duy nhất thành bố cục này qua `Super + L`.

Nhấn `Super + L` lần nữa biến không gian làm việc thành nổi, nơi các cửa sổ chồng lên nhau tự do và bạn tự đặt chúng, và nhấn lần thứ ba đưa nó trở lại dwindle. `Super + Alt + L` đi qua chúng theo chiều ngược lại. Một cửa sổ vẫn nổi dù sao đi nữa — cửa sổ bạn đã bật ra bằng `Super + T`, hoặc một ứng dụng luôn mở ở chế độ nổi — vẫn tiếp tục nổi khi không gian làm việc quay lại chế độ xếp ô. Thanh trên cùng đánh dấu không gian làm việc bạn đang ở bằng bố cục của nó: một hình vuông cho dwindle, một hình tròn cho cuộn, và một hình tam giác cho nổi. Nhấp vào dấu đó cũng chuyển đổi bố cục.

 ![navigation-scrolling-layout](images/navigation-scrolling-layout.webp)

Lựa chọn là theo từng không gian làm việc, và nó được giữ nguyên. Vì vậy bạn có thể giữ không gian làm việc 1 ở dwindle để duyệt web và không gian làm việc 2 ở cuộn để viết code, và chúng sẽ quay lại như vậy sau khi khởi động lại.

Nếu bạn muốn dùng bố cục cuộn làm mặc định, bạn có thể đặt điều đó trong `~/.config/hypr/looknfeel.lua`:

```lua
hl.config({
  general = {
    layout = "scrolling",
  },
})
```

### Không gian làm việc nổi

Một không gian làm việc nổi hoạt động giống như một desktop truyền thống: các cửa sổ chồng lên nhau, và bạn tự di chuyển và định kích thước chúng. Mỗi cửa sổ nhận được một thanh tiêu đề theo màu sắc chủ đề của bạn, với các nút để thu nhỏ, phóng to và đóng. `Super + M` cũng thu nhỏ cửa sổ đang được tập trung. Một cửa sổ đã thu nhỏ chờ trong dock; nhấp vào ứng dụng của nó để đưa nó trở lại. Nhấp vào một cửa sổ để đưa nó ra phía trước. Thay đổi kích thước nó từ bất kỳ cạnh hoặc góc nào. Nhấp đúp vào thanh tiêu đề để phóng to cửa sổ trong khi vẫn giữ thanh trên cùng trong tầm nhìn, và nhấp lại để lấy lại kích thước cũ của nó.

Một không gian làm việc nổi cũng hiển thị một dock, với các ứng dụng đã ghim của bạn, mọi thứ đang chạy, và một lưới mọi ứng dụng đằng sau nút ứng dụng, nút mà `Super + Alt + Space` và _Ứng dụng_ trong menu Omarchy cũng mở. Nhấp chuột phải vào một ứng dụng trên lưới, hoặc nhấn `Delete`, để gỡ cài đặt nó. Nhấp vào một ứng dụng để mở nó, hoặc để đưa cửa sổ của nó ra phía trước; nhấp lại để chuyển qua các cửa sổ của nó. Nhấp chuột giữa mở một cửa sổ mới. Kéo một biểu tượng dọc theo dock để di chuyển nó; kéo một ứng dụng đang chạy vào giữa các ứng dụng khác sẽ giữ nó ở đó. Nhấp chuột phải để giữ một ứng dụng trong dock, lấy nó ra, hoặc thoát nó. Dock tránh đường cho một cửa sổ toàn màn hình. Nhấp chuột phải vào nút ứng dụng để di chuyển dock sang một cạnh khác hoặc để nó ẩn cho đến khi con trỏ chạm tới cạnh của nó. Vị trí cũng nằm trong _Kích hoạt > Giao diện > Dock > Vị trí Dock_, và `omarchy dock position left` và `omarchy dock autohide on` đặt cả hai từ terminal. Các ứng dụng bạn giữ trong dock sẽ mờ đi trong khi chúng không chạy.

Các không gian làm việc mới, và bất kỳ không gian nào bạn chưa cấp bố cục riêng bằng `Super + L`, dùng bố cục mặc định. Thay đổi mặc định đặt lại mọi không gian làm việc không có cửa sổ về bố cục đó, trong khi một không gian có cửa sổ trên đó giữ nguyên bố cục nó có. Chọn nó trong _Kích hoạt > Giao diện > Bố cục không gian làm việc_: Xếp ô, Cuộn, hoặc Nổi. `omarchy-hyprland-workspace-layout-default scrolling` đặt nó từ terminal.

### Nhóm các cửa sổ

Các cửa sổ có thể được nhóm lại bằng `Super + G`. Khi bạn đã ở trong một nhóm, mọi cửa sổ bạn khởi động trong khi nhóm đó đang hoạt động sẽ thuộc về nhóm. Bạn có thể di chuyển giữa các cửa sổ đã nhóm này bằng `Super + Ctrl + Arrow Left/Right` hoặc `Super + Alt + 1/2/3/4` để đi trực tiếp tới cửa sổ đã nhóm theo thứ tự.

Bạn có thể di chuyển một cửa sổ ra khỏi nhóm bằng `Super + Alt + G` hoặc tháo rời toàn bộ nhóm bằng cách nhấn `Super + G` lần nữa. Cuối cùng, bạn có thể di chuyển các cửa sổ bên ngoài nhóm vào trong nó bằng `Super + Alt + Arrows`.

### Bật cửa sổ ra

Bạn có thể bật một cửa sổ ra khỏi phân bổ không gian làm việc của nó bằng `Super + O`. Thao tác đó sẽ ghim nó dưới dạng cửa sổ nổi đi theo bạn tới bất kỳ không gian làm việc nào bạn đến. Tuyệt vời cho các trình phát video và những thứ tương tự.

 ![navigation-popped-window](images/navigation-popped-window.webp)

### Không gian làm việc scratchpad

Cuối cùng, có một không gian làm việc scratchpad đặc biệt thả xuống phía trên bất kỳ không gian làm việc nào bạn đang ở, giống như một bảng điều khiển Quake. Chuyển đổi nó bằng `Super + Grave` hoặc `Super + S`, và đặt một cửa sổ vào đó bằng `Super + Shift + Grave` hoặc `Super + Alt + S`.

Nó hoạt động đặc biệt tốt cho một terminal đang chạy một agent, hoặc cho các điều khiển mà bạn muốn tương tác nhanh chóng mà không rời khỏi không gian làm việc hiện tại. Để di chuyển một cửa sổ ra khỏi scratchpad, gửi nó trực tiếp tới một không gian làm việc khác bằng thứ gì đó như `Super + Shift + 1`.

Trong khi scratchpad chứa một cửa sổ duy nhất, nó thả xuống dưới dạng một bảng ở giữa thay vì trải dài khắp màn hình. Đặt một ứng dụng thứ hai lên nó và nó quay lại chiều rộng đầy đủ, để hai ứng dụng có chỗ ngồi cạnh nhau.

### Cần một chút thời gian để làm quen!

Cần một chút thời gian để làm quen với việc điều hướng desktop của bạn như thế này, nhưng một khi bạn đã quen, sẽ khó để quay lại trải nghiệm desktop truyền thống điều khiển bằng chuột!
