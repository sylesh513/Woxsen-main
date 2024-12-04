import 'package:flutter/material.dart';
import 'package:woxsen/utils/colors.dart';
import 'package:woxsen/utils/utils.dart';

class DatePicker extends StatefulWidget {
  const DatePicker({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DatePicker createState() => _DatePicker();
}

class _DatePicker extends State<DatePicker> {
  DateTime? bookingDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime currentDate = DateTime.now();
    final DateTime firstAllowedDate = currentDate.add(const Duration(days: 0));

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: firstAllowedDate,
      firstDate: firstAllowedDate,
      lastDate: DateTime(currentDate.year + 2),
    );

    setState(() {
      bookingDate = picked!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: 'Choose Booking Date',
          hintStyle: TextStyle(color: Colors.grey.shade400),
          prefixIcon:
              const Icon(Icons.calendar_today, color: AppColors.primary),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        readOnly: true,
        controller: TextEditingController(
            text:
                bookingDate != null ? formatDate(bookingDate!.toString()) : ''),
        onTap: () => _selectDate(context),
      ),
    );
  }
}
