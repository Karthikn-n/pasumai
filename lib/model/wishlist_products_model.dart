class WishlistProductsModel{
  final int productId;
  final String title;
  final String description;
  final String image;
  final String finalPrice;
  final String quantity;
  final int price;

  WishlistProductsModel({
    required this.productId,
    required this.title,
    required this.description,
    required this.image,
    required this.finalPrice,
    required this.quantity,
    required this.price,
  });


  Map toMap() => {
    "product_id": productId,
    "title": title,
    "description": description,
    "quantity": quantity,
    "image": image,
    "finalPrice": finalPrice,
    "price": price
  };

  factory WishlistProductsModel.fromMap(Map<String, dynamic> map) {
    return WishlistProductsModel(
      productId: map['product_id'], 
      title: map['title'], 
      finalPrice: map["final_price"].toString(),
      description: map["description"], 
      quantity: map["quantity"],
      image: map["image"], 
      price: map["price"]
    );
  }
}