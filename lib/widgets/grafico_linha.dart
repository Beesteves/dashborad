import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GraficoLinha extends StatelessWidget {
  final List<Map<String, dynamic>> dadosBrutos;
  
  GraficoLinha({super.key, required this.dadosBrutos});

  @override
  Widget build(BuildContext context) {
    final List<double> vendas = dadosBrutos
    .map((item) => (item['valor'] as num).toDouble())
    .toList();

    return SizedBox(
      height: 300,
      child: LineChart(
        LineChartData(
          titlesData: FlTitlesData(
            show: true,
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, _) {
                  return Text(
                    'Venda ${value.toInt() + 1}',
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: 100,
                getTitlesWidget: (value, _) => FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text('R\$${value.toInt()}'),
                ),
              ),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            drawHorizontalLine: true,
            horizontalInterval: 100,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.grey.withOpacity(0.2),
              strokeWidth: 1,
            ),
          ),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: Colors.black87,
              getTooltipItems: (List<LineBarSpot> touchedSpots) {
                return touchedSpots.map((spot) {
                  return LineTooltipItem(
                    'R\$ ${spot.y.toStringAsFixed(2)}',
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList();
              },
            ),
            touchCallback: (FlTouchEvent event, LineTouchResponse? response) {},
            handleBuiltInTouches: true,
          ),
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              spots: List.generate(
                vendas.length,
                (index) => FlSpot(index.toDouble(), vendas[index]),
              ),
              barWidth: 3,
              color: Colors.indigo,
              dotData: FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.indigo.withOpacity(0.2),
              ),
            ),
          ],
          borderData: FlBorderData(
            show: true,
            border: const Border(
              left: BorderSide(color: Colors.black26),
              bottom: BorderSide(color: Colors.black26),
            ),
          ),
          minY: 0,
        ),
      ),
    );
  }
}
