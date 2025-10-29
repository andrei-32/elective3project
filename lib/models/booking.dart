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
  });

  Map<String, dynamic> toMap(int userId) {
    return {
      'userId': userId,
      'destination': flight.destination,
      'departureTime': flight.departureTime,
      'arrivalTime': flight.arrivalTime,
      'tripType': tripType,
      'departureDate': departureDate.toIso8601String(),
      'returnDate': returnDate?.toIso8601String(),
      'adults': adults,
      'children': children,
      'infants': infants,
      'flightClass': flightClass,
      'status': status,
    };
  }

  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      id: map['id'],
      flight: Flight(
        destination: map['destination'],
        departureTime: map['departureTime'],
        arrivalTime: map['arrivalTime'],
      ),
      tripType: map['tripType'],
      departureDate: DateTime.parse(map['departureDate']),
      returnDate: map['returnDate'] != null ? DateTime.parse(map['returnDate']) : null,
      adults: map['adults'],
      children: map['children'],
      infants: map['infants'],
      flightClass: map['flightClass'],
      status: map['status'],
    );
  }
}
