import 'package:dashboard/services/api_service.dart';
import 'package:dashboard/services/autenticacao_firebase.dart';
import 'package:dashboard/viewmodels/dashboard_viewmodel.dart';
import 'package:dashboard/views/home.dart';
import 'package:dashboard/views/vincular_chave.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';



class LoginScreen extends StatelessWidget { //Estrutura da tela e design
  const LoginScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('lib/imagens/background.jpg', fit: BoxFit.cover), //imagens de fundo
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
            child: Center(
              child: ConstrainedBox( //caixa onde se encontra login
                constraints: const BoxConstraints(maxWidth: 400),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('lib/imagens/logo.png', height: 100), //logo Portal
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.login),
                        label: const Text('Entrar com Google'),
                        onPressed: () async {
                          final authService = AuthService();
                          try {
                            // Usando GoogleSignInPlatform diretamente
                            final googleUser = await GoogleSignInPlatform.instance.signIn();

                            if (googleUser == null) {
                              // Usuário cancelou o login
                              return;
                            }

                            // Autenticar no Firebase com o googleUser obtido
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
                                      create: (_) =>
                                          DashboardViewModel(vendasUsuario, iD ?? ''),
                                      child: const DashboardHome(),
                                    ),
                                  ),
                                );
                              }
                            }
                          } catch (e) {
                            // Trate erros aqui, exibe um alert, snack etc.
                            debugPrint('Erro ao autenticar: $e');
                          }
                        },
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