import 'package:app_3/helper/cache_manager_helper.dart';
import 'package:app_3/providers/api_provider.dart';
import 'package:app_3/helper/shared_preference_helper.dart';
import 'package:app_3/helper/page_transition_helper.dart';
import 'package:app_3/providers/cart_items_provider.dart';
import 'package:app_3/providers/subscription_provider.dart';
import 'package:app_3/screens/sub-screens/productDetail/product_detail_screen.dart';
import 'package:app_3/screens/sub-screens/subscription/product_subscribe.dart';
import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/products_model.dart';

class HomeScreenProducts extends StatelessWidget {
  final List<Products> products;
  final Widget? icon;
  final VoidCallback onViewall;
  final String category;
  const HomeScreenProducts({super.key, 
    required this.products, 
    required this.category,
    this.icon, required this.onViewall});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    final addtoWishlistHelper = Provider.of<ApiProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    return  SizedBox(
      height: size.height * 0.4,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (context, index) {
          SharedPreferences prefs = SharedPreferencesHelper.getSharedPreferences();
          Products product = products[index];
          String imageUrl = 'https://maduraimarket.in/public/image/product/${product.image}';
          // String imageUrl = 'http://192.168.1.5/pasumaibhoomi/public/image/product/${product.image}';
          return Row(
            children: [
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor: Colors.white10,
                    borderRadius: BorderRadius.circular(5),
                    onTap: () async {
                      icon == null  ? await addtoWishlistHelper.similarProductsAPI(product.id) : null;
                      Navigator.push(context, SideTransistionRoute(
                        screen: icon != null 
                        ? ProductSubScription(product: product,) 
                        : ProductDetailScreen(productDetail: product, category: category,),
                      ));
                    },
                    child: Ink(
                      // color: Colors.transparent.withValues(alpha: 0.2),
                      child: SizedBox(
                        width:  size.width * 0.7,
                        child: Consumer<SubscriptionProvider>(
                          builder: (context, subscribed, child) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    // Product Image
                                    Material(
                                      shadowColor: Colors.transparent,
                                      color: Colors.transparent,
                                      child: SizedBox(
                                        height: size.height * 0.3,
                                        width: double.infinity,
                                        // width:  size.width * 0.69,
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                                          child: CachedNetworkImage(
                                            imageUrl: imageUrl,
                                            fit: BoxFit.cover,
                                            imageBuilder: (context, imageProvider) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.cover
                                                  )
                                                ),
                                              );
                                            },
                                            cacheManager: CacheManagerHelper.cacheIt(key: product.image),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Wishlist Icon
                                    Positioned(
                                      top: 15,
                                      right: 10,
                                      child: Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              // await addWishlist(product.id, size, product.name, product.quantity);
                                              if (prefs.getBool('${product.id}${product.name}${product.quantity}') ?? true) {
                                               await prefs.setBool('${product.id}${product.name}${product.quantity}',  true);
                                              }else{
                                               await prefs.setBool('${product.id}${product.name}${product.quantity}',  false);
                                              }
                                              await addtoWishlistHelper.addWishlist(product.id, size, product.name, product.quantity, context);
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: Colors.green,
                                                borderRadius: BorderRadius.circular(50)
                                              ),
                                              child: Icon(
                                                prefs.getBool('${product.id}${product.name}${product.quantity}') ?? false
                                                ? CupertinoIcons.heart_fill
                                                : CupertinoIcons.heart, 
                                                size: 20, 
                                                color: prefs.getBool('${product.id}${product.name}${product.quantity}') ?? false
                                                ? Colors.white
                                                : Theme.of(context).scaffoldBackgroundColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ),
                                    // Product subscribed
                                    Positioned(
                                      top: 15,
                                      left: 1,
                                      child: product.subscribed == "Subscribed"
                                      ? Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: const BoxDecoration(
                                          // color: Color(0xFFEA2B01),
                                          color: Color.fromARGB(255, 255, 98, 0),
                                           // ff8c42 -> Pumpkin
                                          // db5461 -> indian
                                          // 183a37 -> dark slate grey
                                          // 183a37 -> mustard
                                          // dc602e -> flame
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(2),
                                            bottomRight: Radius.circular(2)
                                          )
                                        ),
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                "assets/icons/crown.png",
                                                height: 20,
                                                width: 20,
                                                color: Colors.white,
                                              ),
                                              const SizedBox(width: 4,),
                                              const AppTextWidget(fontColor: Colors.white, text: "Subscribed", fontWeight: FontWeight.w500, fontSize: 10,),
                                            ],
                                          )
                                        )
                                      : Container(),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 8,),
                                Container(
                                  padding: const EdgeInsets.only(left: 5),
                                  // width:  size.width * 0.68,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: product.subscribed == "Subscribed" ? size.width * 0.38: size.width * 0.41,
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
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Add a Product to Cart 
                                      cartProvider.cartQuantities[product.id] != null && icon == null
                                      ? Container(
                                          margin: const EdgeInsets.only(right: 4),
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
                                                  if (cartProvider.cartQuantities[product.id]  != null && cartProvider.cartQuantities[product.id]  == 1) {
                                                    cartProvider.confirmDelete(id: product.id, size: size, index: index, context: context);
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
                                        highlightColor: icon != null ? Colors.transparent.withValues(alpha: 0.0) : null,
                                        onPressed: () async {
                                          if (icon != null) {
                                            Navigator.push(context, SideTransistionRoute(
                                              screen: ProductSubScription(product: product,),
                                            ));
                                          }else{
                                            await cartProvider.addCart(product.id, size, context, product);
                                          }
                                        },
                                         icon: icon != null 
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
                            );
                          }
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12,),
              products.length - 1 == index
                ? Tooltip(
                  message: "View all",
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(40),
                        splashColor: Colors.transparent.withValues(alpha: 0.1),
                        splashFactory: InkRipple.splashFactory,
                        onTap: onViewall,
                        child: Container(
                          height: 50,
                          width: 50,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            // border: Border.all(
                            //   // color: Colors.grey.withValues(alpha: 0.1),
                            // ),
                            color: Colors.grey.withValues(alpha: 0.2),
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
                      const AppTextWidget(text: "View all", fontWeight: FontWeight.w400, fontSize: 12,)
                    ],
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
