import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../themes/app_theme.dart';
import '../widgets/app_widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _fullNameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (_emailController.text.isEmpty ||
        _usernameController.text.isEmpty ||
        _fullNameController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      setState(() => _errorMessage = 'Please fill in all fields');
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() => _errorMessage = 'Passwords do not match');
      return;
    }

    if (_passwordController.text.length < 6) {
      setState(() => _errorMessage = 'Password must be at least 6 characters');
      return;
    }

    setState(() => _errorMessage = null);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.register(
        _emailController.text.trim(),
        _usernameController.text.trim(),
        _fullNameController.text.trim(),
        _passwordController.text,
      );

      if (!mounted) return;

      if (success) {
        // Registration successful - go to login so user can sign in
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Tài khoản đã được tạo. Vui lòng đăng nhập!')),
        );
        Navigator.of(context).pushReplacementNamed('/login');
      } else {
        setState(() =>
            _errorMessage = authProvider.errorMessage ?? 'Registration failed');
      }
    } catch (e) {
      setState(() => _errorMessage = 'Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: AppTheme.primaryRed,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),

            // Title
            Text(
              'Join SmartRide',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryRed,
                  ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: AppTheme.spacingMedium),

            // Subtitle
            Text(
              'Create an account to book bus tickets easily',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.darkGray,
                  ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: AppTheme.spacingLarge),

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

            // Username Field
            AppTextField(
              label: 'Username',
              controller: _usernameController,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Username is required';
                if (value!.length < 3)
                  return 'Username must be at least 3 characters';
                return null;
              },
            ),

            SizedBox(height: AppTheme.spacingMedium),

            // Full Name Field
            AppTextField(
              label: 'Full Name',
              controller: _fullNameController,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Full name is required';
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

            SizedBox(height: AppTheme.spacingMedium),

            // Confirm Password Field
            AppTextField(
              label: 'Confirm Password',
              controller: _confirmPasswordController,
              obscureText: true,
              validator: (value) {
                if (value?.isEmpty ?? true)
                  return 'Please confirm your password';
                if (value != _passwordController.text)
                  return 'Passwords do not match';
                return null;
              },
            ),

            SizedBox(height: AppTheme.spacingLarge),

            // Register Button
            Consumer<AuthProvider>(
              builder: (context, authProvider, _) {
                return AppButton(
                  label: 'Create Account',
                  isLoading: authProvider.isLoading,
                  onPressed: authProvider.isLoading ? () {} : _handleRegister,
                );
              },
            ),

            SizedBox(height: AppTheme.spacingMedium),

            // Sign In Link
            Consumer<AuthProvider>(
              builder: (context, authProvider, _) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    GestureDetector(
                      onTap: authProvider.isLoading
                          ? null
                          : () {
                              Navigator.of(context)
                                  .pushReplacementNamed('/login');
                            },
                      child: Text(
                        'Sign In',
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
          ],
        ),
      ),
    );
  }
}
