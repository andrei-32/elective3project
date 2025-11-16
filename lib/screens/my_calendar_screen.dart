import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import '../database/database_helper.dart';
import '../models/booking.dart';
import '../models/calendar_event.dart';
// import '../models/holiday.dart'; // <<< FIX: This line has been removed.

class MyCalendarScreen extends StatefulWidget {
  final int? userId;
  const MyCalendarScreen({super.key, this.userId});

  @override
  State<MyCalendarScreen> createState() => _MyCalendarScreenState();
}

class _MyCalendarScreenState extends State<MyCalendarScreen> {
  Map<DateTime, List<CalendarEvent>> _events = {};
  late final ValueNotifier<List<CalendarEvent>> _selectedEvents;

  bool _isLoading = true;
  String _error = '';

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    _fetchAllCalendarData();
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<CalendarEvent> _getEventsForDay(DateTime day) {
    return _events[DateTime.utc(day.year, day.month, day.day)] ?? [];
  }

  Future<void> _fetchAllCalendarData() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final holidayEvents = await _fetchHolidays();
      final bookingEvents = await _fetchBookings();

      final newEvents = <DateTime, List<CalendarEvent>>{};
      for (var event in [...holidayEvents, ...bookingEvents]) {
        final date = DateTime.utc(event.date.year, event.date.month, event.date.day);
        if (newEvents[date] == null) {
          newEvents[date] = [];
        }
        newEvents[date]!.add(event);
      }

      setState(() {
        _events = newEvents;
        _isLoading = false;
        _selectedEvents.value = _getEventsForDay(_selectedDay!);
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Failed to load calendar data: $e';
      });
    }
  }

  Future<List<CalendarEvent>> _fetchHolidays() async {
    final currentYear = DateTime.now().year;
    final years = [currentYear, currentYear + 1, currentYear + 2];
    List<CalendarEvent> allHolidayEvents = [];

    for (var year in years) {
      final response = await http.get(Uri.parse('https://date.nager.at/api/v3/PublicHolidays/$year/PH'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        // FIX: Directly map the JSON to CalendarEvent
        allHolidayEvents.addAll(data.map((json) => CalendarEvent(
          title: json['name'],
          type: EventType.holiday,
          date: DateTime.parse(json['date']),
        )).toList());
      } else {
        print('Failed to load holidays for $year');
      }
    }
    return allHolidayEvents;
  }

  Future<List<CalendarEvent>> _fetchBookings() async {
    if (widget.userId == null) {
      return [];
    }
    final db = DatabaseHelper();
    final List<Booking> bookings = await db.getBookings(widget.userId!);
    return bookings.map((booking) => CalendarEvent(
      title: 'Flight to ${booking.destination}',
      type: EventType.booking,
      date: booking.departureDate,
    )).toList();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Calendar'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
          ? Center(child: Text(_error, style: const TextStyle(color: Colors.red)))
          : Column(
        children: [
          TableCalendar<CalendarEvent>(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: _calendarFormat,
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.sunday,
            onDaySelected: _onDaySelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (events.isEmpty) return null;
                bool hasBooking = events.any((event) => event.type == EventType.booking);
                return Positioned(
                  right: 1,
                  bottom: 1,
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: hasBooking ? Colors.red : Colors.blue,
                    ),
                  ),
                );
              },
            ),
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<CalendarEvent>>(
              valueListenable: _selectedEvents,
              builder: (context, events, _) {
                if (events.isEmpty) {
                  return const Center(child: Text('No events on this day.'));
                }
                return ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: event.color),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        leading: Icon(
                          event.type == EventType.booking ? Icons.flight_takeoff : Icons.celebration,
                          color: event.color,
                        ),
                        title: Text(event.title),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
