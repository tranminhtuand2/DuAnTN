import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../../../model/thongke_model.dart';

class DailyStatisticsChart extends StatelessWidget {
  final List<ThongKe> thongKeData; // Danh sách các đối tượng ThongKe

  DailyStatisticsChart(this.thongKeData);

  @override
  Widget build(BuildContext context) {
    final dailyData = _calculateDailyData(thongKeData);

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: true),
        borderData: FlBorderData(show: true),
        minX: dailyData.keys.first.millisecondsSinceEpoch.toDouble(),
        maxX: dailyData.keys.last.millisecondsSinceEpoch.toDouble(),
        minY: 0,
        maxY: dailyData.values.reduce((a, b) => a > b ? a : b) +
            10, // Điều chỉnh tùy theo yêu cầu của bạn
        lineBarsData: [
          LineChartBarData(
            spots: dailyData.entries
                .map((entry) => FlSpot(
                      entry.key.millisecondsSinceEpoch.toDouble(),
                      entry.value,
                    ))
                .toList(),
            isCurved: true,
            color: Color(0xff53f0e7),
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }

  Map<DateTime, double> _calculateDailyData(List<ThongKe> thongKeData) {
    final dailyData = <DateTime, double>{};

    for (var thongKe in thongKeData) {
      final timestamp = thongKe.date as Timestamp;
      final date = timestamp.toDate(); // Chuyển đổi FieldValue thành DateTime
      final total = thongKe.total ?? 0.0;

      if (dailyData.containsKey(date)) {
        dailyData[date] = (dailyData[date]! + total)!;
      } else {
        dailyData[date] = total;
      }
    }

    return dailyData;
  }
}
