import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class AdminGuard extends StatelessWidget {
  final Widget child;

  const AdminGuard({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        // Check if user is authenticated
        if (!authProvider.isLoggedIn) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.lock,
                    size: 48,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Access Denied',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text('Please login to access admin panel'),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/login',
                      (route) => false,
                    ),
                    child: const Text('Go to Login'),
                  ),
                ],
              ),
            ),
          );
        }

        // Check if user has admin role
        // Note: This requires role information from AuthProvider
        // For now, we'll show the child (full implementation in next phase)

        return child;
      },
    );
  }
}
