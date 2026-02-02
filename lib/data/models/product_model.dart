import 'package:ecomservics/domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    super.oldPrice,
    required super.image,
    required super.rating,
    required super.categoryId,
    super.isTrending,
    super.isNew,
    super.isFavorite,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      oldPrice: json['oldPrice'] != null ? (json['oldPrice'] as num).toDouble() : null,
      image: json['image'] as String,
      rating: (json['rating'] as num).toDouble(),
      categoryId: json['categoryId'] as String,
      isTrending: json['isTrending'] as bool? ?? false,
      isNew: json['isNew'] as bool? ?? false,
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'oldPrice': oldPrice,
      'image': image,
      'rating': rating,
      'categoryId': categoryId,
      'isTrending': isTrending,
      'isNew': isNew,
      'isFavorite': isFavorite,
    };
  }
}
