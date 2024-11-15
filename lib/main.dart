import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:woxsen/Pages/academics_page.dart';
import 'package:woxsen/Pages/campus_jobs_admin.dart';
import 'package:woxsen/Pages/feedback_complaints.dart';
import 'package:woxsen/Pages/get_started.dart';
import 'package:woxsen/Pages/home_page.dart';
import 'package:woxsen/Pages/leave_page.dart';
import 'package:woxsen/Pages/login_page.dart';
import 'package:woxsen/Pages/menu_page.dart';
import 'package:woxsen/Pages/notifications_page.dart';
import 'package:woxsen/Pages/profile_page.dart';
import 'package:woxsen/Pages/services_page.dart';
import 'package:woxsen/Pages/splash_page.dart';
import 'package:woxsen/Pages/upload_page.dart';
import 'package:woxsen/Values/app_routes.dart';
import 'package:woxsen/Values/app_theme.dart';
import 'package:woxsen/providers/feedback_from_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // runApp(const MainApp());
  runApp(ChangeNotifierProvider(
    create: (context) => FeedbackFormProvider(),
    child: const MainApp(),
  ));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Woxsen",
      theme: AppTheme().myTheme,
      initialRoute: AppRoutes.splashPage,
      routes: {
        AppRoutes.splashPage: (context) => const SplashPage(),
        AppRoutes.getStarted: (context) => const GetStarted(),
        AppRoutes.loginPage: (context) => const LoginPage(),
        AppRoutes.homePage: (context) => const HomePage(),
        AppRoutes.academicsPage: (context) => const Academics(),
        AppRoutes.servicesPage: (context) => const Services(),
        AppRoutes.menuPage: (context) => const MenuPage(),
        AppRoutes.uploadPage: (context) => const UploadPage(),
        AppRoutes.profilePage: (context) => const profilePage(
              name: "N/A",
            ),
        AppRoutes.campusJobsAdmin: (context) => const campusJobsAdmin(),
        AppRoutes.feedback: (context) => const feedback(newTitile: 'N/A'),
        AppRoutes.notificationsPage: (context) => const notificationPage(),
        AppRoutes.leavePage: (context) => const FacultyLeavePage(),
      },
    );
  }
}
