import 'package:flutter/material.dart';
import 'package:dashboard/models/venda_diaria.dart';

class GraficoPizzaViewModel extends ChangeNotifier {
  final Map<String, Color> cores = {
    'A VISTA': Colors.blue,
    'A PRAZO': Colors.green,
  };

  List<VendaDiaria> _dados = [];

  set dados(List<VendaDiaria> value) {
    _dados = value;
    _processarDados();
  }

  final List<Map<String, dynamic>> _agrupado = [];

  List<Map<String, dynamic>> get dadosAgrupados => _agrupado;
  double get total => _agrupado.fold(0.0, (soma, item) => soma + (item['valor'] as double));

  void _processarDados() {
    final Map<String, double> mapa = {};

    for (var item in _dados) {
      final formPag = item.formPag;
      final valor = (item.valor as num).toDouble();

      if (formPag == 'A VISTA' || formPag == 'A PRAZO') {
        mapa[formPag] = (mapa[formPag] ?? 0) + valor;
      }
    }

    _agrupado
      ..clear()
      ..addAll(mapa.entries.map((e) {
        return {
          'formPag': e.key,
          'valor': e.value,
          'cor': cores[e.key] ?? Colors.grey,
        };
      }));

    notifyListeners();
  }

  List<VendaDiaria> filtrarPorFormaPagamento(String formPag) {
    return _dados.where((v) => v.formPag == formPag).toList();
  }
}

class GraficoLinhaViewModel extends ChangeNotifier {
  List<VendaDiaria> _dados = [];

  set dados(List<VendaDiaria> value) {
    _dados = value;
    notifyListeners();
  }

  List<double> get valores => _dados.map((v) => v.valor).toList();

  double get maxValor => valores.isEmpty ? 0 : valores.reduce((a, b) => a > b ? a : b);
}