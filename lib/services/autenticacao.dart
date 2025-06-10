//const String apiUrl = 'https://meu-servidor.com/chaves'; // substitua pela sua URL
// final inputKey = _passwordController.text.trim();
    // if (inputKey.isEmpty) return;

    // setState(() {
    //   _loading = true;
    //   _errorMessage = '';
    // });

    // try {
    //   final response = await http.get(Uri.parse(apiUrl));
    //   if (response.statusCode == 200) {
    //     final List data = json.decode(response.body);

    //     final user = data.firstWhere(
    //       (item) => item['chave'] == inputKey,
    //       orElse: () => null,
    //     );

    //     if (user != null) {
    //       Navigator.pushReplacement(
    //         context,
    //         MaterialPageRoute(
    //           builder: (_) => DashboardHome(userData: user),
    //         ),
    //       );
    //     } else {
    //       setState(() => _errorMessage = 'Chave inválida.');
    //     }
    //   } else {
    //     setState(() => _errorMessage = 'Erro ao acessar servidor.');
    //   }
    // } catch (e) {
    //   setState(() => _errorMessage = 'Erro: $e');
    // } finally {
    //   setState(() => _loading = false);
    // }