import 'package:dashboard/models/venda_diaria.dart';
import 'package:dashboard/services/api_service.dart';
import 'package:dashboard/viewmodels/dashboard_viewmodel.dart';
import 'package:dashboard/viewmodels/grafico_viewmodels.dart';
import 'package:dashboard/widgets/grafico_pizza.dart';
import 'package:dashboard/widgets/grafico_linha.dart';
import 'package:dashboard/views/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';


class DashboardHome extends StatelessWidget {
  const DashboardHome({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final formatador = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    final viewModel = Provider.of<DashboardViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF424242),
        title: const Text(
          'Portal.com',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () async {
              final novasVendas = await buscarNovasVendas(context);
              Provider.of<DashboardViewModel>(context, listen: false).atualizarDados(novasVendas);
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildCard(
                      'Vendas',
                      formatador.format(viewModel.totalVendas),
                      Icons.attach_money,
                      isMobile,
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                _buildGraficoContainer(
                  child: ChangeNotifierProvider(
                    create: (_) {
                      final vendas = viewModel.vendas;
                      return GraficoLinhaViewModel()..dados = vendas;
                    },
                    child: const GraficoLinha(),
                  ),
                ),
                _buildGraficoContainer(
                  child: ChangeNotifierProvider(
                    create: (_) {
                      final vendas = viewModel.vendas;
                      return GraficoPizzaViewModel()..dados = vendas;
                    },
                    child: const GraficoPizza(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCard(String title, String value, IconData icon, bool isMobile) {
    return SizedBox(
      width: isMobile ? double.infinity : 250,
      height: 120,
      child: Card(
        color: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.grey[700]),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF212121),
                      ),
                    ),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Color(0xFF424242),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGraficoContainer({String? title, required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF212121),
                ),
              ),
            ),
          child,
        ],
      ),
    );
  }

  Future<List<VendaDiaria>> buscarNovasVendas(BuildContext context) async {
    final viewModel = Provider.of<DashboardViewModel>(context, listen: false);
    final dados = await ApiService.fetchDados();
    return dados.where((v) => v.iD == viewModel.usuarioID).toList();
  }
}
