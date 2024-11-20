import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:woxsen/Values/login_status.dart';
import 'package:woxsen/utils/roles.dart';

class LeaveApproval extends StatefulWidget {
  final Map<String, dynamic> leavedata;

  const LeaveApproval({super.key, required this.leavedata});

  @override
  _LeaveApproval createState() => _LeaveApproval();
}

class _LeaveApproval extends State<LeaveApproval> {
  bool _faculty = false;
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

  @override
  Widget build(BuildContext context) {
    final leavedata = widget.leavedata;

    print(leavedata);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title:
            const Text('Leave Status', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.grey[200],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
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
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    _buildDetailRow(
                        'Total Leave Days', leavedata['total_days'].toString()),
                    _buildDetailRow('Start Date', leavedata['start_date']),
                    _buildDetailRow('End Date', leavedata['end_date']),
                    _buildDetailRow('Reason', leavedata['reason']),
                    const SizedBox(height: 8),
                    if (role == ROLE_DEAN)
                      Text('Applied By',
                          style: TextStyle(color: Colors.grey[600])),
                    if (role == ROLE_DEAN)
                      Text(leavedata['name'],
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    // Text('Associate Dean - Associate Professor,SOB',
                    //     style: TextStyle(fontStyle: FontStyle.italic)),
                  ],
                ),
              ),

              //

              if (role == ROLE_DEAN || role == ROLE_FACULTY)
                const SizedBox(height: 24),
              if (role == ROLE_DEAN || role == ROLE_FACULTY)
                const Text('Status',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

              // Only accessed to Faculty
              if (role == ROLE_FACULTY)
                Text(
                  leavedata['status'] == "Under Review"
                      ? "Your application is in Under Review"
                      : "Your application is ${leavedata['status']}",
                  style: const TextStyle(
                      fontSize: 24, fontStyle: FontStyle.italic),
                ),

              // Only accessed to Dean / Associate Dean
              if (role == ROLE_DEAN) const SizedBox(height: 8),
              if (role == ROLE_DEAN)
                _buildApprovalStatus(
                    'Program Director',
                    "${leavedata['remarks_manager1'] == null ? 'No remarks provided' : leavedata['remarks_manager1']}",
                    "${leavedata['status_manager1'] == null ? 'Under Review' : leavedata['status_manager1']}"),
              if (role == ROLE_DEAN)
                _buildApprovalStatus(
                    'Progran Manager',
                    "${leavedata['remarks_manager2'] == null ? 'No remarks provided' : leavedata['remarks_manager2']}",
                    "${leavedata['status_manager2'] == null ? 'Under Review' : leavedata['status_manager1']}"),
              if (role == ROLE_DEAN)
                _buildApprovalStatus(
                    'Dean / Associate Dean',
                    "${leavedata['remarks_manager3'] == null ? 'No remarks provided' : leavedata['remarks_manager3']}",
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
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildApprovalStatus(
      String managerName, String remarks, String status) {
    var color = status == 'Under Review'
        ? const Color.fromARGB(255, 223, 202, 14)
        : status == 'Approved'
            ? Colors.green
            : Colors.red;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
              Text(managerName,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Text(status, style: TextStyle(color: Colors.grey[600])),
            ],
          ),
          const SizedBox(height: 8),
          Text('Remarks : $remarks',
              style: const TextStyle(
                  color: Colors.grey, fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }
}
