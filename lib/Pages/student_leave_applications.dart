import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:woxsen/Pages/document_viewer.dart';
import 'package:woxsen/Pages/video_player.dart';
import 'package:http/http.dart' as http;
import 'package:woxsen/Values/login_status.dart';
import 'package:woxsen/Values/subjects_list.dart';
import 'dart:convert';

class StudentLeaveApplications extends StatefulWidget {
  const StudentLeaveApplications({Key? key}) : super(key: key);
  @override
  _StudentLeaveApplications createState() => _StudentLeaveApplications();
}

class _StudentLeaveApplications extends State<StudentLeaveApplications> {
  ListStore store = ListStore();

  String role = 'role';

  @override
  void initState() {
    super.initState();
    getRole();
  }

  void getRole() async {
    String roleType = await UserPreferences.getRole();
    setState(() {
      role = roleType;
    });
  }

  Future<List<dynamic>> fetchLeaveApplications() async {
    UserPreferences userPreferences = UserPreferences();
    String email = await userPreferences.getEmail();

    final httpRequest =
        await http.post(Uri.parse('${store.woxUrl}/api/st_leaves'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              'email_id': email,
            }));

    final response = httpRequest;

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);

      return jsonResponse;
    } else {
      throw Exception('Failed to load leave applications');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back navigation
          },
        ),
        title: const Text('Applications'),
      ),
      body: Column(
        children: [
          Container(
            color: const Color(0xFFFF7F7F),
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            child: const Text(
              'Your Past Applications',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: fetchLeaveApplications(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No applications found.'));
                } else {
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final application = snapshot.data![index];

                      print('EACH STUDENT APPLICATION : ${application}');

                      return LeaveCard(
                        title: application['leave_type'],
                        dateRange:
                            'From ${application['start_date']} To ${application['end_date']}',
                        reason: application['reason_for_leave'],
                        status: application['status'],
                        statusColor: _getStatusColor(application['status']),
                        details: LeaveDetails(
                          totalLeave: application['total_leaves'].toString(),
                          leaveType: application['leave_type'],
                          reason: application['reason_for_leave'],
                          hasPdf: application['document_url'] != null,
                          hasVideo: application['video_url'] != null,
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Accepted':
        return Colors.green.shade900;
      case 'Rejected':
        return Colors.red.shade900;
      case 'Pending':
        return Colors.yellow.shade900;
      default:
        return Colors.grey.shade900;
    }
  }
}

class LeaveCard extends StatefulWidget {
  final String title;
  final String dateRange;
  final String status;
  final String reason;
  final Color statusColor;
  final LeaveDetails? details;

  LeaveCard({
    required this.title,
    required this.reason,
    required this.dateRange,
    required this.status,
    required this.statusColor,
    this.details,
  });

  @override
  _LeaveCardState createState() => _LeaveCardState();
}

class _LeaveCardState extends State<LeaveCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(widget.title,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.dateRange),
                Text(widget.reason),
              ],
            ),
            trailing: Chip(
              label: Text(widget.status),
              backgroundColor: widget.statusColor.withOpacity(0.1),
              labelStyle: TextStyle(color: widget.statusColor),
              shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: widget.statusColor
                        .withOpacity(0.2)), // Set the border color here
                borderRadius:
                    BorderRadius.circular(6), // Optional: Set the border radius
              ),
            ),
            onTap: () {
              setState(() {
                _isExpanded = false;
              });
            },
          ),
          if (_isExpanded && widget.details != null)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Leave Taken - ${widget.details!.totalLeave}'),
                    Text('Leave Type - ${widget.details!.leaveType}'),
                    Text('Reason - ${widget.details!.reason}'),
                    const SizedBox(height: 8),
                    const Text('Supporting Documents -'),
                    Row(
                      children: [
                        if (widget.details!.hasPdf)
                          IconButton(
                            icon: const Icon(Icons.picture_as_pdf),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DocumentViewerScreen(
                                          url: '',
                                          filename: ''?.split('\\').last,
                                          userId: '',
                                        )),
                              );
                            },
                          ),
                        if (widget.details!.hasVideo)
                          IconButton(
                            icon: const Icon(Icons.video_library),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => VideoPlayerScreen(
                                        url: '',
                                        filename: ''?.split('\\').last,
                                        userId: '')),
                              );
                            },
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(),
        ],
      ),
    );
  }
}

class LeaveDetails {
  final String totalLeave;
  final String leaveType;
  final String reason;
  final bool hasPdf;
  final bool hasVideo;

  LeaveDetails({
    required this.totalLeave,
    required this.leaveType,
    required this.reason,
    this.hasPdf = false,
    this.hasVideo = false,
  });
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
    case 'Pending':
      backgroundColor = Colors.yellow.shade100;
      break;
    default:
      backgroundColor = Colors.grey.shade100;
  }

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      status,
      style: const TextStyle(fontSize: 12),
    ),
  );
}
