import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amazonia_app/providers/auth_provider.dart';
import 'package:amazonia_app/providers/api_provider.dart';
import 'package:amazonia_app/screens/login_screen.dart';
import 'package:amazonia_app/screens/home_screen.dart';
import 'package:amazonia_app/screens/tree_details_screen.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  // Inicialize o Flutter e aguarde a verificação de permissões
  WidgetsFlutterBinding.ensureInitialized();

  // Solicite permissões
  await _requestPermissions();

  runApp(MyApp());
}

Future<void> _requestPermissions() async {
  // Solicitar permissão de armazenamento para Android 10 ou superior
  if (await Permission.storage.isDenied) {
    await Permission.storage.request();
  }

  // Verificar se as permissões foram concedidas, caso contrário, mostre uma mensagem ou trate o erro
  if (await Permission.storage.isPermanentlyDenied) {
    openAppSettings();  // Abre as configurações do aplicativo para o usuário conceder a permissão manualmente
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ApiProvider()),
      ],
      child: MaterialApp(
        title: 'Amazônia App',
        theme: ThemeData(primarySwatch: Colors.green),
        initialRoute: '/',
        routes: {
          '/': (ctx) => LoginScreen(),
          '/home': (ctx) => HomeScreen(),
          '/tree-details': (ctx) => TreeDetailsScreen(),
        },
      ),
    );
  }
}
