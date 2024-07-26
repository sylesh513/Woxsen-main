import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:woxsen/Pages/login_page.dart';
import 'package:woxsen/Values/app_routes.dart';
import 'package:http/http.dart' as httpp;
import 'package:woxsen/Values/login_status.dart';
import 'package:woxsen/Values/subjects_list.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  RegExp emailPattern = RegExp(r'_[0-9]{4}');
  ListStore store = ListStore();

  bool _isFaculty = true;
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // bool _showCourses = false;

  String? selectedCourse;
  String? selectedSpecialization;
  final List<String> courses = [
    'B.Tech',
    'B.Des',
    'B.Arch',
    'B.B.A',
    'M.B.A',
    'B.A'
  ];
  final List<String> specializations = ['MBA Gen', 'MBA BA', 'MBA FS'];
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/top.png',
                  height: MediaQuery.of(context).size.height * 0.2,
                ),
                buildLoginRow(context, 'Name', _nameController),

                const SizedBox(height: 20),
                buildLoginRow(context, 'Email', _emailController),
                const SizedBox(height: 20),
                buildLoginRow(context, 'Password', _passwordController),
                const SizedBox(height: 20),
                buildLoginRow(context, 'Phone', _phoneController),
                const SizedBox(height: 20),
                buildLoginRow(context, 'ID', _idController),
                const SizedBox(height: 20),

                // buildLoginRow(
                //     context, 'Specialization', _specializationController),
                Container(
                  width: MediaQuery.of(context).size.width * 0.83,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 9,
                        offset:
                            const Offset(4, 7), // changes position of shadow
                      ),
                    ],
                    borderRadius:
                        BorderRadius.circular(16), // Add border radius
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
                          if (newValue == 'B.Tech') {
                            store.specList = store.btechSpecializations;
                          } else if (newValue == 'M.B.A') {
                            store.specList = store.mbaSpecializations;
                          } else if (newValue == 'B.Des') {
                            store.specList = store.bdesSpecializations;
                          } else if (newValue == 'B.B.A') {
                            store.specList = store.bbaSpecializations;
                          } else if (newValue == 'Law') {
                            store.specList = store.lawSpecializations;
                          } else if (newValue == 'Sciences') {
                            store.specList = store.sciSpecializations;
                          }
                          selectedSpecialization = null;
                        },
                        items: courses
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (!_isFaculty)
                  Container(
                    width: MediaQuery.of(context).size.width * 0.83,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 9,
                          offset:
                              const Offset(4, 7), // changes position of shadow
                        ),
                      ],
                      borderRadius:
                          BorderRadius.circular(16), // Add border radius
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          dropdownColor: Colors.white,
                          value: selectedSpecialization,
                          hint: const Text('Select Specialization'),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedSpecialization = newValue;
                            });
                          },
                          items: store.specList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),

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
                const SizedBox(height: 20),
                const Text("Forgot Password?",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    )),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (selectedCourse == null && !_isFaculty) {
                      print('a');
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
                      print('b');

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
                      print('c');

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text(
                                "Please enter your Woxsen email id."),
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
                      print('d');

                      if (_emailController.text == "student@woxsen.edu.in") {
                        UserPreferences.saveRole('student');
                      } else if (_emailController.text ==
                          "admin@woxsen.edu.in") {
                        UserPreferences.saveRole('faculty');
                      }
                      showDialog(
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

                      signupUser(
                              _emailController.text, _passwordController.text)
                          .then((response) {
                        final responseBody = jsonDecode(response.body);
                        print(response);
                        print(responseBody);
                        print(responseBody['role']);
                        if (responseBody['role'] == 'student' ||
                            responseBody['role'] == 'faculty' ||
                            responseBody['role'] == 'admin') {
                          Navigator.of(context).pop();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Sign Up Successful"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Navigator.pushReplacementNamed(
                                          context, AppRoutes.loginPage);
                                    },
                                    child: const Text("OK"),
                                  ),
                                ],
                              );
                            },
                          );

                          UserPreferences.saveCourse(selectedCourse!);
                          UserPreferences.saveRole(responseBody['role']);
                          UserPreferences.saveLoginStatus(true);
                        } else if (responseBody['role'] == 'none' ||
                            response.statusCode != 200) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text(
                                    "Invalid Credentials or User already exists"),
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
                        }
                      }).catchError((error) {
                        print('Error: $error');
                      });
                      // UserPreferences.saveCourse(selectedCourse!);
                      // UserPreferences.saveLoginStatus(true);

                      // Navigator.pushNamed(context, AppRoutes.homePage);
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
                    'Sign Up',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
                TextButton(
                  child: const Text("Already a user? Login",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      )),
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return const LoginPage();
                    }));
                  },
                ),
              ],
            ),
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
        onChanged: (value) {
          setState(() {
            print('changeddddd');
            // if (value == 'admin@woxsen.edu.in' ||
            //     value == 'faculty@woxsen.edu.in') {
            //   _showCourses = false;
            // } else if (value == 'student@woxsen.edu.in') {
            //   _showCourses = true;
            // }
            if (emailPattern.hasMatch(value) &&
                controller == _emailController) {
              _isFaculty = false;
              print(_isFaculty);
            } else if (!emailPattern.hasMatch(value) &&
                controller == _emailController) {
              _isFaculty = true;
              print(_isFaculty);
            }
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

  Future<httpp.Response> signupUser(String email, String password) async {
    print('called signup');
    var userPrefs = UserPreferences();
    await userPrefs.setEmail(email);
    const String apiUrl =
        'http://52.20.1.249:5000/api/register'; // Replace with your API URL
    final response = await httpp.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': _nameController.text,
        'email': email,
        'password': password,
        'phone': _phoneController.text,
        'id': _idController.text,
        'course': selectedCourse ?? 'N/A',
        'specialization': selectedSpecialization ?? 'N/A',
      }),
    );
    print(response.body);
    return response;
  }
}
