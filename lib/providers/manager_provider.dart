import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ManagerProvider extends ChangeNotifier {
  final ApiService apiService;

  ManagerProvider({required this.apiService});

  // State
  List<ManagerTrip> _trips = [];
  List<PassengerInfo> _passengers = [];
  PassengerDetail? _selectedPassenger;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<ManagerTrip> get trips => _trips;
  List<PassengerInfo> get passengers => _passengers;
  PassengerDetail? get selectedPassenger => _selectedPassenger;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load all trips for manager
  Future<void> loadManagerTrips() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await apiService.getManagerTrips();

      if (response['success'] == true && response['data'] != null) {
        final tripsData = response['data'] as List<dynamic>? ?? [];
        _trips = tripsData.map((t) {
          return ManagerTrip(
            id: t['id'] ?? 0,
            departureCity: t['departureCity'] ?? '',
            arrivalCity: t['arrivalCity'] ?? '',
            departureTime: _parseDate(t['departureTime']),
            arrivalTime: _parseDate(t['arrivalTime']),
            price: (t['price'] ?? 0).toDouble(),
            totalSeats: t['totalSeats'] ?? 0,
            bookedSeats: t['bookedSeats'] ?? 0,
            availableSeats: t['availableSeats'] ?? 0,
            companyId: t['companyId'] ?? 0,
            companyName: t['companyName'] ?? 'Unknown',
            busId: t['busId'] ?? 0,
            status: t['status'] ?? 'Active',
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

  // Load passengers for a specific trip
  Future<void> loadTripPassengers(int tripId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await apiService.getTripPassengers(tripId);

      if (response['success'] == true && response['data'] != null) {
        final passengersData = response['data'] as List<dynamic>? ?? [];
        _passengers = passengersData.map((p) {
          return PassengerInfo(
            ticketId: p['ticketId'] ?? 0,
            ticketNumber: p['ticketNumber'] ?? '',
            userId: p['userId'] ?? 0,
            userName: p['userName'] ?? '',
            userFullName: p['userFullName'] ?? '',
            userPhoneNumber: p['userPhoneNumber'] ?? '',
            userEmail: p['userEmail'] ?? '',
            numberOfSeats: p['numberOfSeats'] ?? 0,
            totalPrice: (p['totalPrice'] ?? 0).toDouble(),
            qrCode: p['qrCode'],
            status: p['status'] ?? '',
            bookingDate: _parseDate(p['bookingDate']),
            boardingDate: p['boardingDate'] != null
                ? _parseDate(p['boardingDate'])
                : null,
            seatNumbers: List<String>.from(p['seatNumbers'] ?? []),
          );
        }).toList();
      } else {
        _error = response['message'] ?? 'Failed to load passengers';
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load passengers: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Search passenger by QR code
  Future<bool> searchByQRCode(String qrCode) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await apiService.searchByQRCode(qrCode);

      if (response['success'] == true && response['data'] != null) {
        final data = response['data'];
        _selectedPassenger = PassengerDetail(
          ticketId: data['ticketId'] ?? 0,
          ticketNumber: data['ticketNumber'] ?? '',
          passengerName: data['passengerName'] ?? '',
          passengerPhone: data['passengerPhone'] ?? '',
          passengerEmail: data['passengerEmail'] ?? '',
          tripDepartureCity: data['tripDepartureCity'] ?? '',
          tripArrivalCity: data['tripArrivalCity'] ?? '',
          departureTime: _parseDate(data['departureTime']),
          numberOfSeats: data['numberOfSeats'] ?? 0,
          seatNumbers: List<String>.from(data['seatNumbers'] ?? []),
          totalPrice: (data['totalPrice'] ?? 0).toDouble(),
          bookingDate: _parseDate(data['bookingDate']),
          boardingDate: data['boardingDate'] != null
              ? _parseDate(data['boardingDate'])
              : null,
          status: data['status'] ?? '',
          isBoarded: data['isBoarded'] ?? false,
        );
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = response['message'] ?? 'Vé không tìm thấy';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Lỗi tìm kiếm vé: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Confirm passenger boarding
  Future<bool> confirmBoarding(int ticketId, String qrCode) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await apiService.confirmBoarding(ticketId, qrCode);

      if (response['success'] == true) {
        // Update passenger in list if boarding confirmed
        final index = _passengers.indexWhere((p) => p.ticketId == ticketId);
        if (index != -1) {
          final updated = _passengers[index];
          _passengers[index] = PassengerInfo(
            ticketId: updated.ticketId,
            ticketNumber: updated.ticketNumber,
            userId: updated.userId,
            userName: updated.userName,
            userFullName: updated.userFullName,
            userPhoneNumber: updated.userPhoneNumber,
            userEmail: updated.userEmail,
            numberOfSeats: updated.numberOfSeats,
            totalPrice: updated.totalPrice,
            qrCode: updated.qrCode,
            status: 'Boarded',
            bookingDate: updated.bookingDate,
            boardingDate: DateTime.now(),
            seatNumbers: updated.seatNumbers,
          );
        }

        // Also update selected passenger if it's the same ticket
        if (_selectedPassenger?.ticketId == ticketId) {
          _selectedPassenger = PassengerDetail(
            ticketId: _selectedPassenger!.ticketId,
            ticketNumber: _selectedPassenger!.ticketNumber,
            passengerName: _selectedPassenger!.passengerName,
            passengerPhone: _selectedPassenger!.passengerPhone,
            passengerEmail: _selectedPassenger!.passengerEmail,
            tripDepartureCity: _selectedPassenger!.tripDepartureCity,
            tripArrivalCity: _selectedPassenger!.tripArrivalCity,
            departureTime: _selectedPassenger!.departureTime,
            numberOfSeats: _selectedPassenger!.numberOfSeats,
            seatNumbers: _selectedPassenger!.seatNumbers,
            totalPrice: _selectedPassenger!.totalPrice,
            bookingDate: _selectedPassenger!.bookingDate,
            boardingDate: DateTime.now(),
            status: 'Boarded',
            isBoarded: true,
          );
        }

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = response['message'] ?? 'Lỗi xác nhận lên xe';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Lỗi xác nhận lên xe: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void clearSelectedPassenger() {
    _selectedPassenger = null;
    notifyListeners();
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
}

// Models
class ManagerTrip {
  final int id;
  final String departureCity;
  final String arrivalCity;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final double price;
  final int totalSeats;
  final int bookedSeats;
  final int availableSeats;
  final int companyId;
  final String companyName;
  final int busId;
  final String status;

  ManagerTrip({
    required this.id,
    required this.departureCity,
    required this.arrivalCity,
    required this.departureTime,
    required this.arrivalTime,
    required this.price,
    required this.totalSeats,
    required this.bookedSeats,
    required this.availableSeats,
    required this.companyId,
    required this.companyName,
    required this.busId,
    required this.status,
  });
}

class PassengerInfo {
  final int ticketId;
  final String ticketNumber;
  final int userId;
  final String userName;
  final String userFullName;
  final String userPhoneNumber;
  final String userEmail;
  final int numberOfSeats;
  final double totalPrice;
  final String? qrCode;
  final String status;
  final DateTime bookingDate;
  final DateTime? boardingDate;
  final List<String> seatNumbers;

  PassengerInfo({
    required this.ticketId,
    required this.ticketNumber,
    required this.userId,
    required this.userName,
    required this.userFullName,
    required this.userPhoneNumber,
    required this.userEmail,
    required this.numberOfSeats,
    required this.totalPrice,
    required this.qrCode,
    required this.status,
    required this.bookingDate,
    required this.boardingDate,
    required this.seatNumbers,
  });
}

class PassengerDetail {
  final int ticketId;
  final String ticketNumber;
  final String passengerName;
  final String passengerPhone;
  final String passengerEmail;
  final String tripDepartureCity;
  final String tripArrivalCity;
  final DateTime departureTime;
  final int numberOfSeats;
  final List<String> seatNumbers;
  final double totalPrice;
  final DateTime bookingDate;
  final DateTime? boardingDate;
  final String status;
  final bool isBoarded;

  PassengerDetail({
    required this.ticketId,
    required this.ticketNumber,
    required this.passengerName,
    required this.passengerPhone,
    required this.passengerEmail,
    required this.tripDepartureCity,
    required this.tripArrivalCity,
    required this.departureTime,
    required this.numberOfSeats,
    required this.seatNumbers,
    required this.totalPrice,
    required this.bookingDate,
    required this.boardingDate,
    required this.status,
    required this.isBoarded,
  });
}
