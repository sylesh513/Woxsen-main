import 'package:flutter/material.dart';
import 'package:woxsen/Pages/student_applied_for_leaves.dart';
import 'package:woxsen/Pages/student_leave_application_form.dart';
import 'package:woxsen/Pages/student_leave_applications.dart';
import 'package:woxsen/Pages/student_leave_status.dart';
import 'package:woxsen/Values/login_status.dart';
import 'package:woxsen/utils/responsive.dart';
import 'package:woxsen/utils/roles.dart';

class StudentLeavePage extends StatefulWidget {
  const StudentLeavePage({Key? key}) : super(key: key);
  @override
  _StudentLeavePage createState() => _StudentLeavePage();
}

class _StudentLeavePage extends State<StudentLeavePage> {
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
            color: const Color(0xffFA6978),
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: const Text(
              'Student Leave Manager',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // TODO : ONLY FOR FACULTY
          // const SizedBox(height: 20),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
          //   child: ElevatedButton(
          //     onPressed: () {
          //       Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //               builder: (context) => StudentLeaveStatus()));
          //     },
          //     child: const Text('Check Status'),
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
          if (role == ROLE_STUDENT) const SizedBox(height: 16),
          if (role == ROLE_STUDENT)
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                child: Container(
                  width: Responsive.getWidth(context),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  StudentLeaveApplicationForm()));
                    },
                    child: Text('Apply For Leave'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      textStyle: TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                )),

          // TODO : FOR FACULTY AND STUDNETS
          if (role == ROLE_PD || role == ROLE_STUDENT)
            const SizedBox(height: 16),
          if (role == ROLE_PD || role == ROLE_STUDENT)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StudentAppliedForLeaves()));
                },
                child: Text(
                    role == ROLE_STUDENT ? 'My Leaves' : 'Leave Applications'),
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
        ],
      ),
    );
  }
}
