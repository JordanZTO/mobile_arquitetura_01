class Product {
  final int id;
  final String title;
  final double price;
  final String image;
  final String description;
  final String category;
  final double? rating;
  final String? brand;
  final int? stock;
  final double? discountPercentage;
  final String? thumbnail;
  final List<String> images;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    required this.description,
    required this.category,
    this.rating,
    this.brand,
    this.stock,
    this.discountPercentage,
    this.thumbnail,
    this.images = const [],
  });
}
