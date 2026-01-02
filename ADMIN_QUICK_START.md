# 📊 Admin Dashboard - Hướng Dẫn Nhanh

## 🎯 Giới Thiệu

Admin Dashboard là một công cụ quản lý toàn diện cho ứng dụng SmartRide, cho phép Quản trị viên:
- 📊 Xem thống kê và báo cáo
- 🏢 Quản lý công ty vận tải
- 🚌 Quản lý chuyến xe
- 👥 Quản lý người dùng
- 📋 Theo dõi hoạt động

## 🚀 Cách Sử Dụng

### Truy Cập Admin Dashboard

```dart
// Từ bất kỳ screen nào
Navigator.pushNamed(context, '/admin');
```

### Hoặc qua HomeScreen
Sau khi đăng nhập với tài khoản Admin, bạn sẽ thấy nút "Admin Dashboard" ở menu

## 📑 Các Tab Chính

### 1️⃣ **Dashboard**
Bảng điều khiển tổng quan với 4 thẻ thông tin:

| Thẻ | Thông Tin |
|-----|-----------|
| 👥 Total Users | Tổng người dùng |
| 🚌 Total Trips | Tổng chuyến xe |
| 💰 Total Revenue | Tổng doanh thu |
| 🏢 Bus Companies | Tổng công ty |

**Recent Activities** - Các hoạt động gần nhất:
- Người dùng mới đăng ký
- Chuyến xe mới tạo
- Vé đặt mới
- Công ty được xác minh

### 2️⃣ **Companies** (Công Ty)

```
┌─────────────────────────────────────┐
│ + Add New Company                   │
├─────────────────────────────────────┤
│ 🏢 Phương Trang                      │
│    0243.333.3333                    │
│                        [Active] [⋮] │
├─────────────────────────────────────┤
│ 🏢 Thành Buôn                        │
│    0243.777.7777                    │
│                        [Active] [⋮] │
└─────────────────────────────────────┘
```

**Chức năng:**
- ➕ **Thêm công ty**: Click "Add New Company"
- ✏️ **Chỉnh sửa**: Click "..." → Edit
- 🗑️ **Xóa**: Click "..." → Delete

**Thông tin cần điền:**
- Tên công ty
- Số điện thoại
- Email
- Địa chỉ

### 3️⃣ **Trips** (Chuyến Xe)

```
┌──────────────────────────────────────┐
│ + Add New Trip                       │
├──────────────────────────────────────┤
│ Hà Nội → TP. Hồ Chí Minh   [Active] │
│ Phương Trang                         │
│ 08:00 - 16:30       350.000đ         │
│ 20/25 seats                      [⋮] │
├──────────────────────────────────────┤
│ Hà Nội → Đà Nẵng              [Active]│
│ Thành Buôn                           │
│ 10:00 - 18:00       320.000đ         │
│ 15/25 seats                      [⋮] │
└──────────────────────────────────────┘
```

**Chức năng:**
- ➕ **Thêm chuyến**: Click "Add New Trip"
- ✏️ **Chỉnh sửa**: Click "..." → Edit
- 🗑️ **Xóa**: Click "..." → Delete

**Thông tin cần điền:**
- Công ty vận tải
- Thành phố khởi hành
- Thành phố đến
- Thời gian khởi hành
- Giá vé
- Số ghế (tổng)

### 4️⃣ **Users** (Người Dùng)

```
┌─────────────────────────────────────┐
│ 🔍 Search users...                  │
├─────────────────────────────────────┤
│ N Nguyễn Văn A                      │
│   nguyenvana@gmail.com              │
│   5 bookings              [Active]   │
├─────────────────────────────────────┤
│ T Trần Thị B                        │
│   tranthib@gmail.com                │
│   3 bookings              [Active]   │
└─────────────────────────────────────┘
```

**Chức năng:**
- 🔍 **Tìm kiếm**: Nhập tên hoặc email người dùng
- 🔄 **Kích hoạt/Vô hiệu**: Click trạng thái để thay đổi
- 📊 **Xem chi tiết**: Click người dùng để xem toàn bộ thông tin

## 🎨 Màu Sắc & Biểu Tượng

| Yếu Tố | Màu | Ý Nghĩa |
|--------|-----|---------|
| Primary | 🔴 Deep Red (#A82626) | Hành động chính |
| Active | 🟢 Green | Trạng thái hoạt động |
| Inactive | 🔴 Red | Bị vô hiệu hóa |
| Revenue | 🟠 Orange | Doanh thu |
| Users | 🔵 Blue | Người dùng |
| Trips | 🟢 Green | Chuyến xe |

## 💡 Tips & Tricks

### 1. **Tìm Kiếm Nhanh**
- Dùng tìm kiếm ở tab Users để tìm người dùng cụ thể
- Lọc theo tên, email, hoặc số điện thoại

### 2. **Quản Lý Công Ty**
- Khi thêm công ty, đảm bảo nhập đủ thông tin
- Có thể vô hiệu hóa công ty thay vì xóa

### 3. **Quản Lý Chuyến Xe**
- Chuyến xe phải thuộc về một công ty đã tồn tại
- Số ghế không thể nhỏ hơn số ghế đã đặt

### 4. **Quản Lý Người Dùng**
- Kích hoạt/Vô hiệu hóa tài khoản người dùng
- Xem số lượng vé đã đặt
- Theo dõi ngày tạo tài khoản

## ⚠️ Cảnh Báo Quan Trọng

### Xóa Dữ Liệu
- ⚠️ **KHÔNG THỂ PHỤC HỒI** sau khi xóa
- Luôn có dialog xác nhận trước khi xóa
- Nên vô hiệu hóa thay vì xóa

### Chỉnh Sửa Dữ Liệu
- ✅ Luôn kiểm tra thông tin trước khi lưu
- ✅ Xác nhận khi có thay đổi quan trọng
- ✅ Cập nhật giá vé khi cần

### Cấp Quyền
- 👤 Chỉ **Admin** mới có thể truy cập
- 🔐 Cần đăng nhập với tài khoản Admin
- 🛡️ Tất cả hành động được ghi log

## 🔄 Quy Trình Thêm Công Ty

1. Nhấn **"+ Add New Company"**
2. Điền **Tên công ty** (VD: Phương Trang Express)
3. Nhập **Số điện thoại** (VD: 0243.333.3333)
4. Nhập **Email** (VD: info@phuongtrang.com)
5. Nhập **Địa chỉ** (VD: 123 Đường A, Hà Nội)
6. Nhấn **"Add Company"**

## 🔄 Quy Trình Thêm Chuyến Xe

1. Nhấn **"+ Add New Trip"**
2. Chọn **Công ty vận tải** (VD: Phương Trang)
3. Nhập **Thành phố khởi hành** (VD: Hà Nội)
4. Nhập **Thành phố đến** (VD: TP. Hồ Chí Minh)
5. Nhập **Thời gian khởi hành** (VD: 08:00)
6. Nhập **Giá vé** (VD: 350000)
7. Nhấn **"Add Trip"**

## 📞 Hỗ Trợ

### Có Vấn Đề?
- 🔍 Kiểm tra kết nối internet
- 🔄 Tải lại ứng dụng
- 🗑️ Xóa bộ nhớ cache ứng dụng

### Liên Hệ Admin
- 📧 Email: admin@smartride.com
- 📱 Điện thoại: 0243.333.3333
- 💬 Chat: Messenger

## 📚 Tài Liệu Thêm

- **API Documentation**: Xem `ADMIN_IMPLEMENTATION_GUIDE.md`
- **Technical Docs**: Xem `ADMIN_DASHBOARD.md`
- **FAQs**: Cập nhật sớm...

---

**Version**: 1.0.0  
**Last Updated**: 02 Jan 2026  
**Status**: ✅ In Production
