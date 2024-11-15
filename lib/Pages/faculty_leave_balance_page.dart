import 'package:flutter/material.dart';

class FacultyLeaveBalancePage extends StatelessWidget {
  final String name;
  final String designation;

  const FacultyLeaveBalancePage({
    Key? key,
    required this.name,
    required this.designation,
  }) : super(key: key);

  Widget _buildLeaveCard(String title, Map<String, dynamic> details) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...details.entries.map((entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        entry.key,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        entry.value.toString(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'Leave Balance',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: const BoxDecoration(
                color: Color(0xFFFF9999),
              ),
              child: Column(
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    designation,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildLeaveCard('Earned Leave', {
              'Leave Taken': 0,
              'Leave Balance': 0,
              'Current Leave Eligibility': 0,
              'Total Leave Eligibility': 20,
            }),
            _buildLeaveCard('Sick Leave', {
              'Leave Taken': 0,
              'Leave Balance': 0,
              'Current Leave Eligibility': 0,
              'Total Leave Eligibility': 12,
            }),
            _buildLeaveCard('Paternity Leave', {
              'Leave Taken': 0,
              'Leave Balance': 0,
              'Current Leave Eligibility': 0,
              'Total Leave Eligibility': 7,
            }),
            _buildLeaveCard('Compensation Leave', {
              'Leave Taken': 0,
              'Leave Balance': 0,
              'Current Leave Eligibility': 0,
              'Total Leave Eligibility': 0,
            }),
          ],
        ),
      ),
    );
  }
}
