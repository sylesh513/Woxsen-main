import 'package:flutter/material.dart';
import 'package:woxsen/Values/app_routes.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({super.key});

  @override
  _GetStartedState createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: const BoxDecoration(
              color: Colors.white, // Background color inside the container
              // border: Border.all(
              //   color: Colors.black, // Color of the border
              //   width: 2.0, // Width of the border
              // ),
              borderRadius: BorderRadius.only(
                bottomLeft:
                    Radius.circular(70), // Rounded corner for bottom left
                bottomRight: Radius.circular(70),
              ),
              image: DecorationImage(
                image:
                    AssetImage('assets/bg.png'), // Replace with your image path
                fit:
                    BoxFit.cover, // This will fill the container with the image
              ), // Optional: if you want rounded corners
            ),
          ),
          // Align(
          //   alignment: Alignment.topCenter,
          //   child: Image.asset(
          //     'assets/bg.jpeg', // Replace with your image path
          //     // width: 400, // Adjust the size as needed
          //     // height: 500, // Adjust the size as needed
          //   ),
          // ),
          Align(
            alignment: Alignment.center,
            child: CircleAvatar(
              backgroundColor:
                  Colors.grey.shade300, // Change background color to white
              radius: 65, // Adjust the size as needed
              child: ClipOval(
                child: Image.asset(
                  'assets/top.png',
                  height: 70,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height *
                0.35, // Adjust the distance from the bottom as needed
            left: 0,
            right: 0,
            child: const Center(
              child: Text(
                'Woxsen University',
                style: TextStyle(
                  color: Colors.black, // Change text color to black
                  fontSize: 30, // Adjust font size as needed
                  fontWeight: FontWeight.w500, // Adjust font weight as needed
                ),
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height *
                0.28, // Adjust the distance from the bottom as needed
            left: 0,
            right: 0,
            child: const Center(
              child: Text(
                'Welcomes You!',
                style: TextStyle(
                  color: Colors.black, // Change text color to black
                  fontSize: 30, // Adjust font size as needed
                  fontWeight: FontWeight.w400, // Adjust font weight as needed
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 80, // Adjust the distance from the bottom as needed
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.loginPage);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(
                      255, 230, 131, 141), // Change background color to white
                  minimumSize:
                      const Size(250, 60), // Change dimensions of the button
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16), // Adjust padding if needed
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ), // Adjust border radius if
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(color: Colors.black, fontSize: 24),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
