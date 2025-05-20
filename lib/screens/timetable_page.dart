import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:table_calendar/table_calendar.dart';

class AttendanceCalendarPage extends StatefulWidget {
  @override
  _AttendanceCalendarPageState createState() => _AttendanceCalendarPageState();
}

class _AttendanceCalendarPageState extends State<AttendanceCalendarPage> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  Map<DateTime, Map<String, String>> _attendanceStatus = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
    _loadAttendance();
  }

  Future<void> _loadAttendance() async {
    try {
      final data = await fetchAttendanceFromBackend();
      setState(() {
        _attendanceStatus = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      print("Error fetching attendance: $e");
    }
  }

  Future<Map<DateTime, Map<String, String>>>
      fetchAttendanceFromBackend() async {
    await Future.delayed(Duration(seconds: 2));

    final response = jsonEncode([
      {"date": "2025-05-01", "status": "Present"},
      {"date": "2025-05-02", "status": "Absent"},
      {"date": "2025-05-03", "status": "Holiday", "reason": "Good Friday"},
      {"date": "2025-05-23", "status": "Holiday", "reason": "Founders' Day"},
      {"date": "2025-05-04", "status": "Present"},
      {"date": "2025-05-05", "status": "Absent"},
    ]);

    final List<dynamic> decoded = json.decode(response);
    final Map<DateTime, Map<String, String>> result = {};

    for (var item in decoded) {
      final dateParts = item['date'].split('-').map(int.parse).toList();
      final date = DateTime.utc(dateParts[0], dateParts[1], dateParts[2]);
      result[date] = {
        'status': item['status'],
        'reason': item['reason'] ?? '',
      };
    }

    return result;
  }

  Color _getStatusColor(DateTime date) {
    final data =
        _attendanceStatus[DateTime.utc(date.year, date.month, date.day)];
    switch (data?['status']) {
      case 'Present':
        return Colors.green;
      case 'Absent':
        return Colors.red;
      case 'Holiday':
        return Colors.blue;
      default:
        return Colors.transparent;
    }
  }

  List<Widget> _buildHolidayList() {
    final holidays = _attendanceStatus.entries
        .where((entry) => entry.value['status'] == 'Holiday')
        .map((entry) => ListTile(
              title: Text(
                '${entry.key.toLocal()}'.split(' ')[0],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(entry.value['reason']?.isNotEmpty == true
                  ? entry.value['reason']!
                  : 'Holiday'),
            ))
        .toList();
    return holidays;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance Calendar'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ],
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      padding: EdgeInsets.all(12),
                      child: TableCalendar(
                        firstDay: DateTime.utc(2020, 1, 1),
                        lastDay: DateTime.utc(2030, 12, 31),
                        focusedDay: _focusedDay,
                        selectedDayPredicate: (day) =>
                            isSameDay(_selectedDay, day),
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay;
                          });
                        },
                        calendarStyle: CalendarStyle(
                          todayDecoration: BoxDecoration(
                            color: Colors.orangeAccent,
                            shape: BoxShape.circle,
                          ),
                        ),
                        calendarBuilders: CalendarBuilders(
                          defaultBuilder: (context, date, _) {
                            final color = _getStatusColor(date);
                            return Container(
                              margin: const EdgeInsets.all(6.0),
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '${date.day}',
                                style: TextStyle(
                                  color: color == Colors.transparent
                                      ? Colors.black
                                      : Colors.white,
                                ),
                              ),
                            );
                          },
                          selectedBuilder: (context, date, _) {
                            return Container(
                              margin: const EdgeInsets.all(6.0),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '${date.day}',
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    LegendRow(),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'List of Holidays:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      padding: EdgeInsets.all(8),
                      height: 300,
                      child: ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: _buildHolidayList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class LegendRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          LegendItem(color: Colors.green, label: 'Present'),
          LegendItem(color: Colors.red, label: 'Absent'),
          LegendItem(color: Colors.blue, label: 'Holiday'),
        ],
      ),
    );
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 8),
        Text(label),
      ],
    );
  }
}
