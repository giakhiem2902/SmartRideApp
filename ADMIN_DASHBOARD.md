# Admin Dashboard - SmartRide

## Tổng quan

Admin Dashboard là một giao diện quản lý toàn bộ ứng dụng SmartRide với 4 tab chính:

### 1. **Dashboard Tab** (Bảng Điều Khiển)
- Hiển thị thống kê tổng quan:
  - **Total Users**: Tổng số người dùng đã đăng ký
  - **Total Trips**: Tổng số chuyến xe
  - **Total Revenue**: Tổng doanh thu
  - **Bus Companies**: Tổng số công ty vận tải
- **Recent Activities**: Các hoạt động gần đây (người dùng mới, chuyến xe mới, vé đặt, công ty xác minh)

### 2. **Companies Tab** (Quản Lý Công Ty)
- Danh sách tất cả các công ty vận tải
- **Chức năng**:
  - ➕ **Add New Company**: Thêm công ty mới
  - ✏️ **Edit**: Chỉnh sửa thông tin công ty
  - 🗑️ **Delete**: Xóa công ty
- **Thông tin hiển thị**:
  - Tên công ty
  - Số điện thoại
  - Email
  - Trạng thái (Active/Inactive)

### 3. **Trips Tab** (Quản Lý Chuyến Xe)
- Danh sách tất cả chuyến xe
- **Chức năng**:
  - ➕ **Add New Trip**: Thêm chuyến xe mới
  - ✏️ **Edit**: Chỉnh sửa thông tin chuyến xe
  - 🗑️ **Delete**: Xóa chuyến xe
- **Thông tin hiển thị**:
  - Tuyến đường (Từ - Đến)
  - Công ty vận tải
  - Thời gian đi/đến
  - Giá vé
  - Số ghế đã đặt/Tổng ghế
  - Trạng thái (Active/Inactive)

### 4. **Users Tab** (Quản Lý Người Dùng)
- Danh sách người dùng đã đăng ký
- **Chức năng**:
  - 🔍 **Search**: Tìm kiếm người dùng
  - 🔄 **Toggle Status**: Kích hoạt/Vô hiệu hóa tài khoản người dùng
- **Thông tin hiển thị**:
  - Tên người dùng
  - Email
  - Số lượng vé đã đặt
  - Trạng thái tài khoản

## Cấu trúc File

```
lib/
├── screens/
│   └── admin_dashboard_screen.dart       # Main Admin Dashboard screen
├── models/
│   └── admin_model.dart                  # Data models cho Admin features
├── providers/
│   └── admin_provider.dart               # State management cho Admin
└── main.dart                              # Route: '/admin'
```

## Models

### **AdminStats**
```dart
AdminStats(
  totalUsers: int,
  totalTrips: int,
  totalRevenue: double,
  totalCompanies: int,
)
```

### **BusCompanyAdmin**
```dart
BusCompanyAdmin(
  id: int,
  name: String,
  phone: String,
  email: String,
  address: String,
  isActive: bool,
)
```

### **TripAdmin**
```dart
TripAdmin(
  id: int,
  departureCity: String,
  arrivalCity: String,
  company: String,
  departureTime: String,
  arrivalTime: String,
  price: double,
  totalSeats: int,
  bookedSeats: int,
  isActive: bool,
)
```

### **UserAdmin**
```dart
UserAdmin(
  id: int,
  name: String,
  email: String,
  phone: String,
  bookingCount: int,
  isActive: bool,
  createdAt: DateTime,
)
```

### **ActivityLog**
```dart
ActivityLog(
  id: int,
  title: String,
  subtitle: String,
  timestamp: String,
  type: String,
)
```

## AdminProvider Methods

### **Load Data**
- `loadDashboardStats()`: Tải thống kê bảng điều khiển
- `loadCompanies()`: Tải danh sách công ty
- `loadTrips()`: Tải danh sách chuyến xe
- `loadUsers()`: Tải danh sách người dùng

### **Company Management**
- `addCompany({...})`: Thêm công ty mới
- `editCompany({...})`: Chỉnh sửa công ty
- `deleteCompany(int id)`: Xóa công ty

### **Trip Management**
- `addTrip({...})`: Thêm chuyến xe mới
- `deleteTrip(int id)`: Xóa chuyến xe

### **User Management**
- `toggleUserStatus(int userId)`: Kích hoạt/vô hiệu hóa người dùng

### **State**
- `isLoading`: Trạng thái đang tải
- `error`: Thông báo lỗi
- `clearError()`: Xóa thông báo lỗi

## Cách Sử Dụng

### Truy cập Admin Dashboard
```dart
Navigator.pushNamed(context, '/admin');
```

### Trong Widget
```dart
Consumer<AdminProvider>(
  builder: (context, adminProvider, _) {
    final companies = adminProvider.companies;
    // Sử dụng dữ liệu
  },
)
```

### Tải dữ liệu
```dart
WidgetsBinding.instance.addPostFrameCallback((_) {
  context.read<AdminProvider>().loadCompanies();
});
```

## API Integration (TODO)

Hiện tại AdminProvider sử dụng dữ liệu mocked. Cần tích hợp với các endpoint API:

**Backend Endpoints cần tạo:**
```
GET  /api/admin/stats              # Lấy thống kê
GET  /api/admin/companies          # Lấy danh sách công ty
POST /api/admin/companies          # Thêm công ty
PUT  /api/admin/companies/{id}     # Chỉnh sửa công ty
DELETE /api/admin/companies/{id}   # Xóa công ty

GET  /api/admin/trips              # Lấy danh sách chuyến xe
POST /api/admin/trips              # Thêm chuyến xe
DELETE /api/admin/trips/{id}       # Xóa chuyến xe

GET  /api/admin/users              # Lấy danh sách người dùng
PUT  /api/admin/users/{id}/status  # Thay đổi trạng thái người dùng

GET  /api/admin/activities         # Lấy logs hoạt động
```

## Theme Integration

Admin Dashboard sử dụng AppTheme với:
- **Primary Color**: `AppTheme.primaryRed` (#A82626)
- **Spacing**: `AppTheme.spacingMedium`, `AppTheme.spacingLarge`
- **Widgets**: `AppCard`, `AppButton` từ app_widgets.dart

## Features

✅ Bảng điều khiển với thống kê tổng quan
✅ Quản lý công ty vận tải (Add/Edit/Delete)
✅ Quản lý chuyến xe (Add/Edit/Delete)
✅ Quản lý người dùng (Kích hoạt/Vô hiệu hóa)
✅ Tìm kiếm người dùng
✅ Logs hoạt động gần đây
✅ Responsive Design
✅ Provider State Management

## Cải Tiến Tiếp Theo

- [ ] API integration cho tất cả endpoints
- [ ] Real-time data updates
- [ ] Advanced filtering & search
- [ ] Data export (CSV/PDF)
- [ ] Analytics charts
- [ ] Permission-based access control
- [ ] Activity logs with detailed tracking
- [ ] Batch operations (delete multiple)
- [ ] Notifications system
- [ ] Admin audit trail

## Security Notes

- Admin Dashboard chỉ có thể truy cập với role "Admin"
- Cần implement role-based authorization
- Tất cả API calls cần JWT token
- Validate input dữ liệu trước khi gửi lên server
