import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:woxsen/Pages/academics_page.dart';
import 'package:woxsen/Pages/campus_jobs.dart';
import 'package:woxsen/Pages/campus_jobs_admin.dart';
import 'package:woxsen/Pages/feedback_complaints.dart';
import 'package:woxsen/Pages/lab_booking.dart';
import 'package:woxsen/Pages/leave_approval.dart';
import 'package:woxsen/Pages/leave_page.dart';
import 'package:woxsen/Pages/services_page.dart';
import 'package:woxsen/Pages/student_leave_page.dart';
import 'package:woxsen/Pages/upload_page.dart';
import 'package:woxsen/Values/app_routes.dart';
import 'package:woxsen/Values/login_status.dart';
import 'package:http/http.dart' as http;
import 'package:woxsen/utils/responsive.dart';
import 'package:woxsen/utils/roles.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _faculty = false;
  String role = 'role';

  @override
  void initState() {
    super.initState();
    getFaculty();
    getRole();
  }

  void getRole() async {
    String roleType = await UserPreferences.getRole();
    setState(() {
      role = roleType;
    });
  }

  void getFaculty() async {
    _faculty = await UserPreferences.getRole() == 'faculty' ? true : false;
    setState(() {
      _faculty = _faculty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xffFA6978),
        shape: const CircleBorder(),
        onPressed: () {
          // Navigator.pushNamed(context, AppRoutes.homePage);
        },
        child: const Icon(
          Icons.home_rounded,
          size: 40,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        width: Responsive.getWidth(context),
        height: Responsive.getHeight(context),
        // height: MediaQuery.of(context).size.height * 0.08,
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
            height: 120, // Adjust the size according to your logo
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
      body: Center(
        child: SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(
                  //     vertical: 20,
                  //   ),
                  //   child: Container(
                  //     height: MediaQuery.of(context).size.height * 0.07,
                  //     decoration: const BoxDecoration(
                  //       color: Color(0xffFA6978),
                  //     ),
                  //     child: const Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: <Widget>[
                  //         SizedBox(width: 5),
                  //         Text(
                  //           'Home',
                  //           style: TextStyle(
                  //             color: Colors.black,
                  //             fontSize: 25.0,
                  //             fontWeight: FontWeight.w700,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 40),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: Responsive.getHeight(context),
                        width: Responsive.getWidth(context),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation,
                                        secondaryAnimation) =>
                                    const Academics(), // Assuming HomePage is the page you want to navigate to
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                                transitionDuration: const Duration(
                                    milliseconds: 200), // Customize duration
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            shadowColor: Colors.black,
                            backgroundColor: const Color(
                                0xffF2C9CD), // Change background color to white
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16), // Adjust padding if needed
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ), // Adjust border radius if
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            // mainAxisSize: MainAxisSize
                            //     .min,

                            // Use min to wrap content inside the button
                            children: <Widget>[
                              Icon(
                                Icons.menu_book_sharp,
                                color: Colors.black,
                                size: 30,
                              ),
                              SizedBox(
                                  width: 12), // Space between logo and text
                              Text(
                                'Academics',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (role == ROLE_VP) const SizedBox(height: 20),
                      if (role == ROLE_VP)
                        Container(
                          height: Responsive.getHeight(context),
                          width: Responsive.getWidth(context),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: ElevatedButton(
                            onPressed: () async {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      const campusJobsAdmin(),
                                  // Assuming HomePage is the page you want to navigate to
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    );
                                  },
                                  transitionDuration: const Duration(
                                      milliseconds: 200), // Customize duration
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              shadowColor: Colors.black,
                              backgroundColor: const Color(
                                  0xffF2C9CD), // Change background color to white
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16), // Adjust padding if needed
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ), // Adjust border radius if
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              // mainAxisSize: MainAxisSize
                              //     .min,

                              // Use min to wrap content inside the button
                              children: <Widget>[
                                Icon(
                                  Icons.work,
                                  color: Colors.black,
                                  size: 30,
                                ),
                                SizedBox(
                                    width: 12), // Space between logo and text
                                Text(
                                  'Post Campus Job',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (role == ROLE_PD ||
                          role == ROLE_DEAN ||
                          role == ROLE_STUDENT)
                        const SizedBox(height: 20),
                      if (role == ROLE_PD ||
                          role == ROLE_DEAN ||
                          role == ROLE_STUDENT)
                        Container(
                          height: Responsive.getHeight(context),
                          width: Responsive.getWidth(context),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              if (role == ROLE_PD) {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        const UploadPage(), // Assuming HomePage is the page you want to navigate to
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      );
                                    },
                                    transitionDuration: const Duration(
                                        milliseconds:
                                            200), // Customize duration
                                  ),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        const campusJobs(
                                      isBox: true,
                                    ), // Assuming HomePage is the page you want to navigate to
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      );
                                    },
                                    transitionDuration: const Duration(
                                        milliseconds:
                                            200), // Customize duration
                                  ),
                                );
                              }
                              // Navigator.pushNamed(context, AppRoutes.loginPage);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(
                                  0xffF2C9CD), // Change background color to white
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16), // Adjust padding if needed
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ), // Adjust border radius if
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  _faculty ? Icons.upload_file : Icons.work,
                                  color: Colors.black,
                                  size: 30,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  role == ROLE_PD
                                      ? 'Upload Documents'
                                      : 'Campus Jobs',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),
                      Container(
                        height: Responsive.getHeight(context),
                        width: Responsive.getWidth(context),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation,
                                        secondaryAnimation) =>
                                    const Services(), // Assuming HomePage is the page you want to navigate to
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                                transitionDuration: const Duration(
                                    milliseconds: 200), // Customize duration
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffF2C9CD),
                            minimumSize: const Size(270, 70),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ), // Adjust border radius if
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.supervised_user_circle_outlined,
                                color: Colors.black,
                                size: 30,
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Services',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        height: Responsive.getHeight(context),
                        width: Responsive.getWidth(context),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation,
                                        secondaryAnimation) =>
                                    const feedback(
                                        newTitile:
                                            'Complaints'), // Assuming HomePage is the page you want to navigate to
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                                transitionDuration:
                                    const Duration(milliseconds: 200),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(
                                0xffF2C9CD), // Change background color to white
                            minimumSize: const Size(
                                270, 70), // Change dimensions of the button
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16), // Adjust padding if needed
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ), // Adjust border radius if
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.design_services,
                                color: Colors.black,
                                size: 30,
                              ),
                              SizedBox(
                                  width: 12), // Space between logo and text
                              Text(
                                'Complaints',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (role == ROLE_FACULTY ||
                          role == ROLE_DEAN ||
                          role == ROLE_PD)
                        const SizedBox(height: 20),
                      if (role == ROLE_FACULTY ||
                          role == ROLE_DEAN ||
                          role == ROLE_PD)
                        Container(
                          height: Responsive.getHeight(context),
                          width: Responsive.getWidth(context),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      const FacultyLeavePage(),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    );
                                  },
                                  transitionDuration:
                                      const Duration(milliseconds: 200),
                                ),
                              );
                              // Navigator.pushNamed(context, AppRoutes.loginPage);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xffF2C9CD),
                              minimumSize: const Size(270, 70),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.design_services,
                                  color: Colors.black,
                                  size: 30,
                                ),
                                SizedBox(width: 12),
                                Text(
                                  'Faculty Leave',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (role == ROLE_STUDENT || role == ROLE_PD)
                        const SizedBox(height: 20),
                      if (role == ROLE_STUDENT || role == ROLE_PD)
                        Container(
                          height: Responsive.getHeight(context),
                          width: Responsive.getWidth(context),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      const StudentLeavePage(),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    );
                                  },
                                  transitionDuration: const Duration(
                                      milliseconds: 200), // Customize duration
                                ),
                              );
                              // Navigator.pushNamed(context, AppRoutes.loginPage);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xffF2C9CD),
                              minimumSize: const Size(270, 70),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.design_services,
                                  color: Colors.black,
                                  size: 30,
                                ),
                                SizedBox(
                                    width: 12), // Space between logo and text
                                Text(
                                  'Student Leave',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      // if (role == ROLE_STUDENT || role == ROLE_FACULTY)
                      //   const SizedBox(height: 20),
                      // if (role == ROLE_STUDENT || role == ROLE_FACULTY)
                      //   Container(
                      //     height: Responsive.getHeight(context),
                      //     width: Responsive.getWidth(context),
                      //     decoration: BoxDecoration(
                      //       border: Border.all(
                      //         color: Colors.black,
                      //         width: 2.0,
                      //       ),
                      //       borderRadius: BorderRadius.circular(18),
                      //     ),
                      //     child: ElevatedButton(
                      //       onPressed: () {
                      //         Navigator.push(
                      //           context,
                      //           PageRouteBuilder(
                      //             pageBuilder: (context, animation,
                      //                     secondaryAnimation) =>
                      //                 const LabBooking(), // Assuming HomePage is the page you want to navigate to
                      //             transitionsBuilder: (context, animation,
                      //                 secondaryAnimation, child) {
                      //               return FadeTransition(
                      //                 opacity: animation,
                      //                 child: child,
                      //               );
                      //             },
                      //             transitionDuration: const Duration(
                      //                 milliseconds: 200), // Customize duration
                      //           ),
                      //         );
                      //       },
                      //       style: ElevatedButton.styleFrom(
                      //         shadowColor: Colors.black,
                      //         backgroundColor: const Color(
                      //             0xffF2C9CD), // Change background color to white
                      //         padding: const EdgeInsets.symmetric(
                      //             horizontal: 16), // Adjust padding if needed
                      //         shape: RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(18),
                      //         ), // Adjust border radius if
                      //       ),
                      //       child: const Row(
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         // mainAxisSize: MainAxisSize
                      //         //     .min,

                      //         // Use min to wrap content inside the button
                      //         children: <Widget>[
                      //           Icon(
                      //             Icons.science,
                      //             color: Colors.black,
                      //             size: 30,
                      //           ),
                      //           SizedBox(
                      //               width: 12), // Space between logo and text
                      //           Text(
                      //             'Lab Booking',
                      //             style: TextStyle(
                      //               color: Colors.black,
                      //               fontSize: 24,
                      //               fontWeight: FontWeight.w400,
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> sendJsonData(String requestValue) async {
    final Uri apiUri = Uri.parse("YOUR_API_ENDPOINT");
    final response = await http.post(
      apiUri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'request': requestValue,
      }),
    );

    if (response.statusCode == 200) {
      Navigator.pop(context);
      Navigator.pushNamed(context, AppRoutes.campusJobsAdmin);
      // If the server returns a 200 OK response, then parse the JSON.
      print("Data sent successfully");
    } else {
      showDialog(
        // Show error dialog
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content:
                const Text('Oops! Something went wrong. Please try again.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to send data');
    }
  }
}
