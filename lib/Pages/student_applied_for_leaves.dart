import 'package:flutter/material.dart';
import 'package:woxsen/Pages/student_applied_for_leave_details.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:woxsen/Values/login_status.dart';

import 'package:woxsen/Values/subjects_list.dart';
import 'package:woxsen/utils/roles.dart';

class StudentAppliedForLeaves extends StatefulWidget {
  @override
  _StudentAppliedForLeavesState createState() =>
      _StudentAppliedForLeavesState();
}

class _StudentAppliedForLeavesState extends State<StudentAppliedForLeaves> {
  ListStore store = ListStore();
  String role = 'role';
  late Future<List<dynamic>> futureLeaveApplications;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    await getRole();
    setState(() {
      futureLeaveApplications = fetchLeaveApplications();
    });
  }

  Future<void> getRole() async {
    String roleType = await UserPreferences.getRole();
    setState(() {
      role = roleType;
    });
  }

  Future<List<dynamic>> fetchLeaveApplications() async {
    UserPreferences userPreferences = UserPreferences();
    String email = await userPreferences.getEmail();

    Map<String, dynamic> user = await userPreferences.getProfile(email);

    String apiEndpoint = role == ROLE_PD
        ? '${store.woxUrl}/api/st_leave_all_appl'
        : role == ROLE_STUDENT
            ? '${store.woxUrl}/api/st_leaves'
            : '';

    try {
      setState(() {
        _isLoading = true;
      });
      final httpRequest = role == ROLE_STUDENT
          ? await http.post(Uri.parse('${store.woxUrl}/api/st_leaves'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(<String, String>{
                'email_id': email,
              }))
          : role == ROLE_PD
              ? await http.get(Uri.parse(apiEndpoint))
              : null;

      final response = httpRequest;

      if (response!.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);

        return jsonResponse.map((data) => data).toList();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Failed to load leave applications'),
        ));
        throw Exception('Failed to load leave applications');
      }
    } catch (e) {
      print(' Error fetching leave applications: $e');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Something went wrong'),
      ));
      throw Exception('Failed to lsoad leave applications');
    } finally {
      setState(() {
        _isLoading = false;
      });
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
            color: const Color(0xFFFF7F7F),
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: const Text(
              'Leave Applications',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : FutureBuilder<List<dynamic>>(
                    future: futureLeaveApplications,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text('No leave applications found.'));
                      } else {
                        return ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            var application = snapshot.data![index];
                            return Column(
                              children: [
                                LeaveApplicationCard(
                                    application: application, role: role),
                                const SizedBox(height: 16),
                              ],
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
}

Color getStatusColor(String status) {
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

class LeaveApplicationCard extends StatelessWidget {
  final Map<String, dynamic> application;
  final role;
  final userId;

  const LeaveApplicationCard(
      {Key? key, required this.application, required this.role, this.userId})
      : super(key: key);

  String capitalize(String s) =>
      s[0].toUpperCase() + s.substring(1).toLowerCase();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => StudentAppliedForLeaveDetails(
                  application: application, role: role)),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(application['name'],
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  _buildStatusChip(
                    application['status'],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                  'Leave: From ${DateFormat('d MMM yyyy').format(DateTime.parse(application['start_date']))} - To ${DateFormat('d MMM yyyy').format(DateTime.parse(application['start_date']))}',
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Text(capitalize(application['leave_type']),
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(application['reason_for_leave'] ?? 'N/A',
                  style: TextStyle(fontSize: 16, color: Colors.grey[800])),
            ],
          ),
        ),
      ),
    );
  }
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
