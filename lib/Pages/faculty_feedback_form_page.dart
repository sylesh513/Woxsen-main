import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:woxsen/Values/subjects_list.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:woxsen/providers/feedback_from_provider.dart';
import 'package:woxsen/utils/colors.dart';

class FacultyFeedbackForm extends StatefulWidget {
  final String faculty_name;
  final String subject;
  final String semester;
  final String course;
  final String email;

  const FacultyFeedbackForm({
    Key? key,
    required this.faculty_name,
    required this.subject,
    required this.semester,
    required this.course,
    required this.email,
  }) : super(key: key);

  @override
  State<FacultyFeedbackForm> createState() => _FacultyFeedbackForm();
}

class _FacultyFeedbackForm extends State<FacultyFeedbackForm> {
  ListStore store = ListStore();
  bool _isLoading = true;

  Map<String, dynamic> feedbackData = {
    'heading': '',
    'objective_questions': <Map<String, dynamic>>[],
    'subjective_questions': <Map<String, dynamic>>[]
  };

  // final String apiUrl = '${store.woxUrl}/api/sub_as_list';

  Future<void> getFeedbackQuestions() async {
    final String apiUrl = '${store.woxUrl}/api/feedback_questions';
    // const String apiUrl = 'http://10.7.0.23:4000/api/feedback_questions';

    try {
      final response =
          await http.get(Uri.parse(apiUrl), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          feedbackData = responseData;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getFeedbackQuestions();
  }

  Future<void> submitFeedbackForm(FeedbackFormProvider provider) async {
    setState(() {
      _isLoading = true;
    });

    final String apiUrl = '${store.woxUrl}/api/faculty_feedback';
    // const String apiUrl = 'http://10.7.0.23:4000/api/faculty_feedback';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'objective_answers': jsonEncode(provider.objectiveAnswers),
          'subjective_answers': jsonEncode(provider.subjectiveAnswers),
          'rator_email_id': '${widget.email}',
          'course': '${widget.course}',
          'semester': '${widget.semester}',
          'faculty_name': '${widget.faculty_name}',
          'subject': '${widget.subject}',
        }),
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Feedback submitted successfully!')),
        );
        // Navigator.of(context, rootNavigator: true)
        //     .pop();
        Navigator.pushNamed(context, '/Academics'); // Return to previous screen
      } else {
        throw Exception('Failed to submit feedback');
      }
    } catch (e) {
      debugPrint('ERROR IN FEEDBACK FORM : $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting feedback: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // final provider = Provider.of<FeedbackFormProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF7B7B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Give Feedback',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: _isLoading
            ? const Text('Loading questions...')
            : Consumer<FeedbackFormProvider>(
                builder: (context, provider, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Objective Questions Here
                      ...objectiveQuestionsList(),

                      // Objective Subjective Here
                      ...subjectiveQuestionsList(),

                      const SizedBox(height: 32),
                      _buildSubmitButton(context, provider),
                    ],
                  );
                },
              ),
      ),
    );
  }

  List<Widget> objectiveQuestionsList() {
    return (feedbackData['objective_questions'] as List<dynamic>)
        .map((question) {
      return Column(children: [
        _buildObjectiveQuestion(
          context,
          question['question'],
          question['id'],
          Provider.of<FeedbackFormProvider>(context),
        ),
        const SizedBox(height: 28),
      ]);
    }).toList();
  }

  List<Widget> subjectiveQuestionsList() {
    return (feedbackData['subjective_questions'] as List<dynamic>)
        .map((question) {
      return Column(children: [
        _buildSubjectiveQuestion(
          context,
          question['question'],
          question['id'],
          Provider.of<FeedbackFormProvider>(context),
        ),
        const SizedBox(height: 28),
      ]);
    }).toList();
  }

  Widget _buildObjectiveQuestion(
    BuildContext context,
    String question,
    int questionId,
    FeedbackFormProvider provider,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$questionId. $question',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(5, (index) {
            return _buildRadioOption(
              context,
              1 + index,
              questionId.toString(),
              provider,
            );
          }),
        ),
      ],
    );
  }

  Widget _buildRadioOption(
    BuildContext context,
    int value,
    String questionId,
    FeedbackFormProvider provider,
  ) {
    return InkWell(
      onTap: () => provider.updateObjectiveAnswer(questionId, value),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: provider.objectiveAnswers[questionId]?.toString() ==
                    value.toString()
                ? AppColors.primary
                : Colors.grey,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            value.toString(),
            style: TextStyle(
              color: provider.objectiveAnswers[questionId] == value
                  ? const Color(0xFFFF7B7B)
                  : Colors.grey,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubjectiveQuestion(
    BuildContext context,
    String question,
    int questionId,
    FeedbackFormProvider provider,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${feedbackData['objective_questions'].length + questionId}. $question} ',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          onChanged: (value) =>
              provider.updateSubjectiveAnswer(questionId.toString(), value),
          decoration: InputDecoration(
            hintText: 'Type Your Answer...',
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          maxLines: 4,
        ),
      ],
    );
  }

  Widget _buildSubmitButton(
      BuildContext context, FeedbackFormProvider provider) {
    debugPrint('Submitting feedback');
    bool isFormComplete() {
      bool objectiveComplete = feedbackData['objective_questions'].every(
          (q) => provider.objectiveAnswers.containsKey(q['id'].toString()));

      bool subjectiveComplete = feedbackData['subjective_questions'].every(
          (q) =>
              provider.subjectiveAnswers.containsKey(q['id'].toString()) &&
              provider.subjectiveAnswers[q['id'].toString()]
                      ?.trim()
                      .isNotEmpty ==
                  true);

      return objectiveComplete && subjectiveComplete;
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (isFormComplete()) {
            submitFeedbackForm(provider);
          } else {
            AlertDialog(
              title: const Text('Please fill all the fields.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
            return;
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _isLoading ? AppColors.disabled : AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          _isLoading ? 'Submitting...' : 'Submit Feedback',
          style: TextStyle(
            fontSize: 18,
            color: _isLoading ? Colors.grey : Colors.white,
          ),
        ),
      ),
    );
  }
}
