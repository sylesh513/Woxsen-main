import 'package:flutter/material.dart';
import 'package:woxsen/Pages/document_viewer.dart';
import 'package:woxsen/Pages/video_player.dart';
import 'package:http/http.dart' as http;
import 'package:woxsen/Values/login_status.dart';
import 'dart:convert';
import 'package:woxsen/Values/subjects_list.dart';
import 'package:woxsen/utils/roles.dart';

class StudentAppliedForLeaveDetails extends StatefulWidget {
  final Map<String, dynamic> application;
  final String role;

  const StudentAppliedForLeaveDetails({
    Key? key,
    required this.application,
    required this.role,
  }) : super(key: key);

  @override
  _StudentAppliedForLeaveDetailsState createState() =>
      _StudentAppliedForLeaveDetailsState();
}

class _StudentAppliedForLeaveDetailsState
    extends State<StudentAppliedForLeaveDetails> {
  String? status;
  String? userId;

  @override
  void initState() {
    super.initState();
    status = widget.application['status'];
    getUserId();
  }

  Future<void> getUserId() async {
    UserPreferences userPreferences = UserPreferences();
    String? email = await userPreferences.getEmail();
    Map<String, dynamic> user = await userPreferences
        .getProfile(widget.application['email_id'].toString());
    debugPrint('USER $user');
    setState(() {
      userId = user['id'];
    });
  }

  Future<void> _updateStatus(String newStatus, BuildContext context) async {
    ListStore store = ListStore();
    try {
      final response = await http.post(
        Uri.parse('${store.woxUrl}/api/st_update_status'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email_id': widget.application['email_id'].toString(),
          'user_id': widget.application['user_id'].toString(),
          'status': newStatus,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          status = newStatus;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${jsonDecode(response.body)['message']}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
            backgroundColor: newStatus == 'Accepted'
                ? Colors.green.shade500
                : Colors.red.shade500,
            padding: const EdgeInsets.all(20),
          ),
        );
      } else {
        throw Exception('Something Went Wrong');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title:
            const Text('Applications', style: TextStyle(color: Colors.black)),
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: const Color(0xFFFF9999),
            child: const Text(
              'Leave Application',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  LeaveDetailsCard(
                      application: widget.application, userId: userId ?? ''),
                  if (widget.role == ROLE_STUDENT) const SizedBox(height: 16),
                  if (widget.role == ROLE_STUDENT)
                    if (status == 'Accepted' || status == 'Rejected') ...[
                      Text(
                        'Your leave application is ${status == 'Accepted' ? 'Accepted' : 'Rejected'}',
                        style: TextStyle(
                          color: status == 'Accepted'
                              ? Colors.green.shade700
                              : Colors.red.shade600,
                          fontSize: 20,
                        ),
                      ),
                    ] else ...[
                      Text(
                        'Your application is in Under Review',
                        style: TextStyle(
                          color: Colors.yellow.shade900,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  if (widget.role == ROLE_PD) const SizedBox(height: 16),
                  if (widget.role == ROLE_PD)
                    if (status == 'Accepted' || status == 'Rejected') ...[
                      Text(
                        'Application ${status == 'Accepted' ? 'Accepted' : 'Rejected'}',
                        style: TextStyle(
                          color: status == 'Accepted'
                              ? Colors.green.shade700
                              : Colors.red.shade600,
                          fontSize: 18,
                        ),
                      ),
                    ] else ...[
                      ElevatedButton(
                        onPressed: () async {
                          return await _updateStatus('Accepted', context);
                        },
                        child: Text('Accept',
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontSize: 18,
                            )),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade100,
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            )),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () async {
                          return await _updateStatus('Rejected', context);
                        },
                        child: Text(
                          'Reject',
                          style: TextStyle(
                            color: Colors.red.shade600,
                            fontSize: 18,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade100,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            )),
                      ),
                    ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LeaveDetailsCard extends StatelessWidget {
  final Map<String, dynamic> application;
  final String userId;

  const LeaveDetailsCard({
    Key? key,
    required this.application,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('video url ${application['video_url']}');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(application['leave_type'],
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                // Text('28th Nov 2024', style: TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 16),
            _buildDetailRow('ID', userId ?? ''),
            // _buildDetailRow('ID', userId ?? 'test'),
            _buildDetailRow('Name', application['name']),
            _buildDetailRow('Email', application['email_id']),
            _buildDetailRow('Start Date', application['start_date']),
            _buildDetailRow('End Date', application['end_date']),
            _buildDetailRow(
                'Total Days', application['total_leaves'].toString()),
            // _buildDetailRow('Semester', 'VI'),
            _buildDetailRow('Department', application['course']),
            _buildDetailRow('Leave Reason', application['reason_for_leave']),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (application['document_url'] != '' ||
                    application['video_url'] != '') ...[
                  const Text(
                    'Supporting Documents',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                ],
                if (application['document_url'].isNotEmpty ||
                    application['video_url'].isNotEmpty) ...[
                  Column(
                    children: [
                      if (application['document_url'].isNotEmpty) ...[
                        DocumentButton(
                          icon: Icons.picture_as_pdf,
                          text: application['document_url']?.split('\\').last,
                          customWidget: DocumentViewerScreen(
                              url: application['document_url'],
                              filename:
                                  application['document_url']?.split('\\').last,
                              userId: application['user_id']),
                        ),
                        const SizedBox(width: 8),
                      ],
                      if (application['video_url'].isNotEmpty) ...[
                        DocumentButton(
                          icon: Icons.video_library,
                          text: application['video_url'].split('\\').last,
                          customWidget: VideoPlayerScreen(
                              url: application['video_url'],
                              filename:
                                  application['video_url'].split('\\').last,
                              userId: application['user_id']),
                        ),
                      ],
                    ],
                  ),
                ]
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: Text(value, style: TextStyle(color: Colors.grey[600])),
          ),
        ],
      ),
    );
  }
}

class DocumentButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final Widget customWidget;

  const DocumentButton(
      {Key? key,
      required this.icon,
      required this.text,
      required this.customWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => customWidget),
        );
      },
      icon: Icon(icon, size: 18),
      label: Text(text),
      style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: Colors.grey[200],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          )),
    );
  }
}
