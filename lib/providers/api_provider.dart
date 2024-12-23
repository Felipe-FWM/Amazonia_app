import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:amazonia_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class ApiProvider with ChangeNotifier {
final String baseUrl = "https://noodletop.com.br/api/amazonia";

Future<List<dynamic>> fetchEspecies(BuildContext context) async {
final token = Provider.of<AuthProvider>(context, listen: false).authToken;

if (token == null) {
throw Exception("Token de autenticação não encontrado.");
}

final response = await http.get(
Uri.parse('$baseUrl/especies'),
headers: {
'Content-Type': 'application/json',
'Authorization': 'Bearer $token',
},
);

if (response.statusCode == 200) {
return json.decode(response.body)['data'];
} else {
print('Erro ao buscar espécies: ${response.body}');
throw Exception("Erro ao buscar espécies.");
}
}

Future<Map<String, dynamic>> fetchEspecieDetails(BuildContext context, int id) async {
final token = Provider.of<AuthProvider>(context, listen: false).authToken;
if (token == null) {
throw Exception("Token de autenticação não encontrado.");
}

final endpoints = [
'especies/$id',
'descricoes-botanicas/$id',
'biologias-reprodutivas/$id',
'ocorrencias-naturais/$id',
'aspectos-ecologicos/$id',
'produtos-utilizacoes/$id',
'composicoes-biotecnologicas/$id',
'cultivos-viveiros/$id',
'prodcoes-mudas/$id',
'pragas/$id',
'solos/$id',
];

final futures = endpoints.map((endpoint) async {
try {
final response = await http.get(
Uri.parse('$baseUrl/$endpoint'),
headers: {
'Content-Type': 'application/json',
'Authorization': 'Bearer $token',
},
);

print('Endpoint: $endpoint, Status: ${response.statusCode}');
return MapEntry(endpoint, response.statusCode == 200 ? json.decode(response.body)['data'] : null);
} catch (e) {
print('Erro ao buscar $endpoint: $e');
return MapEntry(endpoint, null);
}
});

final results = await Future.wait(futures);
return Map.fromEntries(results);
}
}