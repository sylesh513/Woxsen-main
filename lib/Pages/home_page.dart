import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:woxsen/Pages/academics_page.dart';
import 'package:woxsen/Pages/feedback_complaints.dart';
import 'package:woxsen/Pages/services_page.dart';
import 'package:woxsen/Pages/upload_page.dart';
import 'package:woxsen/Values/app_routes.dart';
import 'package:woxsen/Values/login_status.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _faculty = false;
  @override
  void initState() {
    super.initState();
    print(_faculty);
    getFacutly();
  }

  void getFacutly() async {
    _faculty = await UserPreferences.getRole() == 'faculty' ? true : false;
    // _faculty = true;
    print(_faculty);
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
                        height: MediaQuery.of(context).size.height * 0.08,
                        width: MediaQuery.of(context).size.width * 0.80,
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
                      const SizedBox(height: 20),
                      if (_faculty)
                        Container(
                          height: MediaQuery.of(context).size.height * 0.08,
                          width: MediaQuery.of(context).size.width * 0.80,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: ElevatedButton(
                            onPressed: () async {
                              if (Platform.isWindows) {
                                _launchUrl(
                                    Uri.parse('http://100.29.97.185:5000/'));
                              }
                              if (Platform.isAndroid) {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        const CustomWebViewPage(
                                            pageTitle: 'Campus Jobs',
                                            pageUrl:
                                                'http://100.29.97.185:5000/'), // Assuming HomePage is the page you want to navigate to
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
                              // showDialog(
                              //   barrierColor: Colors.black.withOpacity(0.5),
                              //   context: context,
                              //   barrierDismissible: false,
                              //   builder: (BuildContext context) {
                              //     return Container(
                              //       height: 100,
                              //       width: 100,
                              //       child: Center(
                              //         child: SpinKitSpinningLines(
                              //           color: Colors.red.shade800,
                              //           size: 70.0,
                              //         ),
                              //       ),
                              //     );
                              //   },
                              // );
                              // await sendJsonData('campus_jobs');
                              // Navigator.pushNamed(
                              //     context, AppRoutes.campusJobsAdmin);
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
                                  'Campus Jobs',
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
                      if (_faculty) const SizedBox(height: 20),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.08,
                        width: MediaQuery.of(context).size.width * 0.80,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_faculty) {
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
                                      milliseconds: 200), // Customize duration
                                ),
                              );
                            } else {
                              // Navigator.push(
                              //   context,
                              //   PageRouteBuilder(
                              //     pageBuilder: (context, animation,
                              //             secondaryAnimation) =>
                              //         const campusJobs(), // Assuming HomePage is the page you want to navigate to
                              //     transitionsBuilder: (context, animation,
                              //         secondaryAnimation, child) {
                              //       return FadeTransition(
                              //         opacity: animation,
                              //         child: child,
                              //       );
                              //     },
                              //     transitionDuration: const Duration(
                              //         milliseconds: 200), // Customize duration
                              //   ),
                              // );
                              Platform.isAndroid
                                  ? Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                                secondaryAnimation) =>
                                            const CustomWebViewPage(
                                                pageTitle: 'Campus Jobs',
                                                pageUrl:
                                                    'http://100.29.97.185:5000/'), // Assuming HomePage is the page you want to navigate to
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
                                    )
                                  : _launchUrl(
                                      Uri.parse('http://100.29.97.185:5000/'));

                              // Navigator.pushNamed(context, AppRoutes.loginP);
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
                            // mainAxisSize: MainAxisSize
                            //     .min,

                            // Use min to wrap content inside the button
                            children: <Widget>[
                              Icon(
                                _faculty ? Icons.upload_file : Icons.work,
                                color: Colors.black,
                                size: 30,
                              ),
                              const SizedBox(
                                  width: 12), // Space between logo and text
                              Text(
                                _faculty ? 'Upload Documents' : 'Campus Jobs',
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
                        height: MediaQuery.of(context).size.height * 0.08,
                        width: MediaQuery.of(context).size.width * 0.80,
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
                            // mainAxisSize: MainAxisSize
                            //     .min,

                            // Use min to wrap content inside the button
                            children: <Widget>[
                              Icon(
                                Icons.supervised_user_circle_outlined,
                                color: Colors.black,
                                size: 30,
                              ),
                              SizedBox(
                                  width: 12), // Space between logo and text
                              Text(
                                'services',
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
                        height: MediaQuery.of(context).size.height * 0.08,
                        width: MediaQuery.of(context).size.width * 0.80,
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
                                transitionDuration: const Duration(
                                    milliseconds: 200), // Customize duration
                              ),
                            );
                            // Navigator.pushNamed(context, AppRoutes.loginPage);
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
                            // mainAxisSize: MainAxisSize
                            //     .min,

                            // Use min to wrap content inside the button
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