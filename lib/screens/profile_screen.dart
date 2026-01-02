import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../themes/app_theme.dart';
import '../widgets/app_widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppTheme.primaryRed,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final user = authProvider.user;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.spacingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Profile Card
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryRed.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 50,
                          color: AppTheme.primaryRed,
                        ),
                      ),
                      SizedBox(height: AppTheme.spacingMedium),
                      Text(
                        user?.fullName ?? 'Unknown User',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      SizedBox(height: AppTheme.spacingSmall),
                      Text(
                        user?.email ?? 'No email',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.darkGray,
                            ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: AppTheme.spacingLarge),

                // User Information
                Text(
                  'User Information',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),

                SizedBox(height: AppTheme.spacingMedium),

                _buildInfoCard('Username', user?.userName ?? 'N/A'),
                SizedBox(height: AppTheme.spacingMedium),
                _buildInfoCard('Email', user?.email ?? 'N/A'),
                SizedBox(height: AppTheme.spacingMedium),
                _buildInfoCard(
                  'Phone',
                  user?.phoneNumber ?? 'Not provided',
                ),
                SizedBox(height: AppTheme.spacingMedium),
                _buildInfoCard(
                  'Role',
                  user?.roles.join(', ') ?? 'User',
                ),

                SizedBox(height: AppTheme.spacingLarge),

                // Account Actions
                Text(
                  'Account',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),

                SizedBox(height: AppTheme.spacingMedium),

                AppCard(
                  onTap: () {
                    // Navigate to edit profile
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.edit, color: AppTheme.primaryRed),
                          SizedBox(width: AppTheme.spacingMedium),
                          Text(
                            'Edit Profile',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ],
                      ),
                      const Icon(Icons.arrow_forward, color: AppTheme.darkGray),
                    ],
                  ),
                ),

                SizedBox(height: AppTheme.spacingMedium),

                AppCard(
                  onTap: () {
                    // Navigate to change password
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.lock, color: AppTheme.primaryRed),
                          SizedBox(width: AppTheme.spacingMedium),
                          Text(
                            'Change Password',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ],
                      ),
                      const Icon(Icons.arrow_forward, color: AppTheme.darkGray),
                    ],
                  ),
                ),

                SizedBox(height: AppTheme.spacingMedium),

                AppCard(
                  onTap: () {
                    // Navigate to settings
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.settings,
                              color: AppTheme.primaryRed),
                          SizedBox(width: AppTheme.spacingMedium),
                          Text(
                            'Settings',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ],
                      ),
                      const Icon(Icons.arrow_forward, color: AppTheme.darkGray),
                    ],
                  ),
                ),

                SizedBox(height: AppTheme.spacingLarge),

                // Logout Button
                AppButton(
                  label: 'Sign Out',
                  backgroundColor: AppTheme.errorRed,
                  onPressed: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Sign Out'),
                        content:
                            const Text('Are you sure you want to sign out?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Sign Out'),
                          ),
                        ],
                      ),
                    );

                    if (confirmed == true && mounted) {
                      await authProvider.logout();
                      if (mounted) {
                        Navigator.of(context).pushReplacementNamed('/login');
                      }
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.darkGray,
                ),
          ),
          SizedBox(height: AppTheme.spacingSmall),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
