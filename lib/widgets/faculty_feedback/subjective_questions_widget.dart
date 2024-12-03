import 'package:flutter/material.dart';

class SubjectiveQuestionWidget extends StatelessWidget {
  final Map<String, dynamic> question;
  final Function(String) onAnswer;

  const SubjectiveQuestionWidget({
    Key? key,
    required this.question,
    required this.onAnswer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('Subjective Answer : $question}');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question['question'],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your answer here',
              ),
              onChanged: onAnswer,
            ),
          ],
        ),
      ),
    );
  }
}
