import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:woxsen/Pages/classroom-evaluaton-form-pages/classroom_evaluation_form_section_one.dart';
import 'package:woxsen/providers/feedback_from_provider.dart';

class FacultyFeedback extends StatelessWidget {
  const FacultyFeedback({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FeedbackFormProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Faculty Feedback',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              color: const Color(0xFFFF8B98),
              child: const Text(
                'Select The Details Below\nTo Give Feedback',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildDropdown(
                    hint: 'Select School',
                    items: ['SOB', 'SOT', 'SOS'],
                    onChanged: (value) => context
                        .read<FeedbackFormProvider>()
                        .updateDegree(value),
                    value: context.watch<FeedbackFormProvider>().selectedDegree,
                  ),
                  const SizedBox(height: 16),
                  _buildDropdown(
                    hint: 'Select Semester',
                    items: [
                      '1st',
                      '2nd',
                      '3rd',
                      '4th',
                      '5th',
                      '6th',
                      '7th',
                      '8th'
                    ],
                    onChanged: (value) => context
                        .read<FeedbackFormProvider>()
                        .updateSemester(value),
                    value:
                        context.watch<FeedbackFormProvider>().selectedSemester,
                  ),
                  const SizedBox(height: 16),
                  _buildDropdown(
                    hint: 'Select Course Name',
                    items: ['Mathematics', 'Physics', 'Computer Science'],
                    onChanged: (value) => context
                        .read<FeedbackFormProvider>()
                        .updateCourse(value),
                    value: context.watch<FeedbackFormProvider>().selectedCourse,
                  ),
                  const SizedBox(height: 16),
                  _buildDropdown(
                    hint: 'Select Faculty Name',
                    items: ['Dr. Smith', 'Dr. Johnson', 'Dr. Williams'],
                    onChanged: (value) => context
                        .read<FeedbackFormProvider>()
                        .updateFaculty(value),
                    value:
                        context.watch<FeedbackFormProvider>().selectedFaculty,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (provider.validateForm()) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ClassroomEvaluationFormSectionOne()));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please select all the fields.'),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF8B98),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Next',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
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

  Widget _buildDropdown({
    required String hint,
    required List<String> items,
    required void Function(String?) onChanged,
    String? value,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        hint: Text(hint),
        isExpanded: true,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
        items: items
            .map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(item),
                ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
