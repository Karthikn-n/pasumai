import 'package:app_3/model/ordered_product_model.dart';

class OrderInfo {
  final int orderId;
  final String orderOn;
  final String total;
  final String status;
  final int quantity;
  final String address;
  final List<ProductOrdered> products;

  OrderInfo({
    required this.orderId,
    required this.orderOn,
    required this.quantity,
    required this.address,
    required this.status,
    required this.total,
    required this.products,
  });

  factory OrderInfo.fromMap(Map<String, dynamic> map){
     return OrderInfo(
      orderId: map['order_id'],
      orderOn: map['ordered_on'].toString(),
      total: map['total'].toString(),
      status: map['status'],
      quantity: map['qty'],
      address: map['address'],
      products: List<ProductOrdered>.from(
        map['product_data'].map((json) => ProductOrdered.fromJson(json)).toList()),
    );
  }
}

