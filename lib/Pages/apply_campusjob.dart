import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:woxsen/Values/app_routes.dart';
import 'package:http/http.dart' as http;
import 'package:woxsen/Values/subjects_list.dart';

class applyJob extends StatefulWidget {
  const applyJob({super.key});

  @override
  _applyJobState createState() => _applyJobState();
}

class _applyJobState extends State<applyJob> {
  @override
  void initState() {
    super.initState();
  }

  TextEditingController _batchController = TextEditingController();
  TextEditingController _experienceController = TextEditingController();

  bool isAlredyCalled = false;
  ListStore store = ListStore();
  String? selectedSchool;

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
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
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
                      'Job Application',
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
                      height: 40,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.black,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: TextField(
                          controller: _experienceController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: const InputDecoration(
                            hintText:
                                'Please mention if you have any \n prior work experience \n (job/internship/volunteering)',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    buildRow(context, 'Batch (Ex: BBA_2025)'),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.83,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 9,
                            offset: const Offset(
                                4, 7), // changes position of shadow
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
                            value: selectedSchool,
                            hint: const Text('Select School'),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedSchool = newValue;
                              });
                            },
                            items: store.schools
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
                    const SizedBox(
                      height: 20,
                    ),
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
                            offset: const Offset(
                                4, 7), // changes position of shadow
                          ),
                        ],
                        borderRadius:
                            BorderRadius.circular(16), // Add border radius
                      ),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_batchController.text.isNotEmpty) {
                            FilePickerResult? result =
                                await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['pdf'],
                            );
                            if (result != null) {
                              String selectedFile = result.files.single.path!;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ResumePdfViewer(pdfPath: selectedFile),
                                ),
                              );
                            }
                          }
                          if (_batchController.text.isEmpty) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title:
                                      const Text('Please fill all the fields'),
                                  content: const Text(
                                      'Please enter your batch details'),
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
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.upload_rounded,
                              color: Colors.black,
                            ),
                            SizedBox(width: 12), // Space between logo and text
                            Text(
                              'Upload Resume',
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
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Container buildRow(BuildContext context, String hintText) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
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
        controller: _batchController,
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

class ResumePdfViewer extends StatelessWidget {
  final String pdfPath;
  const ResumePdfViewer({super.key, required this.pdfPath});

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

              uploadFiles(pdfPath, context);
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

  void uploadFiles(String newPath, BuildContext context) async {
    List<File> files = [];

    files.add(File(newPath));

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
      request.fields['id'] = '12345'; // Replace with the actual id
      request.fields['email'] =
          'example@example.com'; // Replace with the actual email

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
