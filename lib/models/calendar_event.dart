// lib/models/calendar_event.dart
import 'package:flutter/material.dart';

enum EventType { holiday, booking }

class CalendarEvent {
  final String title;
  final EventType type;
  final DateTime date;

  CalendarEvent({
    required this.title,
    required this.type,
    required this.date,
  });

  // Helper to get the display color
  Color get color {
    return type == EventType.booking ? Colors.red : Colors.blue;
  }
}
