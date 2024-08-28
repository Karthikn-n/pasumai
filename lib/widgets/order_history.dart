// // ignore_for_file: must_be_immutable, unused_field, avoid_print, unused_local_variable

// import 'dart:convert';

// import 'package:app_3/model/orders_model.dart';
// import 'package:app_3/screens/sub-screens/profile/order_detail.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// import '../data/encrypt_ids.dart';
// import 'screen_widgets.dart';

// Widget orderHistoryList(
//     OrderInfo order, BuildContext context, String customerId) {
//   double screenHeight = MediaQuery.of(context).size.height;
//   double screenWidth = MediaQuery.of(context).size.width;
//   return Container(
//       width: 410,
//       decoration: BoxDecoration(
//           border: Border.all(color: Colors.green.shade300),
//           borderRadius: BorderRadius.circular(8)),
//       margin: const EdgeInsets.only(
//         top: 10,
//         left: 12,
//         right: 10,
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               // product details
//               Container(
//                 margin: const EdgeInsets.only(left: 12, top: 10),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // order name
//                     SizedBox(
//                       // width: 300,
//                       child: Row(
//                         children: [
//                           SizedBox(
//                             width: 259,
//                             child: Text(
//                               'Ordered ID: ${order.orderId}',
//                               overflow: TextOverflow.ellipsis,
//                               style: const TextStyle(
//                                   fontSize: 18, fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 6,
//                     ),
//                     // order id
//                     SizedBox(
//                       width: 320,
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 // order Status
//                                 Row(
//                                   children: [
//                                     const Text(
//                                       'Status: ',
//                                       style: TextStyle(
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.w600),
//                                     ),
//                                     Text(
//                                       order.status,
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.w400,
//                                           color: order.status == 'Cancelled'
//                                               ? const Color.fromARGB(
//                                                   255, 192, 133, 133)
//                                               : const Color(0xFF60B47B)),
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(
//                                   height: 6,
//                                 ),
//                                 // order on date
//                                 Row(
//                                   children: [
//                                     const Text(
//                                       'Order on: ',
//                                       style: TextStyle(
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.w600),
//                                     ),
//                                     Text(
//                                       order.orderOn,
//                                       style: const TextStyle(
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w400),
//                                     ),
//                                     const Spacer(),
//                                     GestureDetector(
//                                       onTap: () => Navigator.of(context)
//                                           .push(PageRouteBuilder(
//                                         pageBuilder: (context, animation,
//                                                 secondaryAnimation) =>
//                                             OrderProducts(
//                                           orderOn: order.orderOn,
//                                           orderId: order.orderId,
//                                           totalItem: order.quantity,
//                                           address: order.address,
//                                           totalAmount: order.total,
//                                           status: order.status,
//                                           products: order.products,
//                                         ),
//                                         transitionsBuilder: (context, animation,
//                                             secondaryAnimation, child) {
//                                           const begin = Offset(1.0, 0.0);
//                                           const end = Offset.zero;
//                                           const curve = Curves.easeInOut;
//                                           var tween = Tween(
//                                                   begin: begin, end: end)
//                                               .chain(CurveTween(curve: curve));
//                                           var offsetAnimation =
//                                               animation.drive(tween);
//                                           return SlideTransition(
//                                               position: offsetAnimation,
//                                               child: child);
//                                         },
//                                       )),
//                                       child: const Icon(
//                                         Icons.arrow_forward_ios_rounded,
//                                         size: 26,
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                           // order detail page
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//           // Order quantity, price
//           Container(
//             margin: const EdgeInsets.only(left: 12, top: 10),
//             child: Row(
//               children: [
//                 // Text('Order toal: $totalItem'),
//                 const Text(
//                   'Total order: ',
//                   style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
//                 ),
//                 Text(
//                   '₹${order.quantity}',

//                   // '$totalAmount',
//                   style: const TextStyle(
//                       fontSize: 13, fontWeight: FontWeight.w400),
//                 ),
//                 const SizedBox(
//                   width: 20,
//                 ),
//                 const Text(
//                   'Total paid: ',
//                   style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
//                 ),
//                 Text(
//                   '₹${order.total}',
//                   // '$totalAmount',
//                   style: const TextStyle(
//                       fontSize: 13, fontWeight: FontWeight.w400),
//                 ),
//                 const SizedBox(
//                   width: 20,
//                 ),
//                 // Help button
//               ],
//             ),
//           ),
//           // Reorder button
//           Padding(
//             padding: const EdgeInsets.only(bottom: 10),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     print('Reorder button tapped');
//                     orderPerform(
//                         order.orderId,
//                         'https://maduraimarket.in/api/reorder',
//                         context,
//                         customerId);
//                   },
//                   child: Container(
//                     margin: const EdgeInsets.only(left: 12, top: 12, right: 12),
//                     height: screenWidth > 600 ? 30 : 40,
//                     width: 150,
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(8),
//                         color: const Color(0xFF60B47B)),
//                     child: const Center(
//                       child: Text(
//                         'Reorder',
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     print('Cancel');
//                     orderPerform(
//                         order.orderId,
//                         'https://maduraimarket.in/api/cancelorder',
//                         context,
//                         customerId);
//                     // orderList();
//                   },
//                   child: Container(
//                     margin: const EdgeInsets.only(top: 12),
//                     height: screenWidth > 600 ? 30 : 40,
//                     width: 150,
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(8),
//                         color: const Color.fromARGB(255, 224, 158, 158)),
//                     child: const Center(
//                       child: Text(
//                         'Cancel',
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
        
//         ],
//       ));

// }

// void orderPerform(
//   int id,
//   String url,
//   BuildContext context,
//   String customerId,
// ) async {
//   double screenHeight = MediaQuery.of(context).size.height;
//   double screenWidth = MediaQuery.of(context).size.width;
//   Map<String, dynamic> userData = {'customer_id': customerId, 'order_id': id};
//   String jsonData = json.encode(userData);
//   print('Json data: $jsonData');
//   String encryptData = encryptAES(jsonData);
//   print('Decrypted Data: $encryptData');
//   final response = await http.post(Uri.parse(url), body: {
//     'data': encryptData.replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '')
//   });
//     print('Success: ${response.body}');
//     String decryptedData = decryptAES(response.body);
//     decryptedData =
//         decryptedData.replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '');
//     print('Decrypted Dat: $decryptedData');
//     final responseJson = json.decode(decryptedData);
//     print('Response: $responseJson');
  
//   if (response.statusCode == 200) {
//     // orderList();
//     switch (responseJson['status']) {
//       case 'success':
//         showSnackBar(context, responseJson['message'], screenHeight,
//             screenWidth, screenWidth);
//         break;
//       case 'failure':
//         showSnackBar(context, responseJson['message'], screenHeight,
//             screenWidth, screenWidth);
//         break;
//       default:
//     }
//   }
// }

// // void orderList() async {
// //   SharedPreferences prefs = SharedPreferencesHelper.getSharedPreferences();
// //   Map<String, dynamic> userData = {
// //     'customer_id': prefs.getString('customerId') ?? '',
// //     'sort_by': '1y'
// //   };
// //   String url = 'https://maduraimarket.in/api/orderlist';
// //   String jsonData = json.encode(userData);
// //   print('Json order: $jsonData');
// //   final encryptedData = encryptAES(jsonData);
// //   print('Encrypted order data: $encryptedData');
// //   final response = await http.post(Uri.parse(url), body: {
// //     'data': encryptedData.replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '')
// //   });
// //   print('Response Order list: ${response.body}');
// //   List<OrderInfo> orderInfoData = [];
// //   if (response.statusCode == 200) {
// //     print('Success: ${response.statusCode}');
// //     print('Success: ${response.body}');
// //     String decryptedData = decryptAES(response.body);
// //     decryptedData =
// //         decryptedData.replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '');
// //     print('Decrypted Data: $decryptedData');
// //     final responseJson = json.decode(decryptedData);
// //     print('Response: $responseJson');

// //     // if (responseJson.containsKey('results') && responseJson['results'] is List) {
// //     List<dynamic> results = responseJson['results'] as List;
// //     for (var result in results) {
// //       if (result.containsKey('product_data') &&
// //           result['product_data'] is List) {
// //         List<dynamic> productsJson = result['product_data'] as List;
// //         List<ProductOrdered> productsOrdered =
// //             productsJson.map((json) => ProductOrdered.fromJson(json)).toList();

// //         OrderInfo orderInfo = OrderInfo(
// //           orderId: result['order_id'].toString(),
// //           orderDate: result['ordered_on'].toString(),
// //           orderQuantity: result['qty'].toString(),
// //           orderStatus: result['status'],
// //           address: result['address'],
// //           status: result['status'],
// //           totalAmount: result['total'].toString(),
// //           products: productsOrdered,
// //         );
// //         orderInfoData.add(orderInfo);
// //       }
// //     }
// //   } else {
// //     print('Failed to fetch data: ${response.statusCode}');
// //   }
// // }

// List<String> categoriesName = [
//   'Your Orders',
//   // 'Your Addresses',
//   'Subscription',
//   'Invoice Listing',
//   'Vacation'
// ];

// List<bool> isCategoryExpanded = List.generate(5, (index) => false);
