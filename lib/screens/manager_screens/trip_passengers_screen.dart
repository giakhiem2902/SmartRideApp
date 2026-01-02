import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../themes/app_theme.dart';
import '../../widgets/app_widgets.dart';
import '../../providers/manager_provider.dart';
import 'qr_scanner_screen.dart';

class TripPassengersScreen extends StatefulWidget {
  final ManagerTrip trip;

  const TripPassengersScreen({
    Key? key,
    required this.trip,
  }) : super(key: key);

  @override
  State<TripPassengersScreen> createState() => _TripPassengersScreenState();
}

class _TripPassengersScreenState extends State<TripPassengersScreen> {
  @override
  void initState() {
    super.initState();
    // Load passengers for this trip
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPassengers();
    });
  }

  Future<void> _loadPassengers() async {
    final managerProvider = context.read<ManagerProvider>();
    await managerProvider.loadTripPassengers(widget.trip.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách hành khách'),
        backgroundColor: AppTheme.primaryRed,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<ManagerProvider>(
        builder: (context, managerProvider, _) {
          return Column(
            children: [
              // Trip info card
              Container(
                color: AppTheme.primaryRed,
                padding: const EdgeInsets.all(AppTheme.spacingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.trip.departureCity} → ${widget.trip.arrivalCity}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Thời gian: ${_formatTime(widget.trip.departureTime)}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                        Text(
                          'Hành khách: ${widget.trip.bookedSeats}/${widget.trip.totalSeats}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Passengers list
              Expanded(
                child: managerProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : managerProvider.error != null
                        ? Center(
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
                                  onPressed: _loadPassengers,
                                  child: const Text('Thử lại'),
                                ),
                              ],
                            ),
                          )
                        : managerProvider.passengers.isEmpty
                            ? Center(
                                child: Text(
                                  'Chưa có hành khách nào',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              )
                            : RefreshIndicator(
                                onRefresh: _loadPassengers,
                                child: ListView.builder(
                                  padding: const EdgeInsets.all(
                                      AppTheme.spacingMedium),
                                  itemCount: managerProvider.passengers.length,
                                  itemBuilder: (context, index) {
                                    final passenger =
                                        managerProvider.passengers[index];
                                    final isBoarded =
                                        passenger.boardingDate != null;

                                    return AppCard(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Passenger header
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      passenger.userFullName,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleMedium
                                                          ?.copyWith(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      'Vé: ${passenger.ticketNumber}',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall
                                                          ?.copyWith(
                                                            color: Colors
                                                                .grey[600],
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: isBoarded
                                                      ? Colors.green
                                                          .withOpacity(0.2)
                                                      : Colors.orange
                                                          .withOpacity(0.2),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  isBoarded
                                                      ? 'Đã lên'
                                                      : 'Chưa lên',
                                                  style: TextStyle(
                                                    color: isBoarded
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

                                          // Contact info
                                          Row(
                                            children: [
                                              Icon(Icons.phone,
                                                  size: 16,
                                                  color: Colors.grey[600]),
                                              const SizedBox(width: 8),
                                              Text(
                                                passenger.userPhoneNumber,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall,
                                              ),
                                            ],
                                          ),

                                          const SizedBox(height: 8),

                                          // Email info
                                          Row(
                                            children: [
                                              Icon(Icons.email,
                                                  size: 16,
                                                  color: Colors.grey[600]),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  passenger.userEmail,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),

                                          const SizedBox(height: 12),

                                          // Seats info
                                          Text(
                                            'Ghế: ${passenger.seatNumbers.join(", ")}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),

                                          const SizedBox(height: 12),

                                          // QR Scan button
                                          if (!isBoarded)
                                            SizedBox(
                                              width: double.infinity,
                                              child: ElevatedButton.icon(
                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          QRScannerScreen(
                                                        trip: widget.trip,
                                                        passenger: passenger,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                icon: const Icon(Icons.qr_code),
                                                label: const Text('Quét mã QR'),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      AppTheme.primaryRed,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
