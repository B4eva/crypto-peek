import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PriceChart extends StatelessWidget {
  final List<double> prices;

  const PriceChart({super.key, required this.prices});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: true),
        borderData: FlBorderData(show: true),
        minX: 0,
        maxX: prices.length.toDouble(),
        minY: prices.reduce((a, b) => a < b ? a : b),
        maxY: prices.reduce((a, b) => a > b ? a : b),
        lineBarsData: [
          LineChartBarData(
            color: Colors.white,
            spots: prices.asMap().entries.map((entry) {
              int index = entry.key;
              double value = entry.value;
              return FlSpot(index.toDouble(), value);
            }).toList(),
            isCurved: true,
            // color: [Colors.blue],
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }
}
