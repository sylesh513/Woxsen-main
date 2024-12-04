import 'package:flutter/material.dart';
import 'package:woxsen/utils/colors.dart';

class DropdownField extends StatelessWidget {
  final String hintText;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const DropdownField({
    required this.hintText,
    required this.items,
    required this.onChanged,
    required this.value,
    Key? key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade400),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        icon: const Icon(Icons.arrow_drop_down, color: AppColors.primary),
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: onChanged,
        value: value,
      ),
    );
  }
}
