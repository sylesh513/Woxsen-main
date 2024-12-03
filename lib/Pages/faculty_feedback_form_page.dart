// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:woxsen/Values/subjects_list.dart';
// import 'package:woxsen/providers/feedback_from_provider.dart';
// import 'package:http/http.dart' as http;
// import 'package:woxsen/widgets/faculty_feedback/objective_questions_widget.dart';
// import 'package:woxsen/widgets/faculty_feedback/subjective_questions_widget.dart';

// class FacultyFeedbackForm extends StatefulWidget {
//   const FacultyFeedbackForm({Key? key}) : super(key: key);

//   @override
//   State<FacultyFeedbackForm> createState() => _FacultyFeedbackForm();
// }

// class _FacultyFeedbackForm extends State<FacultyFeedbackForm> {
//   ListStore store = ListStore();
//   bool isLoading = true;

//   Map<String, dynamic> feedbackData = {
//     'heading': '',
//     'objective_questions': <Map<String, dynamic>>[],
//     'subjective_questions': <Map<String, dynamic>>[]
//   };

//   @override
//   void initState() {
//     super.initState();
//     getFeedbackQuestions();
//   }

//   void submitFeedback() {
//     debugPrint('Submit feedback called');
//     final provider = Provider.of<FeedbackFormProvider>(context, listen: false);

//     debugPrint('Feedback form : ${provider.answers}');
//     debugPrint('Objective form : ${provider.answers['objective_answers']}');
//     debugPrint('Subjective form : ${provider.answers['subjective_answers']}');

//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Feedback form'),
//         content: const Text('Thank you for your feedback!'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> getFeedbackQuestions() async {
//     // final String apiUrl = '${store.woxUrl}/api/feedback_questions';
//     const String apiUrl = 'http://10.7.0.23:4000/api/feedback_questions';

//     try {
//       final response =
//           await http.get(Uri.parse(apiUrl), headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       });

//       if (response.statusCode == 200) {
//         final responseData = json.decode(response.body);
//         print('Response Data: $responseData');
//         setState(() {
//           feedbackData = responseData;
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   List<Widget> buildObjectiveQuestions() {
//     final objectiveAnswers = Provider.of<FeedbackFormProvider>(context)
//         .answers['objective_answers'] as Map<String, dynamic>;

//     final feed = (feedbackData['objective_questions'] as List<dynamic>)
//         .map((question) => ObjectiveQuestionWidget(
//               question: question,
//               onAnswer: (answer) {
//                 final provider =
//                     Provider.of<FeedbackFormProvider>(context, listen: false);

//                 debugPrint(
//                     'PROVIDDER DATA ${provider.answers['objective_answers']}');

//                 setState(() {
//                   provider.updateAnswers(question['id'], answer);
//                   provider.answers['objective_answers']![question['id']] =
//                       answer;
//                 });
//                 debugPrint('OBJECTIVE ANSWERS DATA ${objectiveAnswers}');
//               },
//             ))
//         .toList();

//     print('Feed Objective : ${feed}');

//     return feed;
//   }

//   List<Widget> buildSubjectiveQuestions() {
//     final subjectiveAnswers = Provider.of<FeedbackFormProvider>(context)
//         .answers['subjective_answers'] as Map<String, dynamic>;

//     return (feedbackData['subjective_questions'] as List<dynamic>)
//         .map((question) => SubjectiveQuestionWidget(
//               question: question,
//               onAnswer: (answer) {
//                 setState(() {
//                   subjectiveAnswers[question['id']] = answer;
//                 });
//               },
//             ))
//         .toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Faculty Feedback Here'),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 16),
//             ...buildObjectiveQuestions(),
//             const SizedBox(height: 16),
//             ...buildSubjectiveQuestions(),
//             const SizedBox(height: 32),
//             Center(
//               child: ElevatedButton(
//                 onPressed: submitFeedback,
//                 child: const Text('Submit Feedback'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// Updated

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:woxsen/Values/subjects_list.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:woxsen/providers/feedback_from_provider.dart';
import 'package:woxsen/utils/colors.dart';

class FacultyFeedbackForm extends StatefulWidget {
  const FacultyFeedbackForm({Key? key}) : super(key: key);

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

  Future<void> getFeedbackQuestions() async {
    // final String apiUrl = '${store.woxUrl}/api/feedback_questions';
    const String apiUrl = 'http://10.7.0.23:4000/api/feedback_questions';

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

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FeedbackFormProvider>(context);
    debugPrint('Objective Answers : ${provider.objectiveAnswers}');
    debugPrint('Objective Answers : ${provider.subjectiveAnswers}');
    debugPrint('FeedbackData : $feedbackData');

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
              5 - index,
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

  // Widget _buildSubmitButton(
  //     BuildContext context, FeedbackFormProvider provider) {
  //   return SizedBox(
  //     width: double.infinity,
  //     child: ElevatedButton(
  //       onPressed: () {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text('Feedback submitted!')),
  //         );
  //       },
  //       style: ElevatedButton.styleFrom(
  //         backgroundColor: _isLoading ? AppColors.disabled : AppColors.primary,
  //         padding: const EdgeInsets.symmetric(vertical: 16),
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(8),
  //         ),
  //       ),
  //       child: Text(
  //         _isLoading ? 'Submitting...' : 'Submit Feedback',
  //         style: TextStyle(
  //           fontSize: 18,
  //           color: _isLoading ? Colors.grey : Colors.white,
  //         ),
  //       ),
  //     ),
  //   );
  // }

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
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Feedback submitted successfully!')),
            );
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
