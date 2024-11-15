import 'package:flutter/material.dart';

void main() {}

class FacultyAttendancePage extends StatelessWidget {
  const FacultyAttendancePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppBar(
            title: const Text('Attendance Sheet'),
            backgroundColor: Colors.grey[300],
            foregroundColor: Colors.black,
            elevation: 0,
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xffFA6978),
            width: double.infinity,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Engineering Mathematics',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '20th Aug, 2024',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    Text(
                      'B. Tech, Semester 3',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  LegendItem(
                      text: ' P = Present', color: Colors.green.shade100),
                  LegendItem(text: ' A = Absent', color: Colors.red.shade100),
                  LegendItem(text: ' O = OD/ML', color: Colors.grey.shade100),
                ]),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 100, // Number of students
              itemBuilder: (context, index) {
                return StudentCard(
                  name: 'Sobit Prasad',
                  rollNo: 'WU20/2323/2..',
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class LegendItem extends StatelessWidget {
  final String text;
  final Color color;

  const LegendItem({Key? key, required this.text, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        Text(text, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}

class StudentCard extends StatelessWidget {
  final String name;
  final String rollNo;

  StudentCard({
    Key? key,
    required this.name,
    required this.rollNo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.grey[300],
              child: Icon(Icons.person, color: Colors.grey[600]),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    rollNo,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const AttendanceButton(text: 'P', color: Colors.green),
            const SizedBox(width: 8),
            const AttendanceButton(text: 'A', color: Colors.red),
            const SizedBox(width: 8),
            const AttendanceButton(text: 'O', color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

class AttendanceButton extends StatelessWidget {
  final String text;
  final Color color;

  const AttendanceButton({
    Key? key,
    required this.text,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 22,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
