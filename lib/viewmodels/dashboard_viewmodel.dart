import 'package:dashboard/models/venda_diaria.dart';
import 'package:flutter/material.dart';

class DashboardViewModel extends ChangeNotifier {
  List<VendaDiaria> _vendas;
  final String usuarioID; // <- novo campo

  DashboardViewModel(this._vendas, this.usuarioID);

  List<VendaDiaria> get vendas => _vendas;

  double get totalVendas => _vendas.fold(0.0, (soma, venda) => soma + venda.valor);

  void atualizarDados(List<VendaDiaria> novasVendas) {
    _vendas = novasVendas;
    notifyListeners();
  }
}
