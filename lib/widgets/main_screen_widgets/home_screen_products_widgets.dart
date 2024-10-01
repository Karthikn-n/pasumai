import 'package:app_3/providers/api_provider.dart';
import 'package:app_3/helper/shared_preference_helper.dart';
import 'package:app_3/helper/page_transition_helper.dart';
import 'package:app_3/providers/cart_items_provider.dart';
import 'package:app_3/repository/app_repository.dart';
import 'package:app_3/screens/sub-screens/subscription/product_subscribe.dart';
import 'package:app_3/service/api_service.dart';
import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
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
    final addtoWishlistHelper = Provider.of<ApiProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
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
                        // await addWishlist(product.id, size, product.name, product.quantity);
                        await addtoWishlistHelper.addWishlist(product.id, size, product.name, product.quantity, context);
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
                          width: size.width > 600 
                            ? size.width * 0.18 
                            : widget.icon != null ? size.width * 0.5 
                            : cartProvider.cartQuantities.isNotEmpty && cartProvider.cartQuantities[product.id] != null
                              ? size.width * 0.53
                              : size.width * 0.6,
                          margin: EdgeInsets.only(left: size.width > 600 ? size.height * 0.08 : size.width * 0.035, top: 5),
                          child: Row(
                            children: [
                             cartProvider.cartQuantities[product.id] != null
                             ? AppTextWidget(
                                text: "${cartProvider.cartQuantities[product.id]}x ", fontSize: 15, fontWeight: FontWeight.w500, fontColor: Theme.of(context).primaryColor,)
                              : Container(),
                              Expanded(
                                child: AppTextWidget(
                                  text: product.name, 
                                  fontSize: 15, 
                                  fontWeight: FontWeight.w600,
                                  maxLines: 1, 
                                  textOverflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          )
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(width: 15,),
                            Row(
                              children: [
                                AppTextWidget(text: "${product.quantity} - ", fontSize: 14, fontWeight: FontWeight.w500),
                                Text(
                                  '₹${product.finalPrice}/',
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
                          ],
                        ),
                      ],
                    ),
                    // Add a Product to Cart 
                    cartProvider.cartQuantities[product.id] != null
                    ? Container(
                        // height: ,
                        // width: size.width * 0.12,
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                print("ProductId: ${product.id}");
                                print("ProductId: ${cartProvider.cartQuantities}");
                                 if (cartProvider.cartQuantities[product.id]  != null && cartProvider.cartQuantities[product.id]  == 1) {
                                  cartProvider.confirmDelete(product.id, size, index, context);
                                } else {
                                  cartProvider.incrementQuantity(productId: product.id);
                                  List<Map<String, dynamic>> cartProductData = [];
                                  cartProvider.cartQuantities.forEach((key, value) {
                                    cartProductData.add({
                                      "prdt_id": key,
                                      "prdt_qty": value,
                                      "prdt_total": value * product.finalPrice
                                    });
                                  },);
                                  addtoWishlistHelper.clearCoupon();
                                  await cartProvider.updateCart(size, context, cartProductData, false);
                                }
                              },
                              child: Icon(
                                cartProvider.cartQuantities[product.id] != null && cartProvider.cartQuantities[product.id] == 1 
                                ? CupertinoIcons.delete
                                : CupertinoIcons.minus, 
                                size: 14, 
                                color: cartProvider.cartQuantities[product.id] != null && cartProvider.cartQuantities[product.id] == 1
                                ? Colors.red
                                : null,
                              )
                            ),
                            const SizedBox(width: 8,),
                            AppTextWidget(
                              text: cartProvider.cartQuantities[product.id] != null && cartProvider.cartQuantities[product.id]! > 99 
                              ? "99+"
                              : "${cartProvider.cartQuantities[product.id]}", fontSize: 13, 
                              fontWeight: FontWeight.w500,
                              fontColor: Colors.black45,
                            ),
                            const SizedBox(width: 8,),
                            GestureDetector(
                              onTap: () async {
                                cartProvider.incrementQuantity(productId: product.id, isIncrement: true);
                                List<Map<String, dynamic>> cartProductData = [];
                                cartProvider.cartQuantities.forEach((key, value) {
                                  cartProductData.add({
                                    "prdt_id": key,
                                    "prdt_qty": value,
                                    "prdt_total": value * product.finalPrice
                                  });
                                },);
                                addtoWishlistHelper.clearCoupon();
                                await cartProvider.updateCart(size, context, cartProductData, false);
                              },
                              child: Icon(
                                CupertinoIcons.plus, 
                                size: 14,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                      )
                    : IconButton(
                      onPressed: () async {
                        if (widget.icon != null) {
                          Navigator.push(context, SideTransistionRoute(
                            screen: ProductSubScription(product: product,),
                          ));
                        }else{
                          await cartProvider.addCart(product.id, size, context, product);
                        }
                      },
                       icon: widget.icon != null 
                          ? widget.icon! 
                          : const Icon(CupertinoIcons.cart_badge_plus, size: 30,)
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

  

}


