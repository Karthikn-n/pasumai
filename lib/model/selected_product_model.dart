class SelectedProductModel{
  final int id;
  final String productName;
  final String productQuantity;
  final int quantityIndex;
  final int quantity;
  final int listPrice;
  final int finalPrice;

  SelectedProductModel({
    required this.id,
    required this.productName,
    required this.productQuantity,
    required this.quantityIndex,
    required this.quantity,
    required this.listPrice,
    required this.finalPrice,
  });

  // factory SelectedProductModel.fromMap(Map<String,>)
}