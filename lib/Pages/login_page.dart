import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:woxsen/Pages/signup_page.dart';
import 'package:woxsen/Values/app_routes.dart';
import 'package:http/http.dart' as http;
import 'package:woxsen/Values/login_status.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  RegExp emailPattern = RegExp(r'_[0-9]{4}');

  String? selectedCourse = 'B.Tech';
  final List<String> courses = [
    'B.Tech',
    'B.Des',
    'B.Arch',
    'B.B.A',
    'M.B.A',
    'B.A'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white, // Start color
                Color(0xFFF36776), // End color
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/top.png',
                height: MediaQuery.of(context).size.height * 0.2,
              ),

              const SizedBox(height: 20),
              buildLoginRow(context, 'Email', _emailController),
              const SizedBox(height: 30),
              buildLoginRow(context, 'Password', _passwordController),
              // Container(
              //   width: MediaQuery.of(context).size.width * 0.83,
              //   decoration: BoxDecoration(
              //     boxShadow: [
              //       BoxShadow(
              //         color: Colors.black.withOpacity(0.5),
              //         spreadRadius: 1,
              //         blurRadius: 9,
              //         offset: const Offset(4, 7), // changes position of shadow
              //       ),
              //     ],
              //   ),
              //   child: TextField(
              //     controller: _passwordController,
              //     keyboardType: TextInputType.visiblePassword,
              //     decoration: const InputDecoration(
              //       fillColor: Colors.white,
              //       filled: true,
              //       hintText: '  Password',
              //       hintStyle: TextStyle(
              //         color: Colors.black,
              //         fontSize: 16,
              //         fontWeight: FontWeight.w600,
              //       ),
              //       border: OutlineInputBorder(
              //         borderSide: BorderSide.none,
              //         borderRadius: BorderRadius.all(
              //           Radius.circular(16),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              const SizedBox(height: 30),
              Container(
                width: MediaQuery.of(context).size.width * 0.83,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 9,
                      offset: const Offset(4, 7), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.circular(16), // Add border radius
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      dropdownColor: Colors.white,
                      value: selectedCourse,
                      hint: const Text('Select Course'),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCourse = newValue;
                        });
                      },
                      items:
                          courses.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text("Forgot Password?",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  )),
              const SizedBox(height: 70),
              ElevatedButton(
                onPressed: () {
                  if (selectedCourse == null) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Please select a course"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("OK"),
                            ),
                          ],
                        );
                      },
                    );
                  } else if (_emailController.text.isEmpty ||
                      _passwordController.text.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Please fill all the fields"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("OK"),
                            ),
                          ],
                        );
                      },
                    );
                  } else if (!RegExp(r'^[a-zA-Z0-9._]+@woxsen\.edu\.in$')
                      .hasMatch(_emailController.text)) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title:
                              const Text("Please enter your Woxsen email id."),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("OK"),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    // if (_emailController.text == "student@woxsen.edu.in") {
                    //   UserPreferences.saveRole('student');
                    // } else if (_emailController.text == "admin@woxsen.edu.in") {
                    //   UserPreferences.saveRole('faculty');
                    // }

                    // loginUser(_emailController.text, _passwordController.text)
                    //     .then((response) {
                    //   final responseBody = jsonDecode(response.body);
                    //   print(responseBody['role']);
                    //   if (responseBody['role'] == 'student' ||
                    //       responseBody['role'] == 'faculty' ||
                    //       responseBody['role'] == 'admin') {
                    //     UserPreferences.saveCourse(selectedCourse!);
                    //     UserPreferences.saveRole(responseBody['role']);
                    //     UserPreferences.saveLoginStatus(true);
                    //     Navigator.pushNamed(context, AppRoutes.homePage);
                    //   } else if (responseBody['role'] == 'none') {
                    //     showDialog(
                    //       context: context,
                    //       builder: (BuildContext context) {
                    //         return AlertDialog(
                    //           title: const Text("Invalid Credentials"),
                    //           actions: [
                    //             TextButton(
                    //               onPressed: () {
                    //                 Navigator.of(context).pop();
                    //               },
                    //               child: const Text("OK"),
                    //             ),
                    //           ],
                    //         );
                    //       },
                    //     );
                    //   }
                    // }).catchError((error) {
                    //   print('Error: $error');
                    // });
                    // UserPreferences.saveCourse(selectedCourse!);
                    // UserPreferences.saveLoginStatus(true);
                    // Navigator.pushNamed(context, AppRoutes.homePage);
                    loadingOnScreen(context);
                    loginUser(_emailController.text, _passwordController.text);
                    var userPrefa = UserPreferences();
                    userPrefa.setEmail(_emailController.text);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(
                      0xFFEA485D), // Change background color to white
                  minimumSize:
                      const Size(250, 60), // Change dimensions of the button
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16), // Adjust padding if needed
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ), // Adjust border radius if
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              TextButton(
                child: const Text("Don't have an account? Sign Up",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    )),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const SignUpPage();
                  }));
                },
              ),
            ],
          ),
          // Add your login page content here
        ),
      ),
    );
  }

  Container buildLoginRow(
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

  Future<http.Response> loginUser(String email, String password) async {
    const String apiUrl =
        'http://52.20.1.249:5000/api/login'; // Replace with your API URL
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );
    print(response.body);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final userData = responseData['user_data'];
      UserPreferences.saveCourse(selectedCourse!);
      UserPreferences.saveLoginStatus(true);
      // UserPreferences.saveRole(userData);
      UserPreferences.saveRole(userData);
      Navigator.pushReplacementNamed(context, AppRoutes.homePage);

      print(userData);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Invalid Credentials"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const LoginPage();
                  }));
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
    // if (response.statusCode == 200) {
    //   UserPreferences.saveCourse(selectedCourse!);
    //   UserPreferences.saveLoginStatus(true);
    //   Navigator.pushNamed(context, AppRoutes.homePage);
    // }
    return response;
  }

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
}
