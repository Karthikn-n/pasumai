// ignore_for_file: use_build_context_synchronously, unused_field, prefer_final_fields

import 'dart:async';

// import 'package:app_3/screens/bottom_bar.dart';
// import 'package:cached_network_image/cached_network_image.dart';
import 'package:app_3/screens/bottom_bar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../data/common_data.dart';
import '../widgets/screen_widgets.dart';
import 'products_list.dart';

class CustomScrollPhysics extends ScrollPhysics{
  const CustomScrollPhysics({ScrollPhysics? scrollPhysics}):super(parent: scrollPhysics);

  @override
  CustomScrollPhysics applyTo(ScrollPhysics? ancestor){
    return CustomScrollPhysics(scrollPhysics: buildParent(ancestor)!);
  }

  @override
  SpringDescription get spring => const SpringDescription(
    mass: 50 , 
    stiffness: 200, 
    damping: 0.2
  );
}
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Listen to the connectivity changes
  late StreamSubscription<ConnectivityResult> connectivitySubscription;
  late ConnectivityResult _isConnected;
  // Session time
  late Timer _sessionTime;
  // Store images in cache
  late List<String> cachedImagePaths;
  late DateTime _lastCacheTime = DateTime.now();
  // First time connection checking 
  bool _isInitialCheckDone = false;
  // bool _remainingSection = false;
  ScrollController _scrollController = ScrollController();
  // banner properties
  int _currentindex = 0;
  PageController _bannerController = PageController();
  double minRatingFilter = 0;
  List<String> appliedFilters = [];

  @override
  void initState() {
    super.initState();
    // set the session time and connectivity status
    _isConnected = ConnectivityResult.none;
    _sessionTime = Timer(const Duration(minutes: 10), () { });
    _loadConnectivityFromCache();
    _restartSessionTimer();
    _bannerController = PageController();
    checkConnectivity();
    connectivitySubscription = Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        _isConnected = result;
        _saveConnectivityToCache();
      });
    });
  }
    // load if any previous result of connectivity 
  void _loadConnectivityFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedConnectivity = prefs.getString('home');
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

  // Save connectivity changes to the home key
  void _saveConnectivityToCache() async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('home', _isConnected.name);
    prefs.setString('lastCacheTime', DateTime.now().toIso8601String());
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
    prefs.remove('home');
  }

  // Restart session timer 
  void _restartSessionTimer(){
    _sessionTime.cancel();
    _sessionTime = Timer(const Duration(minutes: 10), () {
      _clearConnectivityCache();
    });
  }
  
  @override
  void didChangeDependencies() {
    int halfCategoryCount = categories.length ~/ 2;

    // Precache half of the category images
    for (int i = 0; i < halfCategoryCount; i++) {
      precacheImage(AssetImage(categories[i]), context);
    }
    super.didChangeDependencies();
  }

  // Remove all the activity from memory to avoid memory leaks
  @override
  void dispose() {
    connectivitySubscription.cancel();
    _sessionTime.cancel();
    _bannerController.dispose();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
       // load the indicator based initial check
    if (!_isInitialCheckDone) {
      return Scaffold(
        appBar: homeAppBar('Home'),
        body: const LinearProgressIndicator(),
      );
    }

    // load the content based on internet connection
    if (_isConnected == ConnectivityResult.mobile || _isConnected == ConnectivityResult.wifi) {
      return homePage(context);
    } else {
      return Scaffold(
        appBar: homeAppBar('Home'),
        body: Center(
          child: Image.asset('assets/category/nointernet.png'),
        ),
      );
    }
  }


  Widget homePage(BuildContext context){
  double screenHeight = MediaQuery.of(context).size.height;
  double screenWidth = MediaQuery.of(context).size.width;

  double headingSize = screenHeight * 0.035;
  // double textSize = screenHeight * 0.018;
    return Scaffold(
      appBar: homeAppBar('Home'),
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: screenWidth > 600?  screenHeight * 0.4 : screenHeight * 0.150,
            floating: false,
            automaticallyImplyLeading: false,
            // pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                'assets/category/home.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(bottom: screenWidth > 600 ? screenHeight * 0.2 : screenHeight * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.01,),
                  heading('Categories', headingSize),
                  SizedBox(height: screenHeight * 0.05,),
                  Container(
                    margin: const EdgeInsets.only(left: 4),
                    child: categoryWidget(context)
                  ),
                  SizedBox(height: screenHeight * 0.05,),
                  Row(
                    children: [
                      heading('Quick order', headingSize),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed('/productList');
                          
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: screenWidth > 600 ?  screenWidth * 0.8: screenWidth * 0.37,),
                          child: Row(
                            children: [
                              Text(
                                'View all',
                                style: TextStyle(
                                  fontSize: screenWidth > 600 ?  screenHeight * 0.026: screenHeight * 0.012,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.003,),
                              Icon(
                                Icons.arrow_forward_ios_sharp,
                                size:  screenWidth > 600 ?  screenHeight * 0.026: screenHeight * 0.012,
                              )
                            ],
                          ),
                        ),
                     
                      )
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.05,),
                  Container(
                    margin: EdgeInsets.only(left: screenWidth * 0.004),
                    child: quickOrder(context, 'Seller' )
                  ),
                  Row(
                    children: [
                      Container(
                        child: heading('Subscribe Products', headingSize)
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) =>  BottomBar(selectedIndex: 2,),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              return child;
                            },
                            transitionDuration: Duration.zero,
                          ));
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: screenWidth > 600 ?  screenWidth * 0.73: screenWidth * 0.09,),
                          child: Row(
                            children: [
                              Text(
                                'View all',
                                style: TextStyle(
                                  fontSize: screenWidth > 600 ?  screenHeight * 0.026: screenHeight * 0.012,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.003,),
                              Icon(
                                Icons.arrow_forward_ios_sharp,
                                size:  screenWidth > 600 ?  screenHeight * 0.026: screenHeight * 0.012,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.05,),
                  GestureDetector(
                    onTap: (){
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => const (),));
                    },
                    child: subscribeProduct(context, 'Product', "345 ")
                  ),
                
                ],
              ),
            ),
          )
        ]
      ),
    ); 
  
  }
}

