class AppConstants {
  // App Info
  static const String appName = 'SmartRide';
  static const String appVersion = '1.0.0';
  static const String appBuild = '1';

  // API
  static const String baseUrl = 'http://localhost:5000/api';
  static const int connectTimeout = 5000; // ms
  static const int receiveTimeout = 5000; // ms

  // Routes
  static const String routeLogin = '/login';
  static const String routeRegister = '/register';
  static const String routeHome = '/home';
  static const String routeSearch = '/search';
  static const String routeSeats = '/seats';
  static const String routeTickets = '/tickets';
  static const String routeTicketDetail = '/tickets/:id';
  static const String routeManager = '/manager';
  static const String routeAdmin = '/admin';
  static const String routeProfile = '/profile';

  // Storage Keys
  static const String keyAuthToken = 'auth_token';
  static const String keyUser = 'user_data';
  static const String keyLanguage = 'language';
  static const String keyTheme = 'theme_mode';

  // UI Constants
  static const double radiusSmall = 4.0;
  static const double radiusMedium = 8.0;
  static const double radiusLarge = 16.0;

  static const double spacingXSmall = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;
  static const double spacingXLarge = 32.0;

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxSeatsPerBooking = 7;

  // Seat Status
  static const String seatAvailable = 'Available';
  static const String seatBooked = 'Booked';
  static const String seatReserved = 'Reserved';

  // Ticket Status
  static const String ticketPending = 'Pending';
  static const String ticketConfirmed = 'Confirmed';
  static const String ticketUsed = 'Used';
  static const String ticketCancelled = 'Cancelled';

  // Roles
  static const String roleAdmin = 'Admin';
  static const String roleManager = 'Manager';
  static const String roleUser = 'User';

  // Vietnamese Provinces (Sample)
  static const List<String> vietnamProvinces = [
    'Hà Nội',
    'Hồ Chí Minh',
    'Đà Nẵng',
    'Hải Phòng',
    'Cần Thơ',
    'Biên Hòa',
    'Hải Dương',
    'Khánh Hòa',
    'Quảng Ninh',
    'Bắc Ninh',
    'Hưng Yên',
    'Thái Bình',
    'Vĩnh Phúc',
    'Lâm Đồng',
    'Đồng Nai',
    'Bình Dương',
    'Kiên Giang',
    'An Giang',
    'Tiền Giang',
    'Long An',
  ];

  // Messages
  static const String msgLoadingError = 'Có lỗi khi tải dữ liệu';
  static const String msgNetworkError = 'Lỗi kết nối mạng';
  static const String msgNoInternetConnection = 'Không có kết nối internet';
  static const String msgServerError = 'Lỗi máy chủ';
  static const String msgUnauthorized = 'Vui lòng đăng nhập lại';
  static const String msgSuccess = 'Thành công';
  static const String msgFailed = 'Thất bại';
  static const String msgConfirm = 'Xác nhận';
  static const String msgCancel = 'Hủy';
  static const String msgDelete = 'Xóa';
  static const String msgEdit = 'Sửa';
  static const String msgAdd = 'Thêm';
  static const String msgSave = 'Lưu';
  static const String msgClose = 'Đóng';
  static const String msgBack = 'Quay lại';

  // Empty States
  static const String msgEmptyTickets = 'Bạn chưa có vé nào';
  static const String msgEmptyTrips = 'Không tìm thấy chuyến xe nào';
  static const String msgEmptySearchResults = 'Không tìm thấy kết quả phù hợp';

  // Validations
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 20;
  static const int minNameLength = 2;
  static const int maxNameLength = 100;

  // Regex Patterns
  static final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static final RegExp phoneRegex = RegExp(r'^(\+84|0)[0-9]{9,10}$');
}

// Error Messages
class ErrorMessages {
  static const String invalidEmail = 'Email không hợp lệ';
  static const String invalidPassword = 'Mật khẩu phải có ít nhất 6 ký tự';
  static const String passwordsDoNotMatch = 'Mật khẩu không trùng khớp';
  static const String userNotFound = 'Người dùng không tồn tại';
  static const String invalidCredentials = 'Email hoặc mật khẩu không đúng';
  static const String emailAlreadyExists = 'Email đã tồn tại';
  static const String userNameAlreadyExists = 'Tên người dùng đã tồn tại';
  static const String registrationFailed = 'Đăng ký thất bại';
  static const String loginFailed = 'Đăng nhập thất bại';
  static const String tripNotFound = 'Chuyến xe không tồn tại';
  static const String seatsNotAvailable = 'Ghế không còn trống';
  static const String maxSeatsExceeded = 'Tối đa 7 ghế mỗi chuyến';
  static const String ticketNotFound = 'Vé không tồn tại';
  static const String bookingFailed = 'Đặt vé thất bại';
  static const String cancellationFailed = 'Hủy vé thất bại';
}

// Success Messages
class SuccessMessages {
  static const String registrationSuccess = 'Đăng ký thành công';
  static const String loginSuccess = 'Đăng nhập thành công';
  static const String logoutSuccess = 'Đăng xuất thành công';
  static const String bookingSuccess = 'Đặt vé thành công';
  static const String cancellationSuccess = 'Hủy vé thành công';
  static const String updateSuccess = 'Cập nhật thành công';
  static const String deleteSuccess = 'Xóa thành công';
  static const String confirmSuccess = 'Xác nhận thành công';
}
