import 'package:flutter/material.dart';
import 'package:woxsen/Pages/faculties_list_page.dart';
import 'package:woxsen/Pages/faculty_leave_application_form.dart';
import 'package:woxsen/Pages/faculty_leave_status.dart';
import 'package:woxsen/Pages/leave_applications.dart';
import 'package:woxsen/Values/login_status.dart';
import 'package:woxsen/utils/roles.dart';

class FacultyLeavePage extends StatefulWidget {
  const FacultyLeavePage({super.key});

  @override
  _FacultyLeavePage createState() => _FacultyLeavePage();
}

class _FacultyLeavePage extends State<FacultyLeavePage> {
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
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title:
            const Text('Leave Manager', style: TextStyle(color: Colors.black)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: Color(0xffFA6978),
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'Faculty Leave Manager',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // TODO : ONLY FOR FACULTY
          // SizedBox(height: 20),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
          //   child: ElevatedButton(
          //     onPressed: () {
          //       Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //               builder: (context) => FacultyLeaveStatus()));
          //     },
          //     child: Text('See Status'),
          //     style: ElevatedButton.styleFrom(
          //       foregroundColor: Colors.black,
          //       backgroundColor: Colors.white,
          //       padding: EdgeInsets.symmetric(vertical: 16),
          //       textStyle: TextStyle(fontSize: 18),
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(8),
          //       ),
          //     ),
          //   ),
          // ),
          // TODO : ONLY FOR FACULTY
          if (role == ROLE_FACULTY || role == ROLE_PD) SizedBox(height: 16),
          if (role == ROLE_FACULTY || role == ROLE_PD)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FacultyLeaveApplicationForm()));
                },
                child: Text('Apply For Leave'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          // TODO : ONLY FOR PROGRAMME DIRECTORS
          const SizedBox(height: 16),
          if (role == ROLE_FACULTY || role == ROLE_DEAN || role == ROLE_PD)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LeaveApplications()));
                },
                child: const Text('Applications'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          // TODO : ONLY FOR Programme Directors
          // const SizedBox(height: 16),
          // if (role == ROLE_PD)
          //   Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
          //     child: ElevatedButton(
          //       onPressed: () {
          //         Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //                 builder: (context) => FacultiesListPage()));
          //       },
          //       child: Text('Faculties Leaves Availability'),
          //       style: ElevatedButton.styleFrom(
          //         foregroundColor: Colors.black,
          //         backgroundColor: Colors.white,
          //         padding: const EdgeInsets.symmetric(vertical: 16),
          //         textStyle: const TextStyle(fontSize: 18),
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(8),
          //         ),
          //       ),
          //     ),
          //   ),
        ],
      ),
    );
  }
}
