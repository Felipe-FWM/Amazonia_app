import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:amazonia_app/providers/api_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:amazonia_app/screens/especie_details_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> _especies = [];
  List<dynamic> _filteredEspecies = [];
  bool _isLoading = true;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadEspecies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: Image.asset(
            'assets/logo_preta.png',
            height: 24,
            width: 24,
            fit: BoxFit.contain,
          ),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _isSearching = false;
                  _searchController.clear();
                  _filteredEspecies = _especies; // Restaura a lista original
                } else {
                  _isSearching = true;
                }
              });
            },
          ),
        ],
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "Buscar espécie...",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white70),
                ),
                style: TextStyle(color: Colors.white),
                onChanged: _filterEspecies,
              )
            : null,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _filteredEspecies.isEmpty
              ? Center(child: Text("Nenhuma espécie encontrada."))
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: _filteredEspecies.length,
                  itemBuilder: (context, index) {
                    final especie = _filteredEspecies[index];
                    final nomeCientifico = especie['nome_cientifico'] ?? 'Sem nome';
                    final descricao = especie['descricao'] ?? 'Sem descrição';
                    final imagem = especie['imagem'];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EspecieDetalhesScreen(
                              especieId: especie["id"].toString(),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 16),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Card(
                            elevation: 5,
                            shadowColor: Colors.black.withOpacity(0.2),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 200,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: (imagem != null && imagem.isNotEmpty)
                                          ? MemoryImage(_base64ToImage(imagem))
                                          : AssetImage('assets/default_image.png')
                                              as ImageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    nomeCientifico,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(
                                    descricao,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _refreshData,
        backgroundColor: Colors.green,
        child: Icon(Icons.refresh),
      ),
    );
  }

  void _filterEspecies(String query) {
    if (query.isEmpty) {
      setState(() => _filteredEspecies = _especies);
    } else {
      setState(() {
        _filteredEspecies = _especies
            .where((especie) =>
                (especie['nome_cientifico'] ?? '').toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  Future<void> _refreshData() async {
    setState(() => _isLoading = true);
    await _fetchEspecies();
  }

  Future<void> _fetchEspecies() async {
    try {
      final especies =
          await Provider.of<ApiProvider>(context, listen: false).fetchEspecies(context);
      if (especies.isNotEmpty) {
        setState(() {
          _especies = especies;
          _filteredEspecies = especies; // Atualiza a lista filtrada também
        });
        await _cacheEspecies(especies);
      } else {
        print('Nenhuma espécie encontrada.');
      }
    } catch (e) {
      print('Erro ao carregar espécies: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadEspecies() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString('especies');
    if (cachedData != null) {
      setState(() {
        _especies = List.from(json.decode(cachedData));
        _filteredEspecies = _especies;
      });
    }
    await _fetchEspecies();
  }

  Future<void> _cacheEspecies(List<dynamic> especies) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('especies', json.encode(especies));
  }

  Uint8List _base64ToImage(String base64String) {
    final cleanBase64 = base64String.split(',').last;
    return base64Decode(cleanBase64);
  }
}
