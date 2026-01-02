import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../themes/app_theme.dart';
import '../../widgets/app_widgets.dart';
import '../../providers/auth_provider.dart';
import '../../providers/manager_provider.dart';
import 'trip_passengers_screen.dart';

class ManagerDashboardScreen extends StatefulWidget {
  const ManagerDashboardScreen({Key? key}) : super(key: key);

  @override
  State<ManagerDashboardScreen> createState() => _ManagerDashboardScreenState();
}

class _ManagerDashboardScreenState extends State<ManagerDashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Defer data loading to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadManagerData();
    });
  }

  Future<void> _loadManagerData() async {
    final managerProvider = context.read<ManagerProvider>();
    await managerProvider.loadManagerTrips();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý chuyến xe'),
        backgroundColor: AppTheme.primaryRed,
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _handleLogout(context),
          ),
        ],
      ),
      body: Consumer<ManagerProvider>(
        builder: (context, managerProvider, _) {
          if (managerProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (managerProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Lỗi: ${managerProvider.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadManagerData,
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          if (managerProvider.trips.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.directions_bus,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Không có chuyến xe nào',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _loadManagerData,
            child: ListView.builder(
              padding: const EdgeInsets.all(AppTheme.spacingMedium),
              itemCount: managerProvider.trips.length,
              itemBuilder: (context, index) {
                final trip = managerProvider.trips[index];
                final occupancyPercent = trip.totalSeats > 0
                    ? (trip.bookedSeats / trip.totalSeats * 100)
                        .toStringAsFixed(0)
                    : '0';

                return AppCard(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => TripPassengersScreen(trip: trip),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Trip header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${trip.departureCity} → ${trip.arrivalCity}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    _getCompanyLogo(trip.companyName, size: 20),
                                    const SizedBox(width: 8),
                                    Text(
                                      trip.companyName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Colors.grey[600],
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: trip.status == 'Active'
                                  ? Colors.green.withOpacity(0.2)
                                  : Colors.orange.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              trip.status,
                              style: TextStyle(
                                color: trip.status == 'Active'
                                    ? Colors.green
                                    : Colors.orange,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Time info
                      Row(
                        children: [
                          Icon(Icons.schedule,
                              size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 8),
                          Text(
                            '${_formatTime(trip.departureTime)} - ${_formatTime(trip.arrivalTime)}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Occupancy bar
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Ghế đã đặt',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              Text(
                                '$occupancyPercent%',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primaryRed,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: trip.bookedSeats / trip.totalSeats,
                              minHeight: 8,
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppTheme.primaryRed,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Seats and price info
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ghế trống',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                              ),
                              Text(
                                '${trip.availableSeats}/${trip.totalSeats}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hành khách',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                              ),
                              Text(
                                trip.bookedSeats.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Giá vé',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                              ),
                              Text(
                                '₫${trip.price.toStringAsFixed(0)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primaryRed,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // View passengers button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    TripPassengersScreen(trip: trip),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryRed,
                          ),
                          child: const Text('Xem danh sách hành khách'),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Đăng xuất'),
        content: const Text('Bạn có chắc muốn đăng xuất?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              context.read<AuthProvider>().logout();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/login', (route) => false);
            },
            child: const Text('Đăng xuất'),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Widget _getCompanyLogo(String companyName, {double size = 24}) {
    final logoMap = {
      'Phương Trang': 'assets/logos/company_phuongtrang.png',
      'Thành Buôn': 'assets/logos/company_thanhbuon.png',
    };

    if (logoMap.containsKey(companyName)) {
      return Image.asset(
        logoMap[companyName]!,
        width: size,
        height: size,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.business, size: size, color: AppTheme.primaryRed);
        },
      );
    }

    return Icon(Icons.business, size: size, color: AppTheme.primaryRed);
  }
}
