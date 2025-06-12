import 'package:dashboard/models/venda_diaria.dart';

class DashboardViewModel {
  final List<VendaDiaria> vendas;

  DashboardViewModel(this.vendas);

  double get totalVendas => vendas.fold(0.0, (soma, venda) => soma + venda.valor); //soma todos os valores das vendas diarias
}