import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class AttendancePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AttendanceComponent(
              title: 'Design Drawing II',
              total: '100',
              attended: '80',
              absent: '20',
            ),
            const SizedBox(height: 20),
            AttendanceComponent(
              title: 'Fundamentals of Design II',
              total: '100',
              attended: '58',
              absent: '42',
            ),
            const SizedBox(height: 20),
            AttendanceComponent(
              title: 'Digital Skills & Design II',
              total: '100',
              attended: '89',
              absent: '11',
            ),
          ],
        ),
      ),
    );
  }
}

class AttendanceComponent extends StatelessWidget {
  final String title;
  final String total;
  final String attended;
  final String absent;

  AttendanceComponent(
      {required this.title,
      required this.total,
      required this.attended,
      required this.absent});

  @override
  Widget build(BuildContext context) {
    Map<String, double> data = {
      "Total": double.parse(total),
      "Present": double.parse(attended),
      "Absent": double.parse(absent),
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 7,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    'Total - $total',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Present - $attended',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Absent - $absent',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: PieChart(
                  dataMap: data,
                  chartType: ChartType.disc,
                  chartRadius: MediaQuery.of(context).size.width / 3,
                  ringStrokeWidth: 32,
                  animationDuration: const Duration(milliseconds: 800),
                  chartValuesOptions: const ChartValuesOptions(
                    showChartValuesInPercentage: false,
                    showChartValuesOutside: false,
                    showChartValues: true,
                    decimalPlaces: 0,
                  ),
                  legendOptions: const LegendOptions(
                    showLegendsInRow: false,
                    legendPosition: LegendPosition.right,
                    showLegends: true,
                    legendShape: BoxShape.circle,
                    legendTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
