import 'package:flutter/material.dart';
import 'package:woxsen/Values/subjects_list.dart';
import 'package:woxsen/utils/colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FacultyRatingScreen extends StatefulWidget {
  const FacultyRatingScreen({Key? key}) : super(key: key);

  @override
  _FacultyRatingScreenState createState() => _FacultyRatingScreenState();
}

class _FacultyRatingScreenState extends State<FacultyRatingScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? selectedSchool;

  List<Map<String, dynamic>> filteredFacultyList = [];
  List<Map<String, dynamic>> facultiesRatings = [];
  List<Map<String, dynamic>> facultiesData = [];
  bool isLoading = false;
  ListStore store = ListStore();

  @override
  void initState() {
    super.initState();
    filteredFacultyList = facultiesData;
    fetchFacultiesFeedback();
  }

  void fetchFacultiesFeedback() async {
    setState(() {
      isLoading = true;
    });

    // const String apiUrl =
    //     'http://10.7.0.23:4000/api/faculty_ratings';
    String apiUrl = '${store.woxUrl}/api/faculty_ratings';
// change endpoint

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List jsonResponse = jsonDecode(response.body);
        debugPrint('JSON RESPONSE : $jsonResponse');

        setState(() {
          facultiesData = List<Map<String, dynamic>>.from(jsonResponse);
          filteredFacultyList = facultiesData;
        });
      } else {
        throw Exception('Failed to load faculty ratings');
      }
    } catch (e) {
      print('Error fetching faculty ratings: $e');
      throw e;
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterFaculty(String query) {
    debugPrint('query : $query');

    setState(() {
      filteredFacultyList = [...facultiesData].where((faculty) {
        final nameMatch =
            faculty['faculty_name'].toLowerCase().contains(query.toLowerCase());
        final schoolMatch =
            selectedSchool == null || faculty['school'] == selectedSchool;

        debugPrint('nameMatch : $nameMatch');
        debugPrint('schoolMatch : $schoolMatch');
        return nameMatch && schoolMatch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('filtered data : $filteredFacultyList');

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
                    icon: const Icon(Icons.refresh),
                    onPressed: fetchFacultiesFeedback,
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : (filteredFacultyList.isEmpty || facultiesData.isEmpty)
                    ? const Center(
                        child: Text(
                        'No ratings found',
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ))
                    : ListView.builder(
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
                                color: AppColors.border,
                                width: 1.5,
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
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(
                                          Icons.person,
                                          color: AppColors.primary,
                                          size: 80,
                                        );
                                      },
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                size: 16,
                                                color: AppColors.primary),
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
                                          'Based on ${faculty['total_ratings_count']} feedback(s)',
                                          style: TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              '${faculty['avg_rating']}',
                                              style: const TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            ...List.generate(5, (index) {
                                              double rating =
                                                  faculty['avg_rating'];
                                              int fullStars = rating.floor();
                                              double decimal =
                                                  rating - fullStars;

                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 4.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color:
                                                            AppColors.primary),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                  child: Stack(
                                                    children: [
                                                      Icon(
                                                        Icons.star_border,
                                                        color:
                                                            AppColors.primary,
                                                        size: 20,
                                                      ),
                                                      if (index < fullStars)
                                                        Icon(
                                                          Icons.star,
                                                          color:
                                                              AppColors.primary,
                                                          size: 20,
                                                        )
                                                      else if (index ==
                                                              fullStars &&
                                                          decimal > 0)
                                                        ClipRect(
                                                          clipper: _StarClipper(
                                                              decimal),
                                                          child: Icon(
                                                            Icons.star,
                                                            color: AppColors
                                                                .primary,
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
