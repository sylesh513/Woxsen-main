import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:woxsen/Pages/classroom-evaluaton-form-pages/classroom_evaluation_form_section_two.dart';
import 'package:woxsen/providers/feedback_from_provider.dart';

class ClassroomEvaluationFormSectionOne extends StatefulWidget {
  const ClassroomEvaluationFormSectionOne({Key? key}) : super(key: key);

  @override
  State<ClassroomEvaluationFormSectionOne> createState() =>
      _EvaluationFormState();
}

class _EvaluationFormState extends State<ClassroomEvaluationFormSectionOne> {
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
                    'Section 1: Faculty Preparedness',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildQuestionSection(
                    '1. The Instructor Was Well-Prepared For Class',
                    provider.sections['section1']!['q1'],
                    // (value) => setState(
                    //     () => provider.updateSection('section1', 'q1', value!)),
                    (value) => provider.updateSection('section1', 'q1', value!),
                  ),
                  const SizedBox(height: 24),
                  _buildQuestionSection(
                    '2. The Instructions Material Were Well Organized And Relevant',
                    provider.sections['section1']!['q2'],

                    // (value) => setState(
                    //     () => provider.updateSection('section2', 'q2', value!)),
                    (value) => provider.updateSection('section1', 'q2', value!),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (provider.validateSection('section1')) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ClassroomEvaluationFormSectionTwo()));
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
                        'Go To Section 2',
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
    selectedValue,
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