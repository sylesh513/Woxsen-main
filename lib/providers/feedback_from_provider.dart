import 'package:flutter/material.dart';

class FeedbackFormProvider with ChangeNotifier {
  String? selectedDegree;
  String? selectedSemester;
  String? selectedCourse;
  String? selectedFaculty;

  Map<String, int> objectiveAnswers = {};
  Map<String, String> subjectiveAnswers = {};

  void updateObjectiveAnswer(String questionId, int value) {
    objectiveAnswers[questionId] = value;
    notifyListeners();
  }

  void updateSubjectiveAnswer(String questionId, String value) {
    subjectiveAnswers[questionId] = value;
    notifyListeners();
  }

  /// This function notifies the listeners.
  Map<String, Map<String, String>> sections = {
    'section1': {'q1': '', 'q2': ''},
    'section2': {'q1': '', 'q2': ''},
    'section3': {'q1': '', 'q2': ''},
    'section4': {'q1': '', 'q2': '', 'q3': ''},
    'section5': {'q1': '', 'q2': ''},
    'section6': {'q1': '', 'q2': '', 'q3': '', 'q4': ''},
  };

  Map<String, Map<String, dynamic>> answers = {
    'subjective_answers': {},
    'objective_answers': {}
  };

  void updateDegree(String? value) {
    selectedDegree = value;
    notifyListeners();
  }

  void updateSemester(String? value) {
    selectedSemester = value;
    notifyListeners();
  }

  void updateCourse(String? value) {
    selectedCourse = value;
    notifyListeners();
  }

  void updateFaculty(String? value) {
    selectedFaculty = value;
    notifyListeners();
  }

  void updateSection(String section, String question, String answer) {
    if (sections.containsKey(section)) {
      sections[section]![question] = answer;
      notifyListeners();
    }
  }

  String updateAnswers(String id, String answer) {
    return answers['objective_answers']![id] = answer.toString();
    // notifyListeners();
  }

  String getSectionValue(String section, String question) {
    return sections[section]?[question] ?? '';
  }

  bool validateSection(String section) {
    return sections[section]!
        .values
        .every((value) => value != null && value!.isNotEmpty);
  }

  bool validateForm() {
    return [selectedDegree, selectedSemester, selectedCourse, selectedFaculty]
        .every((value) => value != null && value!.isNotEmpty);
  }

  void clearData() {
    selectedCourse = null;
    selectedDegree = null;
    selectedFaculty = null;
    selectedSemester = null;
    sections = {
      'section1': {'q1': '', 'q2': ''},
      'section2': {'q1': '', 'q2': ''},
      'section3': {'q1': '', 'q2': ''},
      'section4': {'q1': '', 'q2': '', 'q3': ''},
      'section5': {'q1': '', 'q2': ''},
      'section6': {'q1': '', 'q2': '', 'q3': '', 'q4': ''},
    };
    notifyListeners();
  }
}
