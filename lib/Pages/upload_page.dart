import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:woxsen/Values/app_routes.dart';
import 'package:woxsen/Values/login_status.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:woxsen/Values/subjects_list.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  ListStore store = ListStore();
  String? _selSpec;

  bool _subject = false;
  bool showSection = false;
  String? dropdownValue;
  String? _selCourse;
  String? _selSem;
  String? _selSub;
  String? _selSect;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      floatingActionButton: FloatingActionButton(
        heroTag: 'home',
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
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
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
                  'Upload Files',
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
            width: MediaQuery.of(context).size.width * 0.45,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xff444444),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)), // Add border radius
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  iconDisabledColor: Colors.white,
                  iconEnabledColor: Colors.white,
                  alignment: Alignment.center,
                  dropdownColor: Colors.grey.shade800,
                  value: dropdownValue,
                  hint:
                      const Text('Type', style: TextStyle(color: Colors.white)),
                  onChanged: (String? newValue) {
                    setState(() {
                      if (newValue != 'Time Table') {
                        _subject = true;
                      } else {
                        _subject = false;
                      }
                      dropdownValue = newValue;
                    });
                  },
                  items: store.typesList
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
          const SizedBox(height: 30),
          Container(
            height: MediaQuery.of(context).size.height * 0.07,
            width: MediaQuery.of(context).size.width * 0.80,
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  dropdownColor: Colors.white,
                  value: _selCourse,
                  hint: const Text('Select Course'),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selSect = null;
                      _selSpec = null;
                      print(newValue);
                      _selCourse = newValue;
                      if (newValue == 'B.Tech') {
                        store.specList = store.btechSpecializations;
                      } else if (newValue == 'M.B.A') {
                        store.specList = store.mbaSpecializations;
                      } else if (newValue == 'B.B.A') {
                        store.specList = store.bbaSpecializations;
                      }
                    });
                  },
                  items: store.courses
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
          const SizedBox(height: 18),
          Container(
            height: MediaQuery.of(context).size.height * 0.07,
            width: MediaQuery.of(context).size.width * 0.80,
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  dropdownColor: Colors.white,
                  value: _selSem,
                  hint: const Text('Select Semester'),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selSem = newValue;
                    });
                    updateLists();
                  },
                  items: store.semestersList
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
          const SizedBox(height: 18),
          Container(
            height: MediaQuery.of(context).size.height * 0.07,
            width: MediaQuery.of(context).size.width * 0.80,
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  dropdownColor: Colors.white,
                  value: _selSpec,
                  hint: const Text('Select Specialization'),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selSpec = newValue;
                    });
                    updateLists();
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
          if (showSection) const SizedBox(height: 18),
          if (showSection)
            Container(
              height: MediaQuery.of(context).size.height * 0.07,
              width: MediaQuery.of(context).size.width * 0.80,
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
                    value: _selSect,
                    hint: const Text('Select Section'),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selSect = newValue;
                      });
                    },
                    items: store.sectionsList
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
          const SizedBox(height: 18),
          Visibility(
            visible: _subject,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.07,
              width: MediaQuery.of(context).size.width * 0.80,
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
                    value: _selSub,
                    hint: const Text('Select Subject'),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selSub = newValue;
                      });
                    },
                    items: store.subjectsList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.64,
                          child: Text(value),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Container(
            height: MediaQuery.of(context).size.height * 0.08,
            width: MediaQuery.of(context).size.width * 0.80,
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
            child: ElevatedButton(
              onPressed: () async {
                if (_selCourse == null ||
                    _selSem == null ||
                    _selSect == null && showSection == true ||
                    dropdownValue == null) {
                  return showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Error'),
                        content:
                            const Text('Please Fill all the fields to proceed'),
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
                } else {
                  if (dropdownValue == 'Time Table') {
                    await selectAndRenamePDF('TT');
                  } else if (dropdownValue == 'Course Outline') {
                    await selectAndRenamePDF('CO');
                  } else {
                    await selectAndRenamePDF('AS');
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xffF2C9CD), // Change background color to white
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
                    Icons.upload_rounded,
                    color: Colors.black,
                  ),
                  SizedBox(width: 12), // Space between logo and text
                  Text(
                    'Upload',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 26,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
        ],
      ),
    );
  }

  void updateLists() {
    return setState(() {
      _selSect = null;
      _selSub = null;
      print(_selSpec);
      if (_selSpec == 'MBA GEN') {
        if (_selSem == 'Semester 1') {
          store.subjectsList = store.mbaGenSem1;
        } else if (_selSem == 'Semester 4') {
          store.subjectsList = store.mbaGenSem4;
        }
        dropdownValue == 'Course Outline'
            ? showSection = false
            : showSection = true;
      } else if (_selSpec == 'MBA BA') {
        dropdownValue == 'Course Outline'
            ? showSection = false
            : showSection = true;
        if (_selSem == 'Semester 1') {
          store.subjectsList = store.mbaBaSem1;
        } else if (_selSem == 'Semester 4') {
          store.subjectsList = store.mbaBaSem4;
        }
      } else if (_selSpec == 'MBA FS') {
        dropdownValue == 'Course Outline'
            ? showSection = false
            : showSection = true;
        if (_selSem == 'Semester 1') {
          store.subjectsList = store.mbaFsSem1;
        } else if (_selSem == 'Semester 4') {
          store.subjectsList = store.mbaFsSem4;
        }
      } else if (_selSpec == 'BBA GEN') {
        showSection = false;
        if (_selSem == 'Semester 1') {
          store.subjectsList = store.bbaGenSem1;
        } else if (_selSem == 'Semester 3') {
          store.subjectsList = store.bbaGenSem3;
        } else if (_selSem == 'Semester 5') {
          store.subjectsList = store.bbaGenSem5;
        }
      } else if (_selSpec == 'BBA DSAI') {
        showSection = false;
        if (_selSem == 'Semester 1') {
          store.subjectsList = store.bbaAiSem1;
        } else if (_selSem == 'Semester 3') {
          store.subjectsList = store.bbaAiSem3;
        } else if (_selSem == 'Semester 5') {
          store.subjectsList = store.bbaAiSem5;
        }
      } else if (_selSpec == 'BBA FS') {
        if (_selSem == 'Semester 1') {
          dropdownValue == 'Course Outline'
              ? showSection = false
              : showSection = true;
          store.subjectsList = store.bbaFsSem1;
        } else if (_selSem == 'Semester 3') {
          dropdownValue == 'Course Outline'
              ? showSection = false
              : showSection = true;
          store.subjectsList = store.bbaFsSem3;
        } else if (_selSem == 'Semester 5') {
          dropdownValue == 'Course Outline'
              ? showSection = false
              : showSection = true;

          store.subjectsList = store.bbaFsSem5;
        }
      } else if (_selSpec == 'BBA ECDM') {
        if (_selSem == 'Semester 1') {
          dropdownValue == 'Course Outline'
              ? showSection = false
              : showSection = true;
          store.subjectsList = store.bbaDmSem1;
        } else if (_selSem == 'Semester 3') {
          dropdownValue == 'Course Outline'
              ? showSection = false
              : showSection = true;
          store.subjectsList = store.bbaDmSem3;
        } else if (_selSem == 'Semester 5') {
          dropdownValue == 'Course Outline'
              ? showSection = false
              : showSection = true;
          store.subjectsList = store.bbaDmSem5;
        }
      } else if (_selSpec == 'BBA ED') {
        showSection = false;
        if (_selSem == 'Semester 1') {
          store.subjectsList = store.bbaEdSem1;
        } else if (_selSem == 'Semester 3') {
          store.subjectsList = store.bbaEdSem3;
        } else if (_selSem == 'Semester 5') {
          store.subjectsList = store.bbaEdSem5;
        }
      } else if (_selSpec == 'BBA INT') {
        showSection = false;
        if (_selSem == 'Semester 1') {
          store.subjectsList = store.bbaIntSem1;
        }
      }
    });
  }

  Future<void> selectAndRenamePDF(String str) async {
    // String? pathCO;
    // String? pathTT;

    // Use FilePicker to select the PDF
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      String directoryPath = (await getTemporaryDirectory()).path;
      String? newFileName;
      if (str == 'TT' && store.specWithSec.contains(_selSpec)) {
        newFileName =
            "${str}_${_selCourse}_${_selSem}_${_selSpec}_$_selSect.pdf";
      } else if (str == 'TT' && !store.specWithSec.contains(_selSpec)) {
        newFileName = "${str}_${_selCourse}_${_selSem}_$_selSpec.pdf";
      } else if (str == 'CO') {
        newFileName =
            "${str}_${_selCourse}_${_selSem}_${_selSpec}_$_selSub.pdf";
      } else if (str == 'AS' && _selSpec == 'MBA GEN') {
        newFileName =
            "${str}_${_selCourse}_${_selSem}_${_selSpec}_${_selSub}_$_selSect.pdf";
      } else if (str == 'AS' && _selSpec != 'MBA GEN') {
        newFileName = "${str}_${_selCourse}_${_selSem}_$_selSpec.pdf";
      }
      String newPath = path.join(directoryPath, newFileName);

      // if (str == 'CO') {
      //   pathCO = newPath;
      // } else if (str == 'TT') {
      //   pathTT = newPath;
      // }
      newPath = path.join(directoryPath, newFileName);

      await file.copy(newPath);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FullScreenPdfViewer(pdfPath: newPath),
        ),
      );

      print("File has been renamed and saved to: $newPath");
    } else {
      print("No file selected");
    }
  }
}

class FullScreenPdfViewer extends StatelessWidget {
  final String pdfPath;
  const FullScreenPdfViewer({super.key, required this.pdfPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SfPdfViewer.file(File(pdfPath)),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            heroTag: 'upload',
            onPressed: () async {
              loadingOnScreen(context);

              bool faculty = await UserPreferences.getRole() == 'faculty';
              if (faculty) {
                uploadFiles(pdfPath, context);
              }
            },
            backgroundColor: Colors.green,
            child: const Icon(Icons.check),
          ),
          const SizedBox(width: 20),
          // Spacing between the buttons

          FloatingActionButton(
            heroTag: 'close',
            onPressed: () async {
              Navigator.pop(context);
              // Handle "wrong" action
            },
            backgroundColor: Colors.red,
            child: const Icon(Icons.close),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
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

  void uploadFiles(String newpath, BuildContext context) async {
    List<File> files = [];

    files.add(File(newpath));

    if (files.isNotEmpty) {
      var uri = Uri.parse('http://52.20.1.249:5000/api/upload');
      var request = http.MultipartRequest('POST', uri);

      for (var file in files) {
        request.files.add(await http.MultipartFile.fromPath(
          'pdf', // The field name for the file in the API
          file.path,
        ));
      }

      // Add other fields if needed
      // request.fields['key'] = 'value';

      try {
        var response = await request.send();
        var responseString = await response.stream.bytesToString();
        print("response is:");
        print(responseString);

        if (response.statusCode == 200) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Success'),
                content: const Text('Files uploaded successfully'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pushNamed(context, AppRoutes.uploadPage);
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );

          // Handle response
          print('Files uploaded successfully');
        } else {
          Navigator.pop(context);

          print('Failed to upload files');
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Oops!'),
                content:
                    const Text('Something went wrong while uploading files.'),
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
