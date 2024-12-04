import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:woxsen/utils/colors.dart';
import 'package:woxsen/utils/utils.dart';

class LabBookingScreen extends StatefulWidget {
  const LabBookingScreen({Key? key}) : super(key: key);

  @override
  _LabBookingScreenState createState() => _LabBookingScreenState();
}

class _LabBookingScreenState extends State<LabBookingScreen> {
  bool isLoading = true;
  Map<String, dynamic> labDetails = {};
  String? selectedSchool;
  String? selectedLab;
  String? selectedTimeSlot;
  DateTime? selectedDate;
  List<String> schools = [];
  List<String> labs = [];
  List<String> labInCharges = [];
  List<String> timeSlots = [];

  @override
  void initState() {
    super.initState();
    getLabDetails();
  }

  Future<void> getLabDetails() async {
    const String apiUrl = 'http://10.7.0.23:4040/api/lab_details';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['status'] == 'success') {
          setState(() {
            labDetails = responseData['data'];
            schools = labDetails.keys.toList();
            isLoading = false;
          });
        } else {
          throw Exception('API returned failure status');
        }
      } else {
        throw Exception('Failed to load lab details');
      }
    } catch (e) {
      debugPrint('Error fetching lab details: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onSchoolSelected(String? school) {
    if (school == null) return;

    final selectedSchoolDetails = labDetails[school] as Map<String, dynamic>?;

    if (selectedSchoolDetails != null) {
      setState(() {
        selectedSchool = school;
        labs = List<String>.from(selectedSchoolDetails['labs'] ?? []);
        labInCharges =
            List<String>.from(selectedSchoolDetails['lab_incharges'] ?? []);
        timeSlots = (selectedSchoolDetails['time intervals'] as List<dynamic>?)
                ?.map((interval) => interval[0] as String)
                .toList() ??
            [];
        selectedLab = null;
        selectedTimeSlot = null;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Lab Booking Service',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    color: AppColors.primary, // Light pink background
                    padding: const EdgeInsets.all(24),
                    child: const Text(
                      'Lab Booking',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Select Date',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () => _selectDate(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.calendar_today,
                                    color: Colors.grey.shade600),
                                const SizedBox(width: 12),
                                Text(
                                  selectedDate != null
                                      ? formatDate(selectedDate!.toString())
                                      // ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                                      : 'Choose Booking Date',
                                  style: TextStyle(
                                    color: selectedDate != null
                                        ? Colors.black
                                        : Colors.grey.shade600,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Select School',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 16),
                              border: InputBorder.none,
                            ),
                            hint: const Text('Choose school'),
                            value: selectedSchool,
                            items: schools.map((String school) {
                              return DropdownMenuItem<String>(
                                value: school,
                                child: Text(school),
                              );
                            }).toList(),
                            onChanged: _onSchoolSelected,
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (selectedSchool != null) ...[
                          const Text(
                            'Select Lab',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 16),
                                border: InputBorder.none,
                              ),
                              hint: const Text('Choose lab'),
                              value: selectedLab,
                              items: labs.map((String lab) {
                                return DropdownMenuItem<String>(
                                  value: lab,
                                  child: Text(
                                    lab,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  selectedLab = value;
                                });
                              },
                            ),
                          ),

                          // TIME SLOT SELECTION
                          const SizedBox(height: 16),
                          const Text(
                            'Select TimeSlot',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 3,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            childAspectRatio: 2,
                            children: timeSlots.map((slot) {
                              bool isSelected = selectedTimeSlot == slot;
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedTimeSlot = slot;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.primary
                                          : Colors.grey,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                    color: isSelected
                                        ? Color(0xFFFFE4E6)
                                        : Colors.white,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    slot,
                                    style: TextStyle(
                                      color: isSelected
                                          ? AppColors.primary
                                          : Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),

                          // LAB INCHARGES LIST
                          const SizedBox(height: 16),
                          const Text(
                            'Lab Incharge\'s',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: labInCharges.map((incharge) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.person,
                                        color: AppColors.primary, size: 16),
                                    const SizedBox(width: 8),
                                    Text(incharge),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: (selectedSchool != null &&
                                    selectedLab != null &&
                                    selectedTimeSlot != null &&
                                    selectedDate != null)
                                ? () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Booking confirmed for $selectedLab at $selectedTimeSlot'),
                                      ),
                                    );
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Book Your Lab Session',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
