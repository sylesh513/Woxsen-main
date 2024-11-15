import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:woxsen/Values/login_status.dart';
import 'package:woxsen/Values/subjects_list.dart';

class FacultyLeaveApplicationForm extends StatefulWidget {
  @override
  _LeaveApplicationFormState createState() => _LeaveApplicationFormState();
}

class _LeaveApplicationFormState extends State<FacultyLeaveApplicationForm> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _startDate;
  DateTime? _endDate;
  String? _leaveType;
  final _reasonController = TextEditingController();
  int _totalDays = 0;

  List<String> _leaveTypes = [
    'Sick Leave',
    'Earned Leave',
    'Leave Without Pay',
    'Compensation Leave'
  ];

  int calculateTotalDays() {
    if (_startDate != null && _endDate != null) {
      return _endDate!.difference(_startDate!).inDays +
          1; // +1 to include both start and end date
    }
    return 0;
  }

  Future<String> getCurrentUserEmail() async {
    UserPreferences userPreferences = UserPreferences();
    String? email = await userPreferences.getEmail();
    if (email != null) {
      print('Current user email: $email');
      return email;
    } else {
      print('No user is currently logged in.');
      throw Exception('No user is currently logged in.');
    }
  }

  String formatDate(String dateStr) {
    DateTime dateTime = DateTime.parse(dateStr);
    DateFormat formatter = DateFormat('d MMM yyyy');
    String formattedDate = formatter.format(dateTime);

    // Add the ordinal suffix
    String day = DateFormat('d').format(dateTime);
    String suffix = 'th';
    if (day.endsWith('1') && !day.endsWith('11')) {
      suffix = 'st';
    } else if (day.endsWith('2') && !day.endsWith('12')) {
      suffix = 'nd';
    } else if (day.endsWith('3') && !day.endsWith('13')) {
      suffix = 'rd';
    }

    print(day + suffix + ' ' + formattedDate.substring(day.length));

    return day + suffix + ' ' + formattedDate.substring(day.length);
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime currentDate = DateTime.now();
    final DateTime firstAllowedDate = currentDate.add(Duration(days: 5));

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate
          ? (_startDate ?? firstAllowedDate)
          : (_endDate ?? (_startDate ?? firstAllowedDate)),
      firstDate: firstAllowedDate,
      lastDate: DateTime(currentDate.year + 2),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          // If end date is before start date, reset it
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = null;
          }
        } else {
          _endDate = picked;
        }
        _totalDays = calculateTotalDays();
      });
    }
  }

  bool _isLoading = false;
  Future<void> _submitLeaveApplication() async {
    String email = await getCurrentUserEmail();

    ListStore store = ListStore();

    // final userResponse = await http.post(
    //   Uri.parse('${store.woxUrl}/api/fetch_profile'),
    //   headers: <String, String>{
    //     'Content-Type': 'application/json; charset=UTF-8',
    //   },
    //   body: jsonEncode(<String, String>{
    //     'required': 'profile_details',
    //     'email': email,
    //   }),
    // );

    // print(userResponse.body);

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final leaveData = {
        'name': 'Praveen R',
        'email': 'praveen.r@woxsen.edu.in',
        'start_date': formatDate(_startDate!.toIso8601String()),
        'end_date': formatDate(_endDate!.toIso8601String()),
        'leave_type': _leaveType,
        'reason': _reasonController.text,
        'days': _totalDays
      };

      try {
        final response = await http.post(
          Uri.parse('http://10.106.13.71:8000/apply_leave'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(leaveData),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Leave application submitted successfully')),
          );

          setState(() {
            _startDate = null;
            _endDate = null;
            _leaveType = null;
            _reasonController.clear();
          });
        } else {
          throw Exception('Failed to submit leave application');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Leave Application Form',
            style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                color: Color(0xFFFF7F7F),
                child: Text(
                  'Fill the form',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Text('Select Start Date'),
                      GestureDetector(
                        onTap: () => _selectDate(context, true),
                        child: AbsorbPointer(
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Choose Start Date...',
                              prefixIcon: Icon(Icons.calendar_today),
                            ),
                            validator: (value) {
                              if (_startDate == null) {
                                return 'Please select a start date';
                              }
                              final minAllowedDate =
                                  DateTime.now().add(Duration(days: 4));
                              if (_startDate!.isBefore(minAllowedDate)) {
                                return 'Start date must be at least 5 days from now';
                              }
                              return null;
                            },
                            controller: TextEditingController(
                              text: _startDate == null
                                  ? ''
                                  : DateFormat('yyyy-MM-dd')
                                      .format(_startDate!),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text('Select End Date'),
                      GestureDetector(
                        onTap: () => _selectDate(context, false),
                        child: AbsorbPointer(
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Choose End Date...',
                              prefixIcon: Icon(Icons.calendar_today),
                            ),
                            validator: (value) {
                              if (_endDate == null) {
                                return 'Please select an end date';
                              }
                              if (_startDate != null &&
                                  _endDate!.isBefore(_startDate!)) {
                                return 'End date must be after start date';
                              }
                              return null;
                            },
                            controller: TextEditingController(
                              text: _endDate == null
                                  ? ''
                                  : DateFormat('yyyy-MM-dd').format(_endDate!),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text('Leave Type'),
                      DropdownButtonFormField<String>(
                        value: _leaveType,
                        hint: Text('Select Leave Type'),
                        items: _leaveTypes.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _leaveType = newValue;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Please select a leave type' : null,
                      ),
                      SizedBox(height: 20),
                      Text('Mention Reason'),
                      TextFormField(
                        controller: _reasonController,
                        decoration: InputDecoration(
                          hintText: 'Mention Your Reason For Leave...',
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a reason for your leave';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        child: _isLoading
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Applying...',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              )
                            : Text(
                                'Apply Leave',
                                style: TextStyle(fontSize: 18),
                              ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFF7F7F),
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 30),
                        ),
                        onPressed: _isLoading ? null : _submitLeaveApplication,
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
