import 'package:ecomservics/data/models/category_model.dart';
import 'package:ecomservics/data/models/product_model.dart';

class StaticDataSource {
  Future<List<CategoryModel>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 800)); // Simulate network delay
    return [
      const CategoryModel(id: '1', name: 'Electronics', image: 'assets/images/electronics.png'),
      const CategoryModel(id: '2', name: 'Fashion', image: 'assets/images/fashion.png'),
      const CategoryModel(id: '3', name: 'Home', image: 'assets/images/home.png'),
      const CategoryModel(id: '4', name: 'Beauty', image: 'assets/images/beauty.png'),
      const CategoryModel(id: '5', name: 'Sports', image: 'assets/images/sports.png'),
    ];
  }

  Future<List<ProductModel>> getProducts({
    int page = 1,
    int limit = 10,
    String? categoryId,
    String? query,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    
    // Generate dummy products with real online images
    final List<String> productImages = [
      'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=800', // Headphones
      'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800', // Watch
      'https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=800', // Sunglasses
      'https://images.unsplash.com/photo-1491553895911-0055eca6402d?w=800', // Sneakers
      'https://images.unsplash.com/photo-1560343090-f0409e92791a?w=800', // Camera
      'https://images.unsplash.com/photo-1585386959984-a4155224a1ad?w=800', // Backpack
      'https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?w=800', // Laptop
      'https://images.unsplash.com/photo-1546868871-7041f2a55e12?w=800', // Smart Watch
      'https://images.unsplash.com/photo-1572635196184-84e35138cf62?w=800', // Bag
      'https://images.unsplash.com/photo-1567401893414-76b7b1e5a7a5?w=800', // Hoodie
    ];
    final List<String> productNames = [
      'Wireless Headphones',
      'Smart Watch Pro',
      'Designer Sunglasses',
      'Running Sneakers',
      'Professional Camera',
      'Travel Backpack',
      'Gaming Laptop',
      'Fitness Tracker',
      'Leather Bag',
      'Premium Hoodie',
    ];
    
    List<ProductModel> products = List.generate(
      50,
      (index) => ProductModel(
        id: 'chk_$index',
        name: productNames[index % productNames.length] + (index >= 10 ? ' ${(index ~/ 10) + 1}' : ''),
        description: 'High quality ${productNames[index % productNames.length].toLowerCase()} with premium features and modern design.',
        price: 100.0 + (index * 5),
        oldPrice: index % 2 == 0 ? 150.0 + (index * 5) : null,
        image: productImages[index % productImages.length],
        rating: 4.5,
        categoryId: '${(index % 5) + 1}',
        isTrending: index % 3 == 0,
        isNew: index < 5,
        isFavorite: false,
      ),
    );

    // Filter
    if (categoryId != null) {
      products = products.where((p) => p.categoryId == categoryId).toList();
    }
    if (query != null && query.isNotEmpty) {
      products = products.where((p) => p.name.toLowerCase().contains(query.toLowerCase())).toList();
    }

    // Pagination
    int startIndex = (page - 1) * limit;
    if (startIndex >= products.length) return [];
    
    int endIndex = startIndex + limit;
    if (endIndex > products.length) endIndex = products.length;

    return products.sublist(startIndex, endIndex);
  }
}
