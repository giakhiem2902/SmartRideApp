import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  final int id;
  final String userName;
  final String email;
  final String? fullName;
  final String? phoneNumber;
  final String? avatar;
  final List<String> roles;

  User({
    required this.id,
    required this.userName,
    required this.email,
    this.fullName,
    this.phoneNumber,
    this.avatar,
    required this.roles,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      userName: json['userName'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      avatar: json['avatar'] as String?,
      roles: List<String>.from(json['roles'] as List? ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'email': email,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'avatar': avatar,
      'roles': roles,
    };
  }

  bool isAdmin() => roles.contains('Admin');
  bool isManager() => roles.contains('Manager');
  bool isUser() => roles.contains('User');
}

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  final SharedPreferences _prefs;

  AuthService(this._prefs);

  Future<void> saveToken(String token) async {
    await _prefs.setString(_tokenKey, token);
  }

  String? getToken() {
    return _prefs.getString(_tokenKey);
  }

  Future<void> saveUser(User user) async {
    await _prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  User? getUser() {
    final userJson = _prefs.getString(_userKey);
    if (userJson == null) return null;
    return User.fromJson(jsonDecode(userJson));
  }

  Future<void> logout() async {
    await _prefs.remove(_tokenKey);
    await _prefs.remove(_userKey);
  }

  bool isLoggedIn() {
    return getToken() != null && getUser() != null;
  }

  bool isTokenExpired(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return true;

      final decoded = base64Url.decode(
        parts[1] + '=' * (4 - parts[1].length % 4),
      );
      final json = jsonDecode(utf8.decode(decoded));
      final exp = DateTime.fromMillisecondsSinceEpoch(
        (json['exp'] as int) * 1000,
      );

      return DateTime.now().isAfter(exp);
    } catch (e) {
      return true;
    }
  }
}
