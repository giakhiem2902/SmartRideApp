import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../themes/app_theme.dart';
import '../widgets/app_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() => _errorMessage = 'Please fill in all fields');
      return;
    }

    setState(() => _errorMessage = null);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (!mounted) return;

      if (success) {
        // Login successful - check user role and navigate accordingly
        final user = authProvider.user;
        if (user != null) {
          if (user.roles.contains('Admin')) {
            // Navigate to admin dashboard
            Navigator.of(context).pushReplacementNamed('/admin');
          } else if (user.roles.contains('Manager')) {
            // Navigate to manager dashboard
            Navigator.of(context).pushReplacementNamed('/manager');
          } else {
            // Navigate to home screen for regular users
            Navigator.of(context).pushReplacementNamed('/home');
          }
        }
      } else {
        // Show error from AuthProvider
        setState(
            () => _errorMessage = authProvider.errorMessage ?? 'Login failed');
      }
    } catch (e) {
      setState(() => _errorMessage = 'Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartRide'),
        backgroundColor: AppTheme.primaryRed,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),

            // Logo/Image
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: AppTheme.lightGray,
                borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
              ),
              child: Center(
                child: Image.asset(
                  'assets/logos/smartride_logo.png',
                  height: 100,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            SizedBox(height: MediaQuery.of(context).size.height * 0.05),

            // Title
            Text(
              'Welcome Back',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryRed,
                  ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: AppTheme.spacingMedium),

            // Subtitle
            Text(
              'Sign in to book your bus tickets',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.darkGray,
                  ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: AppTheme.spacingXLarge),

            // Error Message
            if (_errorMessage != null)
              AppCard(
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(
                    color: AppTheme.errorRed,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

            if (_errorMessage != null) SizedBox(height: AppTheme.spacingMedium),

            // Email Field
            AppTextField(
              label: 'Email',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Email is required';
                if (!value!.contains('@')) return 'Invalid email format';
                return null;
              },
            ),

            SizedBox(height: AppTheme.spacingMedium),

            // Password Field
            AppTextField(
              label: 'Password',
              controller: _passwordController,
              obscureText: true,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Password is required';
                if (value!.length < 6)
                  return 'Password must be at least 6 characters';
                return null;
              },
            ),

            SizedBox(height: AppTheme.spacingLarge),

            // Login Button
            Consumer<AuthProvider>(
              builder: (context, authProvider, _) {
                return AppButton(
                  label: 'Sign In',
                  isLoading: authProvider.isLoading,
                  onPressed: authProvider.isLoading ? () {} : _handleLogin,
                );
              },
            ),

            SizedBox(height: AppTheme.spacingMedium),

            // Sign Up Link
            Consumer<AuthProvider>(
              builder: (context, authProvider, _) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    GestureDetector(
                      onTap: authProvider.isLoading
                          ? null
                          : () {
                              Navigator.of(context)
                                  .pushReplacementNamed('/register');
                            },
                      child: Text(
                        'Sign Up',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.primaryRed,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                );
              },
            ),

            SizedBox(height: AppTheme.spacingXLarge),

            // Demo Login Button
            Consumer<AuthProvider>(
              builder: (context, authProvider, _) {
                return OutlinedButton(
                  onPressed: authProvider.isLoading
                      ? null
                      : () async {
                          // Pre-fill demo credentials
                          _emailController.text = 'demo@example.com';
                          _passwordController.text = 'Demo@123456';

                          // Trigger login
                          await Future.delayed(
                              const Duration(milliseconds: 300));
                          if (mounted) {
                            _handleLogin();
                          }
                        },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(color: AppTheme.primaryRed),
                  ),
                  child: const Text(
                    'Demo Login (Register first)',
                    style: TextStyle(color: AppTheme.primaryRed),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
