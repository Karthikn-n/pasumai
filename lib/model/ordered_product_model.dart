class ProductOrdered {
  final int productId;
  final String productName;
  final int quantity;
  final String price;
  final String total;

  ProductOrdered({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.total,
  });

  factory ProductOrdered.fromJson(Map<String, dynamic> json) {
    return ProductOrdered(
      productId: json['product_id'],
      productName: json['product_name'],
      quantity: json['quantity'],
      price: json['price'],
      total: json['total'].toString(),
    );
  }
}
