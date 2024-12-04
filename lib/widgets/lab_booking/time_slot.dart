import 'package:flutter/material.dart';
import 'package:woxsen/utils/colors.dart';

class TimeSlotGrid extends StatelessWidget {
  const TimeSlotGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with actual time slots from API
    final timeSlots = [
      '03:00 - 04:00',
      '05:00 - 06:00',
      '11:00 - 12:00',
      '23:00 - 24:00',
      '22:00 - 23:30',
      '18:00 - 18:30',
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: timeSlots.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primary),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              timeSlots[index],
              style: const TextStyle(color: Colors.black),
            ),
          ),
        );
      },
    );
  }
}
