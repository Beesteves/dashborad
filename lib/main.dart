import 'package:dashboard/views/login.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'dart:ui' as ui;
import 'dart:html' as html;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kIsWeb) {
    // Registra o botão de login
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'google-signin-button',
      (int viewId) {
        final container = html.DivElement()
          ..id = 'g_id_signin'
          ..setAttribute('data-client_id', 'SEU_CLIENT_ID.apps.googleusercontent.com')
          ..setAttribute('data-type', 'standard')
          ..setAttribute('data-theme', 'outline')
          ..setAttribute('data-size', 'large')
          ..setAttribute('data-callback', 'handleCredentialResponse');

        return container;
      },
    );
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const LoginScreen(),
    );
  }
}
