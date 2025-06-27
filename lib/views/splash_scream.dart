import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dashboard/services/api_service.dart';
import 'package:dashboard/services/autenticacao_firebase.dart';
import 'package:dashboard/viewmodels/dashboard_viewmodel.dart';
import 'package:dashboard/views/home.dart';
import 'package:dashboard/views/login.dart';
import 'package:dashboard/views/vincular_chave.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      _goTo(const LoginScreen());
    } else {
      final isFirst = await authService.isFirstLogin(user.uid);
      if (isFirst) {
        _goTo(VincularChaveScreen(uid: user.uid));
      } else {
        final iD = await authService.getChave(user.uid);
        final dados = await ApiService.fetchDados();
        final vendasUsuario = dados.where((v) => v.iD == iD).toList();
        _goTo(
          ChangeNotifierProvider(
            create: (_) => DashboardViewModel(vendasUsuario, iD ?? ''),
            child: const DashboardHome(),
          ),
        );
      }
    }
  }

  void _goTo(Widget page) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => page),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
