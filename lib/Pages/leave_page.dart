import 'package:flutter/material.dart';
import 'package:woxsen/Pages/faculties_list_page.dart';
import 'package:woxsen/Pages/faculty_leave_application_form.dart';
import 'package:woxsen/Pages/faculty_leave_status.dart';
import 'package:woxsen/Pages/leave_applications.dart';
import 'package:woxsen/Values/login_status.dart';
import 'package:woxsen/utils/colors.dart';
import 'package:woxsen/utils/responsive.dart';
import 'package:woxsen/utils/roles.dart';

class FacultyLeavePage extends StatefulWidget {
  const FacultyLeavePage({Key? key}) : super(key: key);

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

  Widget _buildButton({
    required String text,
    required VoidCallback onPressed,
    required BuildContext context,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.05,
        vertical: 8,
      ),
      child: SizedBox(
        width: Responsive.getWidth(context),
        height: Responsive.getHeight(context),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            foregroundColor: AppColors.primary,
            backgroundColor: Colors.white,
            textStyle: const TextStyle(
              fontSize: 18,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 3,
          ),
          child: Text(
            text,
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: Responsive.getWidth(context),
              color: const Color(0xffFA6978),
              padding: const EdgeInsets.all(20),
              child: const Text(
                'Faculty Leave Manager',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (role == ROLE_FACULTY || role == ROLE_PD)
              _buildButton(
                text: 'Apply For Leave',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FacultyLeaveApplicationForm()),
                  );
                },
                context: context,
              ),
            const SizedBox(height: 20),
            if (role == ROLE_FACULTY || role == ROLE_DEAN || role == ROLE_PD)
              _buildButton(
                text: 'Applications',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LeaveApplications()),
                  );
                },
                context: context,
              ),
            const SizedBox(height: 20),
            if (role == ROLE_PD || role == ROLE_DEAN)
              _buildButton(
                text: 'Faculties Leaves Availability',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FacultiesListPage()),
                  );
                },
                context: context,
              ),
          ],
        ),
      ),
    );
  }
}
