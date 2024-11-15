import 'dart:ffi';

import 'package:flutter/material.dart';

class LeaveApproval extends StatelessWidget {
  final Map<String, dynamic> leavedata;

  LeaveApproval({Key? key, required this.leavedata});

//   leave data: {
// 	end_date: 09 th Nov 2024,
// 	id: 3,
// 	leave_type: Earned Leave,
// 	name: Sonali Thakur,
// 	reason: Function,
// 	start_date: 26 th Oct 2024,
// 	status: Under Review,
// 	status_manager1: null,
// 	status_manager2: null,
// 	status_manager3: null,
// 	total_days: 12
// }

  @override
  Widget build(BuildContext context) {
    print('leave data : $leavedata');
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Leave Status', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.grey[200],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.pink[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(leavedata['leave_type'],
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    _buildDetailRow(
                        'Total Leave Days', leavedata['total_days'].toString()),
                    _buildDetailRow('Start Date', leavedata['start_date']),
                    _buildDetailRow('End Date', leavedata['end_date']),
                    _buildDetailRow('Reason', leavedata['reason']),
                    SizedBox(height: 8),
                    Text('Applied By',
                        style: TextStyle(color: Colors.grey[600])),
                    Text(leavedata['name'],
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    // Text('Associate Dean - Associate Professor,SOB',
                    //     style: TextStyle(fontStyle: FontStyle.italic)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text('Status',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _buildApprovalStatus('Manager 1',
                  "${leavedata['status_manager1'] == null ? 'Under Review' : leavedata['status_manager1']}"),
              _buildApprovalStatus('Manager 2',
                  "${leavedata['status_manager2'] == null ? 'Under Review' : leavedata['status_manager1']}"),
              _buildApprovalStatus('Manager 3',
                  "${leavedata['status_manager3'] == null ? 'Under Review' : leavedata['status_manager1']}"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildApprovalStatus(String managerName, String status) {
    var color = status == 'Under Review'
        ? const Color.fromARGB(255, 223, 202, 14)
        : status == 'Approved'
            ? Colors.green
            : Colors.red;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(status, style: TextStyle(color: Colors.grey[600])),
          const SizedBox(width: 8),
          Text(managerName,
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
