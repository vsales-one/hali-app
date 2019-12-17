# Hali

Hali là ứng dụng hướng tới giảm sự lãng phí trong cộng đồng bằng cách kết nối mỗi người và khuyến khích chia sẽ. Bạn cho đi các món đồ
mà bạn không dùng nữa hoặc là thực phẩm mà bạn dư ra.

## Getting Started

- Ứng dụng published trên [Google Play Store tại link](https://play.google.com/store/apps/details?id=vn.happylife.hali)

- Bạn có thể chạy ứng dụng từ source code. 

- Ứng dụng này có thể sử dụng với backend tự host, [mã nguồn của backend api ở đây](https://github.com/vsales-one/hali-api)

- Ứng dụng cũng có thể chạy ở chế độ không cần backend api, dữ liệu lưu trữ vào firestore

- Để chạy ứng dụng từ mã nguồn đầu tiên bạn cần tạo app trên firebase và tải về 2 file GoogleService-Info.plist cho iOS và google-services.json. Trên iOS file GoogleService-Info.plist đặt vào thư mục **/ios/GoogleService-Info.plist còn trên Android file google-services.json đặt vào thư mục **/android/app/google-services.json

- Nếu dữ liệu lưu trữ trên filestore thì bạn cần tạo 1 số composite index [theo như hình này](https://firebasestorage.googleapis.com/v0/b/hali-ca190.appspot.com/o/public_images%2FScreen%20Shot%202019-12-14%20at%2011.39.40%20PM.png?alt=media&token=953cfe02-42cd-4946-bd80-beb01978a071)

