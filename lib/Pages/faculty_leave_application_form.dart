import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:woxsen/Values/login_status.dart';
import 'package:woxsen/Values/subjects_list.dart';
import 'package:woxsen/utils/colors.dart';

class FacultyLeaveApplicationForm extends StatefulWidget {
  @override
  _LeaveApplicationFormState createState() => _LeaveApplicationFormState();
}

class _LeaveApplicationFormState extends State<FacultyLeaveApplicationForm>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  DateTime? _startDate;
  DateTime? _endDate;
  String? _leaveType;
  final _reasonController = TextEditingController();
  int _totalDays = 0;
  late TabController _tabController;
  int tabControllerIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
    _tabController.addListener(() {
      setState(() {
        tabControllerIndex = _tabController.index;
        _startDate = null;
        _endDate = null;
        _leaveType = null;
        _reasonController.clear();
        _totalDays = 0;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<String> _leaveTypes = [
    'Sick Leave',
    'Earned Leave',
    'Leave Without Pay',
    'Compensation Leave',
    'On Duty Leave',
  ];

  int calculateTotalDays() {
    if (_startDate != null && _endDate != null) {
      return _endDate!.difference(_startDate!).inDays +
          1; // +1 to include both start and end date
    }
    return 0;
  }

  String formatDate(String dateStr) {
    DateTime dateTime = DateTime.parse(dateStr);
    DateFormat formatter = DateFormat('d MMM yyyy');
    String formattedDate = formatter.format(dateTime);

    String day = DateFormat('d').format(dateTime);
    String suffix = 'th';
    if (day.endsWith('1') && !day.endsWith('11')) {
      suffix = 'st';
    } else if (day.endsWith('2') && !day.endsWith('12')) {
      suffix = 'nd';
    } else if (day.endsWith('3') && !day.endsWith('13')) {
      suffix = 'rd';
    }

    return day + suffix + ' ' + formattedDate.substring(day.length);
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime currentDate = DateTime.now();
    final DateTime firstAllowedDate = tabControllerIndex == 1
        ? currentDate.subtract(const Duration(days: 7))
        : currentDate.add(const Duration(days: 5));

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate
          ? (_startDate ?? firstAllowedDate)
          : (_endDate ?? (_startDate ?? firstAllowedDate)),
      firstDate: firstAllowedDate,
      lastDate: DateTime(currentDate.year + 1),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
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
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      UserPreferences userPreferences = UserPreferences();
      String? email = await userPreferences.getEmail();
      Map<String, dynamic> user = await userPreferences.getProfile(email);

      ListStore store = ListStore();

      final leaveData = {
        'name': user['name'],
        'email': user['email'],
        'start_date': formatDate(_startDate!.toIso8601String()),
        'end_date': formatDate(_endDate!.toIso8601String()),
        'leave_type': _leaveType,
        'reason': _reasonController.text,
        'days': _totalDays
      };

      try {
        final response = await http.post(
          Uri.parse('${store.woxUrl}/apply_leave'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(leaveData),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Leave application submitted successfully')),
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
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Leave Application Form',
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
                padding: const EdgeInsets.all(20),
                color: const Color(0xFFFF7F7F),
                child: const Text(
                  'Fill the form',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),

              // Leave Type Tabs
              Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TabBar(
                        controller: _tabController,
                        indicator: BoxDecoration(
                          color: const Color.fromARGB(61, 255, 123, 123),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        indicatorColor: Colors.transparent,
                        indicatorWeight: 0,
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.black,
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        tabs: const [
                          Tab(text: 'General Leave'),
                          Tab(text: 'Emergency Leave'),
                        ],
                      ))),

              Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      const Text('Select Start Date'),
                      GestureDetector(
                        onTap: () => _selectDate(context, true),
                        child: AbsorbPointer(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              hintText: 'Choose Start Date...',
                              prefixIcon: Icon(Icons.calendar_today),
                            ),
                            validator: (value) {
                              if (_startDate == null) {
                                return 'Please select a start date';
                              }
                              final minAllowedDate = tabControllerIndex == 1
                                  ? DateTime.now()
                                      .subtract(const Duration(days: 7))
                                  : DateTime.now().add(const Duration(days: 4));

                              if (tabControllerIndex == 0 &&
                                  _startDate!.isBefore(minAllowedDate)) {
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
                      const SizedBox(height: 20),
                      const Text('Select End Date'),
                      GestureDetector(
                        onTap: () => _selectDate(context, false),
                        child: AbsorbPointer(
                          child: TextFormField(
                            decoration: const InputDecoration(
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
                      const SizedBox(height: 20),
                      const Text('Leave Type'),
                      DropdownButtonFormField<String>(
                        value: _leaveType,
                        hint: const Text('Select Leave Type'),
                        items: (tabControllerIndex == 1
                                ? ['Emergency']
                                : _leaveTypes)
                            .map((String value) {
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
                      const SizedBox(height: 20),
                      const Text('Mention Reason'),
                      TextFormField(
                        controller: _reasonController,
                        decoration: const InputDecoration(
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
                      const SizedBox(height: 20),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 30),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed:
                              _isLoading ? null : _submitLeaveApplication,
                          child: _isLoading
                              ? const Row(
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
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(width: 10),
                                    Text(
                                      'Apply Leave',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ],
                                )),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
