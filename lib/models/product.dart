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

  factory Product.fromJson(Map<String, dynamic> json) {
    double? extractedRating;
    final rating = json["rating"];
    if (rating is num) {
      extractedRating = rating.toDouble();
    } else if (rating is Map) {
      extractedRating = (rating["rate"] as num?)?.toDouble();
    }

    final images =
        (json["images"] as List?)?.whereType<String>().toList() ??
        const <String>[];
    final thumbnail = json["thumbnail"] as String?;
    final image =
        json["image"] as String? ??
        thumbnail ??
        (images.isNotEmpty ? images.first : "");

    return Product(
      id: json["id"],
      title: json["title"],
      price: (json["price"] as num).toDouble(),
      image: image,
      description: json["description"] ?? "",
      category: json["category"] ?? "",
      rating: extractedRating,
      brand: json["brand"],
      stock: (json["stock"] as num?)?.toInt(),
      discountPercentage: (json["discountPercentage"] as num?)?.toDouble(),
      thumbnail: thumbnail,
      images: images,
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
      "brand": brand,
      "stock": stock,
      "discountPercentage": discountPercentage,
      "thumbnail": thumbnail,
      "images": images,
    };
  }
}
