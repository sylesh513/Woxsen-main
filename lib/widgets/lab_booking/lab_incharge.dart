import 'package:flutter/material.dart';
import 'package:woxsen/utils/colors.dart';

class LabInchargeList extends StatelessWidget {
  final List<String> labInCharges;

  const LabInchargeList({Key? key, required this.labInCharges})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: labInCharges.map((incharge) {
        return ListTile(
          leading: const Icon(Icons.person, color: AppColors.primary),
          title: Text(incharge),
        );
      }).toList(),
    );
  }
}
