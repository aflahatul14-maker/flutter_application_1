class CartItem {
  final String id;
  final String title;
  final double price;
  final String imagePath;
  int quantity;

  CartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.imagePath,
    this.quantity = 1,
  });
}