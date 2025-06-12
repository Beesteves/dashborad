import 'package:dashboard/views/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dashboard/viewmodels/login_viewmodel.dart';

class LoginScreen extends StatelessWidget { //Estrutura da tela e design
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: Consumer<LoginViewModel>(
        builder: (context, viewModel, child) {
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
                            TextField( //Entrada da Palavra-chave
                              controller: viewModel.passwordController,
                              obscureText: true,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                labelText: 'Palavra-chave',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onSubmitted: (_) => _handleLogin(context), //funcao de submit
                            ),
                            const SizedBox(height: 16),
                            if (viewModel.errorMessage.isNotEmpty) //Espaço para mensagem de erro
                              Text(viewModel.errorMessage, style: const TextStyle(color: Colors.red)),
                            const SizedBox(height: 16),
                            viewModel.isLoading
                                ? const CircularProgressIndicator()
                                : SizedBox( //botao de entrar
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () => _handleLogin(context),
                                      child: const Text('Entrar'),
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
        },
      ),
    );
  }

  void _handleLogin(BuildContext context) async {  //funcao para verificar a palavra e chamar proxima tela
    final viewModel = Provider.of<LoginViewModel>(context, listen: false); //atribui a classe LoginViewModel e a palavra-chave inserida
    final usuarios = await viewModel.login(); //chama a funcao para validacao da palavra chave pela fncao login()

    if (usuarios.isNotEmpty) { //verifica se retornou usuario e chama a tela DashboardHome
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => DashboardHome(dadosUsuario: usuarios)),
      );
    }
  }
}
