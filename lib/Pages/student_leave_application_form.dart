import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:woxsen/Values/login_status.dart';
import 'package:woxsen/Values/subjects_list.dart';

class StudentLeaveApplicationForm extends StatefulWidget {
  @override
  _StudentLeaveApplicationFormState createState() =>
      _StudentLeaveApplicationFormState();
}

class _StudentLeaveApplicationFormState
    extends State<StudentLeaveApplicationForm> {
  final _formKey = GlobalKey<FormState>();
  DateTime? startDate;
  DateTime? endDate;
  String? leaveCategory;
  String? leaveReason;
  String? supportingDocument;
  String? supportingVideo;
  String? otherReason;

  static const int MAX_DOCUMENT_SIZE = 5 * 1024 * 1024;
  static const int MAX_VIDEO_SIZE = 15 * 1024 * 1024;

  final Map<String, List<Map<String, String>>> reasonData = {
    'Regular': [
      {'reason': 'Home Outing', 'type': 'REGULAR'},
      {'reason': 'Shopping', 'type': 'REGULAR'},
      {'reason': 'Festival', 'type': 'REGULAR'},
      {'reason': 'Government official appointment', 'type': 'GOVERNMENT'},
    ],
    'Medical': [
      {'reason': 'Medical Issue of Student', 'type': 'MEDICAL'},
      {'reason': 'Medical Issue of Parents', 'type': 'MEDICAL'},
      {'reason': 'Appointment with Doctor', 'type': 'MEDICAL'},
      {'reason': 'Medical Issue of Relatives', 'type': 'MEDICAL'},
    ],
    'Emergency': [
      {'reason': 'Demise of a Relative', 'type': 'EMERGENCY'},
      {'reason': 'Medical Emergency', 'type': 'EMERGENCY'},
      {'reason': 'Other reasons', 'type': 'OTHERS'},
    ],
  };

  bool _isLoading = false;

  void _submitForm() async {
    UserPreferences userPreferences = UserPreferences();
    String email = await userPreferences.getEmail();

    Map<String, dynamic> user = await userPreferences.getProfile(email);
    int totalLeaveDays;

    final DateFormat dateFormatter = DateFormat('yyyy-MM-dd');

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      if (_showFileUploadFields()) {
        try {
          if (supportingDocument != null) {
            File documentFile = File(supportingDocument!);
            int documentSize = await documentFile.length();
            if (documentSize > MAX_DOCUMENT_SIZE) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Document size must be less than 5MB')),
              );
              setState(() {
                _isLoading = false;
              });
              return;
            }
          }

          if (supportingVideo != null) {
            File videoFile = File(supportingVideo!);
            int videoSize = await videoFile.length();
            if (videoSize > MAX_VIDEO_SIZE) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Video size must be less than 15MB')),
              );
              setState(() {
                _isLoading = false;
              });
              return;
            }
          }
        } catch (e) {
          print('Error reading files: $e');
        }

        if (_isEmergencyOrOthers() && supportingVideo == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please upload a supporting video')),
          );
          return;
        }
      }

      // Check for valid date range
      if (startDate == null || endDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please select both start and end dates')),
        );
        return;
      }

      if (endDate!.isBefore(startDate!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('End date cannot be before start date')),
        );
        return;
      }

      final difference = endDate!.difference(startDate!).inDays + 1;

      if (difference > 3) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Leave cannot exceed 3 days')),
        );
        return;
      }

      if (startDate != null && endDate != null) {
        DateTime start = DateTime.parse(startDate.toString());
        DateTime end = DateTime.parse(endDate.toString());
        totalLeaveDays = end.difference(start).inDays + 1;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please provide both start and end dates.')),
        );
        return;
      }

      // video and document url

      var matchingReason = reasonData[leaveCategory]?.firstWhere(
        (reason) => reason['reason'] == leaveReason,
        orElse: () => {},
      );

      if (startDate == null ||
          endDate == null ||
          leaveReason == null ||
          matchingReason == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill in all required fields.'),
          ),
        );
        return;
      }

      var bodyContent = <String, String>{
        "start_date": dateFormatter.format(startDate!),
        "end_date": dateFormatter.format(endDate!),
        "reason": otherReason == null
            ? leaveReason.toString()
            : otherReason.toString(),
        "type": matchingReason['type'].toString(),
        "total_leaves": totalLeaveDays.toString(),
        "course": user['course'].toString(),
        "email": user['email'].toString(),
        "name": user['name'].toString(),
      };

      try {
        var uri = Uri.parse('${ListStore().woxUrl}/api/apply');
        var request = http.MultipartRequest('POST', uri);
        request.fields.addAll(bodyContent);

        if (supportingDocument != null) {
          request.files.add(await http.MultipartFile.fromPath(
            'document_url',
            supportingDocument!,
          ));
        }

        if (supportingVideo != null) {
          request.files.add(await http.MultipartFile.fromPath(
            'video_url',
            supportingVideo!,
          ));
        }

        var userResponse = await request.send();

        if (userResponse.statusCode == 200) {
          var data = userResponse;
          print('DATA $data');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Application applied successfully.')),
          );

          setState(() {
            startDate = null;
            endDate = null;
            leaveCategory = null;
            leaveReason = null;
            supportingDocument = null;
            supportingVideo = null;
            otherReason = null;
          });

          return;
        } else {
          print('Request failed with status: ${userResponse.statusCode}');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Something went wrong.')),
          );
          return;
        }
      } catch (e) {
        print('Error in student_leave_application_form.dart: ${e}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Something went wrong.')),
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
        appBar: AppBar(title: const Text('Leave Application Form')),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: const Color(0xFFFF7F7F),
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: const Center(
                  child: Text(
                    'Enter your leave application details',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      _buildDatePicker('Pick start date of leave', startDate,
                          (date) {
                        setState(() {
                          startDate = date;
                        });
                      }),
                      const SizedBox(height: 16),
                      _buildDatePicker('Pick last date of leave', endDate,
                          (date) => setState(() => endDate = date)),
                      const SizedBox(height: 16),
                      _buildDropdown(
                          'Select your reason for leave',
                          ['Regular', 'Medical', 'Emergency'],
                          leaveCategory, (value) {
                        setState(() {
                          leaveCategory = value;
                          leaveReason = null;
                          supportingDocument = null;
                          supportingVideo = null;
                        });
                      }),
                      if (leaveCategory != null) ...[
                        const SizedBox(height: 16),
                        _buildDropdown(
                            'Select specific reason',
                            reasonData[leaveCategory]!
                                .map((e) => e['reason']!)
                                .toList(),
                            leaveReason, (value) {
                          setState(() {
                            leaveReason = value;
                            supportingDocument = null;
                            supportingVideo = null;
                          });
                        }),
                      ],
                      if (_showOtherReasonField()) ...[
                        const SizedBox(height: 16),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Mention your reason',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 3,
                          onChanged: (value) =>
                              setState(() => otherReason = value),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please provide a reason';
                            }
                            return null;
                          },
                        ),
                      ],
                      if (_showFileUploadFields()) ...[
                        const SizedBox(height: 16),
                        _buildFileUpload(
                            'Supporting Document (PDF) [Maximum 5MB]',
                            supportingDocument,
                            (file) => setState(() => supportingDocument = file),
                            ['pdf']),
                        if (_isEmergencyOrOthers()) ...[
                          const SizedBox(height: 16),
                          _buildFileUpload(
                              'Supporting video from your parents [Maximum 15MB]',
                              supportingVideo,
                              (file) => setState(() => supportingVideo = file),
                              ['mp4']),
                        ],
                      ],
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
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
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ],
                                )
                              : const Text('Apply for Leave',
                                  style: TextStyle(fontSize: 20)),
                          onPressed: _isLoading ? null : _submitForm,
                          style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: const Color(0xFFFF7F7F),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildDatePicker(
      String label, DateTime? selectedDate, Function(DateTime) onDateSelected) {
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
        final DateTime now = DateTime.now();
        final DateTime firstDate =
            label.contains('start') ? now : (startDate ?? now);
        final DateTime lastDate = label.contains('start')
            ? now.add(const Duration(days: 365))
            : (startDate != null
                ? startDate!.add(const Duration(days: 2))
                : now.add(const Duration(days: 367)));

        final pickedDate = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? firstDate,
          firstDate: firstDate,
          lastDate: lastDate,
          selectableDayPredicate:
              label.contains('last') ? _selectableDayPredicate : null,
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

  bool _selectableDayPredicate(DateTime day) {
    if (startDate == null) return true;
    final difference = day.difference(startDate!).inDays;
    return difference >= 0 && difference <= 2;
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

  Widget _buildFileUpload(String label, String? fileName,
      Function(String) onFileSelected, List<String> allowedExtensions) {
    print('FILENAME : $fileName');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: allowedExtensions,
            );

            print('result : $result');

            if (result != null) {
              print('RESULT : $result');
              onFileSelected(result.files.single.path!);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Text('No file chosen'),
                // Text(fileName?.split('/').last ?? 'No file chosen'),
                Text(fileName != null
                    ? fileName.split('/').last
                    : 'No file chosen'),
                const Icon(Icons.upload_file),
              ],
            ),
          ),
        ),
      ],
    );
  }

  bool _showOtherReasonField() {
    return leaveCategory == 'Emergency' && leaveReason == 'Other reasons';
  }

  bool _showFileUploadFields() {
    if (leaveCategory == null || leaveReason == null) return false;
    final selectedReason = reasonData[leaveCategory]!
        .firstWhere((r) => r['reason'] == leaveReason);
    return selectedReason['type'] == 'EMERGENCY' ||
        selectedReason['type'] == 'MEDICAL' ||
        selectedReason['type'] == 'GOVERNMENT' ||
        selectedReason['type'] == 'OTHERS';
  }

  bool _isEmergencyOrOthers() {
    if (leaveCategory == null || leaveReason == null) return false;
    final selectedReason = reasonData[leaveCategory]!
        .firstWhere((r) => r['reason'] == leaveReason);
    return selectedReason['type'] == 'EMERGENCY' ||
        selectedReason['type'] == 'OTHERS';
  }
}
