import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
final String apiUrl = "https://noodletop.com.br/api/amazonia";

// Função para pegar o token de autenticação
Future<String?> _getAuthToken() async {
// final prefs = await SharedPreferences.getInstance();
// return prefs.getString('auth_token');
return 'true';
}

// Função genérica para fazer GET
Future<dynamic> _get(String endpoint) async {
// final token = await _getAuthToken();
// if (token == null) {
// throw Exception('Token de autenticação não encontrado');
// }

final response = await http.get(
Uri.parse('$apiUrl/$endpoint'),
headers: {
'Content-Type': 'application/json',
// 'Authorization': 'Bearer $token', 
},
);

if (response.statusCode == 200) {
return json.decode(response.body);
} else {
throw Exception('Falha na requisição: ${response.statusCode}');
}
}

// Funções específicas para os endpoints

// Funções de "Especies"
Future<List<dynamic>> fetchEspecies() async {
return await _get('especies');
}

Future<Map<String, dynamic>> fetchEspecie(String id) async {
return await _get('especies/$id');
}

// Funções de "Taxonomias"
Future<List<dynamic>> fetchTaxonomias() async {
return await _get('taxonomias');
}

Future<Map<String, dynamic>> fetchTaxonomia(String id) async {
return await _get('taxonomias/$id');
}

// Funções de "Descricoes Botânicas"
Future<List<dynamic>> fetchDescricoesBotanicas() async {
return await _get('descricoes-botanicas');
}

Future<Map<String, dynamic>> fetchDescricaoBotanica(String id) async {
return await _get('descricoes-botanicas/$id');
}

// Funções de "Biologias Reprodutivas"
Future<List<dynamic>> fetchBiologiasReprodutivas() async {
return await _get('biologias-reprodutivas');
}

Future<Map<String, dynamic>> fetchBiologiaReprodutiva(String id) async {
return await _get('biologias-reprodutivas/$id');
}

// Funções de "Ocorrências Naturais"
Future<List<dynamic>> fetchOcorrenciasNaturais() async {
return await _get('ocorrencias-naturais');
}

Future<Map<String, dynamic>> fetchOcorrenciaNatural(String id) async {
return await _get('ocorrencias-naturais/$id');
}

// Funções de "Aspectos Ecológicos"
Future<List<dynamic>> fetchAspectosEcologicos() async {
return await _get('aspectos-ecologicos');
}

Future<Map<String, dynamic>> fetchAspectoEcologico(String id) async {
return await _get('aspectos-ecologicos/$id');
}

// Funções de "Produtos e Utilizações"
Future<List<dynamic>> fetchProdutosUtilizacoes() async {
return await _get('produtos-utilizacoes');
}

Future<Map<String, dynamic>> fetchProdutoUtilizacao(String id) async {
return await _get('produtos-utilizacoes/$id');
}

// Funções de "Composições Biotecnológicas"
Future<List<dynamic>> fetchComposicoesBiotecnologicas() async {
return await _get('composicoes-biotecnologicas');
}

Future<Map<String, dynamic>> fetchComposicaoBiotecnologica(String id) async {
return await _get('composicoes-biotecnologicas/$id');
}

// Funções de "Cultivos Viveiros"
Future<List<dynamic>> fetchCultivosViveiros() async {
return await _get('cultivos-viveiros');
}

Future<Map<String, dynamic>> fetchCultivoViveiro(String id) async {
return await _get('cultivos-viveiros/$id');
}

// Funções de "Produções de Mudas"
Future<List<dynamic>> fetchProdcoesMudas() async {
return await _get('prodcoes-mudas');
}

Future<Map<String, dynamic>> fetchProducaoMuda(String id) async {
return await _get('prodcoes-mudas/$id');
}

// Funções de "Pragas"
Future<List<dynamic>> fetchPragas() async {
return await _get('pragas');
}

Future<Map<String, dynamic>> fetchPraga(String id) async {
return await _get('pragas/$id');
}

// Funções de "Solos"
Future<List<dynamic>> fetchSolos() async {
return await _get('solos');
}

Future<Map<String, dynamic>> fetchSolo(String id) async {
return await _get('solos/$id');
}

// Funções de "Anexos"
Future<List<dynamic>> fetchAnexos() async {
return await _get('anexos');
}

Future<Map<String, dynamic>> fetchAnexo(String id) async {
return await _get('anexos/$id');
}

// Funções de "Usuários"
Future<List<dynamic>> fetchUsuarios() async {
return await _get('usuarios');
}

Future<Map<String, dynamic>> fetchUsuario(String id) async {
return await _get('usuarios/$id');
}

fetchTreeData() {}
}