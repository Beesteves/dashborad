import 'package:flutter/material.dart';
import 'package:dashboard/models/venda_diaria.dart';

class GraficoPizzaViewModel extends ChangeNotifier { //view do grafico pizza
  final Map<String, Color> cores = { //indica as cores para forma de pagamento
    'À Vista': Colors.blue,
    'A Prazo': Colors.green,
  };

  List<VendaDiaria> _dados = [];

  set dados(List<VendaDiaria> value) { //recebe os dados e manda para funcao processar
    _dados = value;
    _processarDados();
  }

  final List<Map<String, dynamic>> _agrupado = [];

  List<Map<String, dynamic>> get dadosAgrupados => _agrupado; 
  double get total => _agrupado.fold(0.0, (soma, item) => soma + (item['valor'] as double));
  

  void _processarDados() {
    final Map<String, double> mapa = {};

    for (var item in _dados) {
      String formPag = '';
      if(item.formPag == 'V'){
        formPag = 'À Vista';
      } else if(item.formPag == 'P'){
        formPag = 'A Prazo';
      }
      final valor = (item.valor as num).toDouble();

      if (formPag == 'À Vista' || formPag == 'A Prazo') {
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
    if(formPag == 'À Vista'){
      return _dados.where((v) => v.formPag == 'V').toList();
    } else{
      return _dados.where((v) => v.formPag == 'P').toList();
    }
  }
}

class GraficoLinhaViewModel extends ChangeNotifier { //View do grafico de linha
  List<VendaDiaria> _dados = [];

  set dados(List<VendaDiaria> value) {
    _dados = value;
    notifyListeners();
  }

  List<double> get valores => _dados.map((v) => v.valor).toList();

  double get maxValor => valores.isEmpty ? 0 : valores.reduce((a, b) => a > b ? a : b);
}