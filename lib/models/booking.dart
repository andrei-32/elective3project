import 'dart:convert';

class Booking {
  // Merged properties
  final int? id;
  final String bookingReference;
  final int userId;
  final String origin;
  final String destination;
  final String? origin2;
  final String? destination2;
  final DateTime departureDate;
  final DateTime? returnDate;
  final String tripType;
  final String guestFirstName;
  final String guestLastName;
  final String departureFlightDetails;
  final String? returnFlightDetails;
  final String selectedBundle;
  final double totalPrice;
  final String paymentMethod;
  final String status;
  final String? cancellationReason;
  final int adults;
  final int children;
  final int infants;
  final String flightClass;

  Booking({
    this.id,
    required this.bookingReference,
    required this.userId,
    required this.origin,
    required this.destination,
    this.origin2,
    this.destination2,
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
    this.status = 'Confirmed',
    this.cancellationReason,
    this.adults = 1,
    this.children = 0,
    this.infants = 0,
    required this.flightClass,
  });

  Map<String, dynamic> toMap(int userId) {
    return {
      'id': id,
      'bookingReference': bookingReference,
      'userId': userId,
      'origin': origin,
      'destination': destination,
      'origin2': origin2,
      'destination2': destination2,
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
      'cancellationReason': cancellationReason,
      'adults': adults,
      'children': children,
      'infants': infants,
      'flightClass': flightClass,
    };
  }

  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      id: map['id'],
      bookingReference: map['bookingReference'] ?? '',
      userId: map['userId'] ?? 0,
      origin: map['origin'] ?? '',
      destination: map['destination'] ?? 'Unknown',
      origin2: map['origin2'],
      destination2: map['destination2'],
      departureDate: DateTime.parse(map['departureDate'] ?? DateTime.now().toIso8601String()),
      returnDate: map['returnDate'] != null ? DateTime.parse(map['returnDate']) : null,
      tripType: map['tripType'] ?? 'One-way',
      guestFirstName: map['guestFirstName'] ?? '',
      guestLastName: map['guestLastName'] ?? '',
      departureFlightDetails: map['departureFlightDetails'] ?? '',
      returnFlightDetails: map['returnFlightDetails'],
      selectedBundle: map['selectedBundle'] ?? '',
      totalPrice: map['totalPrice']?.toDouble() ?? 0.0,
      paymentMethod: map['paymentMethod'] ?? '',
      status: map['status'] ?? 'Unknown',
      cancellationReason: map['cancellationReason'],
      adults: map['adults'] ?? 1,
      children: map['children'] ?? 0,
      infants: map['infants'] ?? 0,
      flightClass: map['flightClass'] ?? 'Economy',
    );
  }

   Map<String, dynamic> get departureFlight => jsonDecode(departureFlightDetails);

   Map<String, dynamic>? get returnFlight {
     if (returnFlightDetails == null) return null;
     return jsonDecode(returnFlightDetails!);
   }
   
   @override
  String toString() {
    return 'Booking{id: $id, bookingReference: $bookingReference, userId: $userId, destination: $destination, status: $status}';
  }
}
