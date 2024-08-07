import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:woxsen/Pages/academics_page.dart';
import 'package:woxsen/Pages/campus_jobs.dart';
import 'package:woxsen/Pages/create_job.dart';
import 'package:woxsen/Values/app_routes.dart';
import 'package:http/http.dart' as http;

class campusJobsAdmin extends StatefulWidget {
  const campusJobsAdmin({super.key});

  @override
  _campusJobsAdminState createState() => _campusJobsAdminState();
}

class _campusJobsAdminState extends State<campusJobsAdmin> {
  final List<Map<String, dynamic>> items = [
    {"title": "Job 1", "applicants": 100},
    {"title": "Job 2", "applicants": 150},
    {"title": "Job 3", "applicants": 200},
    {"title": "Job 4", "applicants": 100},
    {"title": "Job 5", "applicants": 150},
    {"title": "Job 6", "applicants": 200},
    {"title": "Job 7", "applicants": 100},
    {"title": "Job 8", "applicants": 150},
    {"title": "Job 9", "applicants": 200},

    // Add more items as
  ];
  int jobCount = 0;
  updateCount(int count) {
    print('ca;;ed');
    setState(() {
      jobCount = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      floatingActionButton: FloatingActionButton(
        heroTag: 'newhomebutton',
        backgroundColor: const Color(0xffFA6978),
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
          // const SizedBox(height: 20),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 120,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceEvenly, // This centers the cards with equal space around them.
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width *
                          0.46, // 40% of screen width
                      height: 90,
                      child: Card(
                        color: const Color(0xffF2C9CD),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              title: const Text(
                                'Total jobs',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w400),
                              ),
                              subtitle: Text(
                                jobCount.toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.46,
                      height: 90, // 40% of screen width
                      child: const Card(
                        color: Color(0xffF2C9CD),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              title: Text(
                                'Total Applications',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w400),
                              ),
                              subtitle: Text(
                                '252',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 380, // Changeable height
                  width: MediaQuery.of(context).size.width * 0.85,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: campusJobs(
                      isBox: false,
                      updateCount: updateCount,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.42,
                    height: 60, // Set height
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200, // Background color
                      borderRadius: BorderRadius.circular(
                          10), // Optional: Rounded corners
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.add_circle,
                          size: 40,
                          color: Colors.green), // Add button with green color
                      onPressed: () {
                        print("add job");
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              return FadeTransition(
                                opacity: animation,
                                child: CreateJob(
                                  title: "Post a job",
                                ),
                              );
                            },
                          ),
                        );
                        // Action to perform on button press
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.42,
                    height: 60, // Set height
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200, // Background color
                      borderRadius: BorderRadius.circular(
                          10), // Optional: Rounded corners
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.download,
                          size: 40,
                          color: Colors.green), // Add button with green color
                      onPressed: () async {
                        print("download jobs");
                        const String apiUrl =
                            'http://10.106.23.119:8000/api/download_applications';
                        final response = await http.post(
                          Uri.parse(apiUrl),
                          headers: <String, String>{
                            'Content-Type': 'application/json; charset=UTF-8',
                          },
                        );
                        if (response.statusCode == 200) {
                          final bytes = response.bodyBytes;
                          final dir = await getApplicationDocumentsDirectory();
                          final file =
                              File('${dir?.path}/JobsApplications.csv');

                          await file.writeAsBytes(bytes);
                          setState(() {
                            var _pdfPath = file.path;
                            print(_pdfPath);

                            // Navigator.push(context,
                            //     MaterialPageRoute(builder: (context) {
                            //   return pdfView(pdfPath: _pdfPath);
                            // }));
                          });
                        }

                        // Action to perform on button press
                      },
                    ),
                  ),
                ],
              )
            ],
          )),
        ],
      ),
    );
  }
}
