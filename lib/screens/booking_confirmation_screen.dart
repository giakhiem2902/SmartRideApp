import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../themes/app_theme.dart';
import '../widgets/app_widgets.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final Map<String, dynamic> ticketData;
  final String departureCity;
  final String arrivalCity;
  final String departureTime;
  final String tripDate;
  final String companyName;
  final VoidCallback onDownloadTicket;

  const BookingConfirmationScreen({
    Key? key,
    required this.ticketData,
    required this.departureCity,
    required this.arrivalCity,
    required this.departureTime,
    required this.tripDate,
    required this.companyName,
    required this.onDownloadTicket,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ticketNumber = ticketData['ticketNumber'] ?? 'N/A';
    final qrCode = ticketData['qrCode'] ?? '';
    final seatNumbers = ticketData['seatNumbers'] as List<dynamic>? ?? [];
    final totalPrice = ticketData['totalPrice'] ?? 0;
    final numberOfSeats = ticketData['numberOfSeats'] ?? 0;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Success Header
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppTheme.primaryRed,
                    AppTheme.primaryRed.withOpacity(0.8)
                  ],
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingMedium,
                vertical: AppTheme.spacingLarge,
              ),
              child: Column(
                children: [
                  const SizedBox(height: AppTheme.spacingLarge),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.check_circle,
                        size: 60,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingMedium),
                  Text(
                    'Đặt vé thành công!',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Mã vé: $ticketNumber',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                  ),
                  const SizedBox(height: AppTheme.spacingLarge),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // QR Code Card
                  AppCard(
                    child: Column(
                      children: [
                        Text(
                          'Mã QR vé xe',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.darkGray,
                                  ),
                        ),
                        const SizedBox(height: AppTheme.spacingMedium),
                        Container(
                          padding: const EdgeInsets.all(AppTheme.spacingSmall),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          width: 220.0,
                          height: 220.0,
                          child: _buildQrWidget(qrCode),
                        ),
                        const SizedBox(height: AppTheme.spacingMedium),
                        Text(
                          'Xuất trình mã QR này khi lên xe',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.darkGray,
                                    fontStyle: FontStyle.italic,
                                  ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppTheme.spacingLarge),

                  // Trip Details
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Thông tin chuyến xe',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: AppTheme.spacingMedium),
                        _buildDetailRow('Hãng xe', companyName, context),
                        const SizedBox(height: 12),
                        _buildDetailRow('Tuyến đường',
                            '$departureCity → $arrivalCity', context),
                        const SizedBox(height: 12),
                        _buildDetailRow('Thời gian khởi hành',
                            '$departureTime • $tripDate', context),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppTheme.spacingLarge),

                  // Seat Details
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Chi tiết ghế',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: AppTheme.spacingMedium),
                        _buildDetailRow(
                            'Số ghế', seatNumbers.join(', '), context),
                        const SizedBox(height: 12),
                        _buildDetailRow(
                            'Số lượng ghế', '$numberOfSeats ghế', context),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppTheme.spacingLarge),

                  // Total Price
                  Container(
                    padding: const EdgeInsets.all(AppTheme.spacingMedium),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppTheme.primaryRed.withOpacity(0.1),
                          AppTheme.primaryRed.withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.primaryRed.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tổng tiền',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Text(
                          '${totalPrice.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}đ',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: AppTheme.primaryRed,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppTheme.spacingLarge),

                  // Download Ticket Button
                  AppButton(
                    onPressed: onDownloadTicket,
                    label: 'Tải vé',
                  ),

                  const SizedBox(height: AppTheme.spacingMedium),

                  // Back to Home Button
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).popUntil(
                        (route) => route.isFirst,
                      );
                    },
                    icon: const Icon(Icons.home),
                    label: const Text('Quay lại trang chủ'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: AppTheme.primaryRed),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.darkGray,
              ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildQrWidget(String qrCode) {
    if (qrCode.isEmpty) {
      return Center(
        child: Container(
          color: Colors.grey.shade200,
          child: const Center(
            child: Text('No QR Code'),
          ),
        ),
      );
    }
    // Use qr_flutter to render QR code
    return Center(
      child: QrImageView(
        data: qrCode,
        version: QrVersions.auto,
        size: 200.0,
        gapless: false,
      ),
    );
  }
}
