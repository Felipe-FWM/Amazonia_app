import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../providers/api_provider.dart';
import '../providers/auth_provider.dart';

class EspecieDetalhesScreen extends StatefulWidget {
  final String especieId;

  EspecieDetalhesScreen({required this.especieId});

  @override
  _EspecieDetalhesScreenState createState() => _EspecieDetalhesScreenState();
}

class _EspecieDetalhesScreenState extends State<EspecieDetalhesScreen> {
  Map<String, dynamic>? especieDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEspecieDetalhes();
  }

  Future<void> _loadEspecieDetalhes() async {
    try {
      // Obtém a instância do ApiProvider e AuthProvider
      final apiProvider = Provider.of<ApiProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Verifica se o token está disponível
      if (authProvider.authToken == null) {
        throw Exception("Token de autenticação não encontrado.");
      }

      // Faz a requisição para buscar os detalhes da espécie
      final data = await apiProvider.fetchEspecieDetails(context, int.parse(widget.especieId));

      setState(() {
        especieDetails = data;
        isLoading = false;
      });

      // Adicionando um log para verificar o que está sendo retornado pela API
      print("Detalhes da espécie recebidos: $especieDetails");

    } catch (error) {
      print("Erro ao carregar detalhes da espécie: $error");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(especieDetails?['taxonomias/especie/${widget.especieId}']?['nome_comum'] ?? 'Detalhes da Espécie'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : especieDetails == null
              ? Center(child: Text("Erro ao carregar os detalhes da espécie."))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Exibir imagem se a URL da imagem estiver disponível
                        if (especieDetails?['taxonomias/especie/${widget.especieId}']?['imagem_url'] != null)
                          CachedNetworkImage(
                            imageUrl: especieDetails?['taxonomias/especie/${widget.especieId}']?['imagem_url'] ?? '',
                            placeholder: (context, url) => CircularProgressIndicator(),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                            height: 250,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        SizedBox(height: 16),

                        // Exibindo nome comum, com verificação de nulidade
                        Text(
                          especieDetails?['taxonomias/especie/${widget.especieId}']?['nome_comum'] ?? 'Nome comum indisponível',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),

                        // Exibindo nome científico, com verificação de nulidade
                        Text(
                          especieDetails?['taxonomias/especie/${widget.especieId}']?['nome_cientifico'] ?? 'Nome científico indisponível',
                          style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                        ),
                        SizedBox(height: 16),

                        // Exibindo descrição botânica com verificação de nulidade
                        Text(
                          "Descrição Botânica:",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          especieDetails?['descricoes-botanicas/especie/${widget.especieId}']?['descricao'] ?? 'Descrição não disponível.',
                        ),
                        SizedBox(height: 16),

                        // Exibindo biologia reprodutiva com verificação de nulidade
                        Text(
                          "Biologia Reprodutiva:",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          especieDetails?['biologias-reprodutivas/especie/${widget.especieId}'] ?? 'Informação não disponível.',
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
