import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../themes/app_theme.dart';
import '../../widgets/app_widgets.dart';
import '../../providers/auth_provider.dart';
import '../../providers/admin_provider.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Defer data loading to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAdminData();
    });
  }

  Future<void> _loadAdminData() async {
    final adminProvider = context.read<AdminProvider>();
    await Future.wait([
      adminProvider.loadDashboardStats(),
      adminProvider.loadCompanies(),
      adminProvider.loadTrips(),
      adminProvider.loadUsers(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Dashboard'),
          backgroundColor: AppTheme.primaryRed,
          centerTitle: true,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => _handleLogout(context),
            ),
          ],
          bottom: const TabBar(
            tabs: const [
              Tab(text: 'Dashboard', icon: Icon(Icons.dashboard)),
              Tab(text: 'Companies', icon: Icon(Icons.business)),
              Tab(text: 'Trips', icon: Icon(Icons.directions_bus)),
              Tab(text: 'Users', icon: Icon(Icons.people)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildDashboardTab(),
            _buildCompaniesTab(),
            _buildTripsTab(),
            _buildUsersTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardTab() {
    return Consumer<AdminProvider>(
      builder: (context, adminProvider, _) {
        final stats = adminProvider.stats;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stats Cards
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      title: 'Total Users',
                      value: '${stats?.totalUsers ?? 0}',
                      icon: Icons.people,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingMedium),
                  Expanded(
                    child: _buildStatCard(
                      title: 'Total Trips',
                      value: '${stats?.totalTrips ?? 0}',
                      icon: Icons.directions_bus,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingMedium),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      title: 'Total Revenue',
                      value:
                          '₫${(stats?.totalRevenue ?? 0).toStringAsFixed(0)}',
                      icon: Icons.attach_money,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingMedium),
                  Expanded(
                    child: _buildStatCard(
                      title: 'Bus Companies',
                      value: '${stats?.totalCompanies ?? 0}',
                      icon: Icons.business,
                      color: Colors.purple,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingLarge),

              // Recent Activities
              Text(
                'Recent Activities',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryRed,
                    ),
              ),
              const SizedBox(height: AppTheme.spacingMedium),
              _buildActivityItem(
                  'New user registered', 'Nguyễn Văn A', '2 hours ago'),
              _buildActivityItem(
                  'Trip created', 'Hà Nội → TP. HCM', '4 hours ago'),
              _buildActivityItem(
                  'Ticket booked', 'User: Trần Thị B', '6 hours ago'),
              _buildActivityItem(
                  'Company verified', 'Phương Trang', '1 day ago'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCompaniesTab() {
    return Consumer<AdminProvider>(
      builder: (context, adminProvider, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Add Company Button
              AppButton(
                label: '+ Add New Company',
                onPressed: () => _showAddCompanyDialog(context),
              ),
              const SizedBox(height: AppTheme.spacingMedium),

              // Companies List
              Text(
                'Bus Companies',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: AppTheme.spacingMedium),
              ...adminProvider.companies
                  .map((company) => _buildCompanyCard(
                        company.name,
                        company.phone,
                        company.isActive ? 'Active' : 'Inactive',
                        company.isActive,
                      ))
                  .toList(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTripsTab() {
    return Consumer<AdminProvider>(
      builder: (context, adminProvider, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Add Trip Button
              AppButton(
                label: '+ Add New Trip',
                onPressed: () => _showAddTripDialog(context),
              ),
              const SizedBox(height: AppTheme.spacingMedium),

              // Trips List
              Text(
                'All Trips',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: AppTheme.spacingMedium),
              ...adminProvider.trips
                  .map((trip) => _buildTripCard(
                        '${trip.departureCity} → ${trip.arrivalCity}',
                        trip.company,
                        '${trip.departureTime} - ${trip.arrivalTime}',
                        '₫${trip.price.toStringAsFixed(0)}',
                        '${trip.bookedSeats}/${trip.totalSeats} seats',
                        trip.isActive,
                      ))
                  .toList(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUsersTab() {
    return Consumer<AdminProvider>(
      builder: (context, adminProvider, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Users
              AppCard(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search users...',
                    border: InputBorder.none,
                    prefixIcon:
                        const Icon(Icons.search, color: AppTheme.primaryRed),
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacingMedium),

              // Users List
              Text(
                'Registered Users',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: AppTheme.spacingMedium),
              ...adminProvider.users
                  .map((user) => _buildUserCard(
                        user.name,
                        user.email,
                        '${user.bookingCount} bookings',
                        user.isActive,
                      ))
                  .toList(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.darkGray,
                    ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingMedium),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String title, String subtitle, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingMedium),
      child: AppCard(
        child: Row(
          children: [
            Container(
              width: 4,
              height: 60,
              decoration: BoxDecoration(
                color: AppTheme.primaryRed,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: AppTheme.spacingMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.darkGray,
                        ),
                  ),
                ],
              ),
            ),
            Text(
              time,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.darkGray,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompanyCard(
      String name, String phone, String status, bool isActive) {
    return AppCard(
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppTheme.primaryRed.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.business, color: AppTheme.primaryRed),
          ),
          const SizedBox(width: AppTheme.spacingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  phone,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.darkGray,
                      ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingSmall,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: isActive
                  ? Colors.green.withOpacity(0.2)
                  : Colors.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.green : Colors.red,
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spacingMedium),
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, size: 18),
                    SizedBox(width: 8),
                    Text('Edit'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, size: 18, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Delete', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'edit') {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Edit $name')),
                );
              } else if (value == 'delete') {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Delete $name')),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTripCard(
    String route,
    String company,
    String time,
    String price,
    String seats,
    bool isActive,
  ) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                route,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingSmall,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isActive
                      ? Colors.green.withOpacity(0.2)
                      : Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  isActive ? 'Active' : 'Inactive',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isActive ? Colors.green : Colors.red,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingSmall),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      company,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.darkGray,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      time,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.darkGray,
                          ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    price,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryRed,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    seats,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.darkGray,
                        ),
                  ),
                ],
              ),
              const SizedBox(width: AppTheme.spacingMedium),
              PopupMenuButton(
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 18),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 18, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$value: $route')),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(
      String name, String email, String bookings, bool isActive) {
    return AppCard(
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppTheme.primaryRed.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                name.substring(0, 1),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: AppTheme.primaryRed,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spacingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.darkGray,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  bookings,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.darkGray,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingSmall,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: isActive
                  ? Colors.green.withOpacity(0.2)
                  : Colors.orange.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              isActive ? 'Active' : 'Inactive',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.green : Colors.orange,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddCompanyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Company'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Company Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: AppTheme.spacingMedium),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: AppTheme.spacingMedium),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: AppTheme.spacingMedium),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          AppButton(
            label: 'Add Company',
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Company added successfully')),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showAddTripDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Trip'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Company',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: AppTheme.spacingMedium),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Departure City',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: AppTheme.spacingMedium),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Arrival City',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: AppTheme.spacingMedium),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Departure Time (HH:MM)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: AppTheme.spacingMedium),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Price (₫)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          AppButton(
            label: 'Add Trip',
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Trip added successfully')),
              );
            },
          ),
        ],
      ),
    );
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final authProvider =
                  Provider.of<AuthProvider>(context, listen: false);
              authProvider.logout();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/login', (route) => false);
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
