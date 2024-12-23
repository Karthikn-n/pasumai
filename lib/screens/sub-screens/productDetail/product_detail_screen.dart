import 'package:app_3/model/products_model.dart';
import 'package:app_3/providers/api_provider.dart';
import 'package:app_3/providers/cart_items_provider.dart';
import 'package:app_3/screens/sub-screens/productDetail/components/similar_products.dart';
// import 'package:app_3/screens/sub-screens/checkout/payment_screen.dart';
// import 'package:app_3/screens/sub-screens/productDetail/components/review_counts.dart';
// import 'package:app_3/screens/sub-screens/productDetail/components/reviews_dashbaord.dart';
// import 'package:app_3/screens/sub-screens/productDetail/components/reviews_listing.dart';
import 'package:app_3/screens/sub-screens/productDetail/provider/product_detail_provider.dart';
import 'package:app_3/widgets/common_widgets.dart/app_bar.dart';
import 'package:app_3/widgets/common_widgets.dart/button_widget.dart';
import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helper/shared_preference_helper.dart';

class ProductDetailScreen extends StatelessWidget {
  final Products productDetail;
  final String category;
  const ProductDetailScreen({super.key, required this.productDetail, required this.category});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Consumer<ApiProvider>(
      builder: (context, provider, child) {
        SharedPreferences prefs = SharedPreferencesHelper.getSharedPreferences();
        return Scaffold(
          appBar: AppBarWidget(
            title: productDetail.name,
            needBack: true,
            fontSize: 18,
            centerTitle: false,
            onBack: () {
              Navigator.pop(context);
            },
            actions: [
              IconButton(
                onPressed: ()async{
                   await provider.addWishlist(productDetail.id, size, productDetail.name, productDetail.quantity, context);
                }, 
                icon: Icon(
                  prefs.getBool('${productDetail.id}${productDetail.name}${productDetail.quantity}') ?? false
                  ? CupertinoIcons.heart_fill
                  : CupertinoIcons.heart,
                  color: prefs.getBool('${productDetail.id}${productDetail.name}${productDetail.quantity}') ?? false
                  ? Theme.of(context).primaryColor : null,
                )
              )
            ],
          ),
          body: Column(
            children: [
              // Product Detail column
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 15,
                    children: [
                      SizedBox(
                        height: 240,
                        width: double.infinity,
                        child: CachedNetworkImage(
                          imageUrl: 'https://maduraimarket.in/public/image/product/${productDetail.image}',
                          fit: BoxFit.cover,
                        ),
                      ),
                      // Product Detail column
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 15,
                          children: [
                            // product category section
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Theme.of(context).primaryColor.withValues(alpha: 0.3)
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                spacing: 4,
                                children: [
                                  Icon(CupertinoIcons.wand_stars, size: 12, color: Theme.of(context).primaryColor,),
                                  AppTextWidget(
                                    text: category, 
                                    fontColor: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w500, 
                                    fontSize: 12,
                                  ),
                                ],
                              ),
                            ),
                            // Product name and price
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppTextWidget(text: productDetail.name, fontWeight: FontWeight.w600, fontSize: 18,),
                                AppTextWidget(text: '₹${productDetail.finalPrice}', fontWeight: FontWeight.w600, fontSize: 18, fontColor: Theme.of(context).primaryColor,),
                              ],
                            ),
                            // Product offer and rating
                            Row(
                              spacing: 15,
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppTextWidget(
                                  text: '${(((productDetail.price - productDetail.finalPrice) / productDetail.price) * 100).round()}% off', 
                                  fontWeight: FontWeight.w500, 
                                  fontSize: 14,
                                  fontColor: Colors.deepOrangeAccent
                                ),
                                const SizedBox(
                                  height: 14,
                                  width: 1,
                                  child: VerticalDivider(color: Colors.black,),
                                ),
                                const Row(
                                  children: [
                                    Icon(CupertinoIcons.star_fill, color: Colors.yellow, size: 16,),
                                    AppTextWidget(
                                      text: '4.2 (332)', 
                                      fontWeight: FontWeight.w400, fontSize: 14,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            // Product description
                            AppTextWidget(
                              text: productDetail.description.replaceAll("<p>", "").replaceAll("</p>", ""), 
                              fontWeight: FontWeight.w500, 
                              fontSize: 12,
                            ),
                            // Quantity selection
                            AppTextWidget(
                              text: "Quntity", 
                              fontWeight: FontWeight.w600, 
                              fontSize: 16, 
                              fontColor: Theme.of(context).primaryColorDark.withValues(alpha: 0.7),
                            ),
                            // list of quantity
                            Row(
                              spacing: 5,
                              children: List.generate(ProductDetailProvider.quantities.length, (index) {
                                return InkWell(
                                  onTap: () {
                                    ProductDetailProvider.setQuntity(ProductDetailProvider.quantities[index]);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color:  ProductDetailProvider.quantity == ProductDetailProvider.quantities[index] ? Theme.of(context).primaryColor : null,
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(color:  ProductDetailProvider.quantity == ProductDetailProvider.quantities[index] 
                                      ? Colors.transparent :Colors.grey)
                                    ),
                                    child: AppTextWidget(
                                      text: ProductDetailProvider.quantities[index], 
                                      fontColor: ProductDetailProvider.quantity == ProductDetailProvider.quantities[index] 
                                          ? Theme.of(context).primaryColorLight
                                          : Theme.of(context).primaryColorDark,
                                      fontWeight: FontWeight.w500, 
                                      fontSize: 12,
                                    ),
                                  ),
                                );
                              },),
                            ),
                            // Similar products section
                            AppTextWidget(
                              text: "Similar products", 
                              fontWeight: FontWeight.w600, 
                              fontSize: 16, 
                              fontColor: Theme.of(context).primaryColorDark.withValues(alpha: 0.7),
                            ),
                            // Similar product list
                            SizedBox(
                              height: size.height * 0.28,
                              child: SimilarProducts(similarProducts: provider.similarProducts)
                            ),
                            // Review heading
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     AppTextWidget(
                            //       text: "Customer reviews", 
                            //       fontWeight: FontWeight.w600, 
                            //       fontSize: 16, 
                            //       fontColor: Theme.of(context).primaryColorDark.withValues(alpha: 0.7),
                            //     ),
                            //     InkWell(
                            //       onTap: () {
                                   
                            //       },
                            //       child: AppTextWidget(
                            //         text: "Write a review", 
                            //         fontWeight: FontWeight.w400, 
                            //         fontSize: 13, 
                            //         fontColor: Theme.of(context).primaryColor,
                            //       ),
                            //     )
                            //   ],
                            // ),
                            // // Review counts and stars
                            // Column(
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   spacing: 5,
                            //   children: [
                            //     ReviewCounts(average: (4.5).toInt()),
                            //     const AppTextWidget(
                            //       text: "332 total ratings, 58 with reviews", 
                            //       fontWeight: FontWeight.w400, 
                            //       fontSize: 14, 
                            //     ),
                            //   ],
                            // ),
                            // // Reviews dash board
                            // const ReviewsDashbaord(
                            //   ratings: [126, 24, 55, 65, 62], // 126 + 24 + 
                            //   totalRating: 332
                            // ),
                            // // Reviews listing
                            // const ReviewsListing(reviews: 3)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            
              // Product buying button
              SizedBox(
                height: kToolbarHeight + 14,
                child: Consumer<CartProvider>(
                  builder: (context, cartProvider, child) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                      child: cartProvider.cartQuantities[productDetail.id] != null 
                      ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            splashRadius: 120,
                            onPressed: () async {
                              if (cartProvider.cartQuantities[productDetail.id]  != null && cartProvider.cartQuantities[productDetail.id]  == 1) {
                                cartProvider.confirmDelete(id: productDetail.id, size: size, context: context);
                              } else {
                                cartProvider.incrementQuantity(productId: productDetail.id);
                                List<Map<String, dynamic>> cartProductData = [];
                                cartProvider.cartQuantities.forEach((key, value) {
                                  cartProductData.add({
                                    "prdt_id": key,
                                    "prdt_qty": value,
                                    "prdt_total": value * productDetail.finalPrice
                                  });
                                },);
                                await cartProvider.updateCart(size, context, cartProductData, false);
                              }
                            },
                            icon: Icon(
                              cartProvider.cartQuantities[productDetail.id] != null && cartProvider.cartQuantities[productDetail.id] == 1 
                              ? CupertinoIcons.delete
                              : CupertinoIcons.minus, 
                              size: 34, 
                              color: cartProvider.cartQuantities[productDetail.id] != null && cartProvider.cartQuantities[productDetail.id] == 1
                              ? Colors.red
                              : null,
                            )
                          ),
                                              
                          // Indicator quantity
                          Column(
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: "${cartProvider.cartQuantities[productDetail.id]}x ",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).primaryColor
                                  ),
                                  children: [
                                    TextSpan(
                                      text: cartProvider.cartQuantities[productDetail.id]! >= 1 ? "items" :"item",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    )
                                  ]
                                )
                              ),
                              // AppTextWidget(
                                // text:  
                              //   fontWeight: FontWeight.w400,
                              //   fontSize: 14,
                              // ),
                              AppTextWidget(
                                text: "In total - ₹${cartProvider.cartQuantities[productDetail.id]! * productDetail.finalPrice}", 
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              )
                            ],
                          ),

                           IconButton(
                              onPressed: () async {
                                cartProvider.incrementQuantity(productId: productDetail.id, isIncrement: true);
                                List<Map<String, dynamic>> cartProductData = [];
                                cartProvider.cartQuantities.forEach((key, value) {
                                  cartProductData.add({
                                    "prdt_id": key,
                                    "prdt_qty": value,
                                    "prdt_total": value * productDetail.finalPrice
                                  });
                                },);
                                await cartProvider.updateCart(size, context, cartProductData, false);
                              },
                              icon: Icon(
                                CupertinoIcons.plus, 
                                size: 34,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                        ],
                      )
                      : ButtonWidget(
                        width: double.infinity,
                        buttonName: "Add to Cart", 
                        fontSize: 16,
                        onPressed: () async {
                          await cartProvider.addCart(productDetail.id, size, context, productDetail);
                        },
                      ),
                    );
                  }
                ),
              )
            ],
          ),
        );
      }
    );
  }
}