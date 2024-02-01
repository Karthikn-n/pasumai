// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:app_3/data/encrypt_ids.dart';
import 'package:app_3/screens/order_history.dart';
import 'package:app_3/widgets/screen_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;



class OrderProducts extends StatefulWidget {
  final String appBar;
  final DateTime orderDate;
  final String orderId;
  final double totalAmount;
  final String totalItem;
  final List<Product> products;
  final DateTime deliveryDate;
  const OrderProducts({
    required this.appBar, 
    required this.orderDate, 
    required this.orderId,
    required this.totalAmount,
    required this.totalItem,
    required this.products,
    required this.deliveryDate,
    super.key});

  @override
  State<OrderProducts> createState() => _OrderProductsState();
}

class _OrderProductsState extends State<OrderProducts> {

  late OrderDetail orderDetail = OrderDetail(
    orderId: 0,
    orderedOn: '',
    total: '',
    status: '',
    qty: 0,
    address: '',
    productData: [],
  );


  @override
  void initState() {
    // 
    super.initState();
    sendData();
  }

  void sendData() async {
    Map<String, dynamic> userData = {'order_id' : UserId.getOrderId()};
    final jsonData = json.encode(userData);
    String encryptedData = encryptAES(jsonData);
    String url = 'http://pasumaibhoomi.com/api/orderdetail';
    final response = await http.post(Uri.parse(url), body: {'data' : encryptedData});

    if(response.statusCode == 200){
      print('Success: ${response.body}');
      final decryptedData = decryptAES(response.body);
      print("Decrypted: $decryptedData");
      final jsonResponse = json.decode(decryptedData);
      print('Response: $jsonResponse');
      setState(() {
        orderDetail = OrderDetail.fromJson(jsonResponse['results'][0]);
      });
      print('OrderId: ${orderDetail.orderId}');

    }
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: orderBar('Order details'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            heading('Order summary'),
            // Order details
            Container(
              // height: 180,
              width: 325,
              margin: const EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black26)
              ),
              child: Column(
                children: [
                  // Order date
                  Container(
                    margin: const EdgeInsets.only(left: 15, top: 15),
                    child: Row(
                      children: [
                        const Text(
                          'Order date',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w300
                          ),
                        ),
                        const SizedBox(width: 97,),
                        Expanded(
                          child: Text(
                            DateFormat('d MMM y').format(widget.orderDate),
                            // DateFormat('d MMM y').format(orderDetail.orderedOn),
                            // formattedOrderDate,
                            style: const TextStyle(
                              fontWeight: FontWeight.w400
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Order Id
                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    child: Row(
                      children: [
                        const Text(
                          'Order #',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w300
                          ),
                        ),
                        const SizedBox(width: 120,),
                        Expanded(
                          child: Text(
                            widget.orderId,
                            // orderDetail.orderId
                            // UserId.getOrderId()
                          ),
                        )
                      ],
                    ),
                  ),
                  // Order amount
                  Container(
                    margin: const EdgeInsets.only(left: 15, bottom: 15),
                    child: Row(
                      children: [
                        const Text(
                          'Order total',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w300
                          ),
                        ),
                        const SizedBox(width: 97,),
                        Expanded(
                          child: Row(
                            children: [
                              Text(
                                'Rs. ${widget.totalAmount}'
                                // 'Rs. ${orderDetail.total}'
                              ),
                              // const SizedBox(width: 4,),
                              Text(
                                '(${widget.totalItem} item)',
                                // '(${orderDetail.qty} item)',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            // shipment details
            heading('Shipment details'),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 10),
              height: 440,
              width: 325,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black26)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10, left: 15),
                    child: const Text(
                      'Products',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300
                      ),
                    ),
                  ),
                  // divider
                  const Divider(
                    thickness: 1,
                    color: Colors.black26,
                  ),
                  // delivery status
                  // Container(
                  //   margin: const EdgeInsets.only(left: 10, top: 8),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       const Text(
                  //         'Delivered',
                  //         style: TextStyle(
                  //           fontSize: 16,
                  //           fontWeight: FontWeight.w500
                  //         ),
                  //       ),
                  //       const Text(
                  //         'Delivered Date:',
                  //         style: TextStyle(
                  //           fontSize: 14,
                  //           fontWeight: FontWeight.w400
                  //         ),
                  //       ),
                  //       Text(
                  //         DateFormat('EEEE, d MMMM, y').format(widget.deliveryDate),
                  //         // DateFormat('EEEE, d MMMM, y').format(deliveryDate!),
                  //         // formattedDeliverDate,
                  //         style: const TextStyle(
                  //           fontSize: 14,
                  //           fontWeight: FontWeight.w600,
                  //           color: Colors.green
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                  
                  // list of products
                  productList(orderDetail.productData),
                ],
              ),
            ),
            heading('Shipping Address'),
            // Shipping address
            Container(
              margin: const EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 10),
              width: 325,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black26)
              ),
              // customer name
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 15, left: 15),
                    child: const Text(
                      'Ramanujam P',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                  // customer address
                  Container(
                    margin: const EdgeInsets.only(top: 8, left: 15, right: 8),
                    child: const Text(
                      'New No 22, Old No 31, Baghirathi Ammal Street, T Nagar, Chennai - Tamilnadu 600017,',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300
                      ),
                    ),
                  ),
                  // customer country
                  Container(
                    margin: const EdgeInsets.only(left: 15, bottom: 15),
                    child: const Text(
                      'India',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget productList(List<ProductDetail> productdetail){
    return SizedBox(
      height: 385,
      width: 325,
      child: ListView.builder(
        itemCount: widget.products.length,
        // itemCount: productdetail.length,
        itemBuilder: (context, index) {
          final product = widget.products[index];
          // final product = productdetail[index];
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black26)
            ),
            // height: 100,
            margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: Row(
              children: [
                // product image
                Container(
                  height: 90,
                  width: 90,
                  margin: const EdgeInsets.only(right: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      // imageUrl: product.imageURL,
                      imageUrl: product.imageURL,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // product name
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      // product.productName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                    const SizedBox(height: 4,),
                    // total amount
                    Row(
                      children: [
                        const Text(
                          'Total amount: ',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300
                          ),
                        ),
                        Text(
                          'Rs.${product.amount}',
                          // 'Rs.${product.price}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 4,),
                    // total count
                    Row(
                      children: [
                        const Text(
                          'Item count: ',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300
                          ),
                        ),
                        Text(
                          '${product.count} item',
                          // '${product.quantity} item',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400
                          ),
                        )
                      ],
                    ), 
                  ],
                )
              ],
            ),
          );
          
        },
      ),
    );
  }
 
  Widget heading(String title){
    return Container(
      margin: const EdgeInsets.only(left: 15, top: 10),
      child:  Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500
        ),
      ),
    );
  }

}



class OrderDetail {
  final int orderId;
  final String orderedOn;
  final String total;
  final String status;
  final int qty;
  final String address;
  final List<ProductDetail> productData;

  OrderDetail({
    required this.orderId,
    required this.orderedOn,
    required this.total,
    required this.status,
    required this.qty,
    required this.address,
    required this.productData,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    List<ProductDetail> products = (json['product_data'] as List)
        .map((productJson) => ProductDetail.fromJson(productJson))
        .toList();

    return OrderDetail(
      orderId: json['order_id'],
      orderedOn: json['ordered_on'],
      total: json['total'],
      status: json['status'],
      qty: json['qty'],
      address: json['address'],
      productData: products,
    );
  }
}

class ProductDetail {
  final int productId;
  final String productName;
  final int quantity;
  final String price;
  final String total;
  final String imageURL; // Add this property if it's present in your API response

  ProductDetail({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.total,
    required this.imageURL,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json) {
    return ProductDetail(
      productId: json['product_id'],
      productName: json['product_name'],
      quantity: json['quantity'],
      price: json['price'],
      total: json['total'],
      imageURL: json['imageURL'], // Update this with the actual property in your API response
    );
  }
}

