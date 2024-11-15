import 'package:flutter/material.dart';
import 'package:woxsen/Pages/document_viewer.dart';
import 'package:woxsen/Pages/video_player.dart';

class StudentAppliedForLeaveDetails extends StatelessWidget {
  final Map<String, dynamic> application;

  const StudentAppliedForLeaveDetails({
    Key? key,
    required this.application,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('Application Details: $application');

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
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  LeaveDetailsCard(application: application),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            'Application accepted',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18),
                          ),
                          backgroundColor: Colors.green.shade500,
                          padding: const EdgeInsets.all(20),
                        ),
                      );
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
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Application rejected',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18),
                          ),
                          backgroundColor: Colors.red.shade500,
                          padding: EdgeInsets.all(20),
                        ),
                      );
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
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        )),
                  ),
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

  const LeaveDetailsCard({
    Key? key,
    required this.application,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('Application Details is Here: $application');

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(application['leave_type'],
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('28th Nov 2024', style: TextStyle(color: Colors.grey)),
              ],
            ),
            SizedBox(height: 16),
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
                if (application['document_url'] != null ||
                    application['video_url'] != null) ...[
                  const Text(
                    'Supporting Documents',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                ],
                Column(
                  children: [
                    if (application['document_url'] != null) ...[
                      DocumentButton(
                        icon: Icons.picture_as_pdf,
                        text: application['document_url']?.split('/').last,
                        customWidget: DocumentViewerScreen(
                            url: application['document_url']),
                      ),
                      const SizedBox(width: 8),
                    ],
                    if (application['video_url'] != null) ...[
                      DocumentButton(
                        icon: Icons.video_library,
                        text: application['video_url'].split('/').last,
                        customWidget:
                            VideoPlayerScreen(url: application['video_url']),
                      ),
                    ],
                  ],
                ),
              ],
            )

            // const SizedBox(height: 16),
            // const Text('Supporting Documents',
            //     style: TextStyle(fontWeight: FontWeight.bold)),
            // const SizedBox(height: 8),
            // Row(
            //   children: [
            //     DocumentButton(
            //       icon: Icons.picture_as_pdf,
            //       text: 'somefile.pdf',
            //       customWidget: DocumentViewerScreen(),
            //     ),
            //     const SizedBox(width: 8),
            //     DocumentButton(
            //       icon: Icons.video_library,
            //       text: 'somevideo.mp4',
            //       customWidget: VideoPlayerScreen(),
            //     ),
            //   ],
            // ),
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
            child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
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
