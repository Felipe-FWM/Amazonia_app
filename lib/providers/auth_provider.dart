import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
String? _authToken;

String? get authToken => _authToken;

// Função para fazer login e armazenar o token
Future<bool> login(String username, String password) async {
final response = await http.post(
Uri.parse('https://noodletop.com.br/api/amazonia/usuarios/login'),
headers: {'Content-Type': 'application/json'},
body: json.encode({
'email': username,
'senha': password,
}),
);

// Verificando a resposta
if (response.statusCode == 200) {
try {
final responseData = json.decode(response.body);
// Acessando o token no caminho correto
_authToken = responseData['data']['token'];

// Salvar token no SharedPreferences
final prefs = await SharedPreferences.getInstance();
await prefs.setString('auth_token', _authToken!);

notifyListeners();
return true;
} catch (e) {
print('Erro ao decodificar o JSON: $e');
return false;
}
} else {
print('Erro na requisição: ${response.statusCode}');
print('Body: ${response.body}');
return false;
}
}

// Função para obter o token do SharedPreferences
Future<void> loadAuthToken() async {
final prefs = await SharedPreferences.getInstance();
_authToken = prefs.getString('auth_token');
notifyListeners();
}

// Função para logout (limpar o token)
Future<void> logout() async {
final prefs = await SharedPreferences.getInstance();
await prefs.remove('auth_token');
_authToken = null;
notifyListeners();
}
}