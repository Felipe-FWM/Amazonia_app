import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amazonia_app/providers/auth_provider.dart';
import 'package:amazonia_app/providers/api_provider.dart';
import 'package:amazonia_app/screens/login_screen.dart';
import 'package:amazonia_app/screens/home_screen.dart';
import 'package:amazonia_app/screens/tree_details_screen.dart';

void main() {
  runApp(MyApp());
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
