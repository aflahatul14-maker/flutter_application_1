class Produk {
  final String id;
  final String name;
  final double price;
  final String description;
  final String imagePath;

  Produk({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'imagePath': imagePath,
    };
  }

  factory Produk.fromMap(Map<String, dynamic> map) {
    return Produk(
      id: map['id'].toString(),
      name: map['name'] ?? '',
      price: (map['price'] as num).toDouble(),
      description: map['description'] ?? '',
      imagePath: map['imagePath'] ?? '',
    );
  }
}