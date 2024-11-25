import 'dart:convert';
import 'package:flutter/material.dart';

class TreeCard extends StatelessWidget {
final String nomeCientifico;
final String? base64Image;
final VoidCallback onTap;

const TreeCard({
Key? key,
required this.nomeCientifico,
required this.base64Image,
required this.onTap,
}) : super(key: key);

@override
Widget build(BuildContext context) {
return GestureDetector(
onTap: onTap,
child: Card(
margin: const EdgeInsets.all(10),
child: Stack(
children: [
// Background com imagem
if (base64Image != null)
Positioned.fill(
child: Opacity(
opacity: 0.5,
child: Image.memory(
base64Decode(base64Image!),
fit: BoxFit.cover,
),
),
),
// Conteúdo do Card
Padding(
padding: const EdgeInsets.all(16.0),
child: Text(
nomeCientifico,
style: const TextStyle(
fontSize: 18,
fontWeight: FontWeight.bold,
),
),
),
],
),
),
);
}
}