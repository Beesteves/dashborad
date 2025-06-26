import 'package:dashboard/services/api_service.dart';
import 'package:dashboard/services/autenticacao_firebase.dart';
import 'package:dashboard/viewmodels/dashboard_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:dashboard/views/home.dart';
import 'package:provider/provider.dart';

class VincularChaveScreen extends StatefulWidget {
  final String uid;

  const VincularChaveScreen({super.key, required this.uid});

  @override
  State<VincularChaveScreen> createState() => _VincularChaveScreenState();
}

class _VincularChaveScreenState extends State<VincularChaveScreen> {
  final TextEditingController chaveController = TextEditingController();
  String? error;

  void _salvar() async {
    final iD = chaveController.text.trim();

    if (iD.isEmpty) {
      setState(() => error = 'Informe a chave de acesso.');
      return;
    }

    final authService = AuthService();
    await authService.salvarChave(widget.uid, iD);

    final dados = await ApiService.fetchDados();
    final vendasUsuario = dados.where((v) => v.iD == iD).toList();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider(
          create: (_) => DashboardViewModel(vendasUsuario, iD),
          child: const DashboardHome(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vincular Chave')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text('Digite sua chave de acesso', style: TextStyle(fontSize: 18)),
            TextField(controller: chaveController),
            if (error != null)
              Text(error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _salvar,
              child: const Text('Salvar e Continuar'),
            ),
          ],
        ),
      ),
    );
  }
}
