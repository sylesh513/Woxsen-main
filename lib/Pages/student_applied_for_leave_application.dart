import 'package:flutter/material.dart';

class StudentAppliedForLeaveApplication extends StatelessWidget {
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
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  LeaveDetailsCard(),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Accept'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Reject'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      minimumSize: Size(double.infinity, 50),
                    ),
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
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Sick Leave',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                // Text('28th Nov 2024', style: TextStyle(color: Colors.grey)),
              ],
            ),
            SizedBox(height: 16),
            _buildDetailRow('Name', 'John Doe'),
            _buildDetailRow('Email', 'Johndoe_2025@Woxsen.Edu.In'),
            _buildDetailRow('Start Date', '30th Nov 2024'),
            _buildDetailRow('End Date', '2nd Dec 2024'),
            _buildDetailRow('Total Days', '3'),
            _buildDetailRow('Semester', 'VI'),
            _buildDetailRow('Department', 'BBA'),
            _buildDetailRow('Leave Reason',
                'Leave Reason Shoule Be Here And It Might Be Long............'),
            SizedBox(height: 16),
            Text('Supporting Documents',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Row(
              children: [
                DocumentButton(
                    icon: Icons.picture_as_pdf, text: 'SomeFile.Pdf'),
                SizedBox(width: 8),
                DocumentButton(
                    icon: Icons.video_library, text: 'SomeVideo.Mp4'),
              ],
            ),
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

  const DocumentButton({Key? key, required this.icon, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 18),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.grey[300],
      ),
    );
  }
}
