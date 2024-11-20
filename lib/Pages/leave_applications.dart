import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:woxsen/Pages/leave_approval.dart';
import 'package:http/http.dart' as http;
import 'package:woxsen/Values/login_status.dart';
import 'package:woxsen/Values/subjects_list.dart';
import 'package:woxsen/utils/roles.dart';

class LeaveApplications extends StatefulWidget {
  @override
  _LeaveApplicationsState createState() => _LeaveApplicationsState();
}

class _LeaveApplicationsState extends State<LeaveApplications> {
  List leaveapplications = [];
  String role = 'role';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    await getRole();
    await fetchLeaveApplications();
  }

  Future<void> getRole() async {
    String roleType = await UserPreferences.getRole();
    setState(() {
      role = roleType;
    });
  }

  Future<void> fetchLeaveApplications() async {
    ListStore store = ListStore();

    try {
      UserPreferences userPreferences = UserPreferences();
      String email = await userPreferences.getEmail();

      String url = role == ROLE_FACULTY || role == ROLE_PD
          ? '${store.woxUrl}/api/get_faculty_leaves'
          : role == ROLE_DEAN
              ? '${store.woxUrl}/dashboard'
              : '';

      final httpRequest = role == ROLE_FACULTY || role == ROLE_PD
          ? await http.post(Uri.parse(url),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(<String, String>{
                'email_id': email,
              }))
          : role == ROLE_DEAN
              ? await http.get(
                  Uri.parse(url),
                )
              : null;

      final response = httpRequest;

      if (response!.statusCode == 200) {
        setState(() {
          leaveapplications = (json.decode(response.body) as List<dynamic>);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch leave applications');
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  color: const Color(0xFFFF7F7F),
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: const Center(
                    child: Text(
                      'Leave Applications Faculty',
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
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LeaveApproval(
                                  leavedata: leaveapplications[index]),
                            ),
                          );
                          if (result == true) {
                            setState(() {
                              isLoading = true;
                            });
                            await fetchLeaveApplications();
                          }
                        },
                        child: Card(
                          margin: const EdgeInsets.all(8),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        'Start date ${leaveapplications[index]['start_date']}'),
                                    Text(
                                        'End date ${leaveapplications[index]['end_date']}'),
                                  ],
                                ),
                                Text(
                                  leaveapplications[index]['name'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
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
}
