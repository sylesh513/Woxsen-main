import 'package:woxsen/Values/login_status.dart';

class ListStore {
  String? course;
  bool isFaculty = false;

  // get woxUrl => "http://52.20.1.249:5000";
  get woxUrl => "http://10.7.0.23:8080";
  // get woxUrl => "http://10.106.13.71:8080";

  get jobsUrl => "http://10.106.16.71:8000"; // 100
  Future<void> getCourse() async {
    course = await UserPreferences.getCourse();
    isFaculty = await UserPreferences.getRole() == 'faculty';
  }

  String? jobId;

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
    'Theories of Organizational Behavior',
    'Understanding India, Past, Present and Future',
    'Working with MS Office',
  ];
  List<String> bbaAiSem3 = [
    'Business SOL',
    'Organizational Behavior',
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
    'Theories of Organizational Behavior',
    'Understanding India, Past, Present and Future',
    'Working with MS Office',
    'Case Study Analysis and Writing - I',
  ];
  List<String> bbaDmSem3 = [
    'Business SOL',
    'Organizational Behavior',
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
    'Theories of Organizational Behavior',
    'Understanding India, Past, Present and Future',
    'Working with MS Office',
    'Case Study Analysis and Writing - I',
  ];
  List<String> bbaEdSem3 = [
    'Business SOL',
    'Organizational Behavior',
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
    'Theories of Organizational Behavior',
    'Understanding India, Past, Present and Future',
    'Working with MS Office',
    'Case Study Analysis and Writing - I',
  ];
  List<String> bbaFsSem3 = [
    'Business SOL',
    'Organizational Behavior',
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
    'Theories of Organizational Behavior',
    'Understanding India, Past, Present and Future',
    'Working with MS Office',
  ];
  List<String> bbaGenSem3 = [
    'Business SOL',
    'Organizational Behavior',
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
    'Theories of Organizational Behavior',
    'Understanding India, Past, Present and Future',
    'Working with MS Office',
  ];

  // SOAP SEMESTERS SUBJECTS LISTS
  List<String> soapsem1 = [
    'Architecture Design 1',
    'Architectural history Theory and Criticism II',
    'Building material and Construction I',
    'Design communication',
    'Theory of Structure I',
    'Digital Skills and & Design',
    'Architectural Design Graphics I',
    'Reflecting self'
  ];

  List<String> soapsem2 = [
    'Architectural Design II',
    'Architecture History Theory & Criticism II',
    'Building Materials & Construction II',
    'Landforms - Surveying & Levelling',
    'Theory of Structure II',
    'Digital Skills & Design II',
    'Architectural Design Graphics II',
    'Responsible Leadership',
    'Foundations of Identity and Communication Skills'
  ];

  List<String> soapsem3 = [
    'Architectural Design III',
    'Architecture History Theory & Criticism III',
    'Building Materials & Construction III'
        'Building Services & Sustainability - I',
    'Theory of Structure III',
    'Digital Skills & Design III',
    'Existential Dialogues',
    'Elective - I - Culture, Crafts & Spaces',
    'Elective - I - Product & Space Design',
    'Elective - I - Arts, Architecture and Media',
    'Elective - I - Sustainability & Urbanism',
    'Related Study Program II',
    'Advanced Communication & Logical Thinking'
  ];

  List<String> soapsem4 = [
    'Architectural Design IV',
    'Built Environment Analysis I',
    'Building Materials & Construction IV',
    'Building Services & Sustainability  II',
    'Theory of Structure IV',
    'Digital Skills & Design IV',
    'Elective - II - Culture, Crafts & Spaces',
    'Elective - II - Product & Space Design',
    'Elective - II - Arts, Architecture and Media',
    'Elective - II - Sustainability & Urbanism',
    'Site Training II',
    'Personality Development Skills'
  ];

  List<String> soapsem5 = [
    'Architectural Design - IV',
    'Building Construction - V',
    'Design of Structures - II',
    'History of Architecture - IV',
    'Computer Applications - II',
    'Building Estimation, Costing and Specifications',
    'ELECTIVE - I',
    'Workshop – Vernacular Architecture',
    'Workshop – Universal Design',
    'Social Skills and Career Readiness Skills'
  ];

  List<String> soapsem6 = [
    'Architectural Design -V',
    'Working Drawing and Details',
    'Acoustics and Illumination',
    'Building Construction Management',
    'Human Settlements and Town Planning',
    'Environment Responsive Design',
    'ELECTIVE - II',
    'Theory of Design and Architecture',
    'Low- Cost Building Techniques',
    'Architectural Heritage and Conservation',
    'Career readiness for Modern Workspace'
  ];

  List<String> soapsem7 = [
    'Architectural Design -VI',
    'Advanced Services',
    'Advanced Building Construction and Materials',
    'ELECTIVE - III',
    'Furniture and Product Design',
    'Green Buildings',
    'Landscape Architecture',
    'Open Elective  I',
    'Personality Development',
    'Leadership and Logical Skills'
  ];

  List<String> soapsem8 = [
    'Architectural Design -VII',
    'Pre- Thesis Seminar',
    'Professional Practice and Building Codes',
    'ELECTIVE - IV',
    'Building Information Modeling',
    'Tall Buildings',
    'Parametric Architecture',
    'ELECTIVE - V',
    'Architectural Photography',
    'Architecture and Media',
    'Set Design',
  ];

  List<String> soapsem9 = ['Practical Training'];

  List<String> soapsem10 = [
    'Design Project',
    'ELECTIVE - VI - Valuation',
    'ELECTIVE - VI - IPR',
    'ELECTIVE - VI - Entrepreneurship',
    'ELECTIVE - VII - Disaster Resistant Architecture',
    'ELECTIVE - VII - Intelligent Buildings',
    'ELECTIVE - VII - Traffic Awareness'
  ];

  List<String> sectionsList = [
    'Tigers',
    'Panthers',
    'Leopards',
    'Rhinos',
    'Whales'
  ];
  List<String> typesList = [
    'Course Outline',
    'Time Table',
    'Assignment',
  ];
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
  List<String> SOLSpecializations = [
    "N/A",
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
    'SOL',
    'Sciences',
  ];
  final List<String> schools = [
    'School of Technology',
    'School of Architecture and Planning',
    'School of Business',
    'School of Law',
    'School of Sciences',
    'School of Arts and Design',
    'School of Liberal Arts and Humanities'
  ];
  final List<String> SOLSem1 = [
    'Business English and Communication',
    'Critical Legal Thinking ',
    'Management and Leadership Fundamentals',
    'Jurisprudence',
    'Marketing Strategy and Concepts',
    'Basics of Financial Accounting',
    'Reflecting Self',
  ];
  final List<String> SOLSem2 = [
    'Human Capital Management',
    'SOL of Torts and Consumer Protection and MV Act',
    'General Principles of Contract ',
    'International Capstone Project',
    'Legal Research Methodology ',
    'Legal Internship',
    'Entrepreneurship and Innovation',
    'Principles of Economics',
    'Foundations of Identity and Communication Skills'
  ];
  final List<String> SOLSem3 = [
    'Human rights and Humanitarian SOL',
    'Strategy for Companies in Industries and Markets',
    'Spanish Language',
    'Family SOL 1',
    'Special Contract (Agency, Partnership and NI Act)',
    'Responsible Leadership',
    'Legal History of India and European union',
    'Advanced Communication Skills',
  ];
  final List<String> SOLSem4 = [
    'Constitutional SOL I',
    'Bharatiya Nyaya Sanhita 2023',
    'Company SOL',
    'Family SOL II',
    'Legislative Analysis Project ',
    'Legal Internship',
    'Business Incubator and Legal Services',
    'Basics of Computer Applications',
    'Personality Development Skills',
  ];
  final List<String> SOLSem5 = [
    'Constitutional SOL II',
    'Civil Procedure Code and Limitation Act ',
    'Property SOL',
    'Environmental SOL',
    'Existential Dialogues ',
    'Legal Venture Tech Challenge ',
    'International Seminar ',
    'Social Skills and Career Readiness Skills',
  ];
}
