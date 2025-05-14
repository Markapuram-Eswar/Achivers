import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Main page that combines the calendar view and tabs for Attendance, Holiday, and Today's Classes
class TimetablePage extends StatefulWidget {
  @override
  _TimetablePageState createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  Map<DateTime, String> _attendanceStatus = {}; // For storing attendance status

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
  }

  // Function to fetch attendance data from the backend for the selected day
  Future<void> fetchAttendanceData(String userId, String month) async {
    try {
      final response = await http.get(
        Uri.parse('http://your-api-url/attendance/$userId?month=$month'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Process and update the UI with the fetched data
        setState(() {
          _attendanceStatus = Map.fromIterable(
            data,
            key: (item) => DateTime.parse(item['date']),
            value: (item) => item['status'],
          );
        });
      } else {
        throw Exception('Failed to load attendance data');
      }
    } catch (e) {
      print(e);
    }
  }

  // Get color for each day's attendance status
  Color _getDayColor(DateTime date) {
    String? status = _attendanceStatus[date];
    switch (status) {
      case 'Present':
        return Colors.blue; // Attended
      case 'Absent':
        return Colors.red; // Absent
      case 'Holiday':
        return Colors.green; // Holiday
      default:
        return Colors.transparent; // No data yet
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Class Timetable"),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2025, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              fetchAttendanceData(
                  "user123", "2025-05"); // Fetch attendance for selected month
            },
            calendarBuilders: CalendarBuilders(
              selectedBuilder: (context, date, events) {
                return Container(
                  margin: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: Colors.blue, // selected day color
                    shape: BoxShape.circle,
                  ),
                  child: Center(child: Text('${date.day}')),
                );
              },
              defaultBuilder: (context, date, events) {
                return Container(
                  margin: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: _getDayColor(date),
                    shape: BoxShape.circle,
                  ),
                  child: Center(child: Text('${date.day}')),
                );
              },
            ),
          ),
          // Tabs for Attendance, Holiday, and Today's Classes
          Expanded(
            child: TimetableTabs(),
          ),
        ],
      ),
    );
  }
}

// Tabs widget to display different sections like Attendance, Holiday, and Today's Classes
class TimetableTabs extends StatefulWidget {
  @override
  _TimetableTabsState createState() => _TimetableTabsState();
}

class _TimetableTabsState extends State<TimetableTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: "Attendance"),
            Tab(text: "Holiday"),
            Tab(text: "Today's Classes"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          AttendanceTab(), // Attendance Tab
          HolidayTab(), // Holiday Tab
          TimetableTab(), // Today's Classes Tab
        ],
      ),
    );
  }
}

// Attendance Tab widget
class AttendanceTab extends StatelessWidget {
  final List<Map<String, dynamic>> subjectAttendance = [
    {"subject": "Math", "attendance": 95},
    {"subject": "Physics", "attendance": 85},
    {"subject": "Chemistry", "attendance": 90},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: subjectAttendance.length,
      itemBuilder: (context, index) {
        final subject = subjectAttendance[index];
        return Card(
          margin: EdgeInsets.all(10),
          child: ListTile(
            title: Text(subject["subject"]),
            subtitle: Text("Attendance: ${subject["attendance"]}%"),
            trailing: CircularProgressIndicator(
              value: subject["attendance"] / 100,
              strokeWidth: 6,
            ),
          ),
        );
      },
    );
  }
}

// Holiday Tab widget
class HolidayTab extends StatelessWidget {
  final List<Map<String, dynamic>> holidays = [
    {"date": "2025-05-01", "reason": "Lab Holiday"},
    {"date": "2025-05-02", "reason": "Public Holiday"},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: holidays.length,
      itemBuilder: (context, index) {
        final holiday = holidays[index];
        return Card(
          margin: EdgeInsets.all(10),
          child: ListTile(
            title: Text("Holiday: ${holiday['date']}"),
            subtitle: Text("Reason: ${holiday['reason']}"),
          ),
        );
      },
    );
  }
}

// Today's Classes Tab widget
class TimetableTab extends StatelessWidget {
  final List<Map<String, dynamic>> classes = [
    {
      "subject": "Mathematics",
      "start_time": "10:00",
      "end_time": "11:30",
      "teacher_name": "Prof. John"
    },
    {
      "subject": "Physics",
      "start_time": "12:00",
      "end_time": "13:30",
      "teacher_name": "Prof. Sarah"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: classes.length,
      itemBuilder: (context, index) {
        final classDetails = classes[index];
        return Card(
          margin: EdgeInsets.all(10),
          child: ListTile(
            title: Text(classDetails["subject"]),
            subtitle: Text(
                "Time: ${classDetails['start_time']} - ${classDetails['end_time']}"),
            trailing: Text("Teacher: ${classDetails['teacher_name']}"),
          ),
        );
      },
    );
  }
}
