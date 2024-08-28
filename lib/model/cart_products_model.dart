class CartProducts{
  int id;
  String name;
  String price;
  String image;
  int quantity;
  String listPrice;
  String total;

  CartProducts({
    required this.id,
    required this.name,
    required this.price,
    required this.listPrice,
    required this.image,
    required this.quantity,
    required this.total
  });

  factory CartProducts.fromJson(Map<String, dynamic> json){
    return CartProducts(
      id: json['product_id'], 
      name: json['product_name'], 
      price: json['product_price'].toString(), 
      total: json['total'], 
      listPrice: json["price"].toString(),
      image: json['product_image'], 
      quantity: json['quantity']
    );
  }
}
