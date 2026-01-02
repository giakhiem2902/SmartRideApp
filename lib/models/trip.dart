class BusCompany {
  final int id;
  final String name;
  final String logo;
  final String description;
  final String phoneNumber;
  final String email;
  final String address;
  final bool isActive;

  BusCompany({
    required this.id,
    required this.name,
    required this.logo,
    required this.description,
    required this.phoneNumber,
    required this.email,
    required this.address,
    required this.isActive,
  });

  factory BusCompany.fromJson(Map<String, dynamic> json) {
    return BusCompany(
      id: json['id'] as int,
      name: json['name'] as String,
      logo: json['logo'] as String,
      description: json['description'] as String,
      phoneNumber: json['phoneNumber'] as String,
      email: json['email'] as String,
      address: json['address'] as String,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logo': logo,
      'description': description,
      'phoneNumber': phoneNumber,
      'email': email,
      'address': address,
      'isActive': isActive,
    };
  }
}

class Trip {
  final int id;
  final int busCompanyId;
  final String departureCity;
  final String arrivalCity;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final double price;
  final int totalSeats;
  final int bookedSeats;
  final BusCompany? busCompany;

  Trip({
    required this.id,
    required this.busCompanyId,
    required this.departureCity,
    required this.arrivalCity,
    required this.departureTime,
    required this.arrivalTime,
    required this.price,
    required this.totalSeats,
    required this.bookedSeats,
    this.busCompany,
  });

  int get availableSeats => totalSeats - bookedSeats;

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'] as int,
      busCompanyId: json['busCompanyId'] as int,
      departureCity: json['departureCity'] as String,
      arrivalCity: json['arrivalCity'] as String,
      departureTime: DateTime.parse(json['departureTime'] as String),
      arrivalTime: DateTime.parse(json['arrivalTime'] as String),
      price: (json['price'] as num).toDouble(),
      totalSeats: json['totalSeats'] as int,
      bookedSeats: json['bookedSeats'] as int,
      busCompany: json['busCompany'] != null
          ? BusCompany.fromJson(json['busCompany'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'busCompanyId': busCompanyId,
      'departureCity': departureCity,
      'arrivalCity': arrivalCity,
      'departureTime': departureTime.toIso8601String(),
      'arrivalTime': arrivalTime.toIso8601String(),
      'price': price,
      'totalSeats': totalSeats,
      'bookedSeats': bookedSeats,
      'busCompany': busCompany?.toJson(),
    };
  }
}

class Ticket {
  final int id;
  final String ticketNumber;
  final String qrCode;
  final int numberOfSeats;
  final double totalPrice;
  final String status;
  final Trip? trip;
  final List<String> seatNumbers;

  Ticket({
    required this.id,
    required this.ticketNumber,
    required this.qrCode,
    required this.numberOfSeats,
    required this.totalPrice,
    required this.status,
    this.trip,
    required this.seatNumbers,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'] as int,
      ticketNumber: json['ticketNumber'] as String,
      qrCode: json['qrCode'] as String,
      numberOfSeats: json['numberOfSeats'] as int,
      totalPrice: (json['totalPrice'] as num).toDouble(),
      status: json['status'] as String,
      trip: json['trip'] != null
          ? Trip.fromJson(json['trip'] as Map<String, dynamic>)
          : null,
      seatNumbers: List<String>.from(json['seatNumbers'] as List? ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ticketNumber': ticketNumber,
      'qrCode': qrCode,
      'numberOfSeats': numberOfSeats,
      'totalPrice': totalPrice,
      'status': status,
      'trip': trip?.toJson(),
      'seatNumbers': seatNumbers,
    };
  }
}

class BusSeat {
  final int id;
  final String seatNumber;
  final String status; // Available, Reserved, Booked

  BusSeat({required this.id, required this.seatNumber, required this.status});

  factory BusSeat.fromJson(Map<String, dynamic> json) {
    return BusSeat(
      id: json['id'] as int,
      seatNumber: json['seatNumber'] as String,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'seatNumber': seatNumber, 'status': status};
  }
}
