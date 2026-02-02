import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? oldPrice;
  final String image;
  final double rating;
  final String categoryId;
  final bool isTrending;
  final bool isNew;
  final bool isFavorite;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.oldPrice,
    required this.image,
    required this.rating,
    required this.categoryId,
    this.isTrending = false,
    this.isNew = false,
    this.isFavorite = false,
  });

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? oldPrice,
    String? image,
    double? rating,
    String? categoryId,
    bool? isTrending,
    bool? isNew,
    bool? isFavorite,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      oldPrice: oldPrice ?? this.oldPrice,
      image: image ?? this.image,
      rating: rating ?? this.rating,
      categoryId: categoryId ?? this.categoryId,
      isTrending: isTrending ?? this.isTrending,
      isNew: isNew ?? this.isNew,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        oldPrice,
        image,
        rating,
        categoryId,
        isTrending,
        isNew,
        isFavorite,
      ];
}
