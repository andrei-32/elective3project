import 'dart:convert';

class Booking {
  final int? id;
  final String bookingReference;
  final int userId;
  final String origin;
  final String destination;
  final DateTime departureDate;
  final DateTime? returnDate;
  final String tripType;
  final String guestFirstName;
  final String guestLastName;
  final String departureFlightDetails; // Stored as JSON string
  final String? returnFlightDetails; // Stored as JSON string
  final String selectedBundle;
  final double totalPrice;
  final String paymentMethod;
  final String status;

  Booking({
    this.id,
    required this.bookingReference,
    required this.userId,
    required this.origin,
    required this.destination,
    required this.departureDate,
    this.returnDate,
    required this.tripType,
    required this.guestFirstName,
    required this.guestLastName,
    required this.departureFlightDetails,
    this.returnFlightDetails,
    required this.selectedBundle,
    required this.totalPrice,
    required this.paymentMethod,
    required this.status,
  });

  // Convert a Booking object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bookingReference': bookingReference,
      'userId': userId,
      'origin': origin,
      'destination': destination,
      'departureDate': departureDate.toIso8601String(),
      'returnDate': returnDate?.toIso8601String(),
      'tripType': tripType,
      'guestFirstName': guestFirstName,
      'guestLastName': guestLastName,
      'departureFlightDetails': departureFlightDetails,
      'returnFlightDetails': returnFlightDetails,
      'selectedBundle': selectedBundle,
      'totalPrice': totalPrice,
      'paymentMethod': paymentMethod,
      'status': status,
    };
  }

  // Extract a Booking object from a Map object
  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      id: map['id'],
      bookingReference: map['bookingReference'],
      userId: map['userId'],
      origin: map['origin'],
      destination: map['destination'],
      departureDate: DateTime.parse(map['departureDate']),
      returnDate: map['returnDate'] != null ? DateTime.parse(map['returnDate']) : null,
      tripType: map['tripType'],
      guestFirstName: map['guestFirstName'],
      guestLastName: map['guestLastName'],
      departureFlightDetails: map['departureFlightDetails'],
      returnFlightDetails: map['returnFlightDetails'],
      selectedBundle: map['selectedBundle'],
      totalPrice: map['totalPrice'],
      paymentMethod: map['paymentMethod'],
      status: map['status'],
    );
  }

  // Helper to get departure flight details as a Map
  Map<String, dynamic> get departureFlight => jsonDecode(departureFlightDetails);

  // Helper to get return flight details as a Map
  Map<String, dynamic>? get returnFlight {
    if (returnFlightDetails == null) return null;
    return jsonDecode(returnFlightDetails!);
  }

  @override
  String toString() {
    return 'Booking{id: $id, bookingReference: $bookingReference, userId: $userId, destination: $destination, status: $status}';
  }
}
