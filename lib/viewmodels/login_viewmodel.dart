import 'package:dashboard/models/venda_diaria.dart';
import 'package:flutter/material.dart';
import 'package:dashboard/services/api_service.dart';
import 'package:flutter/rendering.dart';

class LoginViewModel extends ChangeNotifier {
  final TextEditingController passwordController = TextEditingController();

  String errorMessage = '';
  bool isLoading = false;

  Future<List<VendaDiaria>> login() async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      final dados = await ApiService.fetchDados();
      final input = passwordController.text.trim();

      final filtrados = dados.where((item) => item.iD == input).toList();

      if (filtrados.isEmpty) {
        errorMessage = 'Palavra-chave não encontrada.';
      }

      return filtrados;
    } catch (e) {
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
