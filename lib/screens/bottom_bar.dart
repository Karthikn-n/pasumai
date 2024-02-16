// ignore_for_file: must_be_immutable


import 'package:app_3/screens/subscription_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'cart_page.dart';
import 'home_page.dart';
import 'profile_page.dart';

class BottomBar extends StatefulWidget {
 // This will help to navigate with any of the page in this bottom bar from other page

  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  late int selectedIndex;
  DateTime? currentPress;
  // List of pages in the0 bottom navigation bar
  final List<Widget> _pages = const [
    HomePage(),
    CartPage(),
    SubscriptionList(),
    ProfilePage(),
  ];

  static const List<IconData> _selectedIcons = [
    Icons.home,
    Icons.shopping_bag_rounded,
    Icons.notifications,
    Icons.person,
  ];

  String _getLabel(int index) {
    switch (index) {
      case 0:
        return 'Home';
      case 1:
        return 'Cart';
      case 2:
        return 'Subscription';
      case 3:
        return 'Profile';
      default:
        return '';
    }
  }

@override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Retrieve the mobile number from the previous screen
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, int>;
    selectedIndex = args['selectedIndex']!;
   

  }
  @override
  Widget build(BuildContext context) {
    
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if(selectedIndex != 0){
          setState(() {
            selectedIndex = 0;
          });
          return;
        } else {
          final now = DateTime.now();
          if(currentPress == null || now.difference(currentPress!) > const Duration(seconds: 2)){
            currentPress = now;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                elevation: 1,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                backgroundColor:  Color(0xFF60B47B),
                content: const Text('Press back again to exit', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),
                duration: const Duration(seconds: 1),
              ),
            );
            return;
          } else {
            SystemNavigator.pop();
          }
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
                child: _pages[selectedIndex],
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
                  
                  items: List.generate(4, (index) {
                    return BottomNavigationBarItem(
                      icon: Icon(
                        _selectedIcons[index],
                        color: selectedIndex == index ? Colors.blue : Colors.grey.shade500,
                        size: 28.0,
                      ),
                      label: _getLabel(index),
                    );
                  }),
                  type: BottomNavigationBarType.fixed,
                  showUnselectedLabels: true,
                  currentIndex: selectedIndex,
                  selectedItemColor: Colors.blue,
                  unselectedItemColor: Colors.grey.shade500,
                  backgroundColor: Colors.transparent,
                  elevation: 0, // No shadow for the BottomNavigationBar
                  selectedFontSize: 12.0,
                  unselectedFontSize: 12.0,
                  onTap: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                ),
              ),
            ),
         
          ],
        ),
      ),
    );
  }

}

