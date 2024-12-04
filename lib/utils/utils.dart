import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

Future<dynamic> loadingOnScreen(BuildContext context) {
  return showDialog(
    barrierColor: Colors.black.withOpacity(0.5),
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return SizedBox(
        height: 100,
        width: 100,
        child: Center(
          child: SpinKitSpinningLines(
            color: Colors.red.shade800,
            size: 70.0,
          ),
        ),
      );
    },
  );
}

Future<void> showAlertDialog(BuildContext context, String message,
    [String buttonText = 'OK']) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(buttonText),
          ),
        ],
      );
    },
  );
}

Map<String, dynamic> convertFeedbackToNumerical(
    Map<String, dynamic> feedbackData) {
  Map<String, int> ratingMap = {
    'Strongly Agree': 4,
    'Agree': 3,
    'Neutral': 0,
    'Disagree': 2,
    'Strongly Disagree': 1
  };

  Map<String, dynamic> convertedData = {};

  feedbackData.forEach((section, questions) {
    if (questions is Map) {
      convertedData[section] = Map.fromEntries(
        questions.entries.map((entry) {
          var value = entry.value;
          if (ratingMap.containsKey(value)) {
            return MapEntry(entry.key, ratingMap[value]);
          }
          return MapEntry(entry.key, value);
        }),
      );
    }
  });

  return convertedData;
}

String formatDate(String dateStr) {
  DateTime dateTime = DateTime.parse(dateStr);
  DateFormat formatter = DateFormat('d MMM yyyy');
  String formattedDate = formatter.format(dateTime);

  String day = DateFormat('d').format(dateTime);
  String suffix = 'th';
  if (day.endsWith('1') && !day.endsWith('11')) {
    suffix = 'st';
  } else if (day.endsWith('2') && !day.endsWith('12')) {
    suffix = 'nd';
  } else if (day.endsWith('3') && !day.endsWith('13')) {
    suffix = 'rd';
  }

  return day + suffix + formattedDate.substring(day.length);
}
