import 'package:dashboard/viewmodels/grafico_viewmodels.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class GraficoPizza extends StatelessWidget {
  const GraficoPizza({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<GraficoPizzaViewModel>(context);
    final dados = vm.dadosAgrupados;
    final total = vm.total;
    final formatador = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Forma de pagamento',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              sections: dados.map((item) {
                final percent = (item['valor'] / total) * 100;

                return PieChartSectionData(
                  color: item['cor'],
                  value: item['valor'].toDouble(),
                  title: '${percent.toStringAsFixed(1)}%',
                  radius: 60,
                  titleStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 20),
        ...dados.map((item) {
          final valorLabel = formatador.format(item['valor']);

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: item['cor'],
                  radius: 6,
                ),
                const SizedBox(width: 8),
                Expanded(child: Text(item['formPag'])),
                const SizedBox(width: 8),
                Text(valorLabel),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () => mostrarDetalhesVenda(context, item['formPag']),
                  child: const Text(
                    'VER',
                    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  void mostrarDetalhesVenda(BuildContext context, String formPag) {
    final vm = Provider.of<GraficoPizzaViewModel>(context, listen: false);
    final vendasFiltradas = vm.filtrarPorFormaPagamento(formPag);
    final formatador = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Vendas - $formPag', style: const TextStyle(fontWeight: FontWeight.bold)),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: vendasFiltradas.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final venda = vendasFiltradas[index];
                final valorFormatado = formatador.format(venda.valor);
                return ListTile(
                  leading: const Icon(Icons.monetization_on),
                  title: Text('Valor: $valorFormatado'),
                  subtitle: Text('Tipo: ${venda.tipo}'),
                );
              },
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Fechar')),
          ],
        );
      },
    );
  }
}
