import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/common_data.dart';

// auth app bar
Widget customAppbar(String title){
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent.withOpacity(1.0),
          Colors.transparent.withOpacity(0.9),
          // Colors.transparent.withOpacity(0.6),
          Colors.transparent.withOpacity(0.7),
          Colors.transparent.withOpacity(0.5),
          // Colors.transparent.withOpacity(0.3),
          Colors.transparent.withOpacity(0.3),
          Colors.transparent.withOpacity(0.1),
          Colors.transparent.withOpacity(0.0),
        ]
      )
    ),
    height: 60,
    child: Align(
      alignment: Alignment.bottomCenter,
      child: Text(
        title,
        style: const TextStyle(fontSize: 16),
      ),
    ),
  );
              
}
// auth buttons
Widget buttons(String title){
// int hexToInteger(String hex) => int.parse(hex, radix: 16);
  return Container(
    margin: EdgeInsets.only(top: title == "Let's Go" ? 10 :14),
    height: 45,
    width: 299,
    decoration: BoxDecoration(
      color:  const Color(0xFF60B47B),
      // border: Border.all(color: title == 'Login' ? Colors.deepOrange.shade200 : Colors.green.shade300),
      borderRadius: BorderRadius.circular(8)
    ),
    child: Center(
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w300,
          color: Colors.white
        ),
      )
    ),
  );
}
// home app bar
PreferredSizeWidget homeAppBar(String title){
    return  AppBar(
      leading: const Icon(
        Icons.location_pin,
        size: 24,
      ),
      surfaceTintColor: Colors.transparent,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16
        ),
      ),
      centerTitle: true,
    );
  }
PreferredSizeWidget orderBar(String title){
    return  AppBar(
      leading: const Icon(
        Icons.location_pin,
        size: 24,
      ),
      surfaceTintColor: Colors.transparent,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16
        ),
      ),
      centerTitle: true,
    );
  }
// Title for every home section
Widget heading(String title, double size){
  return Container(
    margin: const EdgeInsets.only(left: 20),
    child: Text(
      title,
      style:  TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: size
      ),
    ),
  );
}

// Categories section in home (first section)
Widget categoryWidget(BuildContext context){
  return Container(
    margin: EdgeInsets.zero,
    child: Column(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 8, right: 8),
          height: 135,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Container(
                    height: 100,
                    width: 90,
                    margin: const EdgeInsets.only(left: 20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: categories[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    width: 90,
                    height: 24,
                    child: Text(
                      names[index],
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        )
      ],
    ),
  );
}

// best seller
Widget quickOrder(BuildContext context, String title){
   double screenHeight = MediaQuery.of(context).size.height;
  double screenWidth = MediaQuery.of(context).size.width;

 
  return Container(
    margin: EdgeInsets.only(left: screenWidth * 0.008, right: screenWidth * 0.008),
    height: screenHeight * 0.45,
    child: CarouselSlider.builder(
      itemCount: restaurants.length,
      options: CarouselOptions(
        height: screenWidth > 600 ? screenHeight * 0.7 : screenHeight * 0.48,
        aspectRatio: 16/9,
        // enableInfiniteScroll: true,
        enlargeCenterPage: true,
        viewportFraction: screenWidth > 600 ? 0.3 : 0.8,
        // autoPlay: true
      ),
      itemBuilder: (context, index, relaindex) {
        return Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: screenHeight * 0.34,
              width: screenWidth > 600 ? screenHeight * 0.45: screenWidth * 1.2,
              margin:  EdgeInsets.only(left: screenWidth * 0.03, right: screenWidth * 0.03),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: restaurants[index],
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.006,),
            Container(
              alignment: Alignment.bottomCenter,
              // margin: const EdgeInsets.only(left: 40),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: screenWidth > 600 ? screenHeight * 0.08 : screenWidth * 0.035),
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: screenHeight * 0.025
                          ),
                        )
                      ),
                      // const SizedBox(height: 6,),
                      Container(
                        margin:  EdgeInsets.only(left: screenWidth > 600 ? screenHeight * 0.08 :screenWidth * 0.035),
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: screenHeight * 0.014
                          ),
                        )
                      ),
                    ],
                  ),
                  SizedBox(width: screenWidth > 600 ? screenWidth * 0.14 : screenWidth * 0.5,),
                  const Icon(Icons.shopping_cart)
                ],
              ),
            ),
          ],
        );
      },
    ),
  );
}

Widget subscribeProduct(BuildContext context, String name, String price){
    double screenHeight = MediaQuery.of(context).size.height;
  double screenWidth = MediaQuery.of(context).size.width;

 
  return Container(
    margin:  EdgeInsets.only(left: screenWidth * 0.008, right: screenWidth * 0.008),
    height: screenHeight * 0.45,
    child: CarouselSlider.builder(
      options: CarouselOptions(
        height: screenWidth > 600 ? screenHeight * 0.7 : screenHeight * 0.49,
        aspectRatio: 16/9,
        enableInfiniteScroll: true,
        enlargeCenterPage: true,
        viewportFraction: screenWidth > 600 ? 0.3 : 0.8,
        // autoPlay: true
      ),
      itemCount: products.length,
      itemBuilder: (context, index, realindex) {
        return Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: screenHeight * 0.34,
              width: screenWidth > 600 ? screenHeight * 0.45: screenWidth * 1.2,
              margin:  EdgeInsets.only(left: screenWidth * 0.03, right: screenWidth * 0.03),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl:products[index],
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: screenWidth * 0.006,),
            Row(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: screenWidth > 600 ? screenHeight * 0.08 :screenWidth * 0.035),
                      child: Text(
                        name,
                        style: TextStyle(
                          fontSize: screenHeight * 0.025
                        ),
                      )
                    ),
                    SizedBox(height: screenHeight * 0.004,),
                    Container(
                      margin: EdgeInsets.only(left: screenWidth > 600 ? screenHeight * 0.08 : screenWidth * 0.035),
                      child: Row(
                        children: [
                          Icon(
                            Icons.currency_rupee,
                            size: screenHeight * 0.014,  
                          ),
                          Text(
                            price,
                            style: TextStyle(
                              fontSize: screenHeight * 0.014
                            ),
                          ),
                        ],
                      )
                    ),
                  ],
                ),
                SizedBox(width: screenWidth > 600 ? screenWidth * 0.14 : screenWidth * 0.44,),
                GestureDetector(
                  onTap: (){},
                  child:  const Icon(
                    Icons.shopping_cart,
                    // size: screenHeight * 0.035,
                  )
                )
              ],
            ),
          ],
        );
      },
    ),
  );

}

// Cart page app bar
PreferredSizeWidget cartAppBar(BuildContext context){
  return AppBar(
    title: const Text(
      'Your Cart',
      style: TextStyle(
        fontSize: 16
      ),
    ),
    centerTitle: true,
    surfaceTintColor: Colors.transparent,
  );     
}

// This class help to add cart item in the cart page
class CartItem {
  String name;
  double rating;
  late int quantity;
  double price;

  CartItem({
    required this.name,
    required this.rating,
    required this.quantity,
    required this.price,
  });

  CartItem.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        rating = json['rating'],
        price = json['price'];

  // Serialize to JSON
  Map<String, dynamic> toJson() => {
        'name': name,
        'rating': rating,
        'price': price,
      };
}
// Sample cart item
  List<CartItem> cartItems = [
    CartItem(name: 'Product Name 1', rating: 2.1, quantity: 1, price: 10),
    CartItem(name: 'Product Name 2', rating: 3.2, quantity: 1, price: 20),
    CartItem(name: 'Product Name 3', rating: 4.3, quantity: 1, price: 30),
  ];

  // Notification page App bar
PreferredSizeWidget subscribeListAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        'Subscription ',
        style: TextStyle(fontSize: 16),
      ),
      centerTitle: true,
      surfaceTintColor: Colors.transparent,
      // leading: GestureDetector(
      //   onTap: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => BottomBar())),
      //   child: const Padding(
      //     padding: EdgeInsets.only(left: 10.0),
      //     child: Icon(
      //       Icons.arrow_back,
      //       size: 24,
      //     ),
      //   ),
      // ),
    );
  }
Widget headBar(){
  return Center(
    child: Container(
      width: 70,
      margin: const EdgeInsets.only(left: 60, right: 60,),
      child: const Divider(
        thickness: 2,
        color: Colors.black54,
      ),
    ),
  );
}
 Future<void> precacheBestProduct(List<String> imageUrls) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cachedImageUrls = prefs.getStringList('bestproduct') ?? [];

    for (final url in imageUrls) {
      if (!cachedImageUrls.contains(url)) {
        // Cache the image using flutter_cache_manager
        await DefaultCacheManager().downloadFile(url);

        // Update the cached image URLs in shared preferences
        cachedImageUrls.add(url);
        prefs.setStringList('bestproduct', cachedImageUrls);
      }
    }
  }


Widget subscriptionButton(){
  return  Container(
    height: 50,
    width: 240,
    decoration: BoxDecoration(
      // border: Border.all(color: Colors.green.shade300),
      color: const Color(0xFF60B47B),
      borderRadius: BorderRadius.circular(10)
    ),
    child: const Center(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart
          ),
          SizedBox(width: 10,),
          Text(
            'Subscribe',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w300
            ),
          )
        ],
      ),
    ),
  );             
}


Widget tabTitle(String title){
  return Container(
    width: 160,
    margin: const EdgeInsets.only(left: 10),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w500
      ),
    )
  );
}





// Profile app bar
PreferredSizeWidget profileAppBar(BuildContext context){
    return AppBar(
      title: const Text('Profile', style: TextStyle(fontSize: 16),),
      centerTitle: true,
      surfaceTintColor: Colors.transparent,
      // leading: GestureDetector(
      //   onTap:() => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => BottomBar(),)),
      //   child: const Padding(
      //     padding: EdgeInsets.only(left: 10),
      //     child: Icon(
      //       Icons.arrow_back,
      //       size: 24,
      //     ),
      //   ),
      // ),
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: Icon(
            Icons.settings,
            size: 24,
          ), 
        )
      ],
    );
  }


// form fields
 Widget buildFormField({
    required String hintText,
    required IconData icon,
    TextInputType? keyboardType,
    Function(String)? onChanged,
    required TextEditingController controller,
    required TextInputAction textInputAction,
    String? Function(String?)? validator,
  }) {
    return Center(
      child: Container(
        height: 55,
        width: 309,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(icon),
            border: InputBorder.none,
            hintStyle: TextStyle(
              color: Colors.grey.withOpacity(0.5) 
            )
          ),
          keyboardType: keyboardType,
          onChanged: onChanged,
          textInputAction: textInputAction,
          validator: validator,
        ),
      ),
    );
  }
  

class LocationPart{
  final String name;
  String address;
  String city;
  final String? pincode;
  final String email;
  final String mobile;

  LocationPart({
    required this.name, 
    required this.address,
    required this.city,
    this.pincode,
    required this.email,
    required this.mobile
  });
}
  List<LocationPart> locations = [
    LocationPart(name: 'Ramanujam P', address: '123, Main st,', city: 'Kochin', pincode: '245521', email: 'ramanujam.infinity@gmail.com', mobile: '987654321'),
  ];

  class LocationAPIList{
  final String flatNo;
  final String address;
  final String floor;
  final String landMark;
  final String region;
  final String town;
  final String pincode;

  LocationAPIList({
    required this.flatNo, 
    required this.address, 
    required this.floor, 
    required this.landMark, 
    required this.region, 
    required this.town, 
    required this.pincode,
  });
}

  List<LocationAPIList> yourLocations = [];



class CustomPageRoute extends PageRoute {
  final WidgetBuilder pageBuilder;

  CustomPageRoute({required this.pageBuilder})
      : super(settings: const RouteSettings(name: '/customPageRoute'));

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return pageBuilder(context);
  }

  @override
  Widget buildTransitions(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    const begin = Offset(1.0, 0.0);
    const end = Offset.zero;
    const curve = Curves.easeInOut;
    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    var offsetAnimation = animation.drive(tween);
    return SlideTransition(position: offsetAnimation, child: child);
  }
}



