class VendaDiaria {
  final String iD;
  final String formPag;
  final double valor;
  final String tipo;
  //final String data;

  VendaDiaria({
    required this.iD,
    required this.formPag,
    required this.valor,
    required this.tipo,
    //required this.data,
  });

  factory VendaDiaria.fromJson(Map<String, dynamic> json) {
    return VendaDiaria(
      iD: json['iD'].toString(),
      formPag: json['formPag'],
      valor: (json['valor'] as num).toDouble(),
      tipo: json['tipo'],
      //data: json['data'],
    );
  }
}
