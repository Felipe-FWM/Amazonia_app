import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:amazonia_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class ApiProvider with ChangeNotifier {
  final String baseUrl = "https://noodletop.com.br/api/amazonia";

  // Método para buscar as espécies
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

    print('AQUIIIIIIIIIII');
    print(response.body);



    print(response.statusCode);


    if (response.statusCode == 200) {
      return json.decode(response.body)['data'];
    } else {
      print('Erro ao buscar espécies: ${response.body}');
      throw Exception("Erro ao buscar espécies.");
    }
  }

  

  // Método para buscar os detalhes de uma espécie
  Future<Map<String, dynamic>> fetchEspecieDetails(BuildContext context, int id) async {
    final token = Provider.of<AuthProvider>(context, listen: false).authToken;

    if (token == null) {
      throw Exception("Token de autenticação não encontrado.");
    }

    final endpoints = [
      'especies/all/$id'
    ];

    print(endpoints);

    

    final futures = endpoints.map((endpoint) async {
      try {
        final response = await http.get(
          Uri.parse('$baseUrl/$endpoint'),
          headers: {
            'Content-Type': 'application/json',
          },
        );

        print('GRITANDOOOOOOOOOOOOOOOOOOOO');
        print('Endpoint: $endpoint, Status: ${response.statusCode}');
        print(response.body);

        if (response.statusCode == 200) {
          return MapEntry('data', json.decode(response.body)['data']);
        } else {
          return MapEntry('data', null);
        }
      } catch (e) {
        print('Erro ao buscar $endpoint: $e');
        return MapEntry('data', null);
      }
    });

    final results = await Future.wait(futures);

    print('MAPA JHONSONNNNN');
    print(results);
    return Map.fromEntries(results);
  }
}
