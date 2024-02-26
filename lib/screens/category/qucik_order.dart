// ignore_for_file: avoid_print

import 'dart:async';

import 'package:app_3/data/common_data.dart';
import 'package:app_3/screens/category/deliver_page.dart';
import 'package:app_3/widgets/screen_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuickOrderPage extends StatefulWidget {
  const QuickOrderPage({super.key});

  @override
  State<QuickOrderPage> createState() => _QuickOrderPageState();
}

class _QuickOrderPageState extends State<QuickOrderPage> {

  bool _isInitialCheckDone = false;
  late ConnectivityResult _isConnected;
  late StreamSubscription<ConnectivityResult> connectivitySubscription;
  late Timer _sessionTime;
  late DateTime lastCacheTime = DateTime.now();
  List<int> quantities = []; 
  int totalAmount = 0;
  int totalProduct =0;

    // load if any previous result of connectivity 
  void _loadConnectivityFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedConnectivity = prefs.getString('quick');
    final lastCacheTimeStr = prefs.getString('quickCache');
    if (cachedConnectivity != null) {
      setState(() {
        _isConnected = ConnectivityResult.values.byName(cachedConnectivity);
        _isInitialCheckDone = true;
        if (lastCacheTimeStr != null) {
          lastCacheTime = DateTime.parse(lastCacheTimeStr);
        }
      });
    } else {
      checkConnectivity(); // Check if cache is empty
    }
  }
  void _saveConnectivityToCache() async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('quick', _isConnected.name);
    prefs.setString('quickCache', DateTime.now().toIso8601String());
    
  }

  // check connectivity status on first time
  void checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = connectivityResult;
      _isInitialCheckDone = true;
      _saveConnectivityToCache();
    });
  }

  // remove the connectivity status from the cache
  void _clearConnectivityCache() async{
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('quick');
  }

  @override
  void initState() {
    super.initState();
    _isConnected = ConnectivityResult.none;
    _sessionTime = Timer(const Duration(minutes: 10), () { });
    _loadConnectivityFromCache();
    _restartSessionTimer();
    checkConnectivity();
    connectivitySubscription = Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        _isConnected = result;
        _saveConnectivityToCache();
      });
    });
  }

  @override
  void dispose() {
     connectivitySubscription.cancel();
    _sessionTime.cancel();
    super.dispose();
  }
    // Restart session timer 
  void _restartSessionTimer(){
    _sessionTime.cancel();
    _sessionTime = Timer(const Duration(minutes: 10), () {
      _clearConnectivityCache();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialCheckDone) {
      return Scaffold(
        appBar: homeAppBar('Quick Order'),
        body: const LinearProgressIndicator(),
      );
    }
    // load the content based on internet connection
    if (_isConnected == ConnectivityResult.mobile || _isConnected == ConnectivityResult.wifi) {
      return quickOrer(context);
    } else {
      return Scaffold(
        appBar: homeAppBar('Quick Order'),
        body: Center(
          child: Image.asset('assets/category/nointernet.png'),
        ),
      );
    }
  }

  Widget quickOrer(BuildContext context){
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: homeAppBar('Quick Order'),
      body: Column(
        children: [
          SizedBox(
            height: screenWidth > 600 ? screenHeight * 0.65 : screenHeight * 0.70,
            child: ListView.builder(
              itemCount: quickOrderImages.length,
              itemBuilder: (context, index) {
                if (quantities.length <= index) {
                  quantities.add(0);
                }
                // if (totalProductsList.length <= index) {
                //   totalProductsList.add(0);
                // }
                return SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(8)
                        ),
                      child: Row(
                        children: [
                          Container(
                            margin:const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 8.0),
                            height: 110,
                            width: 90,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl: quickOrderImages[index],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            width: 120,
                            margin: const EdgeInsets.only(top: 8.0, left: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // SizedBox(height: 8,),
                                Expanded(
                                  child: Text(
                                    quickOrderFoodNames[index],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12
                                    ),
                                  )
                                ),
                                const SizedBox(height: 8,),
                                 Expanded(
                                  child: Text(
                                    'List Price: ${listPrices[index]}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12
                                    ),
                                  )
                                ),
                                 Expanded(
                                  child: Text(
                                    'Final Price: ${finalPrices[index]}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12
                                    ),
                                  )
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 5, right: 10),
                            child: Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(
                                    left: 20.0,
                                    bottom: 25.0,
                                    top: 30
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(screenHeight * 0.018,),
                                  ),
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (quantities[index] > 0) {
                                              quantities[index]--;
                                            }
                                            updateTotal();
                                          });
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
                                            Icons.remove,
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
                                            '${quantities[index]}',
                                            style: TextStyle(
                                              fontSize: screenWidth > 600 ? screenHeight * 0.035 : screenHeight * 0.018,
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            quantities[index]++;
                                            updateTotal();
                                          });
                                        },
                                        child: Container(
                                          margin: EdgeInsets.zero,
                                          height:  screenWidth > 600 ? screenHeight * 0.085 : screenHeight * 0.032,
                                          width: screenWidth > 600 ? screenHeight * 0.085 : screenHeight * 0.032,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(screenHeight * 0.008),
                                              bottomRight: Radius.circular(screenHeight * 0.008),
                                            ),
                                            border: Border(
                                              top: BorderSide(color: Colors.grey.shade300),
                                              bottom: BorderSide(color: Colors.grey.shade300),
                                              left: BorderSide(color: Colors.grey.shade300),
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
                                Padding(
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Text(
                                    quantities[index] == 0 
                                    ? ''
                                    :"Total: ₹${calculateTotal(quantities[index], finalPrices[index])}"
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      )
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Order summary:',
                        style: TextStyle(
                          fontSize: 12, 
                          fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      totalAmount == 0
                      ? 'Add Somthing'
                      : totalProduct > 1 ? '($totalProduct item)' : '($totalProduct items)', 
                      style: const TextStyle(
                        fontSize: 12, 
                        fontWeight: FontWeight.w600
                      ),
                    ),
                  
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Total:',
                          style: TextStyle(
                            fontSize: 18, 
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        totalAmount == 0
                        ? 'Add Somthing'
                        : '₹$totalAmount', 
                        style: const TextStyle(
                          fontSize: 18, 
                          fontWeight: FontWeight.w600
                        ),
                      ),
                    
                    ],
                  ),
                ),
                 Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: GestureDetector(
                    onTap: () async {
                      if(totalAmount > 0){
                        if (totalAmount > 0) {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DeliverPage(),));
                        }
                      }else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            elevation: 1,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            backgroundColor:  const Color(0xFF60B47B),
                            content: const Text('Add Somthing in the List', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),
                            duration: const Duration(seconds: 1),
                          )
                        );
                      }
                      print("List of quantites : $quantities");
                      int newTotalProduct = 0;
                      print("Total product before update : $totalProduct");
                      for(int quantity in quantities){
                        if (quantity >= 1) {
                          newTotalProduct += quantity;
                        }
                      }
                      setState(() {
                        totalProduct = newTotalProduct;
                      });
                      await saveTotal();
                      print("Total product after update  : $totalProduct");
                    },
                    child: Container(
                      width: screenWidth > 600 ? screenHeight * 0.4 : screenHeight * 0.4,
                      height: screenWidth > 600 ? screenHeight * 0.4 : screenHeight * 0.05,
                      decoration: BoxDecoration(
                        color: const Color(0xFF60B47B),
                        borderRadius: BorderRadius.circular(8)
                      ),
                      child: const Center(
                        child: Text(
                          'Checkout',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  
  }
  
  
  String calculateTotal(int quantity, String price){
    int total = quantity * int.parse(price);
    return total.toString();
  }
  void updateTotal() {
    // Update total amount by iterating over all quantities and final prices
    int newTotalAmount = 0;
    for (int i = 0; i < quantities.length; i++) {
      newTotalAmount += quantities[i] * int.parse(finalPrices[i]);
     
    }
    setState(() {
      totalAmount = newTotalAmount;
    });
  }
  Future<void> saveTotal() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('totalQuickOrder', totalAmount);
    prefs.setInt('totalProducts', totalProduct);
  }
 
}
