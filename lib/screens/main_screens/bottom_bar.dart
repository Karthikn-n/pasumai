import 'dart:convert';

import 'package:app_3/data/encrypt_ids.dart';
import 'package:app_3/providers/api_provider.dart';
import 'package:app_3/providers/cart_items_provider.dart';
import 'package:app_3/helper/shared_preference_helper.dart';
import 'package:app_3/repository/app_repository.dart';
import 'package:app_3/screens/main_screens/cart_screen.dart';
import 'package:app_3/screens/main_screens/profile_screen.dart';
import 'package:app_3/screens/main_screens/subcribe_products_screen.dart';
import 'package:app_3/service/api_service.dart';
import 'package:app_3/service/connectivity_helper.dart';
import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_page.dart';

class BottomBar extends StatefulWidget {
  int selectedIndex;
  BottomBar({super.key, required this.selectedIndex});

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


  @override
  void initState() {
    super.initState();
    userProfileAPI();
  }

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
      // const CartPage(),
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
                        buildBottomNavigationBarItem(0, Icons.home, 'Home'),
                        buildBottomNavigationBarItem(1, Icons.shopping_bag_outlined, 'Cart'),
                        buildBottomNavigationBarItem(2, Icons.notifications, 'Subscription'),
                        buildBottomNavigationBarItem(3, Icons.person, 'Profile')
                      ],
                      type: BottomNavigationBarType.fixed,
                      showUnselectedLabels: true,
                      currentIndex: widget.selectedIndex,
                      selectedItemColor: Colors.blue,
                      unselectedItemColor: Colors.grey.shade500,
                      backgroundColor: Colors.transparent,
                      elevation: 0, // No shadow for the BottomNavigationBar
                      selectedFontSize: 12.0,
                      unselectedFontSize: 12.0,
                      onTap: (value) async {
                        setState(() {
                          widget.selectedIndex = value;
                        });
                      },
                    ),
                  ),
                )
              ],
            ),
          )
        : PopScope(
          canPop: false,
          onPopInvoked: (didPop) async {
            if (widget.selectedIndex != 0) {
              setState(() {
                widget.selectedIndex = 0;
              });
              return;
            } else {
            }
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                // Your main content goes here
                Positioned.fill(
                  child: PageStorage(
                    bucket: PageStorageBucket(),
                    child: _pages[widget.selectedIndex],
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
                        buildBottomNavigationBarItem(0, Icons.home, 'Home'),
                        buildBottomNavigationBarItem(1, Icons.shopping_bag_outlined, 'Cart'),
                        buildBottomNavigationBarItem(2, Icons.notifications, 'Subscription'),
                        buildBottomNavigationBarItem(3, Icons.person, 'Profile')
                      ],
                      type: BottomNavigationBarType.fixed,
                      showUnselectedLabels: true,
                      currentIndex: widget.selectedIndex,
                      selectedItemColor: Colors.blue,
                      unselectedItemColor: Colors.grey.shade500,
                      backgroundColor: Colors.transparent,
                      elevation: 0, // No shadow for the BottomNavigationBar
                      selectedFontSize: 12.0,
                      unselectedFontSize: 12.0,
                      onTap: (value) async {
                        if (value == 0) {
                          apiProvider.setQuick(false);
                        }
                        setState(() {
                          widget.selectedIndex = value;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          )
        );
        
      },
    );
  }

  BottomNavigationBarItem buildBottomNavigationBarItem(int index, IconData icon, String label) {
    final cartItemsList = Provider.of<CartProvider>(context);
    if (index == 1) {
      // Check if the index corresponds to the Cart page
      return BottomNavigationBarItem(
        icon: Badge(
          backgroundColor: widget.selectedIndex == index ? Colors.blue : Colors.grey.shade500,
          smallSize: 12,
          largeSize: 18,
          label: AppTextWidget(
            text: '${cartItemsList.cartItems.length > 100 ? '99+' : cartItemsList.cartItems.length}',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontColor: widget.selectedIndex == index ? Colors.white : Colors.black
          ),
          child: Icon(
            icon,
            color: widget.selectedIndex == index ? Colors.blue : Colors.grey.shade500,
            size: 28.0,
          ),
        ),
        label: label,
      );
    } else {
      return BottomNavigationBarItem(
        icon: Icon(
          icon,
          color: widget.selectedIndex == index ? Colors.blue : Colors.grey.shade500,
          size: 28.0,
        ),
        label: label,
      );
    }
  }

  // Get User profile Details from API and Store it in Cache
  Future<void> userProfileAPI() async {
    Map<String, dynamic> userData = {
      'customer_id': prefs.getString('customerId')
    };

    final response = await bottomRepository.userprofile(userData);
    String decryptedResponse = decryptAES(response.body).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '');
    final decodedResponse = json.decode(decryptedResponse);
    print('Profile Response: $decodedResponse, Status Code: ${response.statusCode}');

    if (response.statusCode == 200 && decodedResponse['status'] == 'success') {

      prefs.setString('firstname', '${decodedResponse['results']['first_name'] ?? ''}');
      prefs.setString('lastname', '${decodedResponse['results']['last_name'] ?? ''}');
      prefs.setString('mail', '${decodedResponse['results']['email'] ?? ''}');
      prefs.setString('mobile', '${decodedResponse['results']['mobile_no'] ?? ''}');
      // print('firstName: ${prefs.getString('firstname') ?? ''}');
      // print('lastname: ${prefs.getString('lastname') ?? ''}');
      // print('mail: ${prefs.getString('mail') ?? ''}');
      // print('mobile: ${prefs.getString('mobile') ?? ''}');
    } else {
      print('Error: ${response.body}');
    }
  }


}

