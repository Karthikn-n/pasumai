import 'package:app_3/providers/api_provider.dart';
import 'package:app_3/providers/cart_items_provider.dart';
import 'package:app_3/helper/shared_preference_helper.dart';
import 'package:app_3/repository/app_repository.dart';
import 'package:app_3/screens/main_screens/cart_screen.dart';
import 'package:app_3/screens/main_screens/profile_screen.dart';
import 'package:app_3/screens/main_screens/quick_order_screen.dart';
import 'package:app_3/screens/main_screens/subcribe_products_screen.dart';
import 'package:app_3/service/api_service.dart';
import 'package:app_3/service/connectivity_helper.dart';
import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_page.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key,});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  AppRepository bottomRepository = AppRepository(ApiService('https://maduraimarket.in/api'));
  // AppRepository bottomRepository = AppRepository(ApiService('http://192.168.1.5/pasumaibhoomi/public/api'));
  DateTime? currentPress;
  // List of pages in the0 bottom navigation bar
  SharedPreferences prefs = SharedPreferencesHelper.getSharedPreferences();
  late List<Widget> _pages;
  bool _isInitialized = false;
  bool isQuickOrderSelected = false;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final cartItemsHelper = Provider.of<CartProvider>(context, listen: false);
      cartItemsHelper.cartItemsAPI();
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    _pages = [
      const HomePage(),
      const CartScreen(),
      const QuickOrderScreen(),
      SubscriptionList(),
      const NewProfileScreen(),
      // ProfilePage()
    ];
    return Consumer2<ConnectivityService, ApiProvider>(
      builder: (context, provider, apiProvider, child) {
        return !provider.isConnected 
        ? Scaffold(
            body: Stack(
              children: [
                Positioned.fill(
                  child: Center(
                    child: Image.asset('assets/category/nointernet.png'),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20.0), // Adjust the corner radius
                        topRight: Radius.circular(20.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 1,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: BottomNavigationBar(
                      items: [
                        buildBottomNavigationBarItem(
                          0,  Icon(
                            CupertinoIcons.home,
                            color: apiProvider.bottomIndex == 0 ? Theme.of(context).primaryColor : Colors.grey.shade400,
                            size: 28.0,
                          ), 'Home',false
                        ),
                        buildBottomNavigationBarItem(
                          1,  Icon(
                            CupertinoIcons.shopping_cart,
                            color: apiProvider.bottomIndex == 1 ? Theme.of(context).primaryColor : Colors.grey.shade400,
                            size: 28.0,
                          ), 'Cart',false
                        ),
                        buildBottomNavigationBarItem(
                          2,  const SizedBox(
                              height: 28,
                              width: 28,
                          ), '',true
                        ),
                        buildBottomNavigationBarItem(
                          3,  Icon(
                            CupertinoIcons.bell,
                            color: apiProvider.bottomIndex == 3 ? Theme.of(context).primaryColor : Colors.grey.shade400,
                            size: 28.0,
                          ), 'Subscription',true
                        ),
                        buildBottomNavigationBarItem(
                          4,  Icon(
                            CupertinoIcons.person,
                            color: apiProvider.bottomIndex == 4 ? Theme.of(context).primaryColor : Colors.grey.shade400,
                            size: 28.0,
                          ), 'Profile',true
                        ),
                      ],
                      
                      type: BottomNavigationBarType.fixed,
                      showUnselectedLabels: true,
                      currentIndex: apiProvider.bottomIndex,
                      selectedItemColor: Theme.of(context).primaryColor,
                      unselectedItemColor: Colors.grey.shade500,
                      backgroundColor: Colors.transparent,
                      elevation: 0, // No shadow for the BottomNavigationBar
                      selectedFontSize: 12.0,
                      unselectedFontSize: 12.0,
                      onTap: (value) {
                        apiProvider.setIndex(value);
                        apiProvider.setQuick(false);
                      },
                    ),
                  ),
                ),
              ],
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FloatingActionButton(
              // backgroundColor: ,
              tooltip: "Quick order",
              elevation: 3,
              splashColor: Colors.white30,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              ),
              foregroundColor: Colors.transparent.withOpacity(0.0),
              onPressed: () async {
                apiProvider.setQuick(true);
                apiProvider.setIndex(2);
                print(apiProvider.quickOrderProductsList.length);
                if (apiProvider.quickOrderProductsList.isEmpty) {
                  await apiProvider.quickOrderProducts();
                }
              },
              child: SizedBox(
                height: 30,
                width: 28,
                child: Image.asset(
                  "assets/category/quick_order.png",
                  color: Colors.white,
                  fit: BoxFit.cover,
                )
              ),
            ),
          )
        : PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (apiProvider.bottomIndex != 0) {
              apiProvider.setQuick(false);
              apiProvider.setIndex(0);
              return;
            }
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                // Your main content goes here
                apiProvider.isQuick
                ? const QuickOrderScreen()
                : Positioned.fill(
                  child: PageStorage(
                    bucket: PageStorageBucket(),
                    child: _pages[apiProvider.bottomIndex],
                  ),
                ),
        
                // Bottom Navigation Bar with floating effect
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20.0), // Adjust the corner radius
                        topRight: Radius.circular(20.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 1,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: BottomNavigationBar(
                      items: [
                        buildBottomNavigationBarItem(
                          0,  Icon(
                            CupertinoIcons.home,
                            color: apiProvider.bottomIndex == 0 ? Theme.of(context).primaryColor : Colors.grey.shade600,
                            size: 24,
                          ), 'Home',false
                        ),
                        buildBottomNavigationBarItem(
                          1, SizedBox(
                            height: 24,
                            width: 24,
                            child: Image.asset(
                              "assets/category/cart.png",
                              fit: BoxFit.cover,
                              // filterQuality: FilterQuality.high,
                              color: apiProvider.bottomIndex == 1 ? Theme.of(context).primaryColor : Colors.grey.shade600,
                             
                            )
                          ), 'Cart',false
                        ),
                        buildBottomNavigationBarItem(
                          2,  const SizedBox(
                              height: 28,
                              width: 28,
                          ), '',true
                        ),
                        buildBottomNavigationBarItem(
                          3,  Icon(
                            CupertinoIcons.bell,
                            color: apiProvider.bottomIndex == 3 ? Theme.of(context).primaryColor : Colors.grey.shade600,
                            size: 24.0,
                          ), 'Subscription',true
                        ),
                        buildBottomNavigationBarItem(
                          4,  Icon(
                            CupertinoIcons.person,
                            color: apiProvider.bottomIndex == 4 ? Theme.of(context).primaryColor : Colors.grey.shade600,
                            size: 24.0,
                          ), 'Profile',true
                        ),
                      ],
                      
                      type: BottomNavigationBarType.fixed,
                      showUnselectedLabels: true,
                      currentIndex: apiProvider.bottomIndex,
                      selectedItemColor: Theme.of(context).primaryColor,
                      unselectedItemColor: Colors.grey.shade500,
                      backgroundColor: Colors.transparent,
                      elevation: 0, // No shadow for the BottomNavigationBar
                      selectedFontSize: 12.0,
                      unselectedFontSize: 12.0,
                      onTap: (value) {
                        apiProvider.setIndex(value);
                        apiProvider.setQuick(false);
                      },
                    ),
                  ),
                ),
              ],
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FloatingActionButton(
              // backgroundColor: ,
              tooltip: "Quick order",
              elevation: 3,
              splashColor: Colors.white30,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              ),
              foregroundColor: Colors.transparent.withOpacity(0.0),
              onPressed: () async {
                apiProvider.setQuick(true);
                apiProvider.setIndex(2);
                print(apiProvider.quickOrderProductsList.length);
                if (apiProvider.quickOrderProductsList.isEmpty) {
                  await apiProvider.quickOrderProducts();
                }
              },
              child: SizedBox(
                height: 30,
                width: 28,
                child: Image.asset(
                  "assets/category/quick_order.png",
                  color: Colors.white,
                  fit: BoxFit.cover,
                )
              ),
            ),
          )
        );
        
      },
    );
  }

  BottomNavigationBarItem buildBottomNavigationBarItem(int index, Widget icon, String label, bool isQuick) {
 
    final apiProvider = Provider.of<ApiProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    if (index == 1) {
      // Check if the index corresponds to the Cart page
      return BottomNavigationBarItem(
        tooltip: label,
        icon: Badge(
          offset: Offset(
           cartProvider.totalCartProduct < 10 ? -2 : -6, 
            cartProvider.totalCartProduct < 10 ? -5 : -6
          ),
          backgroundColor: Colors.transparent.withOpacity(0.0),
          label: AppTextWidget(
            text: '${cartProvider.totalCartProduct > 99 ? '99' : cartProvider.totalCartProduct}',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            fontColor: apiProvider.bottomIndex == index ? Theme.of(context).primaryColor: Colors.grey.shade600
          ),
          child: icon,
        ),
        label: label,
      );
    } else {
      return BottomNavigationBarItem(
        icon: icon,
        label: label,
      );
    }
  }


  // Get User profile Details from API and Store it in Cache
  
}

