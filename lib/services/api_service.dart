import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _url = 'https://servidor-dashboard-fboxwqyjfq-rj.a.run.app/v1/vendaDiaria';

  static Future<List<Map<String, dynamic>>> fetchDados() async {
    final response = await http.get(Uri.parse(_url));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception('Erro ao carregar dados da API');
    }
  }
}
