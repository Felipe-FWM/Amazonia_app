import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amazonia_app/providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
@override
_LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
final _usernameController = TextEditingController();
final _passwordController = TextEditingController();
String? _errorMessage;
bool _obscurePassword = true; // Flag para ocultar/exibir a senha

// Função de login que chama o método do provider
Future<void> _login() async {
final authProvider = Provider.of<AuthProvider>(context, listen: false);
final success = await authProvider.login(
_usernameController.text,
_passwordController.text,
);

// Se login for bem-sucedido, redireciona para a tela principal
if (success) {
Navigator.pushReplacementNamed(context, '/home');
} else {
// Se falhar, exibe a mensagem de erro
setState(() {
_errorMessage = "Nome de usuário ou senha incorretos!";
});
}
}

// Função para alternar entre exibir e ocultar a senha
void _togglePasswordVisibility() {
setState(() {
_obscurePassword = !_obscurePassword;
});
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: Text("Login"),
backgroundColor: Colors.transparent, // AppBar sem fundo sólido
elevation: 0, // Sem sombra
),
body: Container(
decoration: BoxDecoration(
gradient: LinearGradient(
colors: [Colors.green.shade800, Colors.green.shade400], // Gradiente verde
begin: Alignment.topLeft,
end: Alignment.bottomRight,
),
),
child: Padding(
padding: const EdgeInsets.symmetric(horizontal: 24.0),
child: Center(
child: SingleChildScrollView(
child: Column(
mainAxisSize: MainAxisSize.min,
children: [
// Logo ou título grande (se necessário)
Text(
"Bem-vindo",
style: TextStyle(
fontSize: 32,
fontWeight: FontWeight.bold,
color: Colors.white,
),
),
SizedBox(height: 40),

// Campo de texto para o nome de usuário
TextField(
controller: _usernameController,
decoration: InputDecoration(
labelText: 'Usuário',
labelStyle: TextStyle(color: Colors.white),
filled: true,
fillColor: Colors.white.withOpacity(0.2), // Fundo suave
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(12),
borderSide: BorderSide.none,
),
contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
),
style: TextStyle(color: Colors.white),
),
SizedBox(height: 16),

// Campo de texto para a senha
TextField(
controller: _passwordController,
obscureText: _obscurePassword, // Utilizando o flag para ocultar/exibir a senha
decoration: InputDecoration(
labelText: 'Senha',
labelStyle: TextStyle(color: Colors.white),
filled: true,
fillColor: Colors.white.withOpacity(0.2),
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(12),
borderSide: BorderSide.none,
),
contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
suffixIcon: IconButton(
icon: Icon(
_obscurePassword ? Icons.visibility : Icons.visibility_off, // Altera o ícone
color: Colors.white,
),
onPressed: _togglePasswordVisibility, // Alterna a visibilidade da senha
),
),
style: TextStyle(color: Colors.white),
),
SizedBox(height: 24),

// Botão de login
ElevatedButton(
onPressed: _login,
style: ElevatedButton.styleFrom(
backgroundColor: Colors.green.shade600,
padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(12),
),
),
child: Text(
'Login',
style: TextStyle(fontSize: 18, color: Colors.white),
),
),

// Exibir mensagem de erro se houver
if (_errorMessage != null)
Padding(
padding: const EdgeInsets.only(top: 8.0),
child: Text(
_errorMessage!,
style: TextStyle(color: Colors.red, fontSize: 14),
),
),
],
),
),
),
),
),
);
}
}