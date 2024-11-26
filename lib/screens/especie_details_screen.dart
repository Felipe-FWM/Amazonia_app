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

  Widget _buildTopicTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _buildSubsection(String subtitle, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 4),
          Text(
            content.isNotEmpty ? content : 'Dados não disponíveis',
            style: TextStyle(fontSize: 14),
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

                        // Espécie
                        _buildTopicTitle("Espécie"),
                        _buildSubsection(
                          "Nome Científico",
                          especieDetails?['Especie']['nome_cientifico'] ?? '',
                        ),
                        _buildSubsection(
                          "Descrição",
                          especieDetails?['Especie']['descricao'] ?? '',
                        ),

                        // Taxonomia e Nomenclatura
                        _buildTopicTitle("Taxonomia e Nomenclatura"),
                        _buildSubsection(
                          "Divisão",
                          especieDetails?['Taxonomia']?['divisao'] ?? '',
                        ),
                        _buildSubsection(
                          "Clado",
                          especieDetails?['Taxonomia']?['clado'] ?? '',
                        ),
                        _buildSubsection(
                          "Ordem",
                          especieDetails?['Taxonomia']?['ordem'] ?? '',
                        ),
                        _buildSubsection(
                          "Família",
                          especieDetails?['Taxonomia']?['familia'] ?? '',
                        ),
                        _buildSubsection(
                          "Subfamília",
                          especieDetails?['Taxonomia']?['subfamilia'] ?? '',
                        ),
                        _buildSubsection(
                          "Gênero",
                          especieDetails?['Taxonomia']?['genero'] ?? '',
                        ),
                        _buildSubsection(
                          "Tribo",
                          especieDetails?['Taxonomia']?['tribo'] ?? '',
                        ),
                        _buildSubsection(
                          "Seção",
                          especieDetails?['Taxonomia']?['secao'] ?? '',
                        ),
                        _buildSubsection(
                          "Binômio específico",
                          especieDetails?['Taxonomia']?['binomio_especifico'] ?? '',
                        ),
                        _buildSubsection(
                          "Primeira publicação",
                          especieDetails?['Taxonomia']?['primeira_publicacao'] ?? '',
                        ),
                        _buildSubsection(
                          "Sinonímia botânica",
                          especieDetails?['Taxonomia']?['sinonimia_botanica'] ?? '',
                        ),
                        _buildSubsection(
                          "Nomes vulgares por Unidades da Federação",
                          especieDetails?['Taxonomia']?['nomes_vulgares_uf'] ?? '',
                        ),
                        _buildSubsection(
                          "Nomes vulgares no exterior",
                          especieDetails?['Taxonomia']?['nomes_vulgares_exter'] ?? '',
                        ),
                        _buildSubsection(
                          "Etimologia",
                          especieDetails?['Taxonomia']?['etimologia'] ?? '',
                        ),

                        // Descrição Botânica
                        _buildTopicTitle("Descrição Botânica"),
                        _buildSubsection(
                          "Forma biológica e foliação",
                          especieDetails?['DescricaoBotanica']?['forma_biologica_foliacao'] ?? '',
                        ),
                        _buildSubsection(
                          "Tronco",
                          especieDetails?['DescricaoBotanica']?['tronco'] ?? '',
                        ),
                        _buildSubsection(
                          "Ramificação",
                          especieDetails?['DescricaoBotanica']?['ramificacao'] ?? '',
                        ),
                        _buildSubsection(
                          "Casca",
                          especieDetails?['DescricaoBotanica']?['casca'] ?? '',
                        ),
                        _buildSubsection(
                          "Folhas",
                          especieDetails?['DescricaoBotanica']?['folhas'] ?? '',
                        ),
                        _buildSubsection(
                          "Inflorescências",
                          especieDetails?['DescricaoBotanica']?['inflorescencias'] ?? '',
                        ),
                        _buildSubsection(
                          "Flores",
                          especieDetails?['DescricaoBotanica']?['flores'] ?? '',
                        ),
                        _buildSubsection(
                          "Fruto",
                          especieDetails?['DescricaoBotanica']?['fruto'] ?? '',
                        ),
                        _buildSubsection(
                          "Sementes",
                          especieDetails?['DescricaoBotanica']?['sementes'] ?? '',
                        ),

                        // Biologia Reprodutiva e Eventos Fenológicos
                        _buildTopicTitle("Biologia Reprodutiva e Eventos Fenológicos"),
                        _buildSubsection(
                          "Sistema sexual",
                          especieDetails?['BiologiaReprodutiva']?['sistema_sexual'] ?? '',
                        ),
                        _buildSubsection(
                          "Vetor de polinização",
                          especieDetails?['BiologiaReprodutiva']?['vetor_polinizacao'] ?? '',
                        ),
                        _buildSubsection(
                          "Floração",
                          especieDetails?['BiologiaReprodutiva']?['floracao'] ?? '',
                        ),
                        _buildSubsection(
                          "Frutificação",
                          especieDetails?['BiologiaReprodutiva']?['frutificacao'] ?? '',
                        ),
                        _buildSubsection(
                          "Dispersão de frutos e sementes",
                          especieDetails?['BiologiaReprodutiva']?['dispersao_frutos_sementes'] ?? '',
                        ),
                        _buildSubsection(
                          "Qualidade das sementes",
                          especieDetails?['BiologiaReprodutiva']?['qualidade_sementes'] ?? '',
                        ),

                        // Ocorrência Natural
                        _buildTopicTitle("Ocorrência Natural"),
                        _buildSubsection(
                          "Latitudes",
                          especieDetails?['AspectosEcologicos']?['latitudes'] ?? '',
                        ),
                        _buildSubsection(
                          "Variação altitudinal",
                          especieDetails?['AspectosEcologicos']?['variacao_altitudinal'] ?? '',
                        ),
                        _buildSubsection(
                          "Mapa (Imagem)",
                          especieDetails?['AspectosEcologicos']?['mapa_imagem'] ?? '',
                        ),

                        // Aspectos Ecológicos
                        _buildTopicTitle("Aspectos Ecológicos"),
                        _buildSubsection(
                          "Grupo sucessional",
                          especieDetails?['AspectosEcologicos']?['grupo_sucessional'] ?? '',
                        ),
                        _buildSubsection(
                          "Importância sociológica",
                          especieDetails?['AspectosEcologicos']?['importancia_sociologica'] ?? '',
                        ),
                        _buildSubsection(
                          "Regeneração natural",
                          especieDetails?['AspectosEcologicos']?['regeneracao_natural'] ?? '',
                        ),

                        // Produtos e Utilizações
                        _buildTopicTitle("Produtos e Utilizações"),
                        _buildSubsection(
                          "Aproveitamento alimentar",
                          especieDetails?['ProdutosUtilizacoes']?['aproveitamento_alimentar'] ?? '',
                        ),
                        _buildSubsection(
                          "Apícola",
                          especieDetails?['ProdutosUtilizacoes']?['apicola'] ?? '',
                        ),
                        _buildSubsection(
                          "Celulose e papel",
                          especieDetails?['ProdutosUtilizacoes']?['celulose_papel'] ?? '',
                        ),
                        _buildSubsection(
                          "Energia",
                          especieDetails?['ProdutosUtilizacoes']?['energia'] ?? '',
                        ),
                        _buildSubsection(
                          "Madeira serrada e roliça",
                          especieDetails?['ProdutosUtilizacoes']?['madeira_serrada_rolica'] ?? '',
                        ),
                        _buildSubsection(
                          "Medicinal",
                          especieDetails?['ProdutosUtilizacoes']?['medicinal'] ?? '',
                        ),
                        _buildSubsection(
                          "Alerta",
                          especieDetails?['ProdutosUtilizacoes']?['alerta'] ?? '',
                        ),
                        _buildSubsection(
                          "Paisagístico",
                          especieDetails?['ProdutosUtilizacoes']?['paisagistico'] ?? '',
                        ),
                        _buildSubsection(
                          "Plantios com finalidade ambiental",
                          especieDetails?['ProdutosUtilizacoes']?['plantios_ambientais'] ?? '',
                        ),
                        _buildSubsection(
                          "Substâncias tanantes",
                          especieDetails?['ProdutosUtilizacoes']?['substancias_tanantes'] ?? '',
                        ),

                        // Composição – Potencial Biotecnológico
                        _buildTopicTitle("Composição – Potencial Biotecnológico"),
                        _buildSubsection(
                          "Variação do teor de carboidratos",
                          especieDetails?['ComposicaoBiotecnologica']?['variacao_carboidratos'] ?? '',
                        ),
                        _buildSubsection(
                          "Variação do teor de Proteínas",
                          especieDetails?['ComposicaoBiotecnologica']?['variacao_proteinas'] ?? '',
                        ),
                        _buildSubsection(
                          "Grupo substâncias",
                          especieDetails?['ComposicaoBiotecnologica']?['grupo_substancias'] ?? '',
                        ),
                        _buildSubsection(
                          "Levantamento bibliográfico",
                          especieDetails?['ComposicaoBiotecnologica']?['levantamento_bibliografico'] ?? '',
                        ),
                        _buildSubsection(
                          "Composição de nutrientes e uso como biofertilizante",
                          especieDetails?['ComposicaoBiotecnologica']?['biofertilizante'] ?? '',
                        ),

                        // Cultivo em viveiros
                        _buildTopicTitle("Cultivo em viveiros"),
                        _buildSubsection(
                          "Implantação de Viveiros Florestais Experimentais em Escolas",
                          especieDetails?['CultivoViveiros']?['implantacao_viveiros'] ?? '',
                        ),
                        _buildSubsection(
                          "Características Silviculturais",
                          especieDetails?['CultivoViveiros']?['caracteristicas_silviculturais'] ?? '',
                        ),
                        _buildSubsection(
                          "Hábito",
                          especieDetails?['CultivoViveiros']?['habito'] ?? '',
                        ),
                        _buildSubsection(
                          "Sistemas de plantio",
                          especieDetails?['CultivoViveiros']?['sistemas_plantio'] ?? '',
                        ),
                        _buildSubsection(
                          "Sistemas agroflorestais (SAFs)",
                          especieDetails?['CultivoViveiros']?['sistemas_agroflorestais'] ?? '',
                        ),
                        _buildSubsection(
                          "Crescimento e Produção",
                          especieDetails?['CultivoViveiros']?['crescimento_producao'] ?? '',
                        ),
                        _buildSubsection(
                          "Número de sementes por quilograma",
                          especieDetails?['CultivoViveiros']?['numero_sementes_por_kg'] ?? '',
                        ),
                        _buildSubsection(
                          "Tratamento pré-germinativo",
                          especieDetails?['CultivoViveiros']?['tratamento_pre_germinativo'] ?? '',
                        ),
                        _buildSubsection(
                          "Longevidade e armazenamento",
                          especieDetails?['CultivoViveiros']?['longevidade_armazenamento'] ?? '',
                        ),
                        _buildSubsection(
                          "Germinação em laboratório",
                          especieDetails?['CultivoViveiros']?['germinacao_lab'] ?? '',
                        ),

                        // Produção de Mudas
                        _buildTopicTitle("Produção de Mudas"),
                        _buildSubsection(
                          "Semeadura",
                          especieDetails?['ProducaoMudas']?['semeadura'] ?? '',
                        ),
                        _buildSubsection(
                          "Germinação",
                          especieDetails?['ProducaoMudas']?['germinacao'] ?? '',
                        ),
                        _buildSubsection(
                          "Associação simbiótica",
                          especieDetails?['ProducaoMudas']?['associacao_simbiotica'] ?? '',
                        ),
                        _buildSubsection(
                          "Cuidados especiais",
                          especieDetails?['ProducaoMudas']?['cuidados_especiais'] ?? '',
                        ),

                        // Principais Pragas
                        _buildTopicTitle("Principais Pragas"),
                        _buildSubsection(
                          "Pragas",
                          especieDetails?['Pragas']?['descricao'] ?? '',
                        ),

                        // Solos
                        _buildTopicTitle("Solos"),
                        _buildSubsection(
                          "Solos",
                          especieDetails?['Solos']?['descricao'] ?? '',
                        ),

                        // Anexo (Fotos complementares)
                        _buildTopicTitle("Anexo (Fotos complementares)"),
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
