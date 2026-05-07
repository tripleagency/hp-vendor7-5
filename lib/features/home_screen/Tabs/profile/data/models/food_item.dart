class FoodItem {
  final String id;
  final String name;
  final String price;
  final String imagePath;
  bool isPublished;

  FoodItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imagePath,
    this.isPublished = true,
  });
}
