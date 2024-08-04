import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:woxsen/Pages/apply_campusjob.dart';
import 'package:woxsen/Values/app_routes.dart';
import 'package:http/http.dart' as http;

class campusJobs extends StatefulWidget {
  final bool isBox;
  final Function? updateCount;

  const campusJobs({super.key, required this.isBox, this.updateCount});

  @override
  _campusJobsState createState() => _campusJobsState();
}

class _campusJobsState extends State<campusJobs> {
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

  Future<void> _downloadAndViewPDF(
      String documentPath, String title, String jobId) async {
    loadingOnScreen(context);
    const baseUrl =
        'http://100.29.97.185:5000'; // Replace with your base API URL
    final formattedDocumentPath =
        documentPath.startsWith('/') ? documentPath.substring(1) : documentPath;

    // Ensure a single slash between baseUrl and formattedDocumentPath
    final url = Uri.parse('$baseUrl/$formattedDocumentPath');
    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/temp.pdf';
    final file = File(filePath);

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);
        Navigator.of(context).pop();
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => pdfViewJobs(
                file: file,
                title: title,
                jobId: jobId,
              ),
            ));
      } else {
        throw Exception('Failed to download PDF');
      }
    } catch (e) {
      print('Error downloading PDF: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error downloading PDF')),
      );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      floatingActionButton: widget.isBox
          ? FloatingActionButton(
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
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: widget.isBox
          ? Container(
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
            )
          : null,
      appBar: widget.isBox
          ? AppBar(
              backgroundColor: Colors.white,
              toolbarHeight: 100,
              leading: IconButton(
                icon:
                    const Icon(Icons.menu, size: 30, color: Color(0xffFA6978)),
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
            )
          : null,
      body: Column(
        children: [
          if (widget.isBox)
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
          if (widget.isBox) const SizedBox(height: 10),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: futureJobs,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SpinKitSpinningLines(
                      color: Colors.red,
                      size: 70.0,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No jobs found'));
                } else {
                  if (widget.updateCount != null && !isAlredyCalled) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      widget.updateCount!(snapshot.data!.length);
                      isAlredyCalled = true;
                    });
                  }
                  return Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.93,
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final job =
                              snapshot.data![index] as Map<String, dynamic>;
                          return GestureDetector(
                            onTap: () {
                              _downloadAndViewPDF(job['document_path'],
                                  job['designation'], job['id']);
                            },
                            child: Card(
                              margin: const EdgeInsets.all(10.0),
                              color: const Color(0xffF2C9CD),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _getString(job['designation'])!,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        _buildKeyValue(
                                            'ID', _getString(job['id'])),
                                        _buildKeyValue('Department',
                                            _getString(job['department'])),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }
              },
            ),
          ),
          if (widget.isBox) const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildKeyValue(String key, String? value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            '$key:',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Text(
            value ?? 'No Data',
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}

class pdfViewJobs extends StatefulWidget {
  final File file;
  final String title;
  final String jobId;

  const pdfViewJobs({
    super.key,
    required this.file,
    required this.title,
    required this.jobId,
  });
  @override
  _pdfViewJobsState createState() => _pdfViewJobsState();
}

class _pdfViewJobsState extends State<pdfViewJobs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
              heroTag: 'apply',
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => applyJob(),
                  ),
                );
              },
              backgroundColor: Colors.green,
              child: const Text("Apply"),
            ),
            const SizedBox(width: 20),
            FloatingActionButton(
              heroTag: 'close',
              onPressed: () async {
                Navigator.of(context).pop();
              },
              backgroundColor: Colors.red,
              child: const Text("close"),
            ),

            // Spacing between the buttons
          ],
        ),
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SfPdfViewer.file(
          widget.file,
        ));
  }
}
