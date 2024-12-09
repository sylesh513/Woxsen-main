import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:woxsen/Pages/assignments_list.dart';
import 'package:woxsen/Pages/attendance_page.dart';
import 'package:woxsen/Pages/faculty_attendance_page.dart';
import 'package:woxsen/Pages/faculty_feedback.dart';
import 'package:woxsen/Pages/faculty_feedback_form_page.dart';
import 'package:woxsen/Pages/faculty_ratings_page.dart';
import 'package:woxsen/Pages/home_page.dart';
import 'package:woxsen/Values/app_routes.dart';
import 'package:woxsen/Values/login_status.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:woxsen/Values/subjects_list.dart';
import 'package:woxsen/utils/colors.dart';
import 'package:woxsen/utils/roles.dart';

class Academics extends StatefulWidget {
  const Academics({super.key});

  @override
  _AcademicsState createState() => _AcademicsState();
}

class _AcademicsState extends State<Academics> {
  ListStore store = ListStore();
  String _pdfPath = '';
  String? dropdownValue;
  bool showSection = false;
  String? selectedSection;
  String? selectedSubject;
  String? selectedFaculty;

  String? userEmail;

  String? selectedSubjectFb;

  bool fetchingFaculties = false;
  String role = 'role';

  List<File> _pdfs = [];

  String? selectedSpecialization;
  @override
  void initState() {
    super.initState();
    getRole();
    store.getCourse();
    updateSubjectsList();
    _loadUserEmail();
  }

  void getRole() async {
    String roleType = await UserPreferences.getRole();
    setState(() {
      role = roleType;
    });
  }

  Future<void> _loadUserEmail() async {
    UserPreferences userPreferences = UserPreferences();
    String? email = await userPreferences.getEmail();
    setState(() {
      userEmail = email;
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Fectching Faculties State: $fetchingFaculties');
    debugPrint('Building UI with facultiesList: ${store.facultiesList}');
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      floatingActionButton: FloatingActionButton(
        heroTag: 'homeButton1',
        backgroundColor: const Color(0xffFA6978),
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const HomePage(), // Assuming HomePage is the page you want to navigate to
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              transitionDuration:
                  const Duration(milliseconds: 200), // Customize duration
            ),
          );
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
              Navigator.pushNamed(context, AppRoutes.academicsPage);
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
                  'Academics',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.4,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xff444444),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)), // Add border radius
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  dropdownColor: Colors.grey.shade800,
                  value: dropdownValue,
                  hint: const Text('Semester',
                      style: TextStyle(color: Colors.white)),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue;
                    });
                    updateLists();
                  },
                  items: store.semestersList
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                child: ElevatedButton(
                  onPressed: () async {
                    if (dropdownValue == null) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Please select a semester'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return StatefulBuilder(
                            builder: (context, setState) {
                              return AlertDialog(
                                title: const Text('Please fill the below'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    DropdownButton<String>(
                                      value: selectedSpecialization,
                                      hint: const Text('Select Specialization'),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedSpecialization = newValue;
                                          debugPrint(
                                              'Selected Spec $selectedSpecialization');
                                          if (selectedSpecialization ==
                                              'MBA GEN') {
                                            showSection = true;
                                          } else {
                                            showSection = false;
                                          }
                                        });
                                        selectedSubject = null;
                                        updateLists();
                                      },
                                      items: store.specList
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: SizedBox(
                                              width: 250, child: Text(value)),
                                        );
                                      }).toList(),
                                    ),
                                    if (showSection)
                                      DropdownButton<String>(
                                        value: selectedSection,
                                        hint: const Text('Select Section'),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            selectedSection = newValue;
                                          });
                                          updateLists();
                                        },
                                        items: store.sectionsList
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: SizedBox(
                                                width: 250, child: Text(value)),
                                          );
                                        }).toList(),
                                      ),
                                  ],
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      if (selectedSection == null &&
                                          selectedSpecialization == 'MBA GEN') {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text(
                                                  'Please select a section'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('OK'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      } else {
                                        getPdf('TT', selectedSpecialization!,
                                            selectedSection ?? 'N/A', 'N/A');
                                      }
                                      // Handle OK action
                                    },
                                    child: const Text('OK'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // Handle Cancel action
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                      // getPdf("TT");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shadowColor: Colors.black,
                    backgroundColor: const Color(
                        0xffE7E7E7), // Change background color to white
                    minimumSize:
                        const Size(270, 63), // Change dimensions of the button
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16), // Adjust padding if needed
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ), // Adjust border radius if
                  ),
                  child: const Text(
                    'Time Table',
                    style: TextStyle(color: Colors.black, fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                child: ElevatedButton(
                  onPressed: () async {
                    if (dropdownValue == null) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Please select a semester'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    } else if (dropdownValue != null) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return StatefulBuilder(
                            builder: (context, setState) {
                              return AlertDialog(
                                title: const Text('Select Options'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    DropdownButton<String>(
                                      value: selectedSpecialization,
                                      hint: const Text('Select Specialization'),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          // Subjects.clear();
                                          selectedSection = null;
                                          selectedSubject = null;
                                          selectedSpecialization = newValue;
                                          if (selectedSpecialization ==
                                              'MBA GEN') {
                                            if (dropdownValue == 'Semester 1') {
                                              store.subjectsList =
                                                  store.mbaGenSem1;
                                            } else if (dropdownValue ==
                                                'Semester 2') {
                                              store.subjectsList =
                                                  store.mbaGenSem2;
                                            } else if (dropdownValue ==
                                                'Semester 4') {
                                              store.subjectsList =
                                                  store.mbaGenSem4;
                                            } else if (dropdownValue ==
                                                'Semester 5') {
                                              store.subjectsList =
                                                  store.mbaGenSem5;
                                            }
                                            showSection = true;
                                          } else {
                                            showSection = false;
                                          }
                                          if (selectedSpecialization ==
                                              'MBA BA') {
                                            if (dropdownValue == 'Semester 1') {
                                              store.subjectsList =
                                                  store.mbaBaSem1;
                                            } else if (dropdownValue ==
                                                'Semester 2') {
                                              store.subjectsList =
                                                  store.mbaBaSem2;
                                            } else if (dropdownValue ==
                                                'Semester 4') {
                                              store.subjectsList =
                                                  store.mbaBaSem4;
                                            } else if (dropdownValue ==
                                                'Semester 5') {
                                              store.subjectsList =
                                                  store.mbaBaSem5;
                                            }
                                          } else if (selectedSpecialization ==
                                              'MBA FS') {
                                            if (dropdownValue == 'Semester 1') {
                                              store.subjectsList =
                                                  store.mbaFsSem1;
                                            } else if (dropdownValue ==
                                                'Semester 2') {
                                              store.subjectsList =
                                                  store.mbaFsSem2;
                                            } else if (dropdownValue ==
                                                'Semester 4') {
                                              store.subjectsList =
                                                  store.mbaFsSem4;
                                            } else if (dropdownValue ==
                                                'Semester 5') {
                                              store.subjectsList =
                                                  store.mbaFsSem5;
                                            }
                                          }
                                        });
                                        updateLists();
                                      },
                                      items: store.specList
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: SizedBox(
                                              width: 250, child: Text(value)),
                                        );
                                      }).toList(),
                                    ),
                                    if (showSection)
                                      DropdownButton<String>(
                                        value: selectedSection,
                                        hint: const Text('Select Section'),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            selectedSection = newValue;
                                          });
                                          updateLists();
                                        },
                                        items: store.sectionsList
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: SizedBox(
                                                width: 250, child: Text(value)),
                                          );
                                        }).toList(),
                                      ),
                                    DropdownButton<String>(
                                      value: selectedSubject,
                                      hint: const Text('Select Subject'),
                                      onChanged: (String? newValue) async {
                                        setState(() {
                                          selectedSubject = newValue;
                                        });
                                        // await fetchFaculties();
                                      },
                                      items: store.subjectsList
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: SizedBox(
                                              width: 250, child: Text(value)),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      if (selectedSection == null &&
                                          selectedSubject == null) {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text(
                                                  'Please select a section and subject'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('OK'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      } else {
                                        getPdf(
                                            'CO',
                                            selectedSpecialization,
                                            selectedSection ?? 'N/A',
                                            selectedSubject ?? 'N/A');
                                      }
                                      // Handle OK action
                                    },
                                    child: const Text('OK'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // Handle Cancel action
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(
                        0xffE7E7E7), // Change background color to white
                    minimumSize:
                        const Size(270, 63), // Change dimensions of the button
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16), // Adjust padding if needed
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ), // Adjust border radius if
                  ),
                  child: const Text(
                    'Course outline',
                    style: TextStyle(color: Colors.black, fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (dropdownValue == null) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Please select a semester'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  } else if (dropdownValue != null) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return StatefulBuilder(
                          builder: (context, setState) {
                            return AlertDialog(
                              title: const Text('Select Options'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  DropdownButton<String>(
                                    value: selectedSpecialization,
                                    hint: const Text('Select Specialization'),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        // Subjects.clear();
                                        selectedSection = null;
                                        selectedSubject = null;

                                        selectedSpecialization = newValue;
                                        if (selectedSpecialization ==
                                            'MBA GEN') {
                                          if (dropdownValue == 'Semester 1') {
                                            store.subjectsList =
                                                store.mbaGenSem1;
                                          } else if (dropdownValue ==
                                              'Semester 2') {
                                            store.subjectsList =
                                                store.mbaGenSem2;
                                          } else if (dropdownValue ==
                                              'Semester 4') {
                                            store.subjectsList =
                                                store.mbaGenSem4;
                                          } else if (dropdownValue ==
                                              'Semester 5') {
                                            store.subjectsList =
                                                store.mbaGenSem5;
                                          }

                                          showSection = true;
                                        } else if (selectedSpecialization !=
                                            'MBA GEN') {
                                          selectedSection = null;
                                          showSection = false;
                                        }
                                        if (selectedSpecialization ==
                                            'MBA BA') {
                                          if (dropdownValue == 'Semester 1') {
                                            store.subjectsList =
                                                store.mbaBaSem1;
                                          } else if (dropdownValue ==
                                              'Semester 2') {
                                            store.subjectsList =
                                                store.mbaBaSem2;
                                          } else if (dropdownValue ==
                                              'Semester 4') {
                                            store.subjectsList =
                                                store.mbaBaSem4;
                                          } else if (dropdownValue ==
                                              'Semester 5') {
                                            store.subjectsList =
                                                store.mbaBaSem5;
                                          }
                                        } else if (selectedSpecialization ==
                                            'MBA FS') {
                                          if (dropdownValue == 'Semester 1') {
                                            store.subjectsList =
                                                store.mbaFsSem1;
                                          } else if (dropdownValue ==
                                              'Semester 2') {
                                            store.subjectsList =
                                                store.mbaFsSem2;
                                          } else if (dropdownValue ==
                                              'Semester 4') {
                                            store.subjectsList =
                                                store.mbaFsSem4;
                                          } else if (dropdownValue ==
                                              'Semester 5') {
                                            store.subjectsList =
                                                store.mbaFsSem5;
                                          }
                                        }
                                      });
                                      updateLists();
                                    },
                                    items: store.specList
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: SizedBox(
                                            width: 250, child: Text(value)),
                                      );
                                    }).toList(),
                                  ),
                                  if (showSection)
                                    DropdownButton<String>(
                                      value: selectedSection,
                                      hint: const Text('Select Section'),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedSection = newValue;
                                        });
                                        updateLists();
                                      },
                                      items: store.sectionsList
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: SizedBox(
                                              width: 250, child: Text(value)),
                                        );
                                      }).toList(),
                                    ),
                                  DropdownButton<String>(
                                    value: selectedSubject,
                                    hint: const Text('Select Subject'),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedSubject = newValue;
                                      });
                                      updateLists();
                                    },
                                    items: store.subjectsList
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: SizedBox(
                                            width: 250, child: Text(value)),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    if (selectedSection == null &&
                                        selectedSubject == null) {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text(
                                                'Please select a section and subject'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    } else {
                                      getPdf(
                                        'AS',
                                        selectedSpecialization,
                                        selectedSection ?? 'N/A',
                                        selectedSubject,
                                      );
                                    }
                                    // Handle OK action
                                  },
                                  child: const Text('OK'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Handle Cancel action
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Cancel'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(
                      0xffE7E7E7), // Change background color to white
                  minimumSize:
                      const Size(270, 63), // Change dimensions of the button
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16), // Adjust padding if needed
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ), // Adjust border radius if
                ),
                child: const Text(
                  'Assignments',
                  style: TextStyle(color: Colors.black, fontSize: 24),
                ),
              ),
              const SizedBox(height: 20),
              if (store.isFaculty)
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(
                        0xffE7E7E7), // Change background color to white
                    minimumSize:
                        const Size(270, 63), // Change dimensions of the button
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16), // Adjust padding if needed
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ), // Adjust border radius if
                  ),
                  child: const Text(
                    'Subject List',
                    style: TextStyle(color: Colors.black, fontSize: 24),
                  ),
                ),
              const SizedBox(height: 20),
              if (!store.isFaculty)
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AttendancePage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(
                        0xffE7E7E7), // Change background color to white
                    minimumSize:
                        const Size(270, 63), // Change dimensions of the button
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16), // Adjust padding if needed
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ), // Adjust border radius if
                  ),
                  child: const Text(
                    'Attendance',
                    style: TextStyle(color: Colors.black, fontSize: 24),
                  ),
                ),

              // FACULTY RATING
              if (role == ROLE_STUDENT) const SizedBox(height: 20),
              if (role == ROLE_STUDENT)
                ElevatedButton(
                  onPressed: () async {
                    if (dropdownValue == null) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Please select a semester'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    } else if (dropdownValue != null) {
                      return showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return StatefulBuilder(
                            builder: (BuildContext context,
                                StateSetter setDialogState) {
                              return AlertDialog(
                                title: const Text('Select Options '),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    DropdownButton<String>(
                                      value: selectedSubjectFb,
                                      hint: const Text('Select Subject'),
                                      onChanged: (String? newValue) {
                                        setDialogState(() {
                                          selectedSubjectFb = newValue;
                                          selectedFaculty = null;
                                        });
                                        fetchFaculties().then((_) {
                                          setDialogState(() {});
                                        });
                                      },
                                      items: store.subjectsList
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                    // store.facultiesList.isNotEmpty
                                    if (fetchingFaculties)
                                      const CircularProgressIndicator(),
                                    if (!fetchingFaculties &&
                                        store.facultiesList.isNotEmpty)
                                      DropdownButton<String>(
                                        value: selectedFaculty,
                                        hint: const Text('Select Faculty'),
                                        onChanged: (String? newValue) {
                                          setDialogState(() {
                                            selectedFaculty = newValue;
                                          });
                                        },
                                        items: store.facultiesList
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                  ],
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: !store.facultiesList
                                            .contains(selectedFaculty)
                                        ? null
                                        : () {
                                            // need to pass specialization, subject, faculty data
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    FacultyFeedbackForm(
                                                        faculty_name:
                                                            selectedFaculty!,
                                                        subject:
                                                            selectedSubjectFb!,
                                                        semester:
                                                            dropdownValue!,
                                                        course:
                                                            selectedSpecialization!,
                                                        email: userEmail!),
                                              ),
                                            );

                                            // Handle OK action
                                          },
                                    child: !store.facultiesList
                                                .contains(selectedFaculty) &&
                                            !fetchingFaculties
                                        ? const Text('OK')
                                        : const Text('Continue'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // Handle Cancel action
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(
                        0xffE7E7E7), // Change background color to white
                    minimumSize:
                        const Size(270, 63), // Change dimensions of the button
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16), // Adjust padding if needed
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ), // Adjust border radius if
                  ),
                  child: const Text(
                    'Give Feedback',
                    style: TextStyle(color: Colors.black, fontSize: 24),
                  ),
                ),

              // if (store.isFaculty) const SizedBox(height: 20),
              if (store.isFaculty)
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FacultyRatingScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(
                        0xffE7E7E7), // Change background color to white
                    minimumSize:
                        const Size(270, 63), // Change dimensions of the button
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16), // Adjust padding if needed
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ), // Adjust border radius if
                  ),
                  child: const Text(
                    'See Feedback',
                    style: TextStyle(color: Colors.black, fontSize: 24),
                  ),
                ),

              const SizedBox(height: 20),
              if (store.isFaculty)
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FacultyAttendancePage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(
                        0xffE7E7E7), // Change background color to white
                    minimumSize:
                        const Size(270, 63), // Change dimensions of the button
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16), // Adjust padding if needed
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ), // Adjust border radius if
                  ),
                  child: const Text(
                    'Take Attendance',
                    style: TextStyle(color: Colors.black, fontSize: 24),
                  ),
                ),
            ],
          )),
        ],
      ),
    );
  }

  Future<void> getPdf(String what, String? specialization, String? section,
      [String? subject]) async {
    loadingOnScreen(context);
    // ListStore store = ListStore();
    var pdfs;

    // final String apiUrl = '${store.woxUrl}/api/view_files';
    final String apiUrl = '${store.woxUrl}/api/sub_as_list';
    var bodyContent = what == "TT"
        ? <String, String>{
            'course': await UserPreferences.getCourse(),
            'semester': dropdownValue!.replaceAll(' ', '_'),
            'specialization': specialization!.replaceAll(' ', '_'),
            'section': section!.replaceAll(' ', '_'),
            'type': what.replaceAll(' ', '_'),
          }
        : <String, String>{
            'course': await UserPreferences.getCourse(),
            'semester': dropdownValue!.replaceAll(' ', '_'),
            'type': what.replaceAll(' ', '_'),
            'specialization': specialization!.replaceAll(' ', '_'),
            'subject': subject!.replaceAll(' ', '_'),
            'section': section!.replaceAll(' ', '_'),
          };

    try {
      final response = await http.post(Uri.parse(apiUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(bodyContent));

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final dir = await getApplicationDocumentsDirectory();

        var data = jsonDecode(response.body);
        List<File> pdfPaths = [];
        pdfs = data['assignments'];

        print('PDFs ${pdfs}');

        for (var pdf in pdfs) {
          final filePath = '${dir.path}/$pdf';
          final file = File(filePath);
          pdfPaths.add(file);
          await file.writeAsBytes(bytes);
          print('Written to $filePath');
        }

        setState(() {
          _pdfs = pdfPaths;

          Navigator.push(context, MaterialPageRoute(builder: (context) {
            // return pdfView(pdfPath: _pdfPath);
            return AssignmentsList(
                pdfs: _pdfs, params: jsonEncode(bodyContent));
          }));
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void updateSubjectsList() async {
    UserPreferences userPreferences = UserPreferences();
    String? email = await userPreferences.getEmail();
    Map<String, dynamic> user = await userPreferences.getProfile(email);

    String specialization = user['specialization'];

    debugPrint(
        'updateSubjectsList() : Selected Specialization : $specialization');

    setState(() {
      store.subjectsList = [];
      selectedSpecialization = specialization;
    });

    debugPrint('updateSubjectsList ${store.subjectsList}');
    updateLists();
    debugPrint('updateSubjectsList Later ${store.subjectsList}');
  }

  void updateLists() {
    debugPrint('SELECTED SPECIALIZATION : $selectedSpecialization');

    return setState(() {
      // School
      if (store.course == 'School of Technology') {
        store.specList = store.btechSpecializations;
      } else if (store.course == 'School of Business') {
        store.specList = store.sobSpecializations;
      } else if (store.course == 'School of Arts and Design') {
        store.specList = store.bdesSpecializations;
      } else if (store.course == 'School of Law') {
        store.specList = store.SOLSpecializations;
      } else if (store.course == 'School of Sciences') {
        store.specList = store.sciSpecializations;
      } else if (store.course == 'School of Liberal Arts and Humanities') {
        store.specList = store.humanSpecializations;
      } else if (store.course == 'School of Architecture and Planning') {
        store.specList = store.SOAPSpecializations;
      }

      // selectedSpecialization = null;

      // Specialization
      if (selectedSpecialization == 'MBA GEN') {
        if (dropdownValue == 'Semester 1') {
          store.subjectsList = store.mbaGenSem1;
        } else if (dropdownValue == 'Semester 2') {
          store.subjectsList = store.mbaGenSem2;
        } else if (dropdownValue == 'Semester 4') {
          store.subjectsList = store.mbaGenSem4;
        } else if (dropdownValue == 'Semester 5') {
          store.subjectsList = store.mbaGenSem5;
        }
        showSection = true;
      } else if (selectedSpecialization == 'MBA BA') {
        showSection = false;
        if (dropdownValue == 'Semester 1') {
          store.subjectsList = store.mbaBaSem1;
        } else if (dropdownValue == 'Semester 2') {
          store.subjectsList = store.mbaBaSem2;
        } else if (dropdownValue == 'Semester 4') {
          store.subjectsList = store.mbaBaSem4;
        } else if (dropdownValue == 'Semester 5') {
          store.subjectsList = store.mbaBaSem5;
        }
      } else if (selectedSpecialization == 'MBA FS') {
        showSection = false;
        if (dropdownValue == 'Semester 1') {
          store.subjectsList = store.mbaFsSem1;
        } else if (dropdownValue == 'Semester 2') {
          store.subjectsList = store.mbaFsSem2;
        } else if (dropdownValue == 'Semester 4') {
          store.subjectsList = store.mbaFsSem4;
        } else if (dropdownValue == 'Semester 5') {
          store.subjectsList = store.mbaFsSem5;
        }
      } else if (selectedSpecialization == 'BBA GEN') {
        showSection = false;
        if (dropdownValue == 'Semester 1') {
          store.subjectsList = store.bbaGenSem1;
        } else if (dropdownValue == 'Semester 3') {
          store.subjectsList = store.bbaGenSem3;
        } else if (dropdownValue == 'Semester 5') {
          store.subjectsList = store.bbaGenSem5;
        }
      } else if (selectedSpecialization == 'BBA DSAI') {
        debugPrint('$selectedSpecialization : $dropdownValue');
        showSection = false;
        if (dropdownValue == 'Semester 1') {
          store.subjectsList = store.bbaAiSem1;
        } else if (dropdownValue == 'Semester 2') {
          store.subjectsList = store.bbaAiSem2;
        } else if (dropdownValue == 'Semester 3') {
          store.subjectsList = store.bbaAiSem3;
        } else if (dropdownValue == 'Semester 4') {
          store.subjectsList = store.bbaAiSem4;
          debugPrint('Store Subject List : ${store.subjectsList}');
        } else if (dropdownValue == 'Semester 5') {
          store.subjectsList = store.bbaAiSem5;
        } else if (dropdownValue == 'Semester 6') {
          store.subjectsList = store.bbaAiSem6;
        }
      } else if (selectedSpecialization == 'BBA FS') {
        if (dropdownValue == 'Semester 1') {
          showSection = false;
          store.subjectsList = store.bbaFsSem1;
        } else if (dropdownValue == 'Semester 2') {
          showSection = true;
          store.subjectsList = store.bbaFsSem2;
        } else if (dropdownValue == 'Semester 3') {
          showSection = true;
          store.subjectsList = store.bbaFsSem3;
        } else if (dropdownValue == 'Semester 4') {
          showSection = true;
          store.subjectsList = store.bbaFsSem4;
        } else if (dropdownValue == 'Semester 5') {
          showSection = true;
          store.subjectsList = store.bbaFsSem5;
        } else if (dropdownValue == 'Semester 6') {
          showSection = true;

          store.subjectsList = store.bbaFsSem6;
        }
      } else if (selectedSpecialization == 'BBA ECDM') {
        if (dropdownValue == 'Semester 1') {
          showSection = false;
          store.subjectsList = store.bbaDmSem1;
        } else if (dropdownValue == 'Semester 2') {
          showSection = true;
          store.subjectsList = store.bbaDmSem2;
        } else if (dropdownValue == 'Semester 3') {
          showSection = true;
          store.subjectsList = store.bbaDmSem3;
        } else if (dropdownValue == 'Semester 4') {
          showSection = true;
          store.subjectsList = store.bbaDmSem4;
        } else if (dropdownValue == 'Semester 5') {
          showSection = true;
          store.subjectsList = store.bbaDmSem5;
        } else if (dropdownValue == 'Semester 6') {
          showSection = true;
          store.subjectsList = store.bbaDmSem6;
        }
      } else if (selectedSpecialization == 'BBA ED') {
        showSection = false;
        if (dropdownValue == 'Semester 1') {
          store.subjectsList = store.bbaEdSem1;
        } else if (dropdownValue == 'Semester 3') {
          store.subjectsList = store.bbaEdSem3;
        } else if (dropdownValue == 'Semester 5') {
          store.subjectsList = store.bbaEdSem5;
        }
      } else if (selectedSpecialization == 'BBA INT') {
        showSection = false;
        if (dropdownValue == 'Semester 1') {
          store.subjectsList = store.bbaIntSem1;
        }
      }
    });
  }

  Future<void> fetchFaculties() async {
    if (selectedSubjectFb == null) return;

    debugPrint('🏃‍♂️ - -- - - -- - -- - -- - -- -- - ');

    // final url = Uri.parse('http://10.7.0.23:4000/api/get_faculties');
    final String apiUrl = '${store.woxUrl}/api/get_faculties';

    try {
      setState(() {
        fetchingFaculties = true;
      });
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'specialization': selectedSpecialization,
          'subject': selectedSubjectFb,
          'semester': dropdownValue,
        }),
      );

      debugPrint('fetchFaculties() : ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        List<String> faculties =
            List<String>.from(data['fac_list'].map((item) => item.toString()));

        debugPrint('fetchFaculties() Faculties List Now: ${faculties}');

        setState(() {
          store.facultiesList = faculties;
          // store.facultiesList = faculties.toSet().toList();
          fetchingFaculties = false;
        });
      } else {
        throw Exception('Failed to load faculties');
      }
    } catch (e) {
      debugPrint('Error fetching faculties: $e');
      setState(() {
        store.facultiesList = [];
        fetchingFaculties = false;
      });
    } finally {
      setState(() {
        fetchingFaculties = false;
      });
    }
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

// pdfView UI
class pdfView extends StatelessWidget {
  final String pdfPath;
  const pdfView({super.key, required this.pdfPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PDFView(
        filePath: pdfPath,
        fitPolicy: FitPolicy.BOTH,
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            heroTag: 'academicsButton',
            onPressed: () async {
              Navigator.pushNamed(context, AppRoutes.academicsPage);
              // await UserPreferences.getRole() == 'faculty';
              // Handle "right" action
            },
            backgroundColor: Colors.green,
            child: Text('PDF LISTS HERE'),
          ),
          const SizedBox(width: 20),
          // Spacing between the buttons
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void uploadFiles(String newpath) async {
    List<File> files = [];

    files.add(File(newpath));

    if (files.isNotEmpty) {
      ListStore store = ListStore();
      var uri = Uri.parse('${store.woxUrl}/api/upload');
      var request = http.MultipartRequest('POST', uri);

      for (var file in files) {
        request.files.add(await http.MultipartFile.fromPath(
          'pdf', // The field name for the file in the API
          file.path,
        ));
      }

      try {
        var response = await request.send();
        var responseString = await response.stream.bytesToString();
        print("response is:");
        print(responseString);

        if (response.statusCode == 200) {
          // Handle response
          print('Files uploaded successfully');
        } else {
          print('Failed to upload files');
        }
      } catch (e) {
        print('Error uploading files: $e');
      }
    } else {
      print("No file selected");
    }
    // Upload the files to the server
  }
}
