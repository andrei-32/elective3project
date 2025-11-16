import 'dart:convert';

class Booking {
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
  final String departureFlightDetails; // Stored as JSON string
  final String? returnFlightDetails; // Stored as JSON string
  final String selectedBundle;
  final double totalPrice;
  final String paymentMethod;
  final String status;
<<<<<<< HEAD
  // These are the properties you added.
  final String destination;
  final DateTime flight_date;
=======
  final String? cancellationReason;
>>>>>>> 7a216ea75d2d1eb69f01744958c44f4881f3d2d0

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
<<<<<<< HEAD
    this.adults = 1,
    this.children = 0,
    this.infants = 0,
    required this.flightClass,
    this.status = 'Confirmed',
    // *** FIX 1: Initialize the new final properties in the constructor. ***
    required this.destination,
    required this.flight_date,
  });

  // This method converts a Booking object into a Map for database storage.
  Map<String, dynamic> toMap(int userId) {
=======
    required this.tripType,
    required this.guestFirstName,
    required this.guestLastName,
    required this.departureFlightDetails,
    this.returnFlightDetails,
    required this.selectedBundle,
    required this.totalPrice,
    required this.paymentMethod,
    required this.status,
    this.cancellationReason,
  });

  // Convert a Booking object into a Map object
  Map<String, dynamic> toMap() {
>>>>>>> 7a216ea75d2d1eb69f01744958c44f4881f3d2d0
    return {
      'id': id,
      'bookingReference': bookingReference,
      'userId': userId,
<<<<<<< HEAD
      // *** FIX 2: Use the direct properties from the Booking object. ***
      'destination': destination,
      'flight_date': flight_date.toIso8601String(), // Store the main flight date.
      'departureTime': flight.departureTime,
      'arrivalTime': flight.arrivalTime,
      'tripType': tripType,
      'departureDate': departureDate.toIso8601String(), // This seems redundant, but we'll keep it for now.
=======
      'origin': origin,
      'destination': destination,
      'origin2': origin2,
      'destination2': destination2,
      'departureDate': departureDate.toIso8601String(),
>>>>>>> 7a216ea75d2d1eb69f01744958c44f4881f3d2d0
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
    };
  }

<<<<<<< HEAD
  // This factory creates a Booking object from a Map retrieved from the database.
  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      id: map['id'],
      // *** FIX 3: Populate all required fields from the map. ***
      destination: map['destination'] ?? 'Unknown', // If destination is null, use 'Unknown'.
      flight_date: map['flight_date'] != null
          ? DateTime.parse(map['flight_date'])
          : DateTime.now(), // If date is null, use today's date as a fallback.

      flight: Flight(
        // Also add fallbacks here for safety.
        destination: map['destination'] ?? 'Unknown',
        departureTime: map['departureTime'] ?? 'N/A',
        arrivalTime: map['arrivalTime'] ?? 'N/A',
      ),
      tripType: map['tripType'] ?? 'One-way',
      // For departureDate, we can reuse the same safe logic as flight_date.
      departureDate: map['departureDate'] != null
          ? DateTime.parse(map['departureDate'])
          : DateTime.parse(map['flight_date']), // Fallback to flight_date if departureDate is null
      returnDate: map['returnDate'] != null ? DateTime.parse(map['returnDate']) : null,
      adults: map['adults'] ?? 1,
      children: map['children'] ?? 0,
      infants: map['infants'] ?? 0,
      flightClass: map['flightClass'] ?? 'Economy',
      status: map['status'] ?? 'Unknown',
=======
  // Extract a Booking object from a Map object
  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      id: map['id'],
      bookingReference: map['bookingReference'],
      userId: map['userId'],
      origin: map['origin'],
      destination: map['destination'],
      origin2: map['origin2'],
      destination2: map['destination2'],
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
      cancellationReason: map['cancellationReason'],
>>>>>>> 7a216ea75d2d1eb69f01744958c44f4881f3d2d0
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
