import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:woxsen/Values/app_routes.dart';
import 'package:http/http.dart' as http;
import 'package:woxsen/Values/subjects_list.dart';

class CreateJob extends StatefulWidget {
  final String? id;
  final String? department;
  final String? role;
  final String title;
  CreateJob(
      {super.key, this.id, this.department, this.role, required this.title});

  @override
  _CreateJobState createState() => _CreateJobState();
}

class _CreateJobState extends State<CreateJob> {
  TextEditingController jobId = TextEditingController();
  TextEditingController department = TextEditingController();
  TextEditingController designation = TextEditingController();
  TextEditingController description = TextEditingController();
  ListStore store = ListStore();
  @override
  void initState() {
    super.initState();
    jobId.text = widget.id ?? '';
    department.text = widget.department ?? '';
    designation.text = widget.role ?? '';
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
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.07,
                decoration: const BoxDecoration(
                  color: Color(0xffFA6978),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(width: 5),
                    Text(
                      widget.title,
                      style: const TextStyle(
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
                    const SizedBox(height: 30),
                    buildRow(context, "Job Id", jobId),
                    const SizedBox(height: 20),
                    buildRow(context, "Department", department),
                    const SizedBox(height: 20),
                    buildRow(context, "Designation / Job Role", designation),
                    const SizedBox(height: 20),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.25,
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.black,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextField(
                          controller: description,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: const InputDecoration(
                            hintText: 'Job Description',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
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
                          var result = await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['pdf'],
                          );
                          if (result != null) {
                            List<File> files = result.paths
                                .map((path) => File(path!))
                                .toList();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => postJobPdf(
                                    files: files,
                                    jobId: jobId.text,
                                    department: department.text,
                                    designation: designation.text,
                                    description: description.text),
                              ),
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
                              'Upload pdf',
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
                    SizedBox(height: 20),
                    if (widget.title == 'Edit a Job')
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
                            loadingOnScreen(context);
                            var uri = Uri.parse(
                                '${store.jobsUrl}/api/edit_job/${jobId.text}');
                            var request = http.MultipartRequest('POST', uri);

                            request.fields['job_id'] = jobId.text;
                            request.fields['department'] = department.text;
                            request.fields['designation'] = designation.text;
                            request.fields['description'] = description.text;
                            var response = await request.send();
                            if (response.statusCode == 200) {
                              Navigator.pop(context);
                              print("OK");
                            } else if (response.statusCode != 200) {
                              Navigator.pop(context);
                              print("error");
                              print(response.headers);
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
                                Icons.save,
                                color: Colors.black,
                              ),
                              SizedBox(
                                  width: 12), // Space between logo and text
                              Text(
                                'Submit',
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
              ), // Add your widgets here
            ],
          ),
        ),
      ),
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

  Container buildRow(
      BuildContext context, String hintText, TextEditingController controller) {
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

class postJobPdf extends StatelessWidget {
  final String jobId;
  final String department;
  final String designation;
  final String description;

  final List<File> files;
  const postJobPdf(
      {super.key,
      required this.files,
      required this.jobId,
      required this.department,
      required this.designation,
      required this.description});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SfPdfViewer.file(File(files[0].path)),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            heroTag: 'upload',
            onPressed: () async {
              loadingOnScreen(context);

              uploadFiles(files, context);
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

  void uploadFiles(List<File> newpath, BuildContext context) async {
    ListStore store = ListStore();
    List<File> files = newpath;
    if (files.isNotEmpty) {
      var uri = Uri.parse('${store.jobsUrl}/api/edit_job/$jobId');
      var request = http.MultipartRequest('POST', uri);

      for (var file in files) {
        request.files.add(await http.MultipartFile.fromPath(
          'pdf', // The field name for the file in the API
          file.path,
        ));
      }
      request.fields['job_id'] = jobId;
      request.fields['department'] = department;
      request.fields['designation'] = designation;
      request.fields['description'] = description;

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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateJob(
                                    title: 'Post a Job',
                                  )));
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
