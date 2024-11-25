class TreeModel {
final String id;
final String name;
final String imageUrl;
final String botanicalDescription;
final String reproductiveBiology;
final String ecologicalAspects;
final String usage;

TreeModel({
required this.id,
required this.name,
required this.imageUrl,
required this.botanicalDescription,
required this.reproductiveBiology,
required this.ecologicalAspects,
required this.usage,
});

// Método para converter JSON para objeto TreeModel
factory TreeModel.fromJson(Map<String, dynamic> json) {
return TreeModel(
id: json['id'],
name: json['name'],
imageUrl: json['image_url'],
botanicalDescription: json['botanical_description'],
reproductiveBiology: json['reproductive_biology'],
ecologicalAspects: json['ecological_aspects'],
usage: json['usage'],
);
}

// Método para converter Map para objeto TreeModel (para armazenar no banco)
factory TreeModel.fromMap(Map<String, dynamic> map) {
return TreeModel(
id: map['id'],
name: map['name'],
imageUrl: map['image_url'],
botanicalDescription: map['botanical_description'],
reproductiveBiology: map['reproductive_biology'],
ecologicalAspects: map['ecological_aspects'],
usage: map['usage'],
);
}

// Método para converter TreeModel para Map (para armazenar no banco)
Map<String, dynamic> toMap() {
return {
'id': id,
'name': name,
'image_url': imageUrl,
'botanical_description': botanicalDescription,
'reproductive_biology': reproductiveBiology,
'ecological_aspects': ecologicalAspects,
'usage': usage,
};
}

// Método para converter TreeModel para JSON (para enviar para a API)
Map<String, dynamic> toJson() {
return {
'id': id,
'name': name,
'image_url': imageUrl,
'botanical_description': botanicalDescription,
'reproductive_biology': reproductiveBiology,
'ecological_aspects': ecologicalAspects,
'usage': usage,
};
}
}