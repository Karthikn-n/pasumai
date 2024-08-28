import 'dart:convert';

import 'package:app_3/data/encrypt_ids.dart';
import 'package:app_3/providers/cart_items_provider.dart';
import 'package:app_3/helper/shared_preference_helper.dart';
import 'package:app_3/helper/page_transition_helper.dart';
import 'package:app_3/repository/app_repository.dart';
import 'package:app_3/screens/sub-screens/subscription/product_subscribe.dart';
import 'package:app_3/service/api_service.dart';
import 'package:app_3/widgets/common_widgets.dart/snackbar_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/products_model.dart';

class HomeScreenProducts extends StatefulWidget {
  final List<Products> products;
  final Widget? icon;
  const HomeScreenProducts({super.key, required this.products, this.icon});

  @override
  State<HomeScreenProducts> createState() => _HomeScreenProductsState();
}

class _HomeScreenProductsState extends State<HomeScreenProducts> with TickerProviderStateMixin{
  late List<AnimationController> controller;
  SharedPreferences prefs = SharedPreferencesHelper.getSharedPreferences();
  final wishlistRepository = AppRepository(ApiService('https://maduraimarket.in/api'));
  // final wishlistRepository = AppRepository(ApiService('http://192.168.1.5/pasumaibhoomi/public/api'));
  late List<bool> isLiked;
  @override
  void initState() {
    super.initState();
    isLiked = List.generate(widget.products.length, (index) => false,);
    controller = List.generate(widget.products.length, (index) {
      return AnimationController(
        vsync: this, 
        duration: const Duration(milliseconds: 500), 
        reverseDuration: const Duration(milliseconds: 500)
      );
    },);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    final addtoCartHelper = Provider.of<CartProvider>(context);
    return  Container(
      margin: EdgeInsets.only(left: size.width * 0.008, right: size.width * 0.008),
      height: size.height * 0.45,
      child: CarouselSlider.builder(
        itemCount: widget.products.length,
        options: CarouselOptions(
          height: size.width > 600 ? size.height * 0.8 : size.height * 0.5,
          aspectRatio: 16 / 9,
          // enableInfiniteScroll: true,
          enlargeCenterPage: true,
          viewportFraction: size.width > 600 ? 0.28 : 0.8,
          // autoPlay: true
        ),
        itemBuilder: (context, index, relaindex) {
          Products product = widget.products[index];
          String imageUrl = 'https://maduraimarket.in/public/image/product/${product.image}';
          // String imageUrl = 'http://192.168.1.5/pasumaibhoomi/public/image/product/${product.image}';
          return Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: size.height * 0.34,
                    width: size.width > 600 ? size.height * 0.45 : size.width * 1.2,
                    margin: EdgeInsets.only(left: size.width * 0.03, right: size.width * 0.03),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top:  size.height * 0.021,
                    left:  size.width * 0.58,
                    child: GestureDetector(
                      onTap: () async {
                        await addWishlist(product.id, size, product.name, product.quantity);
                      },
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Center(
                          child: Icon(
                            prefs.getBool('${product.id}${product.name}${product.quantity}') ?? false
                            ? CupertinoIcons.heart_fill
                            : CupertinoIcons.heart, 
                            size: 20, 
                            color: prefs.getBool('${product.id}${product.name}${product.quantity}') ?? false
                            ? Colors.white
                            : Theme.of(context).scaffoldBackgroundColor,
                          )
                        ),
                      ),
                    )
                  )
                ],
              ),
              SizedBox(height: size.height * 0.006,),
              Container(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: size.width > 600 ? size.width * 0.18 : size.width * 0.64,
                          margin: EdgeInsets.only(left: size.width > 600 ? size.height * 0.08 : size.width * 0.035, top: 5),
                          child: Text(
                            product.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600
                            ),
                          )
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(width: 15,),
                            Row(
                              children: [
                                Text(
                                  'Price: ₹${product.finalPrice}/',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: const TextStyle(
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(width: 4,),
                                Text(
                                  "₹${product.price}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w400,
                                    decoration: TextDecoration.lineThrough,
                                    decorationColor: Colors.red,
                                    decorationThickness: 2
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(width: 90,),
                            widget.icon != null
                            ? GestureDetector(
                                onTap: (){
                                  Navigator.push(context, SideTransistionRoute(
                                    screen: const ProductSubScription(),
                                    args: {
                                      'name': product.name,
                                      'image': product.image,
                                      'final': product.finalPrice.toString(),
                                      'price': product.price,
                                      'id': product.id
                                    }
                                  ));
                                },
                                child: widget.icon 
                              )
                            : Container()
                          ],
                        ),
                      ],
                    ),
                    // Add a Product to Cart 
                    GestureDetector(
                      onTap: () async => await addtoCartHelper.addCart(product.id, size, context, product),
                      child: widget.icon != null ? Container() : const Icon(Icons.add_shopping_cart_rounded)
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  
  // Add A product to wishlist
  Future<void> addWishlist(int productId, Size size, String name, String quantity) async {
    Map<String, dynamic> wishlistData = {
      'customer_id': prefs.getString('customerId'),
      'product_id': productId
    };
    print('product Data: $wishlistData');
    final response = await wishlistRepository.addWishList(wishlistData);
    final decryptedResponse = decryptAES(response.body).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), "");
    final decodedReponse = json.decode(decryptedResponse);
    print('Wishlist added Message: $decodedReponse, Stauts code: ${response.statusCode}');
    SnackBar wishlistAddedMessage = snackBarMessage(
      context: context, 
      message: decodedReponse['message'],
      backgroundColor: Theme.of(context).primaryColor, 
      sidePadding: size.width * 0.1, bottomPadding: size.height * 0.85);
    if (response.statusCode == 200 && decodedReponse['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(wishlistAddedMessage);
      setState(() {
        prefs.setBool('$productId$name$quantity', decodedReponse['message'] == "Wishlist added successfully" ? true : decodedReponse['message'] == "Wishlist removed successfully" ? false : false);
      });
    }else{
      ScaffoldMessenger.of(context).showSnackBar(wishlistAddedMessage);
      setState(() {
        prefs.remove('$productId$name$quantity');
      });
    }
  }

  // // Add A product to wishlist
  // Future<void> removeWishlist(int productId, Size size) async {
  //   Map<String, dynamic> wishlistData = {
  //     'customer_id': prefs.getString('customerId'),
  //     'product_id': productId
  //   };
  //   print(wishlistData);

  //   final response = await wishlistRepository.removeWishlist(wishlistData);
  //   final decryptedResponse = decryptAES(response.body).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), "");
  //   final decodedReponse = json.decode(decryptedResponse);
  //   print('Wishlist removed response: $decodedReponse, Stauts code: ${response.statusCode}');
  //   SnackBar wishlistRemovedMessage = snackBarMessage(
  //     context: context, 
  //     message: "Removed from Wishlist",
  //     backgroundColor: Theme.of(context).primaryColor, 
  //     sidePadding: size.width * 0.1, bottomPadding: size.height * 0.85);
  //   if (response.statusCode == 200) {
  //     print("Wishlist removed");
  //     ScaffoldMessenger.of(context).showSnackBar(wishlistRemovedMessage);
  //   }else{
  //     print('Something wrong: $decodedReponse');
  //   }
  // }

}


//  prefs.getBool("wishlist${product.id}") ?? false
  //                       ? CircleAvatar(
  //                           radius: 25,
  //                           backgroundColor: Theme.of(context).primaryColor,
  //                           child: LottieBuilder.asset(
  //                             'assets/animations/like2.json',
  //                             controller: _controller[index],
  //                             fit: BoxFit.cover,
  //                             height: size.height * 0.1,
  //                             width: size.width  * 0.3,
  //                             onLoaded: (composition) {
  //                               _controller[index].duration = composition.duration;
  //                               _controller[index].reverseDuration = composition.duration;
  //                             },
  //                           ),
  //                         )   
  //                       :