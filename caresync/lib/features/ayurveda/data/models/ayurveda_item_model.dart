class AyurvedaItemModel {
  final String id;
  final String name;
  final String description;
  final String imagePath;

  AyurvedaItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imagePath,
  });

  factory AyurvedaItemModel.fromMap(Map<String, dynamic> map) {
    return AyurvedaItemModel(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      imagePath: map['imagePath']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imagePath': imagePath,
    };
  }
}
