// lib/models/holiday.dart

class Holiday {
  final String name;
  final DateTime date;

  Holiday({required this.name, required this.date});

  // A factory constructor to create a Holiday from a map (JSON object)
  factory Holiday.fromJson(Map<String, dynamic> json) {
    return Holiday(
      name: json['name'],
      date: DateTime.parse(json['date']),
    );
  }
}
