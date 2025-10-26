import './flight.dart';

class Booking {
  final Flight flight;
  final String tripType;
  final DateTime departureDate;
  final DateTime? returnDate;
  final int adults;
  final int children;
  final int infants;
  final String flightClass;

  Booking({
    required this.flight,
    required this.tripType,
    required this.departureDate,
    this.returnDate,
    this.adults = 1,
    this.children = 0,
    this.infants = 0,
    required this.flightClass,
  });
}
