import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/auth.dart';
import '../themes/app_theme.dart';
import '../widgets/app_widgets.dart';

class MyTicketsScreen extends StatefulWidget {
  const MyTicketsScreen({Key? key}) : super(key: key);

  @override
  State<MyTicketsScreen> createState() => _MyTicketsScreenState();
}

class _MyTicketsScreenState extends State<MyTicketsScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadTickets();
  }

  Future<void> _loadTickets() async {
    setState(() => _isLoading = true);
    // TODO: Call API to fetch user tickets
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tickets'),
        backgroundColor: AppTheme.primaryRed,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Sample tickets
                  _buildTicketCard(
                    'SR20260102001234',
                    'Hà Nội → Hồ Chí Minh',
                    '08:00 - 16:30',
                    '2 seats',
                    'Confirmed',
                    AppTheme.successGreen,
                  ),
                  SizedBox(height: AppTheme.spacingMedium),
                  _buildTicketCard(
                    'SR20260115005678',
                    'Hồ Chí Minh → Đà Nẵng',
                    '14:00 - 20:00',
                    '1 seat',
                    'Pending',
                    AppTheme.warningOrange,
                  ),
                  SizedBox(height: AppTheme.spacingMedium),
                  _buildTicketCard(
                    'SR20260201009101',
                    'Hà Nội → Quảng Ninh',
                    '10:00 - 13:00',
                    '3 seats',
                    'Used',
                    AppTheme.darkGray,
                  ),
                  SizedBox(height: AppTheme.spacingLarge),
                  AppButton(
                    label: 'Book New Ticket',
                    onPressed: () {
                      Navigator.of(context).pushNamed('/search');
                    },
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildTicketCard(
    String ticketNumber,
    String route,
    String time,
    String seats,
    String status,
    Color statusColor,
  ) {
    return AppCard(
      onTap: () {
        // Navigate to ticket details
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ticket #$ticketNumber',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.darkGray,
                        ),
                  ),
                  SizedBox(height: AppTheme.spacingSmall),
                  Text(
                    route,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingSmall,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                ),
                child: Text(
                  status,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppTheme.spacingMedium),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.schedule,
                      color: AppTheme.darkGray, size: 16),
                  SizedBox(width: AppTheme.spacingSmall),
                  Text(
                    time,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.darkGray,
                        ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.event_seat,
                      color: AppTheme.darkGray, size: 16),
                  SizedBox(width: AppTheme.spacingSmall),
                  Text(
                    seats,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.darkGray,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
