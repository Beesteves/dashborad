import 'package:dashboard/viewmodels/grafico_viewmodels.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class GraficoLinha extends StatelessWidget {
  const GraficoLinha({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<GraficoLinhaViewModel>(context);
    final vendas = vm.valores;
    final formatador = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Vendas do Dia',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
    SizedBox(
      height: 300,
      child: LineChart(
        LineChartData(
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, _) => Text(
                  'Venda ${value.toInt() + 1}',
                  style: const TextStyle(fontSize: 10),
                ),
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: 100,
                getTitlesWidget: (value, _) => FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(formatador.format(value)),
                ),
              ),
            ),
          ),
          gridData: FlGridData(
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
              getTooltipItems: (spots) => spots.map(
                (spot) => LineTooltipItem(
                  formatador.format(spot.y),
                  const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ).toList(),
            ),
            handleBuiltInTouches: true,
          ),
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              spots: List.generate(
                vendas.length,
                (i) => FlSpot(i.toDouble(), vendas[i]),
              ),
              barWidth: 3,
              color: Colors.indigo,
              dotData: const FlDotData(show: true),
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
          maxY: vm.maxValor + 50,
        ),
      ),
    )
    ]
    );
  }
}
