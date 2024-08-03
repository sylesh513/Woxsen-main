import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:woxsen/Values/app_routes.dart';
import 'package:http/http.dart' as http;

class applyJob extends StatefulWidget {
  const applyJob({super.key});

  @override
  _applyJobState createState() => _applyJobState();
}

class _applyJobState extends State<applyJob> {
  final List<Map<String, dynamic>> items = [
    {
      "title": "Stuent Engagement Coordinator",
      "applicants": 7,
      "department": "VP Office",
      "pdfLink": "assets/Student_Engagement.pdf",
      'description':
          "The Student Engagement Coordinator is a part-time role dedicated to fostering a vibrant and inclusive campus community by enhancing student engagement through various activities, events, and programs. This position involves supporting administrative tasks, coordinating student initiatives, and collaborating with the schools, Centers of Excellence (COEs), student council, clubs, and other departments at Woxsen University to ensure a positive student experiene."
    },
    {
      "title": "Mobile Application Developer",
      "applicants": 4,
      "department": "AI research center",
      "pdfLink": "assets/App_Development.pdf",
      'description':
          'We are looking for a creative Mobile Application Developer to join our team. The ideal candidate will be a fresher or have up to 1 year of experience in mobile app development.'
    },
    {
      "title": "Web application developer",
      "applicants": 71,
      "department": "AI research center",
      "pdfLink": "assets/Student_Engagement.pdf",
      'description':
          'we are looking for a creative web developer to join our team.'
    },
    {
      "title": "Cloud engineer",
      "applicants": 21,
      "department": "AI research center",
      "pdfLink": "assets/Student_Engagement.pdf",
      'description':
          'we are looking for an experienced cloud engineer to join our team.'
    },

    // Add more items as needed
  ];
  late Future<List<dynamic>> futureJobs;

  @override
  void initState() {
    super.initState();
    futureJobs = fetchJobs();
  }

  Future<List<dynamic>> fetchJobs() async {
    final response =
        await http.get(Uri.parse('http://100.29.97.185:5000/api/jobs_list'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body) as List<dynamic>;
      return jsonResponse;
    } else {
      throw Exception('Failed to load jobs');
    }
  }

  String? _getString(dynamic value) {
    if (value == null) {
      return 'No Data';
    } else if (value is int) {
      return value.toString();
    } else if (value is String) {
      return value;
    } else {
      return 'Invalid Data';
    }
  }

  bool isAlredyCalled = false;

  Future<dynamic> loadingOnScreen(BuildContext context) {
    return showDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SizedBox(
          height: 100,
          width: 100,
          child: Center(
            child: SpinKitSpinningLines(
              color: Colors.red.shade800,
              size: 70.0,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      floatingActionButton: FloatingActionButton(
        heroTag: 'homebutton',
        backgroundColor: Color(0xffFA6978),
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.pushReplacementNamed(context, AppRoutes.homePage);
        },
        child: const Icon(
          Icons.home_rounded,
          size: 40,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.08,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(40)),
        ),
        child: const BottomAppBar(
          color: Color(0xffDBDBDB),
          shape: CircularNotchedRectangle(),
          notchMargin: 10.0,
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 100,
        leading: IconButton(
          icon: const Icon(Icons.menu, size: 30, color: Color(0xffFA6978)),
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.menuPage);

            // Handle menu button press
          },
        ),
        title: Center(
          child: Image.asset(
            'assets/top.png',
            fit: BoxFit.cover,
            height: 90, // Adjust the size according to your logo
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.notifications_active_rounded,
              size: 30,
              color: Color(0xffFA6978),
            ),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.notificationsPage);

              // Handle notifications button press
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.07,
            decoration: const BoxDecoration(
              color: Color(0xffFA6978),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(width: 5),
                Text(
                  'Campus Jobs',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                buildRow(context, 'Full Name', TextEditingController()),
              ],
            ),
          )
        ],
      ),
    );
  }

  Container buildRow(
      BuildContext context, String hintText, TextEditingController controller) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.83,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 9,
            offset: const Offset(4, 7), // changes position of shadow
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        onChanged: (value) {
          setState(() {
            print('changeddddd');
          });
        },
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(
              Radius.circular(16),
            ),
          ),
        ),
      ),
    );
  }
}
