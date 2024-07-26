import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:woxsen/Pages/notifications_page.dart';
import 'package:woxsen/Values/app_routes.dart';

class campusJobs extends StatefulWidget {
  const campusJobs({super.key});

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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height *
                    0.5, // Changeable height
                width: MediaQuery.of(context).size.width * 0.89,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => pdfViewJobs(
                                        pdfPath: items[index]["pdfLink"],
                                        title: 'Job',
                                      )));
                          // showDialog(
                          //   context: context,
                          //   builder: (BuildContext context) {
                          //     return AlertDialog(
                          //       title: Text(
                          //         "${items[index]["title"]}",
                          //         style: const TextStyle(
                          //             fontSize: 22,
                          //             fontWeight: FontWeight.bold),
                          //       ),
                          //       content: Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           Text(
                          //             "Department: ${items[index]["department"]}",
                          //             style: const TextStyle(
                          //                 fontSize: 15,
                          //                 fontWeight: FontWeight.bold),
                          //           ),
                          //           const Text(
                          //             "Description: ",
                          //             style: TextStyle(
                          //                 fontSize: 15,
                          //                 fontWeight: FontWeight.bold),
                          //           ),
                          //           Text("${items[index]["description"]}"),
                          //         ],
                          //       ),
                          //       actions: [
                          //         TextButton(
                          //           onPressed: () {
                          //             Navigator.of(context).pop();
                          //           },
                          //           child: Text(
                          //             "Close",
                          //             style: TextStyle(
                          //               color: Colors.red.shade800,
                          //               fontSize: 20,
                          //             ),
                          //           ),
                          //         ),
                          //         TextButton(
                          //           onPressed: () {
                          //             Navigator.push(
                          //               context,
                          //               MaterialPageRoute(
                          //                 builder: (context) =>
                          //                     const CustomWebViewPage(
                          //                   pageTitle: 'Campus Jobs',
                          //                   pageUrl:
                          //                       'https://forms.office.com/r/0YGLHKwqVc',
                          //                 ),
                          //               ),
                          //             );
                          //           },
                          //           child: Text(
                          //             "Apply",
                          //             style: TextStyle(
                          //               color: Colors.green.shade800,
                          //               fontSize: 20,
                          //             ),
                          //           ),
                          //         ),
                          //       ],
                          //     );
                          //   },
                          // );
                        },
                        child: Card(
                          color: const Color(0xffF2C9CD),
                          child: ListTile(
                            title: Text(
                              items[index]["title"],
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                                "Number of applicants: ${items[index]["applicants"]}"),
                            // trailing: Row(
                            //   mainAxisSize: MainAxisSize.min,
                            //   children: [
                            //     TextButton(
                            //       onPressed: () {
                            //         Navigator.push(
                            //           context,
                            //           MaterialPageRoute(
                            //             builder: (context) =>
                            //                 const CustomWebViewPage(
                            //               pageTitle: 'Campus Jobs',
                            //               pageUrl:
                            //                   'https://forms.office.com/r/0YGLHKwqVc',
                            //             ),
                            //           ),
                            //         );
                            //       },
                            //       child: Text(
                            //         "Apply",
                            //         style: TextStyle(
                            //           color: Colors.green.shade800,
                            //           fontSize: 20,
                            //         ),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          )),
        ],
      ),
    );
  }
}

class pdfViewJobs extends StatefulWidget {
  final String pdfPath;
  final String title;

  const pdfViewJobs({super.key, required this.pdfPath, required this.title});
  @override
  _pdfViewJobsState createState() => _pdfViewJobsState();
}

class _pdfViewJobsState extends State<pdfViewJobs> {
  String? _localFile;

  @override
  void initState() {
    super.initState();
    _loadPDF().then((path) {
      setState(() {
        _localFile = path;
      });
    });
  }

  Future<String> _loadPDF() async {
    final byteData = await rootBundle.load(widget.pdfPath);
    final file =
        File('${(await getTemporaryDirectory()).path}/my_document.pdf');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return file.path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            heroTag: 'apply',
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CustomWebViewPage(
                    pageTitle: 'Campus Jobs',
                    pageUrl: 'https://forms.office.com/r/0YGLHKwqVc',
                  ),
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
      body: _localFile != null
          ? PDFView(
              filePath: _localFile,
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
