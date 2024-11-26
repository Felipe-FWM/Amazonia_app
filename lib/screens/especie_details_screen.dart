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

      setState(() {
        especieDetails = data['data'];
        isLoading = false;
      });
      print('AMIGO ESTOU AQUI');
      print(data['data']);
    } catch (error) {
      print("Erro ao carregar detalhes da espécie: $error");
      setState(() {
        isLoading = false;
      });
    }
  }

  ImageProvider _base64ToImage(String base64String) {
    final cleanBase64 = base64String.split(',').last;
    final bytes = base64Decode(cleanBase64);
    return MemoryImage(bytes);
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          SizedBox(height: 4),
          Text(
            content.isNotEmpty ? content : 'Dados não disponíveis',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection(String imageBase64) {
    return imageBase64.isNotEmpty
        ? Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: _base64ToImage(imageBase64),
                fit: BoxFit.cover,
              ),
            ),
          )
        : SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes da Espécie'),
        backgroundColor: Colors.green,
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
                        // Exibição da imagem da espécie
                        _buildImageSection(especieDetails?['Especie']['imagem'] ?? ''),
                        
                        // Exibição do nome científico e descrição
                        _buildSection(
                          "Nome Científico",
                          especieDetails?['Especie']['nome_cientifico'] ?? 'Dados não disponíveis',
                        ),
                        _buildSection(
                          "Descrição",
                          especieDetails?['Especie']['descricao'] ?? 'Dados não disponíveis',
                        ),



                        // Exibição das outras seções diretamente
                        _buildSection(
                          "Taxonomia e Nomenclatura",
                          especieDetails?['Taxonomia']?['divisao'] ?? 'Dados não disponíveis',
                        ),

                         _buildSection(
                          "Clado",
                          especieDetails?['Taxonomia']?['clado'] ?? 'Dados não disponíveis',
                        ),

                        _buildSection(
                          "Regeneração Natural",
                          especieDetails?['AspectosEcologicos']?['regeneracao_natural'] ?? 'Dados não disponíveis',
                        ),
                        _buildSection(
                          "Aproveitamento",
                          especieDetails?['ProdutosUtilizacoes']?['aproveitamento_alimentar'] ?? 'Dados não disponíveis',
                        ),
                        _buildSection(
                          "Biotecnológico Energético",
                          especieDetails?['ComposicaoBiotecnologica']?['variacao_carboidratos'] ?? 'Dados não disponíveis',
                        ),
                        _buildSection(
                          "Biologia Reprodutiva",
                          especieDetails?['BiologiaReprodutiva']?['sistema_sexual'] ?? 'Dados não disponíveis',
                        ),
                        _buildSection(
                          "Aspectos Ecológicos",
                          especieDetails?['AspectosEcologicos']?['importancia_sociologica'] ?? 'Dados não disponíveis',
                        ),
                        _buildSection(
                          "Produtos e Utilizações",
                          especieDetails?['ProdutosUtilizacoes']?['celulose_papel'] ?? 'Dados não disponíveis',
                        ),
                        _buildSection(
                          "Cultivo em Viveiros",
                          especieDetails?['CultivoViveiros']?['implantacao_viveiros'] ?? 'Dados não disponíveis',
                        ),
                        _buildSection(
                          "Produção de Mudas",
                          especieDetails?['ProducaoMudas']?['semeadura'] ?? 'Dados não disponíveis',
                        ),
                        _buildSection(
                          "Pragas",
                          especieDetails?['Pragas']?['descricao'] ?? 'Dados não disponíveis',
                        ),
                        _buildSection(
                          "Solos",
                          especieDetails?['Solos']?['descricao'] ?? 'Dados não disponíveis',
                        ),

                        // Se a seção de anexos for não vazia
                        if (especieDetails?['Anexos'] != null)
                          ...especieDetails?['Anexos'].map<Widget>((anexo) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (anexo['imagem'] != null)
                                    Image.memory(
                                      base64Decode(anexo['imagem'].split(',').last),
                                      fit: BoxFit.cover,
                                      height: 200,
                                      width: double.infinity,
                                    ),
                                  if (anexo['legenda'] != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        anexo['legenda'] ?? '',
                                        style: TextStyle(fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          }).toList(),

                      ],
                    ),
                  ),
                ),
      
      // BottomNavigationBar personalizado
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
            currentIndex: 0,
            selectedItemColor: Colors.green,
            onTap: (index) {
              if (index == 0) {
                Navigator.pushNamed(context, '/home');
              } else if (index == 1) {
                Navigator.pushNamed(context, '/map');
              } else if (index == 2) {
                Navigator.pushNamed(context, '/especies');
              }
            },
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
        ),
      ),
    );
  }
}
