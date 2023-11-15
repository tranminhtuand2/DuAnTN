import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../../../../model/thongke_model.dart';

class BarChartWidget extends StatelessWidget {
  final List<ThongKe> thongKeData;
  const BarChartWidget({super.key, required this.thongKeData});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.7,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: const Color(0xff2c4260),
        child: BarChart(
          BarChartData(
            titlesData: const FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true, reservedSize: 60),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true, reservedSize: 60),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true, reservedSize: 60),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true, reservedSize: 60),
              ),
            ),
            borderData: FlBorderData(
              show: true,
            ),
            gridData: FlGridData(show: true),
            barGroups: thongKeData
                .asMap()
                .map(
                  (index, thongke) => MapEntry(
                    index,
                    BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: thongke.total ?? 0.0,
                          width: 16,
                          color: Colors.amber,
                        ),
                      ],
                    ),
                  ),
                )
                .values
                .toList(),
          ),
        ),
      ),
    );
  }
}
