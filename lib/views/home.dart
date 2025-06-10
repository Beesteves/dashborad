import 'package:dashboard/services/grafico_pizza.dart';
import 'package:dashboard/services/grafico_linha.dart';
import 'package:dashboard/views/login.dart';
import 'package:flutter/material.dart';


class DashboardHome extends StatelessWidget {
    final List<Map<String, dynamic>> dadosUsuario;

  const DashboardHome({super.key, required this.dadosUsuario});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    final totalVendas = dadosUsuario.fold<double>(
      0,
      (soma, item) => soma + (item['valor'] ?? 0),
    );

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
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildCard('Vendas', 'R\$${totalVendas}', Icons.attach_money, isMobile),
                  ],
                ),
                const SizedBox(height: 32),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                  ),
                  child: Column(
                    crossAxisAlignment:  CrossAxisAlignment.start,
                    children:[
                      const Text(
                        'Vendas do Dia',
                        style: TextStyle(fontSize: 18, fontWeight:  FontWeight.bold),
                      ),
                      const SizedBox(height: 16,),
                      GraficoLinha(dadosBrutos: dadosUsuario,)
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                  ),
                  child: Column(
                    crossAxisAlignment:  CrossAxisAlignment.start,
                    children:[
                      const SizedBox(height: 16,),
                      GraficoPizza(dadosBrutos: dadosUsuario)
                    ],
                  ),
                )
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
}


