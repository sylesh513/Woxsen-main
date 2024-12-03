import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:woxsen/Pages/home_page.dart';
import 'package:woxsen/Values/app_routes.dart';
import 'package:woxsen/Values/login_status.dart';
import 'package:http/http.dart' as http;
import 'package:woxsen/Values/subjects_list.dart';
import 'package:woxsen/utils/utils.dart';

class LabBooking extends StatefulWidget {
  const LabBooking({super.key});

  @override
  _LabBooking createState() => _LabBooking();
}

class _LabBooking extends State<LabBooking> {
  DateTime? bookingDate;
  String? department;
  String? labName;

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  ListStore store = ListStore();

  // Departments
  List<String> _departments = [
    'SOB',
    'SOS',
    'SOT',
  ];

  // Labs
  List<String> _labs = [
    'Lab One',
    'Lab Two',
    'Lab Three',
    'Lab Four',
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime currentDate = DateTime.now();
    final DateTime firstAllowedDate = currentDate.add(const Duration(days: 1));

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: firstAllowedDate,
      firstDate: firstAllowedDate,
      lastDate: DateTime(currentDate.year + 2),
    );

    setState(() {
      bookingDate = picked!;
    });
  }

  Future<void> _handleLabBookingSession() async {
    showAlertDialog(context, 'Hi there', 'hello');

    UserPreferences userPreferences = UserPreferences();
    String email = await userPreferences.getEmail();

    Map<String, dynamic> user = await userPreferences.getProfile(email);

    print('Booking date : $bookingDate');
    print('Department : $department');
    print('Lab Name : $labName');

    try {
      final response = await http.post(
        Uri.parse('${store.woxUrl}/api/st_update_status'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email_id': '',
          'user_id': '',
          'status': '',
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _isLoading = false;
        });

        // AlertDialog(
        //   title: const Text(
        //       'Your lab session has been booked. You will be notified by email.'),
        //   actions: <Widget>[
        //     TextButton(
        //       onPressed: () {
        //         Navigator.pop(context);
        //       },
        //       child: const Text('OK'),
        //     ),
        //   ],
        // );
        return showAlertDialog(context,
            'Your lab session has been booked. You will be notified by email.');
      } else {
        throw Exception('Something Went Wrong');
      }
    } catch (e) {
      print('Error occurred: $e');
      showAlertDialog(context,
          'Unable to book lab session. Please try again after sometime');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Lab Booking Service',
            style: TextStyle(color: Colors.black)),
      ),
      body: Column(children: [
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
                'Lab Booking',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 28.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text('Select Start Date'),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Choose Start Date...',
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      validator: (value) {
                        if (bookingDate == null) {
                          return 'Please select the booking date';
                        }

                        return null;
                      },
                      controller: TextEditingController(
                        text: bookingDate == null
                            ? ''
                            : DateFormat('yyyy-MM-dd').format(bookingDate!),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Select Department'),
                DropdownButtonFormField<String>(
                  value: department,
                  hint: const Text('Select Department'),
                  items: _departments.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      department = newValue;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Please select the department' : null,
                ),
                const SizedBox(height: 20),
                const Text('Select Lab'),
                DropdownButtonFormField<String>(
                  value: labName,
                  hint: const Text('Select Lab'),
                  items: _labs.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      labName = newValue;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Please select the lab' : null,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            _handleLabBookingSession();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffFA6978),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      disabledBackgroundColor:
                          Color.fromARGB(78, 250, 105, 119),
                    ),
                    child: Text(
                      _isLoading ? 'Booking...' : 'Book Your Lab Session',
                      style: TextStyle(
                        fontSize: 18,
                        color: _isLoading ? Colors.grey.shade800 : Colors.black,
                      ),
                    ),
                  ),
                )
              ],
            )),
      ]),
    );
  }
}

Widget _buildDropdown(String label, List<String> items, String? value,
    Function(String?) onChanged) {
  return DropdownButtonFormField<String>(
    decoration: InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
    ),
    value: value,
    items: items.map((String item) {
      return DropdownMenuItem<String>(
        value: item,
        child: Text(item),
      );
    }).toList(),
    onChanged: onChanged,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please select an option';
      }
      return null;
    },
  );
}

Widget _buildDatePicker(BuildContext context, String label,
    DateTime? selectedDate, Function(DateTime) onDateSelected) {
  return TextFormField(
    decoration: InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
      suffixIcon: const Icon(Icons.calendar_today),
    ),
    readOnly: true,
    controller: TextEditingController(
      text: selectedDate != null
          ? DateFormat('yyyy-MM-dd').format(selectedDate)
          : '',
    ),
    onTap: () async {
      // final DateTime now = DateTime.now();
      final DateTime? labBookingDate = selectedDate;

      final pickedDate = await showDatePicker(
        context: context,
        initialDate: labBookingDate ?? DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (pickedDate != null) onDateSelected(pickedDate);
    },
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please select a date';
      }
      return null;
    },
  );
}
