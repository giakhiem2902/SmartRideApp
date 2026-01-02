import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../themes/app_theme.dart';
import '../widgets/app_widgets.dart';
import '../providers/auth_provider.dart';
import 'seat_selection_screen.dart';

class SearchTripsScreen extends StatefulWidget {
  const SearchTripsScreen({Key? key}) : super(key: key);

  @override
  State<SearchTripsScreen> createState() => _SearchTripsScreenState();
}

class _SearchTripsScreenState extends State<SearchTripsScreen> {
  String? _selectedDeparture;
  String? _selectedArrival;
  DateTime _selectedDate = DateTime.now();
  bool _isSearching = false;
  List<Map<String, dynamic>> _tripResults = [];
  String? _lastSearchedDeparture;
  String? _lastSearchedArrival;

  final List<String> _provinces = [
    'Hà Nội',
    'Hồ Chí Minh',
    'Đà Nẵng',
    'Hải Phòng',
    'Cần Thơ',
    'Hà Tĩnh',
    'Quảng Ninh',
    'Cà Mau',
    'An Giang',
    'Bạc Liêu',
    'Bến Tre',
    'Bình Dương',
    'Bình Phước',
    'Bình Thuận',
    'Cảm Ranh',
    'Đồng Nai',
    'Đồng Tháp',
    'Đắk Lắk',
    'Đà Lạt',
    'Gia Lai',
    'Hà Giang',
    'Hà Nam',
    'Hà Tây',
    'Hải Dương',
    'Hoà Bình',
    'Hơn',
    'Kiên Giang',
    'Kon Tum',
    'Lai Châu',
    'Lạng Sơn',
    'Lào Cai',
    'Long An',
    'Nam Định',
    'Nghệ An',
    'Ninh Bình',
    'Ninh Thuận',
    'Phú Thọ',
    'Phú Yên',
    'Quảng Bình',
    'Quảng Nam',
    'Quảng Ngãi',
    'Quảng Trị',
    'Sơn La',
    'Tây Ninh',
    'Thái Bình',
    'Thái Nguyên',
    'Thanh Hóa',
    'Thừa Thiên Huế',
    'Tiền Giang',
    'Tuyên Quang',
    'Vĩnh Long',
    'Vĩnh Phúc',
    'Yên Bái',
  ];

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _handleSearch() {
    if (_selectedDeparture == null || _selectedArrival == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn điểm đi và điểm đến')),
      );
      return;
    }

    if (_selectedDeparture == _selectedArrival) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Điểm đi và điểm đến phải khác nhau')),
      );
      return;
    }

    setState(() {
      _isSearching = true;
      _lastSearchedDeparture = _selectedDeparture;
      _lastSearchedArrival = _selectedArrival;
    });

    // Gọi API tìm kiếm chuyến xe
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.apiService
        .searchTrips(
      departureCity: _selectedDeparture!,
      arrivalCity: _selectedArrival!,
      date: _selectedDate,
    )
        .then((response) {
      if (response['success'] == true) {
        final trips =
            (response['data'] as List?)?.cast<Map<String, dynamic>>() ?? [];
        setState(() {
          _tripResults = trips;
          _isSearching = false;
        });
      } else {
        setState(() => _isSearching = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? 'Tìm kiếm thất bại')),
        );
      }
    }).catchError((error) {
      setState(() => _isSearching = false);
      print('Search error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $error')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Trips'),
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
            // Departure City
            AppCard(
              onTap: () => _showProvinceSelector('departure'),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Departure City',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.darkGray,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _selectedDeparture ?? 'Select departure city',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: _selectedDeparture != null
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: _selectedDeparture != null
                                  ? Colors.black
                                  : AppTheme.darkGray,
                            ),
                      ),
                    ],
                  ),
                  const Icon(Icons.location_on, color: AppTheme.primaryRed),
                ],
              ),
            ),

            SizedBox(height: AppTheme.spacingMedium),

            // Arrival City
            AppCard(
              onTap: () => _showProvinceSelector('arrival'),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Arrival City',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.darkGray,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _selectedArrival ?? 'Select arrival city',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: _selectedArrival != null
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: _selectedArrival != null
                                  ? Colors.black
                                  : AppTheme.darkGray,
                            ),
                      ),
                    ],
                  ),
                  const Icon(Icons.location_on, color: AppTheme.primaryRed),
                ],
              ),
            ),

            SizedBox(height: AppTheme.spacingMedium),

            // Date Picker
            InkWell(
              onTap: _selectDate,
              child: AppCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Departure Date',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.darkGray,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                    const Icon(Icons.calendar_today,
                        color: AppTheme.primaryRed),
                  ],
                ),
              ),
            ),

            SizedBox(height: AppTheme.spacingLarge),

            // Search Button
            AppButton(
              label: 'Search Trips',
              isLoading: _isSearching,
              onPressed: _isSearching ? () {} : _handleSearch,
            ),

            SizedBox(height: AppTheme.spacingLarge),

            // Sample Results
            if (!_isSearching)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date Carousel
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 7,
                      itemBuilder: (context, index) {
                        final date = _selectedDate.add(Duration(days: index));
                        final isSelected = index == 0;
                        final dayName = _getDayName(date.weekday);
                        final dateStr = '${date.day}/${date.month}';

                        return Container(
                          width: 80,
                          margin: EdgeInsets.only(
                            right: AppTheme.spacingMedium,
                            bottom: AppTheme.spacingMedium,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isSelected ? AppTheme.primaryRed : Colors.white,
                            borderRadius: BorderRadius.circular(
                              AppTheme.radiusMedium,
                            ),
                            border: Border.all(
                              color: AppTheme.borderGray.withOpacity(0.3),
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color:
                                          AppTheme.primaryRed.withOpacity(0.3),
                                      blurRadius: 4,
                                    ),
                                  ]
                                : [],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                dayName,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isSelected
                                      ? Colors.white
                                      : AppTheme.darkGray,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                dateStr,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: AppTheme.spacingMedium),

                  // Filters
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildFilterButton('Giá'),
                      _buildFilterButton('Loại ghế'),
                      _buildFilterButton('Giờ'),
                    ],
                  ),

                  SizedBox(height: AppTheme.spacingMedium),

                  // Trip Results - Dynamic from API
                  if (_tripResults.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(AppTheme.spacingMedium),
                        child: Text(
                          'Không tìm thấy chuyến xe phù hợp',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppTheme.darkGray,
                                  ),
                        ),
                      ),
                    )
                  else
                    ..._tripResults.asMap().entries.map((entry) {
                      int index = entry.key;
                      Map<String, dynamic> trip = entry.value;

                      final departureTime =
                          DateTime.parse(trip['departureTime']);
                      final arrivalTime = DateTime.parse(trip['arrivalTime']);
                      final timeStr =
                          '${departureTime.hour.toString().padLeft(2, '0')}:${departureTime.minute.toString().padLeft(2, '0')} → ${arrivalTime.hour.toString().padLeft(2, '0')}:${arrivalTime.minute.toString().padLeft(2, '0')}';
                      final availableSeats = (trip['totalSeats'] ?? 0) -
                          (trip['bookedSeats'] ?? 0);
                      final priceStr =
                          '${(trip['price'] ?? 0).toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')}đ';

                      return Column(
                        key: ValueKey(trip['id']),
                        children: [
                          _buildTripResultCard(
                            company: trip['busCompany']?['name'] ?? 'Unknown',
                            time: timeStr,
                            price: priceStr,
                            seats: '$availableSeats seats available',
                            busType: 'Bus',
                            distance: 'Khoảng cách: TBD',
                            departure: _lastSearchedDeparture ??
                                trip['departureCity'] ??
                                '',
                            arrival: _lastSearchedArrival ??
                                trip['arrivalCity'] ??
                                '',
                            tripId: trip['id'] ?? 0,
                            priceInt: (trip['price'] ?? 0).toInt(),
                          ),
                          if (index < _tripResults.length - 1)
                            SizedBox(height: AppTheme.spacingMedium),
                        ],
                      );
                    }).toList(),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void _showProvinceSelector(String type) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(16),
            ),
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingMedium),
                decoration: const BoxDecoration(
                  color: AppTheme.primaryRed,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      type == 'departure'
                          ? 'Select Departure City'
                          : 'Select Arrival City',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              // Province List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppTheme.spacingSmall,
                  ),
                  itemCount: _provinces.length,
                  itemBuilder: (context, index) {
                    final province = _provinces[index];
                    final isSelected = type == 'departure'
                        ? _selectedDeparture == province
                        : _selectedArrival == province;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (type == 'departure') {
                            _selectedDeparture = province;
                          } else {
                            _selectedArrival = province;
                          }
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacingMedium,
                          vertical: AppTheme.spacingMedium,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.lightRed.withOpacity(0.3)
                              : Colors.transparent,
                          border: Border(
                            bottom: BorderSide(
                              color: AppTheme.borderGray.withOpacity(0.3),
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              province,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected
                                    ? AppTheme.primaryRed
                                    : Colors.black,
                              ),
                            ),
                            if (isSelected)
                              const Icon(
                                Icons.check,
                                color: AppTheme.primaryRed,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getDayName(int weekday) {
    const days = ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'];
    return days[weekday % 7];
  }

  Widget _buildFilterButton(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMedium,
        vertical: AppTheme.spacingSmall,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppTheme.borderGray),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.expand_more, size: 20),
        ],
      ),
    );
  }

  Widget _buildTripResultCard({
    required String company,
    required String time,
    required String price,
    required String seats,
    required String busType,
    required String distance,
    required String departure,
    required String arrival,
    int tripId = 1,
    int priceInt = 350000,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SeatSelectionScreen(
              tripId: tripId,
              departureCity: departure,
              arrivalCity: arrival,
              departureTime: time,
              tripDate: 'Thứ Sáu, 02/01/2026',
              price: priceInt ~/ 1000,
              companyName: company,
            ),
          ),
        );
      },
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Company and Price Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  company,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingSmall,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.lightRed.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    price,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.primaryRed,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),

            SizedBox(height: AppTheme.spacingMedium),

            // Time Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  time,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  seats,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.successGreen,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),

            SizedBox(height: AppTheme.spacingSmall),

            // Bus Type and Details
            Row(
              children: [
                Text(
                  busType,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.darkGray,
                      ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(
                    color: AppTheme.borderGray,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    distance,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.darkGray,
                        ),
                  ),
                ),
              ],
            ),

            SizedBox(height: AppTheme.spacingMedium),

            // Divider
            Container(
              height: 1,
              color: AppTheme.borderGray.withOpacity(0.3),
            ),

            SizedBox(height: AppTheme.spacingMedium),

            // Departure Location
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: AppTheme.successGreen,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 12,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingSmall),
                Expanded(
                  child: Text(
                    departure,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),

            SizedBox(height: AppTheme.spacingSmall),

            // Dotted Line
            Padding(
              padding: const EdgeInsets.only(left: 9),
              child: Column(
                children: [
                  for (int i = 0; i < 3; i++)
                    Container(
                      width: 2,
                      height: 2,
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      decoration: const BoxDecoration(
                        color: AppTheme.borderGray,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ),

            SizedBox(height: AppTheme.spacingSmall),

            // Arrival Location
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryRed,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.location_on,
                    size: 12,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingSmall),
                Expanded(
                  child: Text(
                    arrival,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),

            SizedBox(height: AppTheme.spacingMedium),

            // Info Button
            Center(
              child: GestureDetector(
                onTap: () {},
                child: Text(
                  'Lịch trình',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
