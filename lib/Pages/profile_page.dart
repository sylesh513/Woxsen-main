
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:woxsen/Values/app_routes.dart';
import 'package:file_picker/file_picker.dart';

class profilePage extends StatefulWidget {
  final String name;
  const profilePage({super.key, required this.name});

  @override
  _profilePageState createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nameEdit = TextEditingController();
  final TextEditingController _Program = TextEditingController();
  final TextEditingController _academicYear = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = 'change photo';
    _nameEdit.text = widget.name;
    _Program.text = 'M.B.A';
    _academicYear.text = '2024-2026';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_left,
            size: 70,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
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
                        'My Profile',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 28.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                CircleAvatar(
                  radius: 80,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/top.png',
                      height: 95,
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: TextButton(
                    onPressed: () async {
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles(
                        type: FileType.image,
                      );
                      if (result != null) {
                        // File file = File(result.files.single.path!);
                        // Use the selected file here
                      } else {
                        // User canceled the file picking
                      }
                    },
                    child: TextField(
                      textAlign: TextAlign.center,
                      controller: _nameController,
                      enabled: false,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: _nameEdit,
                          decoration: const InputDecoration(
                            hintText: 'Woxsen', // Placeholder text
                            border:
                                OutlineInputBorder(), // Adds a border around the TextField
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit), // Edit icon
                        onPressed: () {
                          // Define what happens when the edit button is pressed
                          // For example, enable the TextField for editing, show a dialog, etc.
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Password Reset'),
                          content: const Text(
                              'Please check your Outlook for password reset instructions.'),
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
                    minimumSize:
                        const Size(250, 60), // Change dimensions of the button
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16), // Adjust padding if needed
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ), // Adjust border radius if
                  ),
                  child: const Text(
                    'Password Reset',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              ],
            ),
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
                Navigator.pushNamed(context, AppRoutes.loginPage);
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
}
