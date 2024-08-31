import 'package:app_3/model/products_model.dart';
import 'package:app_3/model/wishlist_products_model.dart';
import 'package:app_3/providers/api_provider.dart';
import 'package:app_3/providers/cart_items_provider.dart';
import 'package:app_3/widgets/common_widgets.dart/app_bar.dart';
import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WishlistProducts extends StatelessWidget {
  const WishlistProducts({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Wishlist',
        onBack: () => Navigator.pop(context),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Consumer2<ApiProvider, CartProvider>(
          builder: (context, wishlistProvider, cartProvider, child) {
            return wishlistProvider.wishlistProducts.isEmpty
            ? const Center(
              child: AppTextWidget(text: "No Products", fontSize: 15, fontWeight: FontWeight.w500),
            )
            : ListView.builder(
              itemCount: wishlistProvider.wishlistProducts.length,
              itemBuilder: (context, index) {
                WishlistProductsModel product = wishlistProvider.wishlistProducts[index];
                String image = 'https://maduraimarket.in/public/image/product/${product.image}';
                // String image = 'http://192.168.1.5/pasumaibhoomi/public/image/product/${product.image}';
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade300
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: size.width * 0.25,
                            height: size.height * 0.1,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: image,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: size.width * 0.4,
                                child: AppTextWidget(
                                  text: product.title, 
                                  fontSize: 14, 
                                  maxLines: 2,
                                  textOverflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.w400
                                ),
                              ),
                              Row(
                                children: [
                                  AppTextWidget(
                                    text: '₹${product.finalPrice}', 
                                    fontSize: 16, 
                                    fontWeight: FontWeight.w500
                                  ),
                                  const SizedBox(width: 5,),
                                  Text(
                                    "₹${product.price}",
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w400,
                                      decoration: TextDecoration.lineThrough,
                                      decorationColor: Colors.red
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                width: size.width * 0.4,
                                child: AppTextWidget(
                                  text: product.description.replaceAll("<p>", ""), 
                                  fontSize: 13, 
                                  maxLines: 1,
                                  textOverflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.w400
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  await cartProvider.addCart(
                                    product.productId, 
                                    size, context, 
                                    Products(
                                      id: product.productId, 
                                      name: product.title, 
                                      price: product.price, 
                                      finalPrice: product.price, 
                                      image: product.image, 
                                      quantity: product.quantity, 
                                      description: product.description
                                    )
                                  );
                                },
                                child: const Icon(
                                  CupertinoIcons.cart,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 10,),
                              GestureDetector(
                                onTap: () {
                                  wishlistProvider.removeWishlistMessage(
                                    product.productId , 
                                    product.title,
                                    product.quantity, context, size
                                  );
                                  // if (wishlistProvider.removedMessage != null) {
                                   
                                    
                                  // }
                                },
                                child: const Icon(
                                  CupertinoIcons.delete,
                                  size: 22,
                                  color: Colors.red,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 10,)
                  ],
                );
              },
            );
          }
        )
      ),
    );
  
  }
}