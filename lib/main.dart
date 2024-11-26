import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amazonia_app/providers/auth_provider.dart';
import 'package:amazonia_app/providers/api_provider.dart';
import 'package:amazonia_app/screens/login_screen.dart';
import 'package:amazonia_app/screens/home_screen.dart';
import 'package:amazonia_app/screens/tree_details_screen.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _requestPermissions();

  runApp(MyApp());
}

Future<void> _requestPermissions() async {
  if (await Permission.storage.isDenied) {
    await Permission.storage.request();
  }

  if (await Permission.storage.isPermanentlyDenied) {
    openAppSettings();
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
        initialRoute: '/home',
        routes: {
          // '/': (ctx) => LoginScreen(),
          '/home': (ctx) => HomeScreen(),
          '/tree-details': (ctx) => TreeDetailsScreen(),
        },
      ),
    );
  }
}
