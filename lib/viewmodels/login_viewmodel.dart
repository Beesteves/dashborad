import 'package:dashboard/models/venda_diaria.dart';
import 'package:flutter/material.dart';
import 'package:dashboard/services/api_service.dart';

class LoginViewModel extends ChangeNotifier {
  final TextEditingController passwordController = TextEditingController();

  String errorMessage = '';
  bool isLoading = false;

  Future<List<VendaDiaria>> login() async { //funcao de login
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      final dados = await ApiService.fetchDados(); //busca dados da api
      final input = passwordController.text.trim();

      final filtrados = dados.where((item) => item.iD == input).toList(); //busca onde o iD é igual ao input e tras todos os dados em lista

      if (filtrados.isEmpty) { //verifica se encontrou algo, caso nao retorna erro
        errorMessage = 'Palavra-chave não encontrada.';
      }

      return filtrados; //retorna a lista de dados que contem o iD
    } catch (e) { //caso nao consiga se conectar
      errorMessage = 'Erro de rede: $e';
      return [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void disposeController() {
    passwordController.dispose();
  }
}
