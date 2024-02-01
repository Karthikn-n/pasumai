// ignore_for_file: must_be_immutable, unused_field, avoid_print, unused_local_variable

import 'dart:async';
import 'dart:convert';

import 'package:app_3/screens/order_detail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../data/common_data.dart';
import '../data/encrypt_ids.dart';
import '../widgets/screen_widgets.dart';

//  List<String> orderImages = [
//   'assets/logo/order1.jpg',
//   'assets/logo/order2.avif',
//   'assets/logo/order3.avif'
//  ];
// sample orders 
List<Order> orders = [
    Order(
      // Image.asset(orderImages[0]) ,
      "Order Number 1", '124956',DateTime(2023, 12, 03), DateTime(2023, 12, 10), '1' ,50.0,  
      [
        Product(name: 'Product 1', imageURL: products[0], count: 2, amount: 20.0),
        Product(name: 'Product 2', imageURL: products[1], count: 1, amount: 30.0),
        Product(name: 'Product 3', imageURL: products[2], count: 1, amount: 50.0),
        Product(name: 'Product 4', imageURL: products[3], count: 1, amount: 10.0),
      ],
      ),
    Order(
    // Image.asset(orderImages[1]) ,
    "Order Number 2", '124913', DateTime(2023, 04, 10), DateTime(2023, 04, 15), '2' ,30.0, 
      [
        Product(name: 'Product 1', imageURL: products[0], count: 2, amount: 20.0),
        Product(name: 'Product 2', imageURL: products[1], count: 1, amount: 30.0),
        Product(name: 'Product 3', imageURL: products[2], count: 1, amount: 50.0),
        Product(name: 'Product 4', imageURL: products[3], count: 1, amount: 10.0),
        Product(name: 'Product 5', imageURL: products[4], count: 1, amount: 10.0),
      ],
    ),
    Order(
    // Image.asset(orderImages[1]) ,
    "Order Number test", '124913', DateTime(2023, 09, 08), DateTime(2023, 09, 11), '2' ,30.0, 
      [
        Product(name: 'Product 1', imageURL: products[0], count: 2, amount: 20.0),
        Product(name: 'Product 2', imageURL: products[1], count: 1, amount: 30.0),
        Product(name: 'Product 3', imageURL: products[2], count: 1, amount: 50.0),
        Product(name: 'Product 4', imageURL: products[3], count: 1, amount: 10.0),
        Product(name: 'Product 5', imageURL: products[4], count: 1, amount: 10.0),
      ],
    ),
    Order(
      // Image.asset(orderImages[2]),
      "Order Number 3", '1564956', DateTime(2023, 12, 31), DateTime(2023, 02, 10), '3' ,80.0, 
      [
      Product(name: 'Product 1', imageURL: products[0], count: 2, amount: 20.0),
      Product(name: 'Product 2', imageURL: products[1], count: 1, amount: 30.0),
      Product(name: 'Product 3', imageURL: products[2], count: 1, amount: 50.0),
      ],
    ),
];

class OrderList extends StatefulWidget {
  


  const OrderList({super.key});

  @override
  State<OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> with SingleTickerProviderStateMixin{
  Timer? _timer;
  late AnimationController _animationController;
  String? orderid;
  DateTime? orderDate; 
  DateTime? deliveryDate;
  String? totalItem;
  String? totalAmount;
  Map<String, dynamic> productData = {};
  final ScrollController _scrollController = ScrollController();
  double _sizedBoxHeight = 320;

  void orderList() async {
    Map<String, dynamic> userData = {
      'customer_id': UserId.getUserId()
    };
    String url ='http://pasumaibhoomi.com/api/orderlist';
    String jsonData = json.encode(userData);
    final encryptedData = encryptAES(jsonData);
    print('Encrypted order data: $encryptedData');
    final response = await http.post(Uri.parse(url), body: {'data' : encryptedData});

    if (response.statusCode == 200) {
      print('Success: ${response.statusCode}');
      print('Success: ${response.body}');
      String decryptedData = decryptAES(response.body);
      print('Decrypted Data: $decryptedData');
      final responseJson = json.decode(decryptedData);
      print('Response: $responseJson');
      String orderId = responseJson['order_id'];
      UserId.setOrderId(orderId);
      orderid = responseJson['order_id'];
      orderDate = responseJson['date'];
      deliveryDate = responseJson['delivery_date'];
      totalItem = responseJson['total_items'];
      totalAmount = responseJson['total'];
    }
  }

  void orderDetails() async {
    String url = 'http://pasumaibhoomi.com/api/orderdetail';
    Map<String, dynamic> userData = {
      'order_id': UserId.getOrderId()
    };
    String jsonData = json.encode(userData);
    String encryptedData = encryptAES(jsonData);
    final response = await http.post(Uri.parse(url), body: {'data': encryptedData});
    if (response.statusCode == 200) {
      print('Success: ${response.body}');
      String decrptedData =  decryptAES(response.body);
      print('Decrypted Data: $decrptedData');
      final responseJson = json.decode(decrptedData);
      print('Response: $responseJson');
      setState(() {
        productData = Map<String, dynamic>.from(responseJson['product_data']);
      });

    }
  }

    @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 500),
    );
    _scrollController.addListener(() {
      if (_scrollController.offset > 0) {
        // Update the height based on scroll offset or any other logic you desire
        setState(() {
          _sizedBoxHeight = 320 - _scrollController.offset;
          _sizedBoxHeight = _sizedBoxHeight.clamp(80, 320); // Limit the minimum and maximum height
        });
      }
    });
  }
  int? selectedFilter;
  bool isFilterApplied = false;

  void clearFilters() {
  setState(() {
    selectedFilter = null;
    isFilterApplied = false;
    filteredOrders = List.from(orders);
  });
}


  void _showFilterOptions() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, set) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Filter Options', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  for (int months in [3, 6, 9, 12])
                    RadioListTile<int>(
                      title: Text('Last $months months'),
                      value: months,
                      groupValue: selectedFilter,
                      onChanged: (int? value) {
                        set(() {
                          selectedFilter = value!;
                        });
                      },
                    ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the bottom sheet
                        // Apply filter and update the UI
                        filterOrdersByDate();
                        setState(
                          () {
                            isFilterApplied = true;
                          },
                        );
                      },
                      child: const Text('Apply Filter'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
  List<Order> filteredOrders = [];
  double months = 0;

  void filterOrdersByDate() {
    // Apply filter and update the UI without reloading the entire data
    DateTime currentDate = DateTime.now();
    if (selectedFilter != null) {
      DateTime startDate = currentDate.subtract(Duration(days: selectedFilter! * 30));
      setState(() {
      filteredOrders = orders.where((order) => order.deliveryDate.isAfter(startDate)).toList();
    });
    } else {
      // If no filter is selected, show all orders
     setState(() {
      filteredOrders = List.from(orders);
    });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 34, bottom: 30),
          height: 320,
          child: ListView.builder(
            // scrollDirection: Axis.vertical,
            itemCount: (selectedFilter != null) ? filteredOrders.length : orders.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  // order hostory page
                  orderHistory((selectedFilter != null) ? filteredOrders[index] : orders[index]),
                  const SizedBox(height: 4,)
                ],
              );
            },
          ),
        ),
        Container(
            height: 35,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent.withOpacity(0.2),
                  Colors.transparent.withOpacity(0.1),
                  Colors.transparent.withOpacity(0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter
              ),
            ),
            child: Row(
              children: [
                tabTitle('Orders'),
                const SizedBox(width: 140,),
                if(isFilterApplied)
                  GestureDetector(
                    onTap: ()  {
                        clearFilters();     
                    },
                    child: const Icon(Icons.cancel_outlined, color: Colors.black54,),
                  ),
                GestureDetector(
                  onTap: ()  {
                      _showFilterOptions();     
                  },
                  child: const Icon(Icons.filter_alt, color: Colors.black54,),
                )
    
              ],
            ),
          ),       
      ],
    ); 
  }

  // widget order history
  Widget orderHistory(Order order,){
    // date from intl package
    String formattedorderDate = DateFormat('d MMM y').format(order.orderOn);
    // String formattedOrderDate1 = DateFormat('d MMM y').format(orderDate!);
    String formattedDeliveryDate = DateFormat('d MMM y').format(order.deliveryDate);
    // String formattedDeliveryDate = DateFormat('d MMM y').format(deliveryDate!);
    return Container(
      height: 210,
      width: 410,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green.shade300),
        borderRadius: BorderRadius.circular(8)
      ),
      margin: const EdgeInsets.only(top: 10, left: 12, right: 10, bottom: 30),
      child: Column(
        children: [
          Row(
            children: [
              // product details
              Container(
                margin: const EdgeInsets.only(left: 12, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // order name
                    SizedBox(
                      // width: 300,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 259,
                            child: Text(
                              order.orderName,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6,),
                    // order id
                    SizedBox(
                      width: 320,
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // order Id
                                Row(
                                  children: [
                                    const Text(
                                      'Order Id: ',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400
                                      ),
                                    ),
                                    Text(
                                      order.orderId,
                                      // '$orderid',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w300
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6,),
                                // order on date
                                Row(
                                  children: [
                                    const Text(
                                      'Order on: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14
                                      ),
                                    ),
                                    Text(
                                      formattedorderDate,
                                      // '$orderDate',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w300
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6,),
                                // Delivery date
                                Row(
                                  children: [
                                    const Text(
                                      'Delivery Estimated: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14
                                      ),
                                    ),
                                    Text(
                                      formattedDeliveryDate,
                                      // '$deliveryDate',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w300
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.of(context).push(PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) =>
                                  OrderProducts(
                                    appBar: order.orderName,
                                    orderDate: order.orderOn,
                                    orderId: order.orderId,
                                    totalItem: order.quanity,
                                    totalAmount: order.price,
                                    products: order.products,
                                    deliveryDate: order.deliveryDate,
                                  ),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                const begin = Offset(1.0, 0.0);
                                const end = Offset.zero;
                                const curve = Curves.easeInOut;
                                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                var offsetAnimation = animation.drive(tween);
                                return SlideTransition(position: offsetAnimation, child: child);
                              },
                            )),
                            
                            child:  Container(
                              margin: const EdgeInsets.only( top: 24),
                              child: const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 26,
                              ),
                            ),
                          )

                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          // Order quantity, price
          Container(
            margin: const EdgeInsets.only(left: 12, top: 10),
            child: Row(
              children: [
                // Text('Order toal: $totalItem'),
                Text('Order toal: ${order.quanity}'),
                const SizedBox(width: 20,),
                const Text(
                  'Total paid: '
                ),
                const Icon(
                  Icons.currency_rupee,
                  size: 14,
                  weight: 28,
                ),
                Text(
                  '${order.price}',
                  // '$totalAmount',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 20,),
                // Help button
              ],
            ),
          ),
          // Reorder button
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
              margin: const EdgeInsets.only(left: 12, top: 12 ,right: 12),
                height: 40,
                width: 308,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color(0xFF60B47B)
                ),
                child: const Center(
                  child: Text(
                    'Reorder',
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      )
    );
  }

}

class Order {
  // final Image image;
  final String orderName;
  final String orderId;
  final DateTime orderOn;
  final DateTime deliveryDate;
  final String quanity;
  final double price;
  final List<Product> products;
  

  Order(
    // this.image, 
    this.orderName, 
    this.orderId,
    this.orderOn, 
    this.deliveryDate, 
    this.quanity, 
    this.price,
    this.products
    );
}

class Product {
  final String name;
  final String imageURL;
  final int count;
  final double amount;
  

  Product({
    required this.name,
    required this.imageURL,
    required this.count,
    required this.amount,
  });
}

