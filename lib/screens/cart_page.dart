// ignore_for_file: unused_field, avoid_print, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:convert';

import 'package:app_3/data/cart_repo.dart';
import 'package:app_3/screens/products_list.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../data/common_data.dart';
import '../data/encrypt_ids.dart';
import '../widgets/screen_widgets.dart';

class Product {
  final String name;
  final String weight;
  final String image;
  int quantity;
  final String price;

  Product(this.name, this.weight, this.image, this.quantity, this.price);
}
   List<List<Product>> categories = [
    [
      Product('Family Dairy Pack', '250 g', products[0], 0, '199'),
      Product('Ice Coffee with Chocolate', '350 g', products[1], 0, '100'),
      Product('Milk soup', '500g', products[2], 0, '210'),
      Product('Panneer Roast with Noodles ', '800g', products[3], 0, '89'),
    ],
    [
      Product('Egg Noodels', '400 g', products[4], 0, '110'),
      Product('Chicken leg Pieces', '150 g', products[5], 0, '250'),
    ],
    [
      Product('Fish Fry', '200 g', products[6], 0, '350'),
      Product('Whole Chicken', '1 Kg', products[7], 0, '410'),
    ],
  ];
  


class CartPage extends StatefulWidget {

  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

   // listen to the connectivity changes
  late StreamSubscription<ConnectivityResult> connectivitySubscription;
  late ConnectivityResult _isConnected;
  late CartRepository cartRepository;
  // add the session time
  late Timer _sessionTime;
  late DateTime _lastCacheTime = DateTime.now();
  bool _isInitialCheckDone = false;
  List<Product> allProducts = [];

    @override
  void initState() {
    super.initState();
    // initialise the connectivity status and session time
    _isConnected = ConnectivityResult.none;
    _sessionTime = Timer(const Duration(microseconds: 10), () { });
    _loadConnectivityFromCache();
    checkConnectivity();
    // change connectivity changes according to the internet changes
    connectivitySubscription = Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        _isConnected = result;
        _saveConnectivityToCache();
      });
    });
    cartRepository = CartRepository();
    _restartSessionTimer();
  }
  
  // Load the connectivity from caches
  void _loadConnectivityFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedConnectivity = prefs.getString('cart');
    final lastCacheTimeStr = prefs.getString('lastCacheTime');
    if (cachedConnectivity != null) {
      setState(() {
        _isConnected = ConnectivityResult.values.byName(cachedConnectivity);
        _isInitialCheckDone = true;
        if (lastCacheTimeStr != null) {
          _lastCacheTime = DateTime.parse(lastCacheTimeStr);
        }
      });
    } else {
      checkConnectivity(); // Check if cache is empty
    }
  }

  // Save the connectivity change to the caches
  void _saveConnectivityToCache() async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('cart', _isConnected.name);
    prefs.setString('lastCacheTime', DateTime.now().toIso8601String());
  }

  // initial check of the connectivity
  void checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = connectivityResult;
      _isInitialCheckDone = true;
      _saveConnectivityToCache();
    });
  }

  // restart the session time
  void _restartSessionTimer(){
    _sessionTime.cancel();
    _sessionTime = Timer(const Duration(minutes: 10), () {
      _clearConnectivityCache();
    });
  }

  // clear connectivity change result
  void _clearConnectivityCache() async{
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('cart');
  }

  // avoid memory leaks
  @override
  void dispose() {
    connectivitySubscription.cancel();
    _sessionTime.cancel();
    super.dispose();
  }


  // update the quantity
  void updateQuantity(int productIndex, int newQuantity) {
    if (newQuantity > 0) {
      setState(() {
        // allProducts[productIndex].quantity = newQuantity;
        cartRepository.addedProducts[productIndex].quantity = newQuantity;
      });
    } else {
      showDialog(
        context: context, 
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Set your desired border radius
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white, // Set your desired color
                borderRadius: BorderRadius.circular(10.0), // Set your desired border radius
              ),
              height: 195,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          'Remove Item',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Do you want to remove this item from the cart?',
                          style: TextStyle(fontSize: 12.0),
                        ),
                        // SizedBox(height: 16),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey.shade200),
                              top:  BorderSide(color: Colors.grey.shade200),
                            )
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: Center(
                              child: Text(
                                'Cancel',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            cartRepository.addedProducts.removeAt(productIndex);
                          });
                          Navigator.of(context).pop();
                        },
                        child: SizedBox(
                          height: 30,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 5),
                            child: Center(
                              child: Text(
                                'Confirm',
                                style: TextStyle(
                                  color: Colors.blue, // Set your desired color
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      );
    } 
  }
 

  double calcuateTotal() {
    double totalamount = 0.0;
    for(AddedProduct cart in cartRepository.addedProducts){
      totalamount += cart.quantity * int.parse(cart.price);
    }
    return totalamount;
  }
  @override
  void didChangeDependencies() {
    int halfProductCount = products.length ~/ 2;
    for (int i = 0; i < halfProductCount; i++) {
      precacheImage(AssetImage(products[i]), context);
    }
    super.didChangeDependencies();
  }

  @override
   Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double deliveryFee = 20;
    double platformFee = 20;
    double subtotal = calcuateTotal();
    // Flatten the list of categories into a single list of products
    allProducts = categories.expand((category) => category).toList();
     // ignore: unused_local_variable
    if (_isInitialCheckDone) {
      if (_isConnected == ConnectivityResult.mobile || _isConnected == ConnectivityResult.wifi) {
        return Scaffold(
          appBar: cartAppBar(context),
          body: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: screenWidth > 600?  screenHeight * 0.3: screenHeight * 0.15),
                // height: screenWidth > 600?  screenHeight * 0.5 : screenHeight * 1.4,
                child: CustomScrollView(
                  physics: BouncingScrollPhysics(),
                  slivers: [
                    SliverAppBar(
                      expandedHeight: screenWidth > 600?  screenHeight * 0.4 : screenHeight * 0.150,
                      floating: false,
                      surfaceTintColor: Colors.transparent,
                      automaticallyImplyLeading: false,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Image.asset(
                          'assets/category/Banner2.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, productIndex){
                          AddedProduct cart = cartRepository.addedProducts[productIndex];
                          return Column(
                            children: [
                              Container(
                                height: screenWidth > 600 ? screenHeight * 0.25 : screenHeight * 0.1015,
                                width: screenWidth > 600 ? screenHeight * 1.9 : screenHeight * 0.45,
                                margin: EdgeInsets.only(bottom: screenHeight * 0.008, top: screenHeight * 0.007),
                                decoration: BoxDecoration(
                                  color: Color(0xFFF3F3F3),
                                  border: Border(left: BorderSide(color: Color(0xFF60B48B), width: screenHeight * 0.003)),
                                  borderRadius: BorderRadius.only(topRight: Radius.circular(screenHeight * 0.008), bottomRight: Radius.circular(screenHeight * 0.008))
                                ),
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: SizedBox(
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              height: screenWidth > 600 ? screenHeight * 0.18 : screenHeight * 0.08,
                                              width:  screenWidth > 600 ? screenHeight * 0.18 : screenHeight * 0.08,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(screenHeight * 0.008),
                                                child: CachedNetworkImage(
                                                  imageUrl: cart.image,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: screenHeight * 0.008),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: screenWidth > 600 ? screenHeight * 0.67 : screenHeight * 0.18,
                                                  child: Text(
                                                    '${cart.name} (${cart.weight})',
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize:  screenWidth > 600 ? screenHeight * 0.04 : screenHeight * 0.016,
                                                      fontWeight: FontWeight.w600,
                                                      letterSpacing: -0.5,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.currency_rupee,
                                                      size:  screenWidth > 600 ? screenHeight * 0.03 : screenHeight * 0.016,
                                                    ),
                                                    Text(
                                                      cart.price,
                                                      style: TextStyle(
                                                        fontSize:  screenWidth > 600 ? screenHeight * 0.03 :screenHeight * 0.016,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                            // quality counter
                                            Center(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(screenHeight * 0.018,),
                                                ),
                                                margin: EdgeInsets.only(
                                                  bottom: screenHeight * 0.011, 
                                                  top: screenHeight * 0.011, 
                                                  left: screenWidth > 600 ? screenWidth * 0.3 : screenHeight * 0.026
                                                ),
                                                child: Row(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        updateQuantity(
                                                          productIndex,
                                                          cart.quantity - 1,
                                                        );
                                                      },
                                                      child: Container(
                                                        margin: EdgeInsets.zero,
                                                        height:  screenWidth > 600 ? screenHeight * 0.085 : screenHeight * 0.032,
                                                        width: screenWidth > 600 ? screenHeight * 0.085 : screenHeight * 0.032,
                                                        decoration: BoxDecoration(
                                                          color: Colors.grey.shade300,
                                                          borderRadius: BorderRadius.only(
                                                            topLeft: Radius.circular(screenHeight * 0.008),
                                                            bottomLeft: Radius.circular(screenHeight * 0.008),
                                                          ),
                                                          border: Border(
                                                            top: BorderSide(color: Colors.grey.shade300),
                                                            bottom: BorderSide(color: Colors.grey.shade300),
                                                            left: BorderSide(color: Colors.grey.shade300),
                                                          ),
                                                        ),
                                                        child: Icon(
                                                          cart.quantity == 1 ? Icons.delete_outline : Icons.remove,
                                                          size: screenWidth > 600 ? screenHeight * 0.04 : screenHeight * 0.02,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: screenWidth > 600 ? screenHeight * 0.085 : screenHeight * 0.032,
                                                      width: screenWidth > 600 ? screenHeight * 0.085 : screenHeight * 0.032,
                                                      decoration: BoxDecoration(
                                                        border: Border(
                                                          top: BorderSide(color: Colors.grey.shade300),
                                                          bottom: BorderSide(color: Colors.grey.shade300),
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          '${cart.quantity}',
                                                          style: TextStyle(
                                                            fontSize: screenWidth > 600 ? screenHeight * 0.035 : screenHeight * 0.018,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        updateQuantity(
                                                          productIndex,
                                                          cart.quantity + 1,
                                                        );
                                                      },
                                                      child: Container(
                                                        margin: EdgeInsets.zero,
                                                        height: screenWidth > 600 ? screenHeight * 0.085 : screenHeight * 0.032,
                                                        width: screenWidth > 600 ? screenHeight * 0.085 : screenHeight * 0.032,
                                                        decoration: BoxDecoration(
                                                          color: Colors.grey.shade300,
                                                          borderRadius: BorderRadius.only(
                                                            topRight: Radius.circular(screenHeight * 0.008),
                                                            bottomRight: Radius.circular(screenHeight * 0.008),
                                                          ),
                                                        ),
                                                        child: Icon(
                                                          Icons.add,
                                                          size: screenWidth > 600 ? screenHeight * 0.04 : screenHeight * 0.02,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                        childCount: cartRepository.addedProducts.length
                      )
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(height: screenWidth > 600?  screenHeight * 0.0: screenHeight * 0.0,),
                    )
                  ],
                ),
              ),
              Positioned(
                left: screenHeight * 0.0000,
                right: screenHeight * 0.000,
                top: screenWidth > 600?  screenHeight * 0.33: screenHeight * 0.65,
                bottom: screenWidth > 600?  screenHeight * 0.00: screenHeight * 0.00004,
                
                child: Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: screenWidth > 600?  screenHeight * 0.13: screenHeight * 0.056,
                        width: screenWidth > 600?  screenHeight * 0.48 : screenHeight * 0.24,
                        margin: EdgeInsets.only(left: screenWidth > 600?  screenHeight * 0.5 : screenHeight * 0.045,),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF60B47B)),
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(screenHeight * 0.008), bottomLeft: Radius.circular(screenHeight * 0.008))
                        ),
                        child: Row(
                          children: [
                            // SizedBox(width: 20,),
                            SizedBox(width: screenWidth > 600?  screenHeight * 0.06: screenHeight * 0.0068,),
                            Text(
                              'Total - ',
                              style: TextStyle(
                                fontSize: screenWidth > 600?  screenHeight * 0.053: screenHeight * 0.028,
                                fontWeight: FontWeight.w300
                              ),
                            ),
                            Icon(
                              Icons.currency_rupee,
                              size: screenWidth > 600?  screenHeight * 0.053: screenHeight * 0.028,
                            ),
                            // SizedBox(width: 10,),
                            Text(
                              subtotal.toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: screenWidth > 600?  screenHeight * 0.053: screenHeight * 0.028,
                                fontWeight: FontWeight.w300
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if(screenWidth > 600) {
                            showModalBottomSheet(
                              backgroundColor: Colors.white,
                              context: context, 
                              // shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                              builder: (context) {
                                return SizedBox(
                                height: 450,
                                width: double.infinity,
                                child: Container(
                                  margin: const EdgeInsets.only(left: 10,right: 10, top: 20),
                                  child:  Column(
                                    children: [
                                      Center(
                                        child: Container(
                                          width: 50,
                                          margin: EdgeInsets.only(left: 30, right: 30,),
                                          child: Divider(thickness: 3, color: Colors.black45,),
                                        ),
                                      ),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 230,
                                            child: Column(
                                              children: [
                                                const SizedBox(height: 8,),
                                                Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      'Total',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w400
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 130,),
                                                  Icon(
                                                    Icons.currency_rupee,
                                                    size: 12,
                                                  ),
                                                  Text(
                                                    '$subtotal',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w600
                                                    ),
                                                  )
                                                ],
                                              ),
                                                const SizedBox(height: 8,),
                                                Row(
                                                children: [
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          'Delivery Fee',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.w400
                                                          ),
                                                        ),
                                                        SizedBox(width: 2,),
                                                        Icon(Icons.info_outline, size: 10,),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(width: 70,),
                                                  Icon(
                                                    Icons.currency_rupee,
                                                    size: 12,
                                                  ),
                                                  Text(
                                                    '$deliveryFee',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w600
                                                    ),
                                                  )
                                                ],
                                              ),
                                                const SizedBox(height: 8,),
                                                Row(
                                                children: [
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          'Platform Fee',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.w400
                                                          ),
                                                        ),
                                                        SizedBox(width: 2,),
                                                        Icon(Icons.info_outline, size: 10,),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(width: 60,),
                                                  Icon(
                                                    Icons.currency_rupee,
                                                    size: 14,
                                                  ),
                                                  Text(
                                                    '$platformFee',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w600
                                                    ),
                                                  )
                                                ],
                                              ),
                                                const SizedBox(height: 10,),
                                                const SizedBox(
                                                  // margin: EdgeInsets.only(left: 10, right: 10),
                                                  width: 210,
                                                  child: Divider(
                                                    thickness: 1,
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                                const SizedBox(height: 2,),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        'To pay',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w400
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 110,),
                                                    Icon(
                                                      Icons.currency_rupee,
                                                      size: 12,
                                                    ),
                                                    Text(
                                                      '${subtotal + deliveryFee + platformFee}',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w600
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(height: 2,),
                                                SizedBox(
                                            // margin: EdgeInsets.only(left: 10, right: 10),
                                            width: 210,
                                            child: Divider(
                                              thickness: 1,
                                              color: Colors.black54,
                                            ),
                                          ),
                                          
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: 150,
                                            width: 250,
                                            margin: EdgeInsets.only(left: 10, right: 10, top: 8),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                              color: Color(0xFFF3F3F3)
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 250,
                                                  height: 50,
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(8),
                                                    child: Image.asset(
                                                      'assets/category/map.jpg',
                                                      fit: BoxFit.cover,
                                                    )
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(left: 8, top: 8),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            'Confrim Address',
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w700
                                                            ),
                                                          ),
                                                          SizedBox(width: 5,),
                                                          Icon(
                                                            Icons.edit_rounded,
                                                            size: 14,
                                                            color: Colors.blue.shade300,
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        width: 240,
                                                        child: Text(
                                                          'W4MW+6MW, 9th Main Rd, Madurai, Tamil Nadu 625020',
                                                          maxLines: 3,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.w400
                                                          ),
                                                        )
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),                                              
                                          GestureDetector(
                                            onTap: () async {
                                              String url = 'http://pasumaibhoomi.com/api/checkout';
                                              List<Map<String, dynamic>> productsData = [];
                                                for (int i = 0; i < cartRepository.addedProducts.length; i++) {
                                                  AddedProduct cartItem = cartRepository.addedProducts[i];
                                                  Map<String, dynamic> productData = {
                                                    'prdt_id': i + 1,
                                                    'prdt_quantity': cartItem.quantity,
                                                    'prdt_price': cartItem.price,
                                                    'prdt_total': cartItem.quantity * double.parse(cartItem.price),
                                                  };
                                                  productsData.add(productData);
                                                }
                                              Map<String, dynamic> userData = {
                                                'customer_id': UserId.getUserId(),
                                                'total': subtotal,
                                                'products': productsData
                                              };
                                              String jsonData = json.encode(userData);
                                              print('Json Data: $jsonData');
                                              String encryptedUserData = encryptAES(jsonData);
                                              final response = await http.post(Uri.parse(url), body: {'data' : encryptedUserData});
                                
                                              print('Success: ${response.statusCode}');
                                              if(response.statusCode == 200){
                                                print('Response: ${response.body}');
                                              }else{
                                                print('Error: ${response.body}');
                                              }
                                            },
                                            child: Container(
                                              height: 45,
                                              width: 110,
                                              margin: const EdgeInsets.only(top: 55, bottom: 8),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF60B47B),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: const Center(
                                                child: Text(
                                                  'Place Order',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                          }else{
                            showModalBottomSheet(
                              backgroundColor: Colors.white,
                              context: context, 
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                              builder: (context) {
                                return SizedBox(
                                  height: screenWidth > 600 ? screenHeight * 2.6 : screenHeight * 1,
                                  width: double.infinity,
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 30,right: 30, top: 30),
                                    child:  Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Center(
                                          child: Container(
                                            width: 50,
                                            margin: EdgeInsets.only(left: 30, right: 30,),
                                            child: Divider(thickness: 3, color: Colors.black45,),
                                          ),
                                        ),
                                        const SizedBox(height: 10,),
                                        Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              'Total',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400
                                              ),
                                            )
                                          ),
                                          Icon(
                                            Icons.currency_rupee,
                                            size: 14,
                                          ),
                                          Text(
                                            '$subtotal',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600
                                            ),
                                          )
                                        ],
                                      ),
                                        const SizedBox(height: 10,),
                                        Row(
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Text(
                                                  'Delivery Fee',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400
                                                  ),
                                                ),
                                                SizedBox(width: 4,),
                                                Icon(Icons.info_outline, size: 12,),
                                              ],
                                            ),
                                          ),
                                          Icon(
                                            Icons.currency_rupee,
                                            size: 14,
                                          ),
                                          Text(
                                            '$deliveryFee',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600
                                            ),
                                          )
                                        ],
                                      ),
                                        const SizedBox(height: 10,),
                                        Row(
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Text(
                                                  'Platform Fee',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400
                                                  ),
                                                ),
                                                SizedBox(width: 4,),
                                                Icon(Icons.info_outline, size: 12,),
                                              ],
                                            ),
                                          ),
                                          //  SizedBox(width: 120,),
                                          Icon(
                                            Icons.currency_rupee,
                                            size: 14,
                                          ),
                                          Text(
                                            '$platformFee',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600
                                            ),
                                          )
                                        ],
                                      ),
                                        const SizedBox(height: 10,),
                                        const SizedBox(
                                          // margin: EdgeInsets.only(left: 10, right: 10),
                                          width: double.infinity,
                                          child: Divider(
                                            thickness: 1,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        const SizedBox(height: 10,),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'To pay',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400
                                                ),
                                              )
                                            ),
                                            Icon(
                                              Icons.currency_rupee,
                                              size: 14,
                                            ),
                                            Text(
                                              '${subtotal + deliveryFee + platformFee}',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(height: 10,),
                                        SizedBox(
                                          // margin: EdgeInsets.only(left: 10, right: 10),
                                          width: double.infinity,
                                          child: Divider(
                                            thickness: 1,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 10, right: 10),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            color: Color(0xFFF3F3F3)
                                          ),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 120,
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(8),
                                                  child: Image.asset('assets/category/map.jpg')
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(left: 8, top: 8),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          'Confrim Address',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.w700
                                                          ),
                                                        ),
                                                        SizedBox(width: 5,),
                                                        Icon(
                                                          Icons.edit_rounded,
                                                          size: 14,
                                                          color: Colors.blue.shade300,
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: 150,
                                                      child: Text(
                                                        'W4MW+6MW, 9th Main Rd, Madurai, Tamil Nadu 625020',
                                                        maxLines: 3,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w400
                                                        ),
                                                      )
                                                    )
                                                  ],
                                                ),
                                              )
                                            
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            String url = 'http://pasumaibhoomi.com/api/checkout';
                                            List<Map<String, dynamic>> productsData = [];
                                              for (int i = 0; i < cartRepository.addedProducts.length; i++) {
                                                AddedProduct cartItem = cartRepository.addedProducts[i];
                                                Map<String, dynamic> productData = {
                                                  'prdt_id': i + 1,
                                                  'prdt_quantity': cartItem.quantity,
                                                  'prdt_price': cartItem.price,
                                                  'prdt_total': cartItem.quantity * double.parse(cartItem.price),
                                                };
                                                productsData.add(productData);
                                              }
                                            Map<String, dynamic> userData = {
                                              'customer_id': UserId.getUserId(),
                                              'total': subtotal,
                                              'products': productsData
                                            };
                                            String jsonData = json.encode(userData);
                                            print('Json Data: $jsonData');
                                            String encryptedUserData = encryptAES(jsonData);
                                            final response = await http.post(Uri.parse(url), body: {'data' : encryptedUserData});
                              
                                            print('Success: ${response.statusCode}');
                                            if(response.statusCode == 200){
                                              print('Response: ${response.body}');
                                            }else{
                                              print('Error: ${response.body}');
                                            }
                                          },
                                          child: Container(
                                            height: 45,
                                            width: double.infinity,
                                            margin: const EdgeInsets.only(top: 15, bottom: 8),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF60B47B),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: const Center(
                                              child: Text(
                                                'Place Order',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ); 
                          }
                        },
                        child: Container(
                          height: screenWidth > 600?  screenHeight * 0.13:  screenHeight * 0.056,
                          width: screenWidth > 600?  screenHeight * 0.48 : screenHeight * 0.14,
                          margin: const EdgeInsets.only(right: 25),
                          decoration: BoxDecoration(
                            color: const Color(0xFF60B47B),
                            border: Border.all(color: const Color(0xFF60B47B)),
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(8),
                              bottomRight: Radius.circular(8)
                            )
                          ),
                          child: const Center(
                            child: Text(
                              'Buy now',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      } else {
      return Scaffold(
        appBar: cartAppBar(context),
        body: Center(
          child: Image.asset('assets/category/nointernet.png'),
        ),
      );
    }
    } else {
      return Scaffold(
        appBar: cartAppBar(context),
        body: const LinearProgressIndicator(),
      );
    }
  }

  Future<void> precacheImages(List<String> imageUrls) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cachedImageUrls = prefs.getStringList('cartImage') ?? [];

    for (final url in imageUrls) {
      if (!cachedImageUrls.contains(url)) {
        // Cache the image using flutter_cache_manager
        await DefaultCacheManager().downloadFile(url);

        // Update the cached image URLs in shared preferences
        cachedImageUrls.add(url);
        prefs.setStringList('cartImage', cachedImageUrls);
      }
    }
  }

}

