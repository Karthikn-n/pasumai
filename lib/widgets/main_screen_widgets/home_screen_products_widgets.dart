import 'package:app_3/providers/api_provider.dart';
import 'package:app_3/helper/shared_preference_helper.dart';
import 'package:app_3/helper/page_transition_helper.dart';
import 'package:app_3/providers/cart_items_provider.dart';
import 'package:app_3/repository/app_repository.dart';
import 'package:app_3/screens/sub-screens/subscription/product_subscribe.dart';
import 'package:app_3/service/api_service.dart';
import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/products_model.dart';

class HomeScreenProducts extends StatefulWidget {
  final List<Products> products;
  final Widget? icon;
  final VoidCallback onViewall;
  const HomeScreenProducts({super.key, required this.products, this.icon, required this.onViewall});

  @override
  State<HomeScreenProducts> createState() => _HomeScreenProductsState();
}

class _HomeScreenProductsState extends State<HomeScreenProducts>{
  SharedPreferences prefs = SharedPreferencesHelper.getSharedPreferences();
  final wishlistRepository = AppRepository(ApiService('https://maduraimarket.in/api'));
  // final wishlistRepository = AppRepository(ApiService('http://192.168.1.5/pasumaibhoomi/public/api'));
  late List<bool> isLiked;
  @override
  void initState() {
    super.initState();
    isLiked = List.generate(widget.products.length, (index) => false,);
   
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    final addtoWishlistHelper = Provider.of<ApiProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    return  SizedBox(
      height: size.height * 0.4,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.products.length,
        itemBuilder: (context, index) {
          Products product = widget.products[index];
          String imageUrl = 'https://maduraimarket.in/public/image/product/${product.image}';
          // String imageUrl = 'http://192.168.1.5/pasumaibhoomi/public/image/product/${product.image}';
          return Row(
            children: [
              SizedBox(
                width:  size.width * 0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        // Product Image
                        SizedBox(
                          height: size.height * 0.3,
                          width:  size.width * 0.69,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        // Wishlist Icon
                        Positioned(
                          top: 15,
                          left:  190,
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
                    const SizedBox(height: 8,),
                    SizedBox(
                      width:  size.width * 0.7,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: size.width * 0.43,
                            // width:widget.icon != null ? size.width * 0.31 
                            //       : cartProvider.cartQuantities.isNotEmpty && cartProvider.cartQuantities[product.id] != null
                            //         ? size.width * 0.5
                            //         : size.width * 0.5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                   cartProvider.cartQuantities[product.id] != null
                                   ? AppTextWidget(
                                      text: "${cartProvider.cartQuantities[product.id]}x ", fontSize: 16, fontWeight: FontWeight.w500, fontColor: Theme.of(context).primaryColor,)
                                    : Container(),
                                    Expanded(
                                      child: AppTextWidget(
                                        text: product.name, 
                                        fontSize: 14, 
                                        fontWeight: FontWeight.w400,
                                        maxLines: 1, 
                                        textOverflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        AppTextWidget(
                                          text: "${product.quantity} - ", 
                                          fontSize: 14, 
                                          // fontColor: Colors.grey,
                                          fontWeight: FontWeight.w400
                                        ),
                                        Text(
                                          '₹${product.finalPrice}/',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color:  Theme.of(context).primaryColor
                                          ),
                                        ),
                                        const SizedBox(width: 4,),
                                        Text(
                                          "₹${product.price}",
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w400,
                                            decoration: TextDecoration.lineThrough,
                                            decorationColor: Colors.grey,
                                            decorationThickness: 2
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Add a Product to Cart 
                          cartProvider.cartQuantities[product.id] != null
                          ? Container(
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
                                    : "${cartProvider.cartQuantities[product.id]}", fontSize: 12, 
                                    fontWeight: FontWeight.w600,
                                    fontColor: Colors.grey,
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
                            // splashRadius:  widget.icon != null ? 0.1 : null,
                            highlightColor: widget.icon != null ? Colors.transparent.withOpacity(0.0) : null,
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
                                ? Container(
                                  padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    child: const AppTextWidget(
                                      text: "Subscribe", fontSize: 12, 
                                      fontWeight: FontWeight.w500,
                                      fontColor: Colors.white,
                                    )
                                ) 
                                : const Icon(CupertinoIcons.cart_badge_plus, size: 30,)
                            )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12,),
              widget.products.length - 1 == index
                ? Padding(
                  padding: EdgeInsets.only(bottom: size.height *0.1,),
                  child: Tooltip(
                    message: "View all",
                    child: InkWell(
                      borderRadius: BorderRadius.circular(40),
                      splashColor: Colors.transparent.withOpacity(0.1),
                      splashFactory: InkRipple.splashFactory,
                      onTap: widget.onViewall,
                      child: Container(
                        height: 50,
                        width: 50,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          // border: Border.all(
                          //   // color: Colors.grey.withOpacity(0.1),
                          // ),
                          color: Colors.grey.withOpacity(0.2),
                          // shape: BoxShape.circle
                        ),
                        child: const Center(
                          child: Icon(
                            CupertinoIcons.chevron_right,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                : Container()
            ],
          );
        },
      ),
    );
  }

  

}


