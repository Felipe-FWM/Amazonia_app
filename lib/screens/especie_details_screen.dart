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



                        //TABELA TAXONOMIA:
                        _buildSection(
                          "TAXONOMIA E NOMENCLATURA",
                          especieDetails?['Taxonomia']?['divisao'] ?? 'Dados não disponíveis',
                        ),

                         _buildSection(
                          "Clado",
                          especieDetails?['Taxonomia']?['clado'] ?? 'Dados não disponíveis',
                        ),

                        _buildSection(
                          "Ordem",
                          especieDetails?['Taxonomia']?['ordem'] ?? 'Dados não disponíveis',
                        ),

                        _buildSection(
                          "Família",
                          especieDetails?['Taxonomia']?['familia'] ?? 'Dados não disponíveis',
                        ),

                        _buildSection(
                          "Subfamília",
                          especieDetails?['Taxonomia']?['subfamilia'] ?? 'Dados não disponíveis',
                        ),

                        _buildSection(
                          "Gênero",
                          especieDetails?['Taxonomia']?['genero'] ?? 'Dados não disponíveis',
                        ),

                        _buildSection(
                          "Tribo",
                          especieDetails?['Taxonomia']?['tribo'] ?? 'Dados não disponíveis',
                        ),

                        _buildSection(
                          "Seção",
                          especieDetails?['Taxonomia']?['secao'] ?? 'Dados não disponíveis',
                        ),

                        _buildSection(
                          "Binômio específico",
                          especieDetails?['Taxonomia']?['binomio_especifico'] ?? 'Dados não disponíveis',
                        ),

                        _buildSection(
                          "Primeira publicação",
                          especieDetails?['Taxonomia']?['primeira_publicacao'] ?? 'Dados não disponíveis',
                        ),

                        _buildSection(
                          "Sinonímia botânica",
                          especieDetails?['Taxonomia']?['sinonimia_botanica'] ?? 'Dados não disponíveis',
                        ),


                        _buildSection(
                          "Nomes vulgares por Unidades da Federação",
                          especieDetails?['Taxonomia']?['nomes_vulgares_uf'] ?? 'Dados não disponíveis',
                        ),

                        _buildSection(
                          "Nomes vulgares no exterior",
                          especieDetails?['Taxonomia']?['nomes_vulgares_exter'] ?? 'Dados não disponíveis',
                        ),


                      //TABELA DESCRIÇÃO BOTÂNICA
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


                        //BIOLOGIA REPRODUTIVA E EVENTOS FENOLÓGICOS
                        _buildSection(
                          "Sistema sexual",
                          especieDetails?['BiologiaReprodutiva']?['sistema_sexual'] ?? 'Dados não disponíveis',
                        ),

                        _buildSection(
                          "Vetor de polinização",
                          especieDetails?['BiologiaReprodutiva']?['vetor_polinizacao'] ?? 'Dados não disponíveis',
                        ),

                        _buildSection(
                          "Floração",
                          especieDetails?['BiologiaReprodutiva']?['floracao'] ?? 'Dados não disponíveis',
                        ),

                        _buildSection(
                          "Frutificação",
                          especieDetails?['BiologiaReprodutiva']?['frutificacao'] ?? 'Dados não disponíveis',
                        ),

                        _buildSection(
                          "Dispersão de frutos e sementes",
                          especieDetails?['BiologiaReprodutiva']?['dispersao_frutos_sementes'] ?? 'Dados não disponíveis',
                        ),

                        _buildSection(
                          "Qualidade das sementes",
                          especieDetails?['BiologiaReprodutiva']?['qualidade_sementes'] ?? 'Dados não disponíveis',
                        ),


                      //OCORRÊNCIA NATURAL

                        _buildSection(
                              "Latidudes",
                              especieDetails?['AspectosEcologicos']?['latitudes'] ?? 'Dados não disponíveis',
                            ),

                        _buildSection(
                              "Variação altitudinal",
                              especieDetails?['AspectosEcologicos']?['variacao_altitudinal'] ?? 'Dados não disponíveis',
                            ),

                        _buildSection(
                              "Regeneração natural",
                              especieDetails?['AspectosEcologicos']?['mapa_imagem'] ?? 'Dados não disponíveis',
                            ),



                      //ASPECTOS ECOLÓGICOS


                        _buildSection(
                            "Grupo sucessional",
                            especieDetails?['AspectosEcologicos']?['grupo_sucessional'] ?? 'Dados não disponíveis',
                          ),


                        _buildSection(
                          "Importância Sociológica",
                          especieDetails?['AspectosEcologicos']?['importancia_sociologica'] ?? 'Dados não disponíveis',
                        ),

                        _buildSection(
                          "Regeneração natural",
                          especieDetails?['AspectosEcologicos']?['regeneracao_natural'] ?? 'Dados não disponíveis',
                        ),



                      //PRODUTOS E UTILIZAÇÕES
                        _buildSection(
                          "Aproveitamento alimentar",
                          especieDetails?['ProdutosUtilizacoes']?['aproveitamento_alimentar'] ?? 'Dados não disponíveis',
                        ),

                        _buildSection(
                          "Apícola",
                          especieDetails?['ProdutosUtilizacoes']?['apicola'] ?? 'Dados não disponíveis',
                        ),

                        _buildSection(
                          "Celulose e papel",
                          especieDetails?['ProdutosUtilizacoes']?['celulose_papel'] ?? 'Dados não disponíveis',
                        ),

                        _buildSection(
                          "Energia",
                          especieDetails?['ProdutosUtilizacoes']?['energia'] ?? 'Dados não disponíveis',
                        ),

                        _buildSection(
                          "Madeira serrada e roliça",
                          especieDetails?['ProdutosUtilizacoes']?['madeira_serrada_rolica'] ?? 'Dados não disponíveis',
                        ),

                        _buildSection(
                          "Medicinal",
                          especieDetails?['ProdutosUtilizacoes']?['medicinal'] ?? 'Dados não disponíveis',
                        ),

                        _buildSection(
                          "Alerta",
                          especieDetails?['ProdutosUtilizacoes']?['alerta'] ?? 'Dados não disponíveis',
                        ),

                        _buildSection(
                          "Paisagístico",
                          especieDetails?['ProdutosUtilizacoes']?['paisagistico'] ?? 'Dados não disponíveis',
                        ),

                        _buildSection(
                          "Plantios com finalidade ambiental",
                          especieDetails?['ProdutosUtilizacoes']?['plantios_ambientais'] ?? 'Dados não disponíveis',
                        ),

                        _buildSection(
                          "Substâncias tanantes",
                          especieDetails?['ProdutosUtilizacoes']?['substancias_tanantes'] ?? 'Dados não disponíveis',
                        ),



                      //Composição – Potencial Biotecnológico

                        _buildSection(
                            "Variação do teor de carboidratos",
                            especieDetails?['ComposicaoBiotecnologica']?['variacao_carboidratos'] ?? 'Dados não disponíveis',
                          ),

                        _buildSection(
                            "Variação do teor de Proteínas",
                            especieDetails?['ComposicaoBiotecnologica']?['variacao_proteinas'] ?? 'Dados não disponíveis',
                          ),
                        
                        _buildSection(
                            "Grupo substâncias",
                            especieDetails?['ComposicaoBiotecnologica']?['grupo_substancias'] ?? 'Dados não disponíveis',
                          ),

                        _buildSection(
                            "Levantamento bibliográfico",
                            especieDetails?['ComposicaoBiotecnologica']?['levantamento_bibliografico'] ?? 'Dados não disponíveis',
                          ),

                        _buildSection(
                            "Composição de nutrientes e uso como biofertilizante",
                            especieDetails?['ComposicaoBiotecnologica']?['biofertilizante'] ?? 'Dados não disponíveis',
                          ),



                        //CULTIVO EM VIVEIROS
                        
                        _buildSection(
                          "Implantação de Viveiros Florestais Experimentais em Escolas",
                          especieDetails?['CultivoViveiros']?['implantacao_viveiros'] ?? 'Dados não disponíveis',
                        ),

                        _buildSection(
                          "Características Silviculturais",
                          especieDetails?['CultivoViveiros']?['caracteristicas_silviculturais'] ?? 'Dados não disponíveis',
                        ),

                        _buildSection(
                          "Hábito",
                          especieDetails?['CultivoViveiros']?['habito'] ?? 'Dados não disponíveis',
                        ),

                        _buildSection(
                          "Sistemas de plantio",
                          especieDetails?['CultivoViveiros']?['sistemas_plantio'] ?? 'Dados não disponíveis',
                        ),

                        _buildSection(
                          "Sistemas agroflorestais (SAFs)",
                          especieDetails?['CultivoViveiros']?['sistemas_agroflorestais'] ?? 'Dados não disponíveis',
                        ),

                        _buildSection(
                          "Crescimento e Produção",
                          especieDetails?['CultivoViveiros']?['crescimento_producao'] ?? 'Dados não disponíveis',
                        ),

                        _buildSection(
                          "Número de sementes por quilograma",
                          especieDetails?['CultivoViveiros']?['numero_sementes_por_kg'] ?? 'Dados não disponíveis',
                        ),

                        _buildSection(
                          "Tratamento pré-germinativo",
                          especieDetails?['CultivoViveiros']?['tratamento_pre_germinativo'] ?? 'Dados não disponíveis',
                        ),

                        _buildSection(
                          "Longevidade e armazenamento",
                          especieDetails?['CultivoViveiros']?['longevidade_armazenamento'] ?? 'Dados não disponíveis',
                        ),

                        _buildSection(
                          "Germinação em laboratório",
                          especieDetails?['CultivoViveiros']?['germinacao_laboratorio'] ?? 'Dados não disponíveis',
                        ),


                      //PRODUÇÃO DE MUDAS
                         _buildSection(
                          "Semeadura",
                          especieDetails?['ProducaoMudas']?['semeadura'] ?? 'Dados não disponíveis',
                        ),

                         _buildSection(
                          "Germinação",
                          especieDetails?['ProducaoMudas']?['germinacao'] ?? 'Dados não disponíveis',
                        ),

                         _buildSection(
                          "Associação simbiótica",
                          especieDetails?['ProducaoMudas']?['associacao_simbiotica'] ?? 'Dados não disponíveis',
                        ),

                         _buildSection(
                          "Cuidados especiais",
                          especieDetails?['ProducaoMudas']?['cuidados_especiais'] ?? 'Dados não disponíveis',
                        ),


                        //PRINCIPAIS PRAGAS
                        _buildSection(
                          "Pragas",
                          especieDetails?['Pragas']?['descricao'] ?? 'Dados não disponíveis',
                        ),

                        //SOLOS
                        _buildSection(
                          "Solos",
                          especieDetails?['Solos']?['descricao'] ?? 'Dados não disponíveis',
                        ),

                        //ANEXOS
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
      
    
    );
  }
}
