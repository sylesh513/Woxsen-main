import 'dart:io';

import 'package:flutter/material.dart';
import 'package:woxsen/Pages/menu_page.dart';
import 'package:woxsen/Values/app_routes.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Services extends StatefulWidget {
  const Services({super.key});

  @override
  _ServicesState createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  final Uri _busLink = Uri.parse('https://woubus.woxsen.edu.in/login');
  final Uri _martLink = Uri.parse('http://44.208.243.74:8000');

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
                  'Services',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                child: ElevatedButton(
                  // onPressed: _launchUrl,
                  onPressed: () {
                    if (Platform.isAndroid) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CustomWebViewPage(
                            pageTitle: 'Campus Bus Booking',
                            pageUrl: 'https://woubus.woxsen.edu.in/',
                          ),
                        ),
                      );
                    } else if (!Platform.isAndroid) {
                      _launchUrl(_busLink);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(
                        0xffE7E7E7), // Change background color to white
                    minimumSize:
                        const Size(270, 70), // Change dimensions of the button
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16), // Adjust padding if needed
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ), // Adjust border radius if
                  ),
                  child: const Text(
                    'Bus Booking',
                    style: TextStyle(color: Colors.black, fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Container(
              //   child: ElevatedButton(
              //     onPressed: () {
              //       // Navigator.pushNamed(context, AppRoutes.loginPage);
              //     },
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: const Color(
              //           0xffE7E7E7), // Change background color to white
              //       minimumSize:
              //           const Size(270, 70), // Change dimensions of the button
              //       padding: const EdgeInsets.symmetric(
              //           horizontal: 16), // Adjust padding if needed
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(18),
              //       ), // Adjust border radius if
              //     ),
              //     child: const Text(
              //       'Rise',
              //       style: TextStyle(color: Colors.black, fontSize: 24),
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 20),
              Container(
                child: ElevatedButton(
                  onPressed: () {
                    if (!Platform.isAndroid) {
                      _launchUrl(_martLink);
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CustomWebViewPage(
                            pageTitle: 'Campus Mart',
                            pageUrl: 'http://44.208.243.74:8000',
                          ),
                        ),
                      );
                    }

                    // Navigator.pushNamed(context, AppRoutes.loginPage);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(
                        0xfffe7e7e7), // Change background color to white
                    minimumSize:
                        const Size(270, 70), // Change dimensions of the button
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16), // Adjust padding if needed
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ), // Adjust border radius if
                  ),
                  child: const Text(
                    'Campus Mart',
                    style: TextStyle(color: Colors.black, fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PDFViewerPage(
                              pdfPath: 'assets/oval_data.pdf',
                              title: 'Oval schedule')),
                    );
// Navigator.pushNamed(context, AppRoutes.loginPage);
                  },
                  style: ElevatedButton.styleFrom(
                    shadowColor: Colors.black,
                    backgroundColor: const Color(
                        0xffE7E7E7), // Change background color to white
                    minimumSize:
                        const Size(270, 70), // Change dimensions of the button
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16), // Adjust padding if needed
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ), // Adjust border radius if
                  ),
                  child: const Text(
                    'Oval',
                    style: TextStyle(color: Colors.black, fontSize: 24),
                  ),
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
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
