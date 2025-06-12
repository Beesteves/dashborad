import 'dart:convert';
import 'package:dashboard/models/venda_diaria.dart';
import 'package:http/http.dart' as http;

class ApiService { //faz a conxao com a api
  static const String _url = 'https://servidor-dashboard-fboxwqyjfq-rj.a.run.app/v1/vendaDiaria';

  static Future<List<VendaDiaria>> fetchDados() async {
    try { //tenta conectar
      final response = await http.get(Uri.parse(_url));

      if (response.statusCode == 200) { //verifica conexao
        final List<dynamic> data = json.decode(response.body);  
        return data.map((item) => VendaDiaria.fromJson(item)).toList(); //retorna uma lista com todas as VendaDiaria existentes
      } else {
        throw Exception('Erro ao carregar dados da API. Código: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Falha na requisição: $e');
    }
  }
}
