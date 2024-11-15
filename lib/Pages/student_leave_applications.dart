import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:woxsen/Pages/document_viewer.dart';
import 'package:woxsen/Pages/video_player.dart';

class StudentLeaveApplications extends StatelessWidget {
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
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                LeaveCard(
                  title: 'Sick Leave',
                  dateRange: 'From 30th Nov To 2nd Dec',
                  status: 'Under Review',
                  statusColor: Colors.yellow.shade100,
                  details: LeaveDetails(
                    totalLeave: '20days',
                    leaveType: 'Medical',
                    reason: 'Some Reason Should Be Here...',
                    hasPdf: true,
                    hasVideo: true,
                  ),
                ),
                LeaveCard(
                  title: 'Sick Leave',
                  dateRange: 'From 30th Nov To 2nd Dec',
                  status: 'Accepted',
                  statusColor: Colors.green,
                  details: LeaveDetails(
                    totalLeave: '20days',
                    leaveType: 'Medical',
                    reason: 'Some Reason Should Be Here...',
                    hasPdf: true,
                    hasVideo: true,
                  ),
                ),
                LeaveCard(
                  title: 'Sick Leave',
                  dateRange: 'From 30th Nov To 2nd Dec',
                  status: 'Accepted',
                  statusColor: Colors.green,
                  details: LeaveDetails(
                    totalLeave: '20days',
                    leaveType: 'Medical',
                    reason: 'Some Reason Should Be Here...',
                    hasPdf: true,
                    hasVideo: true,
                  ),
                ),
                LeaveCard(
                  title: 'Medical Leave',
                  dateRange: 'From 30th Nov To 2nd Dec',
                  status: 'Rejected',
                  statusColor: Colors.red,
                  details: LeaveDetails(
                    totalLeave: '20days',
                    leaveType: 'Medical',
                    reason: 'Some Reason Should Be Here...',
                    hasPdf: true,
                    hasVideo: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LeaveCard extends StatefulWidget {
  final String title;
  final String dateRange;
  final String status;
  final Color statusColor;
  final LeaveDetails? details;

  LeaveCard({
    required this.title,
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
            subtitle: Text(widget.dateRange),
            trailing: Chip(
              label: Text(widget.status),
              backgroundColor: widget.statusColor.withOpacity(0.2),
              labelStyle: TextStyle(color: widget.statusColor),
            ),
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
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
                                    builder: (context) =>
                                        DocumentViewerScreen(url: '')),
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
                                    builder: (context) =>
                                        VideoPlayerScreen(url: '')),
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
