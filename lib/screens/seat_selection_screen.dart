import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../themes/app_theme.dart';
import '../widgets/app_widgets.dart';
import '../providers/auth_provider.dart';
import 'booking_confirmation_screen.dart';

class SeatSelectionScreen extends StatefulWidget {
  final int tripId;
  final String departureCity;
  final String arrivalCity;
  final String departureTime;
  final String tripDate;
  final int price;
  final String companyName;

  const SeatSelectionScreen({
    Key? key,
    required this.tripId,
    required this.departureCity,
    required this.arrivalCity,
    required this.departureTime,
    required this.tripDate,
    required this.price,
    required this.companyName,
  }) : super(key: key);

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  final List<String> _selectedSeats = [];
  final List<String> _bookedSeats = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSeatsFromServer();
  }

  Future<void> _loadSeatsFromServer() async {
    try {
      final authProvider = context.read<AuthProvider>();
      final apiService = authProvider.apiService;

      final response = await apiService.getTripSeats(widget.tripId);

      if (mounted &&
          (response['success'] == true || response['data'] != null)) {
        final seats = response['data'] as List<dynamic>? ?? [];

        setState(() {
          _bookedSeats.clear();
          // Filter booked seats (status is 'Booked' or similar)
          for (var seat in seats) {
            if (seat['status'] == '2' ||
                seat['status']?.toString().toLowerCase() == 'booked') {
              _bookedSeats.add(seat['seatNumber'] ?? '');
            }
          }
          _isLoading = false;
        });
      } else {
        // Fallback to default booked seats if API fails
        if (mounted) {
          setState(() {
            _bookedSeats.addAll(['A01', 'A02', 'A08', 'A12', 'B05']);
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error loading seats: $e');
      // Fallback to default booked seats
      if (mounted) {
        setState(() {
          _bookedSeats.addAll(['A01', 'A02', 'A08', 'A12', 'B05']);
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chọn ghế'),
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
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header Info Section
                  Container(
                    color: AppTheme.primaryRed,
                    padding: const EdgeInsets.all(AppTheme.spacingMedium),
                    child: Column(
                      children: [
                        Text(
                          '${widget.departureCity} → ${widget.arrivalCity}',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.tripDate,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.white70,
                                  ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: AppTheme.spacingLarge),

                  // Trip Info Card
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingMedium,
                    ),
                    child: AppCard(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ngày đi',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: AppTheme.darkGray,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${widget.departureTime} • ${widget.tripDate}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                          Text(
                            '${widget.price.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}.000đ',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  color: AppTheme.primaryRed,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: AppTheme.spacingLarge),

                  // Seat Grid with Tiers
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacingMedium,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tầng dưới',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: AppTheme.spacingMedium),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacingMedium,
                        ),
                        child: _buildSeatGridTier('A', 1, 17),
                      ),
                      const SizedBox(height: AppTheme.spacingLarge),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacingMedium,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tầng trên',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: AppTheme.spacingMedium),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacingMedium,
                        ),
                        child: _buildSeatGridTier('B', 1, 14),
                      ),
                    ],
                  ),

                  SizedBox(height: AppTheme.spacingLarge),

                  // Legend
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingMedium,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildLegend('Đã bán', Colors.grey.shade300),
                        _buildLegend('Còn trống', Colors.blue.shade100),
                        _buildLegend('Đang chọn', AppTheme.primaryRed),
                      ],
                    ),
                  ),

                  SizedBox(height: AppTheme.spacingLarge),

                  // Selected Seats
                  if (_selectedSeats.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingMedium,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Chiều dài',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppTheme.darkGray,
                                    ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _selectedSeats
                                .map(
                                  (seat) => Chip(
                                    label: Text(seat),
                                    backgroundColor: AppTheme.primaryRed
                                        .withValues(alpha: 0.1),
                                    labelStyle: const TextStyle(
                                      color: AppTheme.primaryRed,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),

                  SizedBox(height: AppTheme.spacingLarge),

                  // Total Price
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingMedium,
                    ),
                    child: AppCard(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Số tiền',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppTheme.darkGray,
                                ),
                          ),
                          Text(
                            '${(_selectedSeats.length * widget.price).toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}.000đ',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  color: AppTheme.primaryRed,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: AppTheme.spacingLarge),

                  // Book Button
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingMedium,
                    ),
                    child: AppButton(
                      label: _selectedSeats.isEmpty
                          ? 'Chọn ghế để tiếp tục'
                          : 'Tiếp tục',
                      onPressed:
                          _selectedSeats.isEmpty ? () {} : _proceedToBooking,
                    ),
                  ),

                  SizedBox(height: AppTheme.spacingLarge),
                ],
              ),
            ),
    );
  }

  Future<void> _proceedToBooking() async {
    setState(() => _isLoading = true);

    try {
      // Use seat numbers (A01, A02, etc.) instead of fake IDs
      final seatNumbers = List<String>.from(_selectedSeats);

      // Call the API
      final authProvider = context.read<AuthProvider>();
      final apiService = authProvider.apiService;

      final response =
          await apiService.createTicket(widget.tripId, seatNumbers);

      if (mounted) {
        // Check both 'success' key and if data exists
        final success = response['success'] == true || response['data'] != null;

        if (success) {
          final ticketData = response['data'] ?? {};

          // Reload seats from server after successful booking
          await _loadSeatsFromServer();

          // Clear selected seats after successful booking
          _selectedSeats.clear();

          // Navigate to confirmation screen
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => BookingConfirmationScreen(
                ticketData: ticketData,
                departureCity: widget.departureCity,
                arrivalCity: widget.arrivalCity,
                departureTime: widget.departureTime,
                tripDate: widget.tripDate,
                companyName: widget.companyName,
                onDownloadTicket: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đang tải vé...')),
                  );
                },
              ),
            ),
          );
        } else {
          final message = response['message'] ?? response.toString();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lỗi: $message'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        // Parse error message
        String errorMsg = 'Lỗi kết nối. Vui lòng thử lại.';

        if (e.toString().contains('401')) {
          errorMsg = 'Vui lòng đăng nhập lại';
          // Redirect to login
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/login', (route) => false);
        } else if (e.toString().contains('Connection refused')) {
          errorMsg = 'Không thể kết nối đến server';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildLegend(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: AppTheme.spacingSmall),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _buildSeatGridTier(String tier, int start, int end) {
    final seats = <String>[];
    for (int i = start; i <= end; i++) {
      seats.add('$tier${i.toString().padLeft(2, '0')}');
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        mainAxisSpacing: AppTheme.spacingSmall,
        crossAxisSpacing: AppTheme.spacingSmall,
      ),
      itemCount: seats.length,
      itemBuilder: (context, index) {
        final seatId = seats[index];
        final isBooked = _bookedSeats.contains(seatId);
        final isSelected = _selectedSeats.contains(seatId);

        return GestureDetector(
          onTap: isBooked
              ? null
              : () {
                  setState(() {
                    if (isSelected) {
                      _selectedSeats.remove(seatId);
                    } else {
                      if (_selectedSeats.length < 7) {
                        _selectedSeats.add(seatId);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Tối đa 7 ghế một lần đặt'),
                          ),
                        );
                      }
                    }
                  });
                },
          child: Container(
            decoration: BoxDecoration(
              color: isBooked
                  ? Colors.grey.shade300
                  : isSelected
                      ? AppTheme.primaryRed
                      : Colors.blue.shade100,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isBooked
                    ? Colors.grey.shade400
                    : isSelected
                        ? AppTheme.primaryRed
                        : Colors.blue.shade200,
              ),
            ),
            child: Center(
              child: Text(
                seatId,
                style: TextStyle(
                  color: isBooked
                      ? Colors.grey.shade600
                      : isSelected
                          ? Colors.white
                          : Colors.blue.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
