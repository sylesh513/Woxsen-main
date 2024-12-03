import 'package:flutter/material.dart';

class ObjectiveQuestionWidget extends StatefulWidget {
  final Map<String, dynamic> question;
  final Function(String) onAnswer;

  const ObjectiveQuestionWidget({
    Key? key,
    required this.question,
    required this.onAnswer,
  }) : super(key: key);

  @override
  _ObjectiveQuestionWidgetState createState() =>
      _ObjectiveQuestionWidgetState();
}

class _ObjectiveQuestionWidgetState extends State<ObjectiveQuestionWidget> {
  String? selectedOption;

  @override
  Widget build(BuildContext context) {
    debugPrint('WIDGET QUESTION ${widget.question}');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.question['question'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 8),
            ...buildOptions(),
          ],
        ),
      ),
    );
  }

  List<Widget> buildOptions() {
    return (widget.question['options'] as List<dynamic>).map((option) {
      return RadioListTile<String>(
        title: Text(option.toString()),
        value: option.toString(),
        groupValue: selectedOption,
        onChanged: (value) {
          setState(() {
            selectedOption = value.toString();
          });
          widget.onAnswer(value.toString());
        },
      );
    }).toList();
  }
}
