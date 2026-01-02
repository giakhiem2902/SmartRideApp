import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // For Android emulator: use 10.0.2.2 instead of localhost
  static const String baseUrl = 'http://10.0.2.2:5000/api';

  late final Dio _dio;
  final SharedPreferences _prefs;

  ApiService(this._prefs) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = _prefs.getString('auth_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          options.headers['Content-Type'] = 'application/json';
          print('API Request [${options.method}]: ${options.path}');
          print('Request Body: ${options.data}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // Log responses for debugging
          print(
              'API Response [${response.statusCode}]: ${response.requestOptions.path}');
          return handler.next(response);
        },
        onError: (error, handler) {
          // Log error details for debugging
          print('API Error [${error.response?.statusCode}]: ${error.message}');
          if (error.response != null) {
            print('Error Body: ${error.response?.data}');
          }

          if (error.response?.statusCode == 401) {
            // Handle unauthorized - logout user
          }
          return handler.next(error);
        },
      ),
    );

    _dio.options.validateStatus = (status) {
      // Accept all status codes, handle them in methods
      return status != null && status < 500;
    };
  }

  // Auth endpoints
  Future<Map<String, dynamic>> register(
    String email,
    String userName,
    String fullName,
    String password,
    String confirmPassword,
    String phoneNumber,
  ) async {
    try {
      final response = await _dio.post(
        '/auth/register',
        data: {
          'email': email,
          'userName': userName,
          'fullName': fullName,
          'password': password,
          'confirmPassword': confirmPassword,
          'phoneNumber': phoneNumber,
        },
      );

      // Handle both success and error responses
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        // Log error details
        print('Register error response: ${response.data}');
        print('Register error status: ${response.statusCode}');

        // Return error response from backend
        return response.data ??
            {
              'success': false,
              'message': 'Registration failed',
              'errors': ['Unknown error occurred']
            };
      }
    } catch (e) {
      print('Register error: $e');
      return {
        'success': false,
        'message': 'Error: ${e.toString()}',
        'errors': [e.toString()]
      };
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await _dio.get('/auth/profile');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // Bus Company endpoints
  Future<Map<String, dynamic>> getBusCompanies() async {
    try {
      final response = await _dio.get('/buscompanies');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getBusCompanyById(int id) async {
    try {
      final response = await _dio.get('/buscompanies/$id');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createBusCompany(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _dio.post('/buscompanies', data: data);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateBusCompany(
    int id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _dio.put('/buscompanies/$id', data: data);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> deleteBusCompany(int id) async {
    try {
      final response = await _dio.delete('/buscompanies/$id');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // Trip endpoints (to be implemented)
  Future<Map<String, dynamic>> searchTrips({
    required String departureCity,
    required String arrivalCity,
    required DateTime date,
  }) async {
    try {
      final response = await _dio.get(
        '/trips/search',
        queryParameters: {
          'departureCity': departureCity,
          'arrivalCity': arrivalCity,
          'date': date.toIso8601String().split('T')[0],
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getTripSeats(int tripId) async {
    try {
      final response = await _dio.get('/trips/$tripId/seats');
      return response.data;
    } catch (e) {
      print('Get trip seats error: $e');
      rethrow;
    }
  }

  // Ticket endpoints (to be implemented)
  Future<Map<String, dynamic>> createTicket(
    int tripId,
    List<dynamic>
        seatData, // Can be List<int> (IDs) or List<String> (seat numbers)
  ) async {
    try {
      final Map<String, dynamic> requestData = {
        'tripId': tripId,
      };

      // Add seat data based on type
      if (seatData.isNotEmpty) {
        if (seatData.first is String) {
          requestData['seatNumbers'] = seatData.cast<String>();
        } else {
          requestData['selectedSeatIds'] = seatData.cast<int>();
        }
      }

      print('Sending createTicket request with data: $requestData');

      final response = await _dio.post(
        '/tickets',
        data: requestData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        print('Create ticket error response: ${response.data}');
        print('Create ticket error status: ${response.statusCode}');
        return response.data ??
            {
              'success': false,
              'message': 'Failed to create ticket',
              'errors': ['Unknown error occurred']
            };
      }
    } catch (e) {
      print('Create ticket error: $e');
      return {
        'success': false,
        'message': 'Error: ${e.toString()}',
        'errors': [e.toString()]
      };
    }
  }

  Future<Map<String, dynamic>> getUserTickets() async {
    try {
      final response = await _dio.get('/tickets/my-tickets');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // Admin endpoints
  Future<Map<String, dynamic>> getAdminStats() async {
    try {
      final response = await _dio.get('/admin/stats');
      return response.data;
    } catch (e) {
      print('Get admin stats error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getAdminCompanies() async {
    try {
      final response = await _dio.get('/admin/companies');
      return response.data;
    } catch (e) {
      print('Get admin companies error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getAdminTrips() async {
    try {
      final response = await _dio.get('/admin/trips');
      return response.data;
    } catch (e) {
      print('Get admin trips error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getAdminUsers() async {
    try {
      final response = await _dio.get('/admin/users');
      return response.data;
    } catch (e) {
      print('Get admin users error: $e');
      rethrow;
    }
  }
}
