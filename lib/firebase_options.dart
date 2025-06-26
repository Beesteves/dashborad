import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform => web;

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAra40A2srVn7RDjx2gYPgIv41BKrNCjvo',
    authDomain: 'dashboard-movimentacoes.firebaseapp.com',
    projectId: 'dashboard-movimentacoes',
    storageBucket: 'dashboard-movimentacoes.firebasestorage.app',
    messagingSenderId: '196444884479',
    appId: '1:196444884479:web:6d817b1ba51b435e272bca',
  );
}
