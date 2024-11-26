import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/api_provider.dart';

class EspecieDetalhesScreen extends StatefulWidget {
  final String especieId;

  EspecieDetalhesScreen({required this.especieId});

  @override
  _EspecieDetalhesScreenState createState() => _EspecieDetalhesScreenState();
}

class _EspecieDetalhesScreenState extends State<EspecieDetalhesScreen> {
  Map<String, dynamic>? especieDetails;
  bool isLoading = true;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadEspecieDetalhes();
  }

  Future<void> _loadEspecieDetalhes() async {
    try {
      final apiProvider = Provider.of<ApiProvider>(context, listen: false);
      final data = await apiProvider.fetchEspecieDetails(
        context,
        int.parse(widget.especieId),
      );


      print('PRINTTTT AQUIIII');
      print(data['data']['Taxonomia']);
      print(data);
      
      setState(() {
        especieDetails = data['data']['Especie']; // Ajustando o acesso aos dados
        isLoading = false;
      });
    } catch (error) {
      print("Erro ao carregar detalhes da espécie: $error");
      setState(() {
        isLoading = false;
      });
    }
  }


  ImageProvider _base64ToImage(String base64String) {
    // Remover o prefixo 'data:image/png;base64,' (ou similar)
    final cleanBase64 = base64String.split(',').last;

    // Decodificar a string Base64 em bytes
    final bytes = base64Decode(cleanBase64);

    // Retornar uma MemoryImage com os bytes decodificados
    return MemoryImage(bytes);
  }



  // Função para alternar entre as telas ao clicar na Navigation Bar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Aqui você pode definir navegações para diferentes telas
    if (index == 0) {
      Navigator.pushNamed(context, '/home'); // Exemplo: tela inicial
    } else if (index == 1) {
      Navigator.pushNamed(context, '/map'); // Exemplo: tela de mapa
    } else if (index == 2) {
      Navigator.pushNamed(context, '/especies'); // Exemplo: lista de espécies
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes da Espécie'),
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
                        // Exibição da imagem
                        Container(
                          height: 250,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: (especieDetails?['imagem'] != null &&
                                      especieDetails!['imagem'].isNotEmpty)
                                  ? _base64ToImage(especieDetails!['imagem'])
                                  : AssetImage('assets/default_image.png')
                                      as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        // Exibição de cada seção com título e dados
                        buildSection(
                          title: "Nome Científico",
                          content: especieDetails?['nome_cientifico'] ??
                              'Dados não disponíveis',
                        ),
                        buildSection(
                          title: "Descrição",
                          content: especieDetails?['descricao'] ??
                              'Dados não disponíveis',
                        ),
                      ],
                    ),
                  ),
                ),
      // Adicionando o BottomNavigationBar personalizado flutuante
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Início',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.map),
                label: 'Mapa',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.nature),
                label: 'Espécies',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.green,
            onTap: _onItemTapped,
            elevation: 0, // Remove sombra padrão
            backgroundColor: Colors.transparent, // Deixa transparente
          ),
        ),
      ),
    );
  }

  // Widget para exibir uma seção com título e conteúdo
  Widget buildSection({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
