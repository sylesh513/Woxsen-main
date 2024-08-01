import 'package:woxsen/Values/login_status.dart';

class ListStore {
  String? course;
  Future<void> getCourse() async {
    course = await UserPreferences.getCourse();
  }

  List<String> mbaBaSem1 = [
    'Introduction to Python',
    'Introduction to Marketing Mgmt',
    'Business Statistics',
    'Managerial Economics',
    'Data Insights and Visualization',
    'Accounting for Managers',
    'Managerial Communication',
    'International Seminar',
    'Computer Applications for Business',
  ];
  List<String> mbaFsSem1 = [
    'Introduction of Financial services',
    'Introduction to Marketing Mgmt',
    'Business Statistics',
    'Accounting for Managers',
    'Managerial Communication',
    'Microeconomics',
    'International Seminar',
    'Computer Applications for Business',
  ];
  List<String> mbaGenSem1 = [
    'Introduction to Marketing Mgmt',
    'Business Statistics',
    'Business Strategy',
    'Managerial Economics',
    'Accounting for Managers',
    'Managerial Communication',
    'International Seminar',
    'Computer Applications',
    'Organizational Behavior',
    'Identity & Logical Intelligence',
    'Case Study Writing and Analysis',
  ];
  List<String> mbaBaSem4 = [
    'Social Media Analytics',
    'Neural Networks & Deep Learning',
    'People Analytics',
    'Existential Dialogue',
    'Responsible Leadership',
    'Marketing Analytics',
    'Advanced Digital Marketing',
    'Strategic Marketing',
    'Security Analysis and Portfolio Mgmt',
    'Direct Taxation',
    'Corporate Valuations',
    'Career Readiness for Modern Workplace',
    'Case Study Writing and Analysis',
    'International Seminar',
  ];
  List<String> mbaFsSem4 = [
    'Financial Derivative and risk management (Electives)',
    'Financial reporting and Analysis',
    'Crypto currency and Blockchain (Electives)',
    'Investment banking* (Electives)',
    'Introduction to SQL',
    'Existential Dialogues',
    'Responsible Leadership',
    'ESG Certification',
    'Career Readiness for Modern Workplace',
    'Case Study Writing and Analysis',
    'International Seminar',
  ];
  List<String> mbaGenSem4 = [
    'Existential Dialogues',
    'Responsible Leadership',
    'Customer Relationship Management',
    'Advanced Digital Marketing',
    'Consumer Psychology',
    'Marketing Analytics',
    'Strategic Marketing',
    'Direct Tax',
    'Security Analysis and Portfolio Management',
    'Wealth Management',
    'Corporate Valuations',
    'Project Appraisal and Financing',
    'Project Management with Agile',
    'Operations Research',
    'Supply Chain Management',
    'Pricing and Revenue Management',
    'New Venture Operations',
    'Python programming',
    'Data Visualization',
    'AI in Business',
    'Foundation of Machine Learning with AWS',
  ];
  List<String> bbaAiSem1 = [
    'EconoSphere: Exploring the Microeconomic Universe',
    'Environmental Education & UN SDGs',
    'Introduction to Business Communication and Etiquette',
    'Introduction to the world of A.I.',
    'Theories of Organizational Behaviour',
    'Understanding India, Past, Present and Future',
    'Working with MS Office',
  ];
  List<String> bbaAiSem3 = [
    'Business Law',
    'Organizational Behaviour',
    'Statistical Techniques for Analytics',
    'Entrepreneurship & Innovation with Capstone Project',
    'International Seminar',
    'Advanced Python Programming ',
    'Foundations on Data Analytics ',
    'Introduction to Decision Support Systems',
  ];
  List<String> bbaAiSem5 = [
    'Business Strategy',
    'Dissertation Dissertation (Planning, Literature Review and Proposal)',
    'Existential Dialogue',
    'Application of Metaverse in Business (Mandatory)',
    'Applied Analytics using Python',
    'Python Automation',
  ];
  List<String> bbaDmSem1 = [
    'EconoSphere: Exploring the Microeconomic Universe',
    'Environmental Education & UN SDGs',
    'Introduction to Business Communication and Etiquette',
    'Introduction to the world of A.I.',
    'Theories of Organizational Behaviour',
    'Understanding India, Past, Present and Future',
    'Working with MS Office',
    'Case Study Analysis and Writing - I',
  ];
  List<String> bbaDmSem3 = [
    'Business Law',
    'Organizational Behaviour',
    'Statistical Techniques for Analytics',
    'Entrepreneurship & Innovation with Capstone Project',
    'International Seminar',
    'Introduction to e-Commerce',
    'Introduction to Digital Marketing',
    'Integrated Marketing Communications',
  ];
  List<String> bbaDmSem5 = [
    'Business Strategy',
    'Dissertation Dissertation',
    'Existential Dialogue',
    'Introduction to e-Commerce',
    'Introduction to Digital Marketing',
    'Website Development Strategies',
  ];
  List<String> bbaEdSem1 = [
    'EconoSphere: Exploring the Microeconomic Universe',
    'Environmental Education & UN SDGs',
    'Introduction to Business Communication and Etiquette',
    'Introduction to the world of A.I.',
    'Theories of Organizational Behaviour',
    'Understanding India, Past, Present and Future',
    'Working with MS Office',
    'Case Study Analysis and Writing - I',
  ];
  List<String> bbaEdSem3 = [
    'Business Law',
    'Organizational Behaviour',
    'Statistical Techniques for Analytics',
    'Entrepreneurship & Innovation with Capstone Project',
    'International Seminar',
    'Entrepreneurship Mindset & Intrapreneurship',
  ];
  List<String> bbaEdSem5 = [
    'Business Strategy',
    'Dissertation Dissertation ',
    'Existential Dialogue',
    'Design Thinking',
    'Managing Family Businesses',
    'Intellectual Property Rights',
  ];
  List<String> bbaFsSem1 = [
    'EconoSphere: Exploring the Microeconomic Universe',
    'Environmental Education & UN SDGs',
    'Introduction to Business Communication and Etiquette',
    'Introduction to the world of A.I.',
    'Theories of Organizational Behaviour',
    'Understanding India, Past, Present and Future',
    'Working with MS Office',
    'Case Study Analysis and Writing - I',
  ];
  List<String> bbaFsSem3 = [
    'Business Law',
    'Organizational Behaviour',
    'Statistical Techniques for Analytics',
    'Entrepreneurship & Innovation with Capstone Project',
    'International Seminar',
    'Introduction of Financial Services',
    'Corporate Finance',
    'Fundamentals of Banking and Insurance',
    'managing Family Businesses',
    'Rural and social entrepreneurship',
  ];
  List<String> bbaFsSem5 = [
    'Business Strategy',
    'Dissertation Dissertation (Planning, Literature Review and Proposal)',
    'Existential Dialogue',
    'Financial Markets & Institutions',
    'Security Analysis and Portfolio Management',
    'Entrepreneurial Finance',
  ];
  List<String> bbaGenSem1 = [
    'EconoSphere: Exploring the Microeconomic Universe',
    'Environmental Education & UN SDGs',
    'Introduction to Business Communication and Etiquette',
    'Introduction to the world of A.I.',
    'Theories of Organizational Behaviour',
    'Understanding India, Past, Present and Future',
    'Working with MS Office',
  ];
  List<String> bbaGenSem3 = [
    'Business Law',
    'Organizational Behaviour',
    'Statistical Techniques for Analytics',
    'Entrepreneurship & Innovation with Capstone Project',
    'International Seminar',
    'Organizational Development and Change Management',
    'Talent Acquisition & Retention',
    ' Learning and Development',
    'Leadership and Managing Diversity at Work',
    'International HRM and Cross-cultural Management',
    'Mindfulness at Workplace ',
  ];
  List<String> bbaGenSem5 = [
    'Business Strategy',
    'Dissertation Dissertation (Planning, Literature Review and Proposal)',
    'Existential Dialogue',
  ];
  List<String> bbaIntSem1 = [
    'EconoSphere: Exploring the Microeconomic Universe',
    'Environmental Education & UN SDGs',
    'Introduction to Business Communication and Etiquette',
    'Introduction to the world of A.I.',
    'Theories of Organizational Behaviour',
    'Understanding India, Past, Present and Future',
    'Working with MS Office',
  ];

  List<String> sectionsList = ['Tigers', 'Panthers', 'Leopards', 'Rhinos'];
  List<String> typesList = ['Course Outline', 'Time Table', 'Assignment'];
  List<String> mbaSpecializations = ['MBA GEN', 'MBA BA', 'MBA FS'];
  List<String> bbaSpecializations = [
    'BBA DSAI',
    'BBA ECDM',
    'BBA ED',
    'BBA FS',
    'BBA INT',
  ];
  List<String> btechSpecializations = [
    'CSE DS/AI',
    'Blockchain and Cybersecurity',
    'CSE Core',
  ];
  List<String> bdesSpecializations = [
    'Fashion Design',
    'Interior Design',
    'Industrial Design',
    'Communication Design',
  ];
  List<String> humanSpecializations = [
    'English',
    'Economics',
    'Psychology',
    'Practical Science',
    'Journalism',
    'Business Studies',
    'History',
    'Sociology and Anthropology',
  ];
  List<String> lawSpecializations = [
    'BA LLB',
    'BBA LLB',
  ];
  List<String> sciSpecializations = [
    'Applied Maths',
    'Physics',
    'Chemistry',
    'Biotechnology',
    'Computer Science',
    'Data Science and AI'
  ];
  List<String> subjectsList = [];
  List<String> specList = [];
  List<String> semestersList = [
    'Semester 1',
    'Semester 2',
    'Semester 3',
    'Semester 4',
    'Semester 5',
    'Semester 6',
    'Semester 7',
    'Semester 8'
  ];
  final List<String> specWithSec = ['BBA ECDM', 'BBA FS', 'MBA GEN'];

  final List<String> courses = [
    'B.Tech',
    'B.Des',
    'B.Arch',
    'B.B.A',
    'M.B.A',
    'B.A',
    'Law',
    'Sciences',
  ];
}
