import 'package:flutter/material.dart';
import 'package:woxsen/Values/app_routes.dart';

class feedback extends StatefulWidget {
  final String newTitile;
  const feedback({super.key, required this.newTitile});

  @override
  _feedbackState createState() => _feedbackState();
}

class _feedbackState extends State<feedback> {
  String? dropdownValue;

  @override
  Widget build(BuildContext context) {
    List<String> category = [
      'Rise',
      'Oval',
      'Academics',
      'Woxsen App',
      'Infrastructure',
    ];
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
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
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
                      widget.newTitile,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 28.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.4,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xff444444),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)), // Add border radius
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      dropdownColor: Colors.grey.shade800,
                      value: dropdownValue,
                      hint: const Text('Department',
                          style: TextStyle(color: Colors.white)),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue;
                        });
                      },
                      items: category
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
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
                      padding: const EdgeInsets.all(10.0),
                      child: TextField(
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: 'Enter your ${widget.newTitile}',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Feedback Submitted'),
                            content: const Text('Thank you for your feedback.'),
                            actions: [
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
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(
                          0xFFEA485D), // Change background color to white
                      minimumSize: const Size(
                          250, 60), // Change dimensions of the button
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16), // Adjust padding if needed
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ), // Adjust border radius if
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}
