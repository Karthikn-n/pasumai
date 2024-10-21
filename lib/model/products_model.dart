class Products{
  final int id;
  final String name;
  final int price;
  final int finalPrice;
  final String? productPosition;
  final String image;
  final String quantity;
  final String description;
  final String? subscribed;
  final int? categoryId;
  final String? offerAmount;

  Products({
    required this.id,
    required this.name,
    required this.price,
    required this.finalPrice,
    required this.image,
    required this.quantity,
    required this.description,
    this.subscribed,
    this.productPosition,
    this.categoryId,
    this.offerAmount,
  });

  factory Products.fromJson(Map<String, dynamic> json){
    return Products(
      id: json['id'] ?? 0, 
      name: json['title'] ?? '', 
      price: json['price'] ?? 0, 
      finalPrice: json['final_price'] ?? 0, 
      image: json['image'] ?? '', 
      quantity: json['quantity'] ?? '',
      productPosition: json["product_position"],
      description: json['description'] ?? '',
      subscribed: json["subscription_status"] ?? "",
      categoryId: json["cat_id"] ?? 0,
      offerAmount: json["offers"].toString()
    );
  }
  Map<String, dynamic> toJson() {
    final results = <String, dynamic>{};

    results.addAll({'id': id});
    results.addAll({'title': name});
    results.addAll({'price': price});
    results.addAll({'final_price': finalPrice});
    results.addAll({'image': image});
    results.addAll({'quantity': quantity});
    results.addAll({'description': description});
    return results;
  }
 }
