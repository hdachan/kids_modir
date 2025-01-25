import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MaterialApp(
    home: BookingSystem(),
  ));
}

class BookingSystem extends StatefulWidget {
  @override
  _BookingSystemState createState() => _BookingSystemState();
}

class _BookingSystemState extends State<BookingSystem> {
  DateTime selectedDate = DateTime.now();
  String? selectedTime;

  final List<String> timeSlots = [    '09:00 AM',    '10:00 AM',    '11:00 AM',    '01:00 PM',    '02:00 PM',    '03:00 PM',  ];

  void _bookAppointment() {
    if (selectedTime != null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('예약 완료'),
            content: Text('예약일: ${DateFormat('yyyy-MM-dd').format(selectedDate)}\n예약시간: $selectedTime'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('확인'),
              ),
            ],
          );
        },
      );
    } else {
      // 시간이 선택되지 않은 경우
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('시간을 선택해 주세요.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('예약 시스템'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('날짜 선택:', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            TableCalendar(
              focusedDay: selectedDate,
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  selectedDate = selectedDay;
                });
              },
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text('시간 선택:', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            DropdownButton<String>(
              hint: Text('시간 선택'),
              value: selectedTime,
              onChanged: (String? newValue) {
                setState(() {
                  selectedTime = newValue;
                });
              },
              items: timeSlots.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _bookAppointment,
              child: Text('예약하기'),
            ),
          ],
        ),
      ),
    );
  }
}
