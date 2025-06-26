class VendaDiaria {
  final String iD;
  final String formPag;
  final double valor;
  final String tipo;
  // final String codVenda;
  // final String data;

  VendaDiaria({
    required this.iD,
    required this.formPag,
    required this.valor,
    required this.tipo,
    // required this.codVenda,
    // required this.data,
  });

  factory VendaDiaria.fromJson(Map<String, dynamic> json) {
    return VendaDiaria(
      iD: json['iD'].toString(),
      formPag: json['formPag'],
      valor: (json['valor'] as num).toDouble(),
      tipo: json['tipo'],
      // codVenda: json['codVenda'],
      // data: json['data'],
    );
  }
}
