import 'package:flutter/material.dart';
import 'package:woxsen/utils/colors.dart';

class FacultyRatingScreen extends StatefulWidget {
  const FacultyRatingScreen({Key? key}) : super(key: key);

  @override
  _FacultyRatingScreenState createState() => _FacultyRatingScreenState();
}

class _FacultyRatingScreenState extends State<FacultyRatingScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? selectedSchool;
  List<Map<String, dynamic>> facultyList = [
    {
      "id": 1,
      "faculty_name": "Dr. John Doe 1",
      "faculty_email": "john.doe1@university.edu",
      "faculty_designation": "Associate Professor",
      "school": "School of Business",
      "profile_image_url": "https://placehold.co/200x200/png",
      "rating": "4.3",
      "total_ratings": 72
    },
    {
      "id": 2,
      "faculty_name": "Dr. John Doe 2",
      "faculty_email": "john.doe2@university.edu",
      "faculty_designation": "Professor",
      "school": "School of Arts and Design",
      "profile_image_url": "https://placehold.co/200x200/png",
      "rating": "4.5",
      "total_ratings": 89
    },
    {
      "id": 3,
      "faculty_name": "Dr. John Doe 3",
      "faculty_email": "john.doe3@university.edu",
      "faculty_designation": "Lecturer",
      "school": "School of Technology",
      "profile_image_url": "https://placehold.co/200x200/png",
      "rating": "3.5",
      "total_ratings": 41
    },
    {
      "id": 4,
      "faculty_name": "Dr. John Doe 4",
      "faculty_email": "john.doe4@university.edu",
      "faculty_designation": "Assistant Professor",
      "school": "School of Sciences",
      "profile_image_url": "https://placehold.co/200x200/png",
      "rating": "4.5",
      "total_ratings": 95
    },
    {
      "id": 5,
      "faculty_name": "Dr. John Doe 5",
      "faculty_email": "john.doe5@university.edu",
      "faculty_designation": "Adjunct Faculty",
      "school": "School of Liberal Arts and Humanities",
      "profile_image_url": "https://placehold.co/200x200/png",
      "rating": "4.2",
      "total_ratings": 28
    },
    {
      "id": 6,
      "faculty_name": "Dr. John Doe 6",
      "faculty_email": "john.doe6@university.edu",
      "faculty_designation": "Professor",
      "school": "School of Law",
      "profile_image_url": "https://placehold.co/200x200/png",
      "rating": "3.4",
      "total_ratings": 107
    },
    {
      "id": 7,
      "faculty_name": "Dr. John Doe 7",
      "faculty_email": "john.doe7@university.edu",
      "faculty_designation": "Associate Professor",
      "school": "School of Architecture and Planning",
      "profile_image_url": "https://placehold.co/200x200/png",
      "rating": "4.4",
      "total_ratings": 63
    },
    {
      "id": 8,
      "faculty_name": "Dr. John Doe 8",
      "faculty_email": "john.doe8@university.edu",
      "faculty_designation": "Lecturer",
      "school": "School of Business",
      "profile_image_url": "https://placehold.co/200x200/png",
      "rating": "4.3",
      "total_ratings": 52
    },
    {
      "id": 9,
      "faculty_name": "Dr. John Doe 9",
      "faculty_email": "john.doe9@university.edu",
      "faculty_designation": "Assistant Professor",
      "school": "School of Technology",
      "profile_image_url": "https://placehold.co/200x200/png",
      "rating": "4.0",
      "total_ratings": 81
    },
    {
      "id": 10,
      "faculty_name": "Dr. John Doe 10",
      "faculty_email": "john.doe10@university.edu",
      "faculty_designation": "Professor",
      "school": "School of Sciences",
      "profile_image_url": "https://placehold.co/200x200/png",
      "rating": "4.8",
      "total_ratings": 99
    },
    {
      "id": 11,
      "faculty_name": "Dr. John Doe 11",
      "faculty_email": "john.doe11@university.edu",
      "faculty_designation": "Adjunct Faculty",
      "school": "School of Arts and Design",
      "profile_image_url": "https://placehold.co/200x200/png",
      "rating": "3.7",
      "total_ratings": 37
    },
    {
      "id": 12,
      "faculty_name": "Dr. John Doe 12",
      "faculty_email": "john.doe12@university.edu",
      "faculty_designation": "Associate Professor",
      "school": "School of Liberal Arts and Humanities",
      "profile_image_url": "https://placehold.co/200x200/png",
      "rating": "4.2",
      "total_ratings": 76
    },
    {
      "id": 13,
      "faculty_name": "Dr. John Doe 13",
      "faculty_email": "john.doe13@university.edu",
      "faculty_designation": "Lecturer",
      "school": "School of Law",
      "profile_image_url": "https://placehold.co/200x200/png",
      "rating": "3.9",
      "total_ratings": 45
    },
    {
      "id": 14,
      "faculty_name": "Dr. John Doe 14",
      "faculty_email": "john.doe14@university.edu",
      "faculty_designation": "Professor",
      "school": "School of Architecture and Planning",
      "profile_image_url": "https://placehold.co/200x200/png",
      "rating": "4.6",
      "total_ratings": 88
    },
    {
      "id": 15,
      "faculty_name": "Dr. John Doe 15",
      "faculty_email": "john.doe15@university.edu",
      "faculty_designation": "Assistant Professor",
      "school": "School of Business",
      "profile_image_url": "https://placehold.co/200x200/png",
      "rating": "3.4",
      "total_ratings": 59
    },
    {
      "id": 16,
      "faculty_name": "Dr. John Doe 16",
      "faculty_email": "john.doe16@university.edu",
      "faculty_designation": "Adjunct Faculty",
      "school": "School of Technology",
      "profile_image_url": "https://placehold.co/200x200/png",
      "rating": "4.4",
      "total_ratings": 70
    },
    {
      "id": 17,
      "faculty_name": "Dr. John Doe 17",
      "faculty_email": "john.doe17@university.edu",
      "faculty_designation": "Professor",
      "school": "School of Sciences",
      "profile_image_url": "https://placehold.co/200x200/png",
      "rating": "4.9",
      "total_ratings": 103
    },
    {
      "id": 18,
      "faculty_name": "Dr. John Doe 18",
      "faculty_email": "john.doe18@university.edu",
      "faculty_designation": "Associate Professor",
      "school": "School of Arts and Design",
      "profile_image_url": "https://placehold.co/200x200/png",
      "rating": "3.6",
      "total_ratings": 42
    },
    {
      "id": 19,
      "faculty_name": "Dr. John Doe 19",
      "faculty_email": "john.doe19@university.edu",
      "faculty_designation": "Lecturer",
      "school": "School of Liberal Arts and Humanities",
      "profile_image_url": "https://placehold.co/200x200/png",
      "rating": "4.1",
      "total_ratings": 84
    },
    {
      "id": 20,
      "faculty_name": "Dr. John Doe 20",
      "faculty_email": "john.doe20@university.edu",
      "faculty_designation": "Assistant Professor",
      "school": "School of Law",
      "profile_image_url": "https://placehold.co/200x200/png",
      "rating": "3.8",
      "total_ratings": 67
    }
  ];
  List<Map<String, dynamic>> filteredFacultyList = [];

  @override
  void initState() {
    super.initState();
    filteredFacultyList = facultyList;
  }

  void filterFaculty(String query) {
    setState(() {
      filteredFacultyList = facultyList.where((faculty) {
        final nameMatch =
            faculty['faculty_name'].toLowerCase().contains(query.toLowerCase());
        final schoolMatch =
            selectedSchool == null || faculty['school'] == selectedSchool;
        return nameMatch && schoolMatch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Color(0xFFFFF0F0),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Faculty Rating',
          style: TextStyle(color: Colors.black, fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: () {
                      // Implement filter action
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: filterFaculty,
                      decoration: const InputDecoration(
                        hintText: 'Search...',
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: PopupMenuButton<String>(
                    child: const Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: Row(
                        children: [
                          Text('Select School'),
                          Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                    onSelected: (String school) {
                      setState(() {
                        selectedSchool = school;
                        filterFaculty(_searchController.text);
                      });
                    },
                    itemBuilder: (BuildContext context) {
                      return [
                        'School of Technology',
                        'School of Architecture and Planning',
                        'School of Business',
                        'School of Law',
                        'School of Sciences',
                        'School of Arts and Design',
                        'School of Liberal Arts and Humanities'
                      ].map((String school) {
                        return PopupMenuItem<String>(
                          value: school,
                          child: Text(school),
                        );
                      }).toList();
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredFacultyList.length,
              itemBuilder: (context, index) {
                final faculty = filteredFacultyList[index];
                return Card.outlined(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(
                      color:
                          AppColors.border, // Replace with desired border color
                      width: 1.5, // Replace with desired border width
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            faculty['profile_image_url'] ?? '',
                            width: 140,
                            height: 140,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.error,
                                color: AppColors.primary,
                                size: 80,
                              );
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                faculty['faculty_name'],
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                              Text(
                                faculty['faculty_designation'],
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(Icons.email,
                                      size: 16, color: AppColors.primary),
                                  SizedBox(width: 4),
                                  Text(
                                    faculty['faculty_email'],
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Based on ${faculty['total_ratings']} feedbacks',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    faculty['rating'].toString(),
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  ...List.generate(5, (index) {
                                    double rating =
                                        double.parse(faculty['rating']);
                                    int fullStars = rating.floor();
                                    double decimal = rating - fullStars;

                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(right: 4.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: AppColors.primary),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Stack(
                                          children: [
                                            Icon(
                                              Icons.star_border,
                                              color: AppColors.primary,
                                              size: 20,
                                            ),
                                            if (index < fullStars)
                                              Icon(
                                                Icons.star,
                                                color: AppColors.primary,
                                                size: 20,
                                              )
                                            else if (index == fullStars &&
                                                decimal > 0)
                                              ClipRect(
                                                clipper: _StarClipper(decimal),
                                                child: Icon(
                                                  Icons.star,
                                                  color: AppColors.primary,
                                                  size: 20,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StarClipper extends CustomClipper<Rect> {
  final double fillPercentage;

  _StarClipper(this.fillPercentage);

  @override
  Rect getClip(Size size) {
    double clippedWidth = (size.width * fillPercentage).roundToDouble();
    return Rect.fromLTWH(0, 0, clippedWidth, size.height);
  }

  @override
  bool shouldReclip(_StarClipper oldClipper) {
    return oldClipper.fillPercentage != fillPercentage;
  }
}
