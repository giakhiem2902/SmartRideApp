import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'themes/app_theme.dart';
import 'services/api_service.dart';
import 'models/auth.dart';
import 'providers/auth_provider.dart';
import 'providers/admin_provider.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/search_trips_screen.dart';
import 'screens/my_tickets_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/admin_screens/admin_dashboard_screen.dart';
import 'screens/admin_screens/admin_guard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final apiService = ApiService(prefs);
  final authService = AuthService(prefs);

  runApp(
    MultiProvider(
      providers: [
        Provider<SharedPreferences>.value(value: prefs),
        Provider<ApiService>.value(value: apiService),
        Provider<AuthService>.value(value: authService),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authService, apiService),
        ),
        ChangeNotifierProvider(
          create: (_) => AdminProvider(apiService: apiService),
        ),
      ],
      child: const SmartRideApp(),
    ),
  );
}

class SmartRideApp extends StatelessWidget {
  const SmartRideApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartRide',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(context),
      darkTheme: AppTheme.darkTheme(context),
      themeMode: ThemeMode.light,
      home: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          if (authProvider.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (authProvider.isLoggedIn) {
            return const HomePage();
          }

          return const LoginScreen();
        },
      ),
      routes: {
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        '/home': (_) => const HomePage(),
        '/search': (_) => const SearchTripsScreen(),
        '/my-tickets': (_) => const MyTicketsScreen(),
        '/profile': (_) => const ProfileScreen(),
        '/admin': (_) => AdminGuard(
              child: const AdminDashboardScreen(),
            ),
      },
    );
  }
}
