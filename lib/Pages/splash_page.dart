import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:woxsen/Pages/get_started.dart';
import 'package:woxsen/Pages/home_page.dart';
import 'package:woxsen/Values/login_status.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Future<void>? initialization;
  late bool loginStat;

  @override
  void initState() {
    super.initState();
    initialization = initializeApp();
  }

  Future<void> initializeApp() async {
    loginStat = await UserPreferences.isLoggedIn();
    await Future.delayed(const Duration(seconds: 2));
    // await Amplify.addPlugins([AmplifyAuthCognito()]);
    // await Amplify.configure(amplifyconfig);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          print("Initialization complete");
          if (loginStat) {
            return const HomePage();
          } else {
            return const GetStarted();
          }
        } else {
          return Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white, // Start color
                    Colors.white12,
                    // Color(0xFFF36776), // End color
                  ],
                ),
              ),
              child: Stack(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Image.asset('assets/download.png',
                            height: MediaQuery.of(context).size.height * 0.26),
                      ),
                      // const SizedBox(height: 20),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 80),
                          child: SpinKitSpinningLines(
                            color: Colors.red.shade800,
                            size: 70.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
