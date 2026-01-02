import 'package:flutter/material.dart';
import '../models/admin_model.dart';
import '../services/api_service.dart';

class AdminProvider extends ChangeNotifier {
  final ApiService apiService;

  AdminProvider({required this.apiService});

  // State
  AdminStats? _stats;
  List<BusCompanyAdmin> _companies = [];
  List<TripAdmin> _trips = [];
  List<UserAdmin> _users = [];
  List<ActivityLog> _activities = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  AdminStats? get stats => _stats;
  List<BusCompanyAdmin> get companies => _companies;
  List<TripAdmin> get trips => _trips;
  List<UserAdmin> get users => _users;
  List<ActivityLog> get activities => _activities;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load Dashboard Stats
  Future<void> loadDashboardStats() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await apiService.getAdminStats();

      if (response['success'] == true && response['data'] != null) {
        final data = response['data'];
        _stats = AdminStats(
          totalUsers: data['totalUsers'] ?? 0,
          totalTrips: data['totalTrips'] ?? 0,
          totalRevenue: (data['totalRevenue'] ?? 0).toDouble(),
          totalCompanies: data['totalCompanies'] ?? 0,
        );
      } else {
        _error = response['message'] ?? 'Failed to load stats';
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load dashboard stats: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load Companies
  Future<void> loadCompanies() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await apiService.getAdminCompanies();

      if (response['success'] == true && response['data'] != null) {
        final companiesData = response['data'] as List<dynamic>? ?? [];
        _companies = companiesData.map((c) {
          return BusCompanyAdmin(
            id: c['id'] ?? 0,
            name: c['name'] ?? '',
            phone: c['phoneNumber'] ?? '',
            email: c['email'] ?? '',
            address: c['address'] ?? '',
            isActive: c['isActive'] ?? true,
          );
        }).toList();
      } else {
        _error = response['message'] ?? 'Failed to load companies';
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load companies: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load Trips
  Future<void> loadTrips() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await apiService.getAdminTrips();

      if (response['success'] == true && response['data'] != null) {
        final tripsData = response['data'] as List<dynamic>? ?? [];
        _trips = tripsData.map((t) {
          return TripAdmin(
            id: t['id'] ?? 0,
            departureCity: t['departureCity'] ?? '',
            arrivalCity: t['arrivalCity'] ?? '',
            company: t['companyName'] ?? '',
            departureTime: _formatTime(t['departureTime']),
            arrivalTime: _formatTime(t['arrivalTime']),
            price: (t['price'] ?? 0).toDouble(),
            totalSeats: t['totalSeats'] ?? 0,
            bookedSeats: t['bookedSeats'] ?? 0,
            isActive: t['isActive'] ?? true,
          );
        }).toList();
      } else {
        _error = response['message'] ?? 'Failed to load trips';
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load trips: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  String _formatTime(dynamic dateTime) {
    if (dateTime == null) return '--:--';
    try {
      if (dateTime is String) {
        final dt = DateTime.parse(dateTime);
        return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
      }
      return '--:--';
    } catch (e) {
      return '--:--';
    }
  }

  // Load Users
  Future<void> loadUsers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await apiService.getAdminUsers();

      if (response['success'] == true && response['data'] != null) {
        final usersData = response['data'] as List<dynamic>? ?? [];
        _users = usersData.map((u) {
          return UserAdmin(
            id: u['id'] ?? 0,
            name: u['fullName'] ?? u['userName'] ?? '',
            email: u['email'] ?? '',
            phone: u['phoneNumber'] ?? '',
            bookingCount: 0,
            isActive: u['isActive'] ?? true,
            createdAt: _parseDate(u['createdAt']),
          );
        }).toList();
      } else {
        _error = response['message'] ?? 'Failed to load users';
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load users: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  DateTime _parseDate(dynamic date) {
    if (date == null) return DateTime.now();
    try {
      if (date is String) {
        return DateTime.parse(date);
      }
      return DateTime.now();
    } catch (e) {
      return DateTime.now();
    }
  }

  // Add Company
  Future<bool> addCompany({
    required String name,
    required String phone,
    required String email,
    required String address,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Call actual API endpoint
      await Future.delayed(const Duration(milliseconds: 500));

      final newCompany = BusCompanyAdmin(
        id: _companies.length + 1,
        name: name,
        phone: phone,
        email: email,
        address: address,
        isActive: true,
      );

      _companies.add(newCompany);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to add company: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Edit Company
  Future<bool> editCompany({
    required int id,
    required String name,
    required String phone,
    required String email,
    required String address,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Call actual API endpoint
      await Future.delayed(const Duration(milliseconds: 500));

      final index = _companies.indexWhere((c) => c.id == id);
      if (index != -1) {
        _companies[index] = BusCompanyAdmin(
          id: id,
          name: name,
          phone: phone,
          email: email,
          address: address,
          isActive: _companies[index].isActive,
        );
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to edit company: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Delete Company
  Future<bool> deleteCompany(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Call actual API endpoint
      await Future.delayed(const Duration(milliseconds: 500));

      _companies.removeWhere((c) => c.id == id);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to delete company: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Add Trip
  Future<bool> addTrip({
    required String departureCity,
    required String arrivalCity,
    required String company,
    required String departureTime,
    required String arrivalTime,
    required double price,
    required int totalSeats,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Call actual API endpoint
      await Future.delayed(const Duration(milliseconds: 500));

      final newTrip = TripAdmin(
        id: _trips.length + 1,
        departureCity: departureCity,
        arrivalCity: arrivalCity,
        company: company,
        departureTime: departureTime,
        arrivalTime: arrivalTime,
        price: price,
        totalSeats: totalSeats,
        bookedSeats: 0,
        isActive: true,
      );

      _trips.add(newTrip);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to add trip: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Delete Trip
  Future<bool> deleteTrip(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Call actual API endpoint
      await Future.delayed(const Duration(milliseconds: 500));

      _trips.removeWhere((t) => t.id == id);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to delete trip: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Toggle User Status
  Future<bool> toggleUserStatus(int userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Call actual API endpoint
      await Future.delayed(const Duration(milliseconds: 500));

      final index = _users.indexWhere((u) => u.id == userId);
      if (index != -1) {
        final user = _users[index];
        _users[index] = UserAdmin(
          id: user.id,
          name: user.name,
          email: user.email,
          phone: user.phone,
          bookingCount: user.bookingCount,
          isActive: !user.isActive,
          createdAt: user.createdAt,
        );
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to update user status: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
