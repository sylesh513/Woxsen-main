import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:woxsen/Pages/classroom-evaluaton-form-pages/classroom_evaluation_form_section_five.dart';
import 'package:woxsen/providers/feedback_from_provider.dart';

class ClassroomEvaluationFormSectionFour extends StatefulWidget {
  const ClassroomEvaluationFormSectionFour({Key? key}) : super(key: key);

  @override
  State<ClassroomEvaluationFormSectionFour> createState() =>
      _EvaluationFormState();
}

class _EvaluationFormState extends State<ClassroomEvaluationFormSectionFour> {
  String? _question1Response;
  String? _question2Response;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FeedbackFormProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Give Feedback',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: const Color(0xFFFF8B98),
              child: const Column(
                children: [
                  Text(
                    'Classroom Instruction',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Quality Evaluation Form',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Section 4 : Content Delivery and Engagement',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildQuestionSection(
                    '1. The content was presented in a way that kept students engaged and connected',
                    provider.sections['section4']!['q1'],
                    (value) => provider.updateSection('section4', 'q1', value!),
                    // (value) => setState(() => _question1Response = value),
                  ),
                  const SizedBox(height: 24),
                  _buildQuestionSection(
                    '2. The Instructor used varied teaching methods to engage students',
                    provider.sections['section4']!['q2'],
                    (value) => provider.updateSection('section4', 'q2', value!),
                    // (value) => setState(() => _question2Response = value),
                  ),
                  const SizedBox(height: 24),
                  _buildQuestionSection(
                    '3. The Instructor Encouraged student participation and questions',
                    provider.sections['section4']!['q3'],
                    (value) => provider.updateSection('section4', 'q3', value!),
                    // (value) => setState(() => _question2Response = value),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (provider.validateSection('section4')) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ClassroomEvaluationFormSectionFive()));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Please answer all questions before proceeding.'),
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
                        'Go To Section 5',
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

  Widget _buildQuestionSection(
    String question,
    String? selectedValue,
    void Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        _buildRadioOption('Strongly Agree', selectedValue, onChanged),
        _buildRadioOption('Agree', selectedValue, onChanged),
        _buildRadioOption('Neutral', selectedValue, onChanged),
        _buildRadioOption('Disagree', selectedValue, onChanged),
        _buildRadioOption('Strongly Disagree', selectedValue, onChanged),
      ],
    );
  }

  Widget _buildRadioOption(
    String option,
    String? selectedValue,
    void Function(String?) onChanged,
  ) {
    return RadioListTile<String>(
      title: Text(
        option,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.grey,
        ),
      ),
      value: option,
      groupValue: selectedValue,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
      activeColor: const Color(0xFFFF8B98),
    );
  }
}
