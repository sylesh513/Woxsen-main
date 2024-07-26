import 'package:flutter/material.dart';
import 'package:woxsen/Values/app_routes.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class notificationPage extends StatefulWidget {
  const notificationPage({super.key});

  @override
  _notificationPageState createState() => _notificationPageState();
}

class _notificationPageState extends State<notificationPage> {
  final Uri _url = Uri.parse('https://woubus.woxsen.edu.in/login');

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
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        toolbarHeight: 100,
        title: Center(
          child: Image.asset(
            'assets/top.png',
            fit: BoxFit.cover,
            height: 100, // Adjust the size according to your logo
          ),
        ),
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
                  'Notifications',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Container(
            height: 80,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xffFA6978),
                width: 2,
              ),
            ),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const CustomWebViewPage(
                    pageTitle: 'International Conference',
                    pageUrl: 'https://aikp24.aircwou.in/',
                  );
                }));
              },
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "International Conference on Artificial Intelligence & Knowledge Processing 24",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }
}

class CustomWebViewPage extends StatelessWidget {
  final String pageTitle;
  final String pageUrl;

  const CustomWebViewPage({
    super.key,
    required this.pageTitle,
    required this.pageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle),
      ),
      body: WebView(
        initialUrl: pageUrl,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
