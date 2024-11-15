import 'package:flutter/material.dart';

class StudentAppliedForLeaveApplications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Applications', style: TextStyle(color: Colors.black)),
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            color: Color(0xFFFF9999),
            child: Text(
              'Leave Applications',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                LeaveCard(
                  name: 'John Doe',
                  dates: 'From 30th Nov To 2nd Dec',
                  leaveType: 'Sick Leave',
                  reason: 'Some Reason Should Be Here...................',
                  status: 'Accepted',
                ),
                LeaveCard(
                  name: 'John Thomson',
                  dates: 'From 30th Nov To 2nd Dec',
                  leaveType: 'Medical Leave',
                  reason: 'Some Reason Should Be Here...................',
                  status: 'Rejected',
                ),
                LeaveCard(
                  name: 'Peter Parker',
                  dates: 'From 30th Nov To 2nd Dec',
                  leaveType: 'Festival',
                  reason: 'Some Reason Should Be Here...................',
                  status: 'Under Review',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LeaveCard extends StatelessWidget {
  final String name;
  final String dates;
  final String leaveType;
  final String reason;
  final String status;

  const LeaveCard({
    Key? key,
    required this.name,
    required this.dates,
    required this.leaveType,
    required this.reason,
    required this.status,
  }) : super(key: key);

  Color _getStatusColor() {
    switch (status) {
      case 'Accepted':
        return Colors.green;
      case 'Rejected':
        return Colors.red;
      case 'Under Review':
        return Colors.yellow;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LeaveDetailsPage(
              name: name,
              dates: dates,
              leaveType: leaveType,
              reason: reason,
              status: status,
            ),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.only(bottom: 16),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text(dates,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                  SizedBox(height: 4),
                  Text(leaveType, style: TextStyle(fontSize: 16)),
                  SizedBox(height: 4),
                  Text(reason,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                ],
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LeaveDetailsPage extends StatelessWidget {
  final String name;
  final String dates;
  final String leaveType;
  final String reason;
  final String status;

  const LeaveDetailsPage({
    Key? key,
    required this.name,
    required this.dates,
    required this.leaveType,
    required this.reason,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leave Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: $name',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Dates: $dates'),
            SizedBox(height: 8),
            Text('Leave Type: $leaveType'),
            SizedBox(height: 8),
            Text('Reason: $reason'),
            SizedBox(height: 8),
            Text('Status: $status',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
