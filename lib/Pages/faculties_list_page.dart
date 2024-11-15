import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:woxsen/Pages/faculty_leave_balance_page.dart';

class FacultiesListPage extends StatefulWidget {
  const FacultiesListPage({Key? key}) : super(key: key);

  @override
  _FacultiesListPageState createState() => _FacultiesListPageState();
}

class _FacultiesListPageState extends State<FacultiesListPage> {
  List<Map<String, dynamic>> facultyList = [];
  String sortOrder = 'asc';
  String? selectedDepartment;

  @override
  void initState() {
    super.initState();
    loadFacultyData();
  }

  Future<void> loadFacultyData() async {
    final String response =
        await rootBundle.loadString('assets/sob_faculties_list.json');
    final data = await json.decode(response);
    setState(() {
      facultyList = List<Map<String, dynamic>>.from(data);
    });
  }

  void toggleSortOrder() {
    setState(() {
      sortOrder = sortOrder == 'asc' ? 'desc' : 'asc';
      facultyList.sort((a, b) => sortOrder == 'asc'
          ? a['name'].compareTo(b['name'])
          : b['name'].compareTo(a['name']));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Handle back button press
          },
        ),
        title:
            const Text('Faculties List', style: TextStyle(color: Colors.black)),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            color: const Color(0xffFA6978),
            width: double.infinity,
            child: const Text(
              'Faculties Leave Status',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              value: selectedDepartment,
              hint: const Text('Select Department'),
              onChanged: (String? newValue) {
                setState(() {
                  selectedDepartment = newValue;
                });
              },
              items: <String>['SOB', 'SOT', 'SOS']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total ${facultyList.length}',
                    style: const TextStyle(
                        color: Color.fromARGB(255, 5, 5, 5), fontSize: 18)),
                IconButton(
                  icon: const Icon(Icons.sort),
                  onPressed: toggleSortOrder,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: facultyList.length,
              itemBuilder: (context, index) {
                final faculty = facultyList[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                faculty['name'],
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                faculty['designation'],
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FacultyLeaveBalancePage(
                                  name: faculty['name'],
                                  designation: faculty['designation'],
                                ),
                              ),
                            )
                          },
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.red.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.arrow_outward, size: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
