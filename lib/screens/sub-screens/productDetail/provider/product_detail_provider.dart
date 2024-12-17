class ProductDetailProvider {
  static String selectedQuantity = "";

  static void setQuntity(String quantity){
    selectedQuantity = quantity;
  }

  static String get quantity => selectedQuantity;

  static List<String> get quantities => ["250ml", "500ml", "1000ml"];
}