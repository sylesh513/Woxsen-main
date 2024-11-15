import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:woxsen/providers/feedback_from_provider.dart';

class ClassroomEvaluationFormSectionSix extends StatefulWidget {
  const ClassroomEvaluationFormSectionSix({Key? key}) : super(key: key);

  @override
  State<ClassroomEvaluationFormSectionSix> createState() =>
      _EvaluationFormSection6State();
}

class _EvaluationFormSection6State
    extends State<ClassroomEvaluationFormSectionSix> {
  late TextEditingController _effectiveController;
  late TextEditingController _improveController;
  late TextEditingController _commentsController;
  String? _satisfactionResponse;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<FeedbackFormProvider>(context, listen: false);
    _satisfactionResponse = provider.getSectionValue('section6', 'q1');
    _effectiveController =
        TextEditingController(text: provider.getSectionValue('section6', 'q2'));
    _improveController =
        TextEditingController(text: provider.getSectionValue('section6', 'q3'));
    _commentsController =
        TextEditingController(text: provider.getSectionValue('section6', 'q4'));
  }

  @override
  void dispose() {
    _effectiveController.dispose();
    _improveController.dispose();
    _commentsController.dispose();
    super.dispose();
  }

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
                    'Section 6: Overall Evaluation',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSatisfactionQuestion(provider),
                  const SizedBox(height: 24),
                  _buildTextArea(
                    '2. What Did You Find Most Effective About The Instructor\'s Teaching?',
                    _effectiveController,
                    provider,
                    'section6',
                    'q2',
                  ),
                  const SizedBox(height: 24),
                  _buildTextArea(
                    '3. How Can The Instructor Improve Their Teaching Methods?',
                    _improveController,
                    provider,
                    'section6',
                    'q3',
                  ),
                  const SizedBox(height: 24),
                  _buildTextArea(
                    '4. Additional Comments',
                    _commentsController,
                    provider,
                    'section6',
                    'q4',
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        print('feedback data  ${provider.sections}');
                        // Handle form submission
                        provider.updateSection(
                            'section6', 'q1', _satisfactionResponse ?? '');
                        provider.updateSection(
                            'section6', 'q2', _effectiveController.text);
                        provider.updateSection(
                            'section6', 'q3', _improveController.text);
                        provider.updateSection(
                            'section6', 'q4', _commentsController.text);
                        // Navigate to the next screen or show a success message
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF8B98),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Submit Feedback',
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

  Widget _buildSatisfactionQuestion(FeedbackFormProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '1. Overall, The Quality Of Instructions in This Course Was Satisfactory',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        _buildRadioOption('Strongly Agree', provider),
        _buildRadioOption('Agree', provider),
        _buildRadioOption('Neutral', provider),
        _buildRadioOption('Disagree', provider),
        _buildRadioOption('Strongly Disagree', provider),
      ],
    );
  }

  Widget _buildRadioOption(String option, FeedbackFormProvider provider) {
    return RadioListTile<String>(
      title: Text(
        option,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.grey,
        ),
      ),
      value: option,
      groupValue: _satisfactionResponse,
      onChanged: (value) {
        setState(() => _satisfactionResponse = value);
        provider.updateSection('section6', 'q1', value ?? '');
      },
      contentPadding: EdgeInsets.zero,
      activeColor: const Color(0xFFFF8B98),
    );
  }

  Widget _buildTextArea(String label, TextEditingController controller,
      FeedbackFormProvider provider, String section, String question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: 4,
          onChanged: (value) {
            provider.updateSection(section, question, value);
          },
          decoration: InputDecoration(
            hintText: 'Type Your Answer...',
            hintStyle: const TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFFF8B98)),
            ),
          ),
        ),
      ],
    );
  }
}
