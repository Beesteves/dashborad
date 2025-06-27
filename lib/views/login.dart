import 'package:dashboard/services/api_service.dart';
import 'package:dashboard/services/autenticacao_firebase.dart';
import 'package:dashboard/viewmodels/dashboard_viewmodel.dart';
import 'package:dashboard/views/home.dart';
import 'package:dashboard/views/vincular_chave.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Future<void> _handleLogin(BuildContext context) async {
    final authService = AuthService();
    try {
      final googleUser = await GoogleSignInPlatform.instance.signIn();
      if (googleUser == null) return;

      final user = await authService.signInWithGoogle();
      if (user != null) {
        final isFirst = await authService.isFirstLogin(user.uid);

        if (isFirst) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => VincularChaveScreen(uid: user.uid),
            ),
          );
        } else {
          final iD = await authService.getChave(user.uid);
          final dados = await ApiService.fetchDados();
          final vendasUsuario = dados.where((v) => v.iD == iD).toList();

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => ChangeNotifierProvider(
                create: (_) => DashboardViewModel(vendasUsuario, iD ?? ''),
                child: const DashboardHome(),
              ),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Erro ao autenticar: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao autenticar: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'lib/imagens/background.jpg',
            fit: BoxFit.cover,
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'lib/imagens/logo.png',
                        height: 100,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Bem-vindo ao Portal',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.login, color: Colors.white),
                          label: const Text(
                            'Entrar com Google',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF424242), 
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                          ),
                          onPressed: () => _handleLogin(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
