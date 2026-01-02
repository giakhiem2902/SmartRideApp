class AdminStats {
  final int totalUsers;
  final int totalTrips;
  final double totalRevenue;
  final int totalCompanies;

  AdminStats({
    required this.totalUsers,
    required this.totalTrips,
    required this.totalRevenue,
    required this.totalCompanies,
  });

  factory AdminStats.fromJson(Map<String, dynamic> json) {
    return AdminStats(
      totalUsers: json['totalUsers'] ?? 0,
      totalTrips: json['totalTrips'] ?? 0,
      totalRevenue: (json['totalRevenue'] ?? 0).toDouble(),
      totalCompanies: json['totalCompanies'] ?? 0,
    );
  }
}

class BusCompanyAdmin {
  final int id;
  final String name;
  final String phone;
  final String email;
  final String address;
  final bool isActive;

  BusCompanyAdmin({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.isActive,
  });

  factory BusCompanyAdmin.fromJson(Map<String, dynamic> json) {
    return BusCompanyAdmin(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      isActive: json['isActive'] ?? false,
    );
  }
}

class TripAdmin {
  final int id;
  final String departureCity;
  final String arrivalCity;
  final String company;
  final String departureTime;
  final String arrivalTime;
  final double price;
  final int totalSeats;
  final int bookedSeats;
  final bool isActive;

  TripAdmin({
    required this.id,
    required this.departureCity,
    required this.arrivalCity,
    required this.company,
    required this.departureTime,
    required this.arrivalTime,
    required this.price,
    required this.totalSeats,
    required this.bookedSeats,
    required this.isActive,
  });

  int get availableSeats => totalSeats - bookedSeats;

  factory TripAdmin.fromJson(Map<String, dynamic> json) {
    return TripAdmin(
      id: json['id'] ?? 0,
      departureCity: json['departureCity'] ?? '',
      arrivalCity: json['arrivalCity'] ?? '',
      company: json['company'] ?? '',
      departureTime: json['departureTime'] ?? '',
      arrivalTime: json['arrivalTime'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      totalSeats: json['totalSeats'] ?? 0,
      bookedSeats: json['bookedSeats'] ?? 0,
      isActive: json['isActive'] ?? false,
    );
  }
}

class UserAdmin {
  final int id;
  final String name;
  final String email;
  final String phone;
  final int bookingCount;
  final bool isActive;
  final DateTime createdAt;

  UserAdmin({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.bookingCount,
    required this.isActive,
    required this.createdAt,
  });

  factory UserAdmin.fromJson(Map<String, dynamic> json) {
    return UserAdmin(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      bookingCount: json['bookingCount'] ?? 0,
      isActive: json['isActive'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }
}

class ActivityLog {
  final int id;
  final String title;
  final String subtitle;
  final String timestamp;
  final String type;

  ActivityLog({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.timestamp,
    required this.type,
  });

  factory ActivityLog.fromJson(Map<String, dynamic> json) {
    return ActivityLog(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      timestamp: json['timestamp'] ?? '',
      type: json['type'] ?? '',
    );
  }
}
