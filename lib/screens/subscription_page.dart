import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/common_data.dart';
import '../widgets/screen_widgets.dart';
import 'product_subscribe.dart';


class SubscriptionList extends StatefulWidget {
  const SubscriptionList({super.key});

  @override
  State<SubscriptionList> createState() => _SubscriptionListState();
}

class _SubscriptionListState extends State<SubscriptionList> {

  late StreamSubscription<ConnectivityResult> connectivitySubscription;
  late ConnectivityResult _isConnected;
  late Timer _sessionTime;
  bool _isInitialCheckDone = false;
  late ScrollController _controller;
  int initialItemCount = products.length - 6;
  @override
    void initState() {
      super.initState();
      _isConnected = ConnectivityResult.none;
      _sessionTime = Timer(Duration.zero, () {});
      _loadConnectivityFromCache();
      checkConnectivity();
      connectivitySubscription = Connectivity().onConnectivityChanged.listen((event) {
        setState(() {
          _isConnected = event;
          _saveConnectivityToCache();
        });
        _restartSessionTimer();
      });
      _controller = ScrollController();
      _controller.addListener(_scrollListener);
    }

  void _scrollListener(){
    if (_controller.offset >= _controller.position.maxScrollExtent &&
            !_controller.position.outOfRange) {
          _loadMoreItems();
        }
  }
  void _loadMoreItems() {
    // Simulate loading more items in the background
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        // Increase the number of initially loaded items
        initialItemCount += 2;
      });
    });
  }
  void _loadConnectivityFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedConnectivity = prefs.getString('connectivity');
    if (cachedConnectivity != null) {
      setState(() {
        _isConnected = ConnectivityResult.values.byName(cachedConnectivity);
        _isInitialCheckDone = true;
      });
    } else {
      checkConnectivity(); // Check if cache is empty
    }
  }

  void _saveConnectivityToCache() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('connectivity', _isConnected.name);
  }

  void checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = connectivityResult;
      _isInitialCheckDone = true;
      _saveConnectivityToCache();
    });
  }

  void _restartSessionTimer() {
    _sessionTime.cancel(); // Cancel any existing timer
    _sessionTime = Timer(const Duration(minutes: 10), () {
      _clearConnectivityCache(); // Clear cache after session expires
    });
  }

  void _clearConnectivityCache() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('connectivity');
  }

  @override
  void dispose() {
    connectivitySubscription.cancel();
    _sessionTime.cancel();
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialCheckDone) {
      return Scaffold(
        appBar:  subscribeListAppBar(context),
        body: const LinearProgressIndicator(),
      );
    }
     if (_isConnected == ConnectivityResult.wifi || _isConnected == ConnectivityResult.mobile) {
      return subscribeListPage();
    } else {
      return Scaffold(
        appBar: subscribeListAppBar(context),
        body: Center(
          child: Image.asset('assets/category/nointernet.png'),
        ),
      );
    }
  }

  Widget subscribeListPage(){
    return Scaffold(
      appBar: subscribeListAppBar(context),
      body: CustomScrollView(
        controller: _controller,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.width > 600
                ? MediaQuery.of(context).size.height * 0.4 
                : MediaQuery.of(context).size.height * 0.150,
            floating: false,
            automaticallyImplyLeading: false,
            surfaceTintColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                'assets/category/subscribe.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                 return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => 
                        ProductSubScription(
                          name: 'Product Name ${index +1}',
                          image: products[index],
                        )
                      )
                    );
                  },
                  child: Container(
                    margin:  const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 8 ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FutureBuilder(
                          future: precacheBestProduct(products), 
                          builder: (context, snapshot) {
                            if(snapshot.connectionState == ConnectionState.done){
                              return  Container(
                                height: 150,
                                width: double.infinity,
                                margin: const EdgeInsets.only(bottom: 10),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    imageUrl: products[index],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            }else{
                              return Container();
                            }
                          },
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 5, right: 5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // product price and name and offer
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // name and rating
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 160,
                                          child: Text(
                                            'Product Name ${index+1}',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          Icons.star,
                                          size: 14,
                                          color: Colors.yellow.shade800,
                                        ),
                                        const Text(
                                          '4.3',
                                          style:  TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14
                                          ),
                                        )
                                      ],
                                    ),
                                    // price and off
                                    const Row(
                                      children: [
                                        Icon(
                                          Icons.currency_rupee,
                                          size: 14,
                                        ),
                                        Text(
                                          '50/kg',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500
                                          ),
                                        ),
                                        SizedBox(width: 5,),
                                        Stack(
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.currency_rupee,
                                                  size: 12,
                                                ),
                                                Text(
                                                  '100',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    // decoration: TextDecoration.lineThrough,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Positioned(
                                              top: 1, // Adjust this value based on your text size and desired position
                                              left: 3,
                                              right: 0,
                                              child: Divider(
                                                color: Colors.black, // Set the color of the strikethrough line
                                                thickness: 1, // Set the thickness of the strikethrough line
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: 5,),
                                        Expanded(
                                          child: Text(
                                            '100% off',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.red
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              // Subscribe button
                              // const SizedBox(width: 60,),
                              Container(
                                height: 40,
                                width: 90,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: const Color(0xFF60B47B)
                                ),
                                child: const Center(
                                  child: Text(
                                    'Subscribe',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400
                                    ),
                                  ),
                                ),
                                // margin: const EdgeInsets.only(right: ),
                              )
                            ],
                          ),
                        )
                      
                      ],
                    ),
                  ),
                );
              
            },
            childCount: products.length  
            ),
            
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 60,),)
        ],
      ),
    );
  }

}


