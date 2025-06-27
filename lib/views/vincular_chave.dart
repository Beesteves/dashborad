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
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF424242),
        title: const Text('Vincular Chave', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Container(
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Digite sua chave de acesso',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF212121),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: chaveController,
                  decoration: InputDecoration(
                    hintText: 'Ex: ABC123',
                    labelText: 'Chave de Acesso',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                if (error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      error!,
                      style: const TextStyle(color: Colors.redAccent, fontSize: 14),
                    ),
                  ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[800],
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _salvar,
                    child: const Text(
                      'Salvar e Continuar',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
