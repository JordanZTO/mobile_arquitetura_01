class Product {
  final int id;
  final String title;
  final double price;
  final String image;
  final String description;
  final String category;
  final double? rating;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    required this.description,
    required this.category,
    this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    double? extractedRating;
    try {
      if (json["rating"] != null && json["rating"] is Map) {
        extractedRating = (json["rating"]["rate"] as num?)?.toDouble();
      }
    } catch (e) {
      extractedRating = null;
    }

    return Product(
      id: json["id"],
      title: json["title"],
      price: (json["price"] as num).toDouble(),
      image: json["image"],
      description: json["description"] ?? "",
      category: json["category"] ?? "",
      rating: extractedRating,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "price": price,
      "image": image,
      "description": description,
      "category": category,
      "rating": rating,
    };
  }
}
