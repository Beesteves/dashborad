import 'package:dashboard/models/venda_diaria.dart';
import 'package:dashboard/viewmodels/dashoard_viewmodel.dart';
import 'package:dashboard/viewmodels/grafico_viewmodels.dart';
import 'package:dashboard/widgets/grafico_pizza.dart';
import 'package:dashboard/widgets/grafico_linha.dart';
import 'package:dashboard/views/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class DashboardHome extends StatelessWidget { //estrutra da tela home
    final List<VendaDiaria> dadosUsuario; //tras a lista com todas as vendas do usuario

  const DashboardHome({super.key, required this.dadosUsuario});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    final viewModel = DashboardViewModel(dadosUsuario);

    return Scaffold(
      backgroundColor: Color.fromARGB(135, 131, 140, 153),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(247, 131, 140, 153),
        title: Text('Portal.com'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
            },
          )
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap( //caixa ajustavel para varios _buildCards
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildCard('Vendas', 'R\$${viewModel.totalVendas.toStringAsFixed(2)}', Icons.attach_money, isMobile), //chama a classe viewModel para trazer o valor total
                  ],
                ),
                const SizedBox(height: 32),
                _buildGraficoContainer( //build do grafico
                  title: 'Vendas do Dia',
                  child: ChangeNotifierProvider( //passagem pelo provider do model com os dados para view
                    create: (_) => GraficoLinhaViewModel()..dados = dadosUsuario,
                    child: const GraficoLinha(),
                  ),
                ),
                _buildGraficoContainer(
                  child: ChangeNotifierProvider( //passagem pelo provider do model com os dados para view
                    create: (_) => GraficoPizzaViewModel()..dados = dadosUsuario,
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

  Widget _buildCard(String title, String value, IconData icon, bool isMobile) { //estrutura do _buildCard
    return SizedBox(
      width: isMobile ? double.infinity : 250,
      height: 120,
      child: Card(
        color: Color.fromARGB(255, 255, 255, 255),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.indigo),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      value,
                      style: TextStyle(fontSize: 20),
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

  Widget _buildGraficoContainer({String? title, required Widget child}) {//estrutura do _buidlGrafico
    return Container(
      margin: const EdgeInsets.only(top: 16),
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          child,
        ],
      ),
    );
  }
}


