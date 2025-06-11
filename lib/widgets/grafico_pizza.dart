import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class GraficoPizza extends StatelessWidget {
  final List<Map<String, dynamic>> dadosBrutos;

  const GraficoPizza({Key? key, required this.dadosBrutos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, Color> cores = {
      'A VISTA': Colors.blue,
      'A PRAZO': Colors.green,
    };

    final Map<String, double> agrupado = {};

    for (var item in dadosBrutos) {
      final formPag = item['formPag'];
      final valor = (item['valor'] as num).toDouble();

      if (formPag == 'A VISTA' || formPag == 'A PRAZO') {
        agrupado[formPag] = (agrupado[formPag] ?? 0) + valor;
      }
    }
    
    final List<Map<String, dynamic>> dados = agrupado.entries.map((e) {
      return {
        'formPag': e.key,
        'valor': e.value,
        'cor': cores[e.key] ?? Colors.grey,
      };
    }).toList();
    
      print("dados $dados");

    final total = dados.fold(0.0, (soma, item) => soma + item['valor']);
    
      print("total $total");

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
          final valorLabel = 'R\$${item['valor'].toStringAsFixed(2)}';

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
                  onTap: () => mostrarDetalhesVenda(context, item),
                  child: const Text(
                    'VER',
                    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  void mostrarDetalhesVenda(BuildContext context, Map<String, dynamic> item) { //Tela para listar as vendas por categoria
    // Filtrar todas as vendas daquele formPag
    final vendasFiltradas = dadosBrutos
        .where((venda) => venda['formPag'] == item['formPag'])
        .toList();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Vendas - ${item['formPag']}', style: const TextStyle(fontWeight: FontWeight.bold)),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: vendasFiltradas.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final venda = vendasFiltradas[index];
                return ListTile(
                  leading: const Icon(Icons.monetization_on),
                  title: Text('Valor: R\$${(venda['valor'] as double).toStringAsFixed(2)}'),
                  subtitle: Text('Tipo: ${venda['tipo']}'),
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