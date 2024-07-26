import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as httpp;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:woxsen/Pages/feedback_complaints.dart';
import 'package:woxsen/Pages/profile_page.dart';
import 'package:woxsen/Values/app_routes.dart';
import 'package:woxsen/Values/login_status.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  List<String> category = [
    'Rise',
    'Oval',
    'Academics',
    'Woxsen App',
    'Infrastructure',
  ];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _studentId = TextEditingController();
  final TextEditingController _Program = TextEditingController();
  final TextEditingController _academicYear = TextEditingController();

  get http => null;

  @override
  void initState() {
    super.initState();
    _nameController.text = 'N/A';
    _studentId.text = 'N/A';
    _Program.text = 'N/A';
    _academicYear.text = '2025';
    getDetails();
  }

  void getDetails() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
    });

    var userPreferences = UserPreferences();
    var email = await userPreferences.getEmail();
    print(email);
    const String apiUrl =
        'http://52.20.1.249:5000/api/fetch_profile'; // Replace with your API URL
    final response = await httpp.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'required': 'profile_details',
        'email': email,
      }),
    );
    print(response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var name = data['name'];
      var studentId = data['id'];
      var program = data['course'];
      var academicYear = data['specialization'];

      setState(() {
        _nameController.text = name;
        _studentId.text = studentId.toString();
        _Program.text = program;
        _academicYear.text = academicYear;
        Navigator.pop(context);
      });
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          iconSize: 90,
          icon: const Icon(
            Icons.arrow_left,
            size: 70,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              CircleAvatar(
                radius: 60,
                child: ClipOval(
                  child: Image.asset(
                    'assets/top.png',
                    height: 95,
                  ),
                ),
              ),
              TextField(
                textAlign: TextAlign.center,
                controller: _nameController,
                enabled: false,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
              ),
              // buildNewRow('Student ID - ', context, _studentId, 0.23, 0.32),
              // buildNewRow('Program Name - ', context, _Program, 0.31, 0.2),
              // buildNewRow(
              //     'Academic Year - ', context, _academicYear, 0.31, 0.26),
              buildRow('ID', _studentId),
              buildRow('Program', _Program),
              buildRow('specialization', _academicYear),

              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildButton(
                      context, 'My Profile', AppRoutes.profilePage, 'prf'),
                  buildButton(context, 'Timings', AppRoutes.homePage, 'tim'),
                  buildButton(context, 'Newsletter', AppRoutes.homePage, 'nwe'),
                  buildButton(context, 'Feedback', AppRoutes.homePage, 'fdbk'),
                ],
              )), // Provides spacing before the buttons
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextButton(
              onPressed: () {
                UserPreferences.logout();
                UserPreferences.clear();
                Navigator.pushNamedAndRemoveUntil(
                    context, AppRoutes.loginPage, (route) => false);
                // Handle logout logic
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('LOGOUT',
                    style: TextStyle(
                      color: Colors.red.shade900,
                      fontSize: 22,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRow(String label, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end, // Centers the row content
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width *
                0.3, // Adjust the width as needed
            child: Text(
              '$label: ',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: SizedBox(
              width: MediaQuery.of(context).size.width *
                  0.3, // Adjust the width as needed
              child: TextField(
                enabled: false,
                controller: controller,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,

                  // Reduces the default top and bottom padding
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildButton(BuildContext context, String text, String route,
      [String? forwhat]) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.06,
        width: MediaQuery.of(context).size.width * 0.80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
        ),
        child: ElevatedButton(
          onPressed: () {
            if (forwhat == 'tim') {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PDFViewerPage(
                        pdfPath: 'assets/oval_timings.pdf', title: 'Timings')),
              );
            } else if (forwhat == "nwe") {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PDFViewerPage(
                        pdfPath: 'assets/newsletter.pdf', title: 'Newsletter')),
              );
            } else if (forwhat == 'fdbk') {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const feedback(
                          newTitile: 'Feedback',
                        )),
              );
            } else if (forwhat == 'prf') {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return profilePage(
                  name: _nameController.text,
                );
              }));
            }
          },
          style: ElevatedButton.styleFrom(
            shadowColor: Colors.black,
            backgroundColor:
                const Color(0xffF2C9CD), // Change background color to white
            padding: const EdgeInsets.symmetric(
                horizontal: 16), // Adjust padding if needed
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ), // Adjust border radius if
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildNewRow(String str, BuildContext context,
      TextEditingController controller, double width, double fieldWidth) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.025,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * width,
            child: Text(
              str,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                // fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * fieldWidth,
            height: MediaQuery.of(context).size.height * 0.017,
            child: Center(
              child: TextField(
                enabled: false,
                controller: controller,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0,
                ),
                maxLines: 1,
                scrollPhysics: const BouncingScrollPhysics(),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 11),
                  counterText: '',
                  border: InputBorder.none,
                ),
                onChanged: (text) {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PDFViewerPage extends StatefulWidget {
  final String pdfPath;
  final String title;

  const PDFViewerPage({super.key, required this.pdfPath, required this.title});
  @override
  _PDFViewerPageState createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
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
      body: _localFile != null
          ? SfPdfViewer.asset(widget.pdfPath)
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
