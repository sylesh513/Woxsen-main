import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:woxsen/Pages/leave_approval.dart';
import 'package:http/http.dart' as http;

// class LeaveApplication {
//   final String type;
//   final String dateRange;
//   final String applicantName;
//   final String applicantPosition;
//   final String status;

//   LeaveApplication({
//     required this.type,
//     required this.dateRange,
//     required this.applicantName,
//     required this.applicantPosition,
//     required this.status,
//   });
// }

class LeaveApplications extends StatefulWidget {
  @override
  _LeaveApplicationsState createState() => _LeaveApplicationsState();
}

class _LeaveApplicationsState extends State<LeaveApplications> {
  // final List applications = [
  //   LeaveApplication(
  //     type: 'Sick Leave',
  //     dateRange: 'From 30th Nov To 2nd Dec',
  //     applicantName: 'Debdutta Choudhary',
  //     applicantPosition: 'Associate Dean - Associate Professor,SOB',
  //     status: 'Accepted',
  //   ),
  //   LeaveApplication(
  //     type: 'Medical Leave',
  //     dateRange: 'From 30th Nov To 2nd Dec',
  //     applicantName: 'Debdutta Choudhary',
  //     applicantPosition: 'Associate Dean - Associate Professor,SOB',
  //     status: 'Rejected',
  //   ),
  //   LeaveApplication(
  //     type: 'Sick Leave',
  //     dateRange: 'From 30th Nov To 2nd Dec',
  //     applicantName: 'Debdutta Choudhary',
  //     applicantPosition: 'Associate Dean - Associate Professor,SOB',
  //     status: 'Under Review',
  //   ),
  // ];

  List leaveapplications = [];
  @override
  void initState() {
    super.initState();
    fetchLeaveApplications();
  }

  Future<void> fetchLeaveApplications() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.106.13.71:8000/dashboard'),
      );

      print('response code is ${response.statusCode}');

      if (response.statusCode == 200) {
        print('RESPONSE FOR LEAVE APPLICATION ${response.body}');

        setState(() {
          leaveapplications = (json.decode(response.body) as List<dynamic>);
        });

        print('Leave Applications fetched successfully ');
        print(leaveapplications);
      } else {
        throw Exception('Failed to fetch leave applications');
      }
    } catch (e) {
      print(e);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Applications'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Container(
            color: Color(0xFFFF7F7F),
            padding: EdgeInsets.symmetric(vertical: 24),
            child: const Center(
              child: Text(
                'Leave Applications',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: leaveapplications.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            LeaveApproval(leavedata: leaveapplications[index]),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.all(8),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                leaveapplications[index]['leave_type'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              _buildStatusChip(
                                  leaveapplications[index]['status']),
                            ],
                          ),
                          Text(leaveapplications[index]['reason']),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  'Start date ${leaveapplications[index]['start_date']}'),
                              Text(
                                  'End date ${leaveapplications[index]['end_date']}'),
                            ],
                          ),
                          Text(
                            leaveapplications[index]['name'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color backgroundColor;
    switch (status) {
      case 'Accepted':
        backgroundColor = Colors.green.shade100;
        break;
      case 'Rejected':
        backgroundColor = Colors.red.shade100;
        break;
      case 'Under Review':
        backgroundColor = Colors.yellow.shade100;
        break;
      default:
        backgroundColor = Colors.grey.shade100;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(fontSize: 12),
      ),
    );
  }
}

// class ApplicationDetailScreen extends StatelessWidget {
//   final LeaveApplication application;

//   ApplicationDetailScreen({required this.application});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(application.type),
//       ),
//       body: Center(
//         child: Text('Details for ${application.type} application'),
//       ),
//     );
//   }
// }
