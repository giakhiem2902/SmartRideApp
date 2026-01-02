import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../../themes/app_theme.dart';
import '../../providers/manager_provider.dart';

class QRScannerScreen extends StatefulWidget {
  final ManagerTrip trip;
  final PassengerInfo passenger;

  const QRScannerScreen({
    Key? key,
    required this.trip,
    required this.passenger,
  }) : super(key: key);

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  late MobileScannerController controller;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    controller = MobileScannerController(
      autoStart: true,
      torchEnabled: false,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quét mã QR'),
        backgroundColor: AppTheme.primaryRed,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            color: Colors.white,
            icon: const Icon(Icons.flip_camera_android),
            tooltip: 'Chuyển camera',
            onPressed: () => controller.switchCamera(),
          ),
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: controller.torchState,
              builder: (context, state, child) {
                switch (state) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off);
                  case TorchState.on:
                    return const Icon(Icons.flash_on);
                }
              },
            ),
            onPressed: () => controller.toggleTorch(),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Camera feed
          MobileScanner(
            controller: controller,
            onDetect: _handleDetection,
            errorBuilder: (context, error, child) {
              return Center(
                child: Text(
                  'Không thể mở camera: $error',
                  textAlign: TextAlign.center,
                ),
              );
            },
          ),

          // UI Overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: IgnorePointer(
              child: CustomPaint(
                painter: QRScannerPainter(),
              ),
            ),
          ),

          // Bottom info panel
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Hành khách: ${widget.passenger.userFullName}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Vé: ${widget.passenger.ticketNumber}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ghế: ${widget.passenger.seatNumbers.join(", ")}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  if (_isProcessing)
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  else
                    Text(
                      'Hướng mã QR vào camera để quét',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleDetection(BarcodeCapture capture) {
    if (_isProcessing) return;

    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      if (barcode.rawValue != null) {
        _processQRCode(barcode.rawValue!);
        break;
      }
    }
  }

  void _processQRCode(String qrCode) async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final managerProvider = context.read<ManagerProvider>();

      // Confirm boarding with the scanned QR code
      final success = await managerProvider.confirmBoarding(
        widget.passenger.ticketId,
        qrCode,
      );

      if (mounted) {
        if (success) {
          // Show success dialog
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Thành công'),
              content: Text(
                'Xác nhận lên xe cho ${widget.passenger.userFullName}',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    Navigator.pop(context); // Close scanner
                    Navigator.pop(context); // Return to trip list
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else {
          // Show error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(managerProvider.error ?? 'Lỗi xác nhận lên xe'),
              backgroundColor: Colors.red,
            ),
          );
          setState(() {
            _isProcessing = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: $e'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }
}

class QRScannerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw a square in the center for QR code scanning area
    final scanAreaSize = 250.0;
    final left = (size.width - scanAreaSize) / 2;
    final top = (size.height - scanAreaSize) / 2.5;

    // Draw corners
    const cornerLength = 30.0;
    final rect = Rect.fromLTWH(left, top, scanAreaSize, scanAreaSize);

    // Top-left corner
    canvas.drawLine(
      Offset(rect.left, rect.top + cornerLength),
      Offset(rect.left, rect.top),
      paint,
    );
    canvas.drawLine(
      Offset(rect.left, rect.top),
      Offset(rect.left + cornerLength, rect.top),
      paint,
    );

    // Top-right corner
    canvas.drawLine(
      Offset(rect.right - cornerLength, rect.top),
      Offset(rect.right, rect.top),
      paint,
    );
    canvas.drawLine(
      Offset(rect.right, rect.top),
      Offset(rect.right, rect.top + cornerLength),
      paint,
    );

    // Bottom-left corner
    canvas.drawLine(
      Offset(rect.left, rect.bottom - cornerLength),
      Offset(rect.left, rect.bottom),
      paint,
    );
    canvas.drawLine(
      Offset(rect.left, rect.bottom),
      Offset(rect.left + cornerLength, rect.bottom),
      paint,
    );

    // Bottom-right corner
    canvas.drawLine(
      Offset(rect.right - cornerLength, rect.bottom),
      Offset(rect.right, rect.bottom),
      paint,
    );
    canvas.drawLine(
      Offset(rect.right, rect.bottom),
      Offset(rect.right, rect.bottom - cornerLength),
      paint,
    );

    // Darken areas outside the scan box
    final dimPaint = Paint()..color = Colors.black.withOpacity(0.5);

    // Top area
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, top),
      dimPaint,
    );

    // Left area
    canvas.drawRect(
      Rect.fromLTWH(0, top, left, scanAreaSize),
      dimPaint,
    );

    // Right area
    canvas.drawRect(
      Rect.fromLTWH(left + scanAreaSize, top, size.width - left - scanAreaSize,
          scanAreaSize),
      dimPaint,
    );

    // Bottom area
    canvas.drawRect(
      Rect.fromLTWH(
          0, top + scanAreaSize, size.width, size.height - top - scanAreaSize),
      dimPaint,
    );
  }

  @override
  bool shouldRepaint(QRScannerPainter oldDelegate) => false;
}
