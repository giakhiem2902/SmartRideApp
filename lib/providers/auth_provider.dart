import 'package:flutter/foundation.dart';
import '../models/auth.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  final ApiService _apiService;
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  AuthProvider(this._authService, this._apiService) {
    _initializeAuth();
  }

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user != null && _authService.isLoggedIn();
  String? get errorMessage => _errorMessage;
  ApiService get apiService => _apiService;

  Future<void> _initializeAuth() async {
    _user = _authService.getUser();
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.login(email, password);

      // Extract data from response
      final data = response['data'] ?? response;
      final token = data['token'] ?? data['accessToken'];
      final userData = data['user'] ?? data;

      if (token == null) {
        throw Exception('No token in response');
      }

      // Create user object from response
      _user = User(
        id: userData['id'] ?? 0,
        userName: userData['userName'] ?? email.split('@')[0],
        email: userData['email'] ?? email,
        fullName: userData['fullName'] ?? 'User',
        phoneNumber: userData['phoneNumber'] ?? '',
        avatar: userData['avatar'],
        roles: List<String>.from(userData['roles'] ?? ['User']),
      );

      // Save token and user
      await _authService.saveToken(token);
      await _authService.saveUser(_user!);

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _user = null;
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register(
    String email,
    String username,
    String fullName,
    String password,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.register(
        email,
        username,
        fullName,
        password,
        password, // confirmPassword
        '', // phoneNumber (optional for now)
      );

      // Register response doesn't include token, just success/message
      // User will need to login after registration
      if (response['success'] == true) {
        // Registration successful - return true so user can go to login
        return true;
      } else {
        final message = response['message'] ?? 'Registration failed';
        final errors = response['errors'] as List<dynamic>?;

        if (errors != null && errors.isNotEmpty) {
          _errorMessage = errors.first.toString();
        } else {
          _errorMessage = message;
        }
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.logout();
      _user = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
