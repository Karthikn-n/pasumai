import '../screens/products_list.dart';

class CartRepository {
  // Singleton instance
  static final CartRepository _instance = CartRepository._internal();

  // Private constructor
  CartRepository._internal();

  // Factory method to get the instance
  factory CartRepository() => _instance;

  // List to store added products
  // ignore: prefer_final_fields
  List<AddedProduct> _addedProducts = [];

  // Getter for added products
  List<AddedProduct> get addedProducts => _addedProducts;

  // Add product to the list
  void addProduct(AddedProduct product) {
    _addedProducts.add(product);
  }

  // Clear the list
  void clearProducts() {
    _addedProducts.clear();
  }
}
