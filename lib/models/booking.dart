import './flight.dart';

class Booking {
  final int? id;
  final Flight flight;
  final String tripType;
  final DateTime departureDate;
  final DateTime? returnDate;
  final int adults;
  final int children;
  final int infants;
  final String flightClass;
  final String status;
  // These are the properties you added.
  final String destination;
  final DateTime flight_date;

  Booking({
    this.id,
    required this.flight,
    required this.tripType,
    required this.departureDate,
    this.returnDate,
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
    return {
      'userId': userId,
      // *** FIX 2: Use the direct properties from the Booking object. ***
      'destination': destination,
      'flight_date': flight_date.toIso8601String(), // Store the main flight date.
      'departureTime': flight.departureTime,
      'arrivalTime': flight.arrivalTime,
      'tripType': tripType,
      'departureDate': departureDate.toIso8601String(), // This seems redundant, but we'll keep it for now.
      'returnDate': returnDate?.toIso8601String(),
      'adults': adults,
      'children': children,
      'infants': infants,
      'flightClass': flightClass,
      'status': status,
    };
  }

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
    );
  }
}
