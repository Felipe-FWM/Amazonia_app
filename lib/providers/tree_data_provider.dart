import 'package:amazonia_app/providers/tree_data_provider.dart';
import 'package:amazonia_app/services/db_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amazonia_app/services/api_service.dart';
import 'package:amazonia_app/models/tree_model.dart';

class TreeDataProvider extends ChangeNotifier {
  List<TreeModel> trees = []; // Lista de árvores que será atualizada

  final ApiService apiService = ApiService();
  final DBService dbService = DBService();

  // Método para buscar dados da API
  Future<void> fetchTrees() async {
    try {
      // Buscando os dados da API
      List<TreeModel> fetchedTrees = await apiService.fetchTreeData();
      // Atualizando a lista de árvores
      trees = fetchedTrees;
      // Salvando os dados no banco de dados local
      await dbService.saveTreeData(trees);
      // Notificando os ouvintes (widgets que dependem dessa lista de árvores)
      notifyListeners();
    } catch (e) {
      print("Erro ao buscar dados da API: $e");
      // Aqui você pode optar por buscar os dados do cache em caso de erro
      loadCachedTrees();
    }
  }

  // Método para buscar dados do banco local (cache)
  Future<void> loadCachedTrees() async {
    try {
      // Tentando carregar dados do banco local
      List<TreeModel> cachedTrees = await dbService.getCachedTrees();
      // Se houver dados no banco local, vamos atualizá-los
      if (cachedTrees.isNotEmpty) {
        trees = cachedTrees;
        notifyListeners();
      } else {
        print("Nenhum dado encontrado no cache.");
      }
    } catch (e) {
      print("Erro ao carregar dados do banco: $e");
    }
  }

  // Método para atualizar dados - pode ser chamado para atualizar os dados tanto da API quanto do banco
  Future<void> updateTreeData() async {
    await fetchTrees(); // Atualiza com os dados da API e depois salva no banco local
  }

  // Método opcional para adicionar uma árvore à lista e no banco
  Future<void> addTree(TreeModel tree) async {
    trees.add(tree); // Adiciona na lista
    await dbService.saveTreeData(trees); // Atualiza o banco local
    notifyListeners(); // Notifica os ouvintes sobre a alteração
  }

  // Método opcional para remover uma árvore da lista e do banco
  Future<void> removeTree(TreeModel tree) async {
    trees.remove(tree); // Remove da lista
    await dbService.saveTreeData(trees); // Atualiza o banco local
    notifyListeners(); // Notifica os ouvintes sobre a alteração
  }
}
