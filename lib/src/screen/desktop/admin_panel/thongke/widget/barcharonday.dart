import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../../../model/chart_Model.dart';

class SalesChart extends StatelessWidget {
  final List<ProductSalesData> productSalesDataList;
  const SalesChart({super.key, required this.productSalesDataList});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 60),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 60,
              getTitlesWidget: (double value, TitleMeta meta) {
                int index = value.toInt();
                if (index >= 0 && index < productSalesDataList.length) {
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Transform.rotate(
                      angle: 45 * (3.14159265359 / 180), // Xoay chữ 45 độ
                      child: Text(
                        productSalesDataList[index].productName,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromARGB(255, 89, 136, 194),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                  // Text(productSalesDataList[index].productName);
                }
                return Text('');
              },
            ),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false, reservedSize: 60),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false, reservedSize: 60),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1),
        ),
        gridData: FlGridData(show: true),
        barGroups: productSalesDataList.asMap().entries.map((entry) {
          final ProductSalesData productSalesData = entry.value;

          return BarChartGroupData(
            x: entry.key,
            barRods: [
              BarChartRodData(
                toY: productSalesData.totalSales.toDouble(),
                width: 16,
                color: Colors.blue,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(6),
                ),
                // backDrawRodData: BackgroundBarChartRodData(
                //   show: true,
                //   toY: productSalesData.totalSales.toDouble() * 10,
                //   color: Colors.white,
                // ),
              ),
            ],
            // showingTooltipIndicators: [0],
          );
        }).toList(),
      ),
    );
  }
}
