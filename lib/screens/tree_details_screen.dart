import 'package:flutter/material.dart';
import 'package:amazonia_app/providers/api_provider.dart';
import 'package:provider/provider.dart';

class TreeDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final especieId = ModalRoute.of(context)!.settings.arguments as int;

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes da Espécie'),
      ),
      body: FutureBuilder(
        future: Provider.of<ApiProvider>(context, listen: false)
            .fetchEspecieDetails(context, especieId),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar detalhes!'));
          } else {
            final details = snapshot.data as Map<String, dynamic>;

            return SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    details['especies/$especieId']['nome'] ??
                        'Nome não encontrado',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    details['descricoes-botanicas/$especieId']?['descricao'] ??
                        '',
                  ),
                  SizedBox(height: 16),
                  Text('Biologia Reprodutiva:'),
                  Text(
                    details['biologias-reprodutivas/$especieId']?['descricao'] ??
                        '',
                  ),
                  SizedBox(height: 16),
                  // Continue adicionando os dados conforme necessário.
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
