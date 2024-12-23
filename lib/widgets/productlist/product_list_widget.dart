import 'package:app_3/model/products_model.dart';
import 'package:app_3/providers/api_provider.dart';
import 'package:app_3/providers/cart_items_provider.dart';
import 'package:app_3/providers/subscription_provider.dart';
import 'package:app_3/screens/sub-screens/productDetail/product_detail_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helper/cache_manager_helper.dart';
import '../../helper/page_transition_helper.dart';
import '../../model/selected_product_model.dart';
import '../../screens/sub-screens/subscription/product_subscribe.dart';
import '../common_widgets.dart/text_widget.dart';

class ProductListWidget extends StatelessWidget {
  final List<Products> products;
  final bool? fromQuickOrder;
  final bool? fromSubscription;
  const ProductListWidget({
    super.key, 
    required this.products, 
    this.fromQuickOrder,
    this.fromSubscription
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Consumer3<ApiProvider, SubscriptionProvider, CartProvider>(
      builder: (context, productProvider, subscriptionProvider, cartProvider, child ) {
        return ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            bool condition = productProvider.quickOrderQuantites[products[index].id] != null &&  productProvider.quickOrderQuantites[products[index].id]! >= 1;
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    fromSubscription != null
                    ? Navigator.push(context, SideTransistionRoute(
                        screen: ProductSubScription(product: products[index],),
                      ))
                    : Navigator.push(context, SideTransistionRoute(
                        screen: ProductDetailScreen(productDetail: products[index], category: "Best Seller",),
                      ));
                  },
                  child: Container(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: index == products.length - 1 
                        ? BorderSide.none
                        : BorderSide(color: Colors.grey.shade300)
                      ),
                      // borderRadius: BorderRadius.circular(10)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Product Image
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 94,
                              height: 105,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                  // imageUrl: 'http://192.168.1.5/pasumaibhoomi/public/image/product/${products[index].image}',
                                  imageUrl: 'https://maduraimarket.in/public/image/product/${products[index].image}',
                                  fit: BoxFit.cover,
                                  cacheManager: CacheManagerHelper.cacheIt(key: products[index].image),
                                ),
                              ),
                            ),
                            
                            Positioned(
                              bottom: 0,
                              child: fromSubscription != null && subscriptionProvider.subscribeProducts[index].subscribed == "Subscribed"
                              ? Container(
                                width: 94,
                                  padding: const EdgeInsets.all(5),
                                  decoration: const BoxDecoration(
                                    // color: Color(0xFFEA2B01),
                                    color: Color.fromARGB(255, 255, 98, 0),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(8),
                                      bottomRight: Radius.circular(8)
                                    )
                                  ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          "assets/icons/crown.png",
                                          height: 12,
                                          width: 12,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 4,),
                                        const AppTextWidget(fontColor: Colors.white, text: "Subscribed  ", fontWeight: FontWeight.w500, fontSize: 10,),
                                      ],
                                    )
                                  )
                              : Container(),
                            )
                          ],
                        ),
                           
                        // Product Details
                        SizedBox(
                          width: size.width * 0.5,
                          child: Column(
                            spacing: 5,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Product Name and Quantity
                               RichText(
                                text: TextSpan(
                                  text: fromQuickOrder != null 
                                    ? productProvider.quickOrderQuantites[products[index].id] != null && productProvider.quickOrderQuantites[products[index].id]! >= 1
                                      ? "${productProvider.quickOrderQuantites[products[index].id]}x " :""
                                    : cartProvider.cartQuantities[products[index].id] != null && cartProvider.cartQuantities[products[index].id]! > 0
                                      ? "${cartProvider.cartQuantities[products[index].id]}x ": "",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).primaryColor
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "${products[index].name}/${products[index].quantity}",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black
                                      )
                                    )
                                  ]
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              // Product Description
                              AppTextWidget(
                                text: products[index].description.replaceAll("<p>", "").replaceAll("</p>", ""), 
                                fontSize: 12, 
                                maxLines: 2,
                                fontColor: Colors.grey,
                                textOverflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.w300
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                spacing: 5,
                                children: [
                                  // Product Final price
                                  AppTextWidget(
                                    text: "₹${products[index].finalPrice.toString()}", 
                                    fontSize: 14, 
                                    fontColor: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  // Product Price 
                                  Text(
                                    "₹${products[index].price.toString()}",
                                    style: const TextStyle(
                                      fontSize: 14, 
                                      fontWeight: FontWeight.w400,
                                      decorationThickness: 2,
                                      decorationColor: Colors.grey,
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Increment and Decrement Button
                        SizedBox(
                          height: 105,
                          child: fromSubscription != null && fromSubscription!
                          ? SizedBox(
                            width: 40,
                            child: ElevatedButton(
                                onPressed: () => Navigator.push(context, SideTransistionRoute(
                                  screen: ProductSubScription(product: products[index],),
                                )), 
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent.withValues(alpha: 0.0),
                                  elevation: 0,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.fromLTRB(18, 0, 0, 0),
                                  shadowColor: Colors.transparent.withValues(alpha: 0.0),
                                  overlayColor: Colors.transparent.withValues(alpha: 0.1),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(5)
                                  )
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                                  child: Icon(
                                    CupertinoIcons.chevron_right,
                                    color: Theme.of(context).primaryColor,
                                    size: 20,
                                  ),
                                )
                              ),
                          )
                          : Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 40,
                                height: fromQuickOrder != null 
                                ? productProvider.quickOrderQuantites[products[index].id] != null  && productProvider.quickOrderQuantites[products[index].id]! >= 1 || cartProvider.cartQuantities[products[index].id] != null
                                  ? 50: 105
                                : cartProvider.cartQuantities[products[index].id] != null ? 50: 105,
                                child: AnimatedSize(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      // Add the product to selected list
                                      if (fromQuickOrder != null) {
                                        productProvider.incrementQuickOrderQuantity(
                                          productPrice: products[index].finalPrice, 
                                          productId: products[index].id,
                                          isIncrement: true
                                        );
                                        productProvider.addSelectedProducts(
                                          SelectedProductModel(
                                            id: products[index].id, 
                                            productName: products[index].name,
                                            productQuantity: products[index].quantity, 
                                            quantityIndex: index, 
                                            quantity: productProvider.quickOrderQuantites[products[index].id]!, 
                                            listPrice: products[index].price, 
                                            finalPrice: products[index].finalPrice
                                          ),
                                        );
                                      } else {
                                        if(cartProvider.cartQuantities[products[index].id] != null){
                                          cartProvider.incrementQuantity(productId: products[index].id, isIncrement: true);
                                          List<Map<String, dynamic>> cartProductData = [];
                                          cartProvider.cartQuantities.forEach((key, value) {
                                            cartProductData.add({
                                              "prdt_id": key,
                                              "prdt_qty": value,
                                              "prdt_total": value * products[index].finalPrice
                                            });
                                          },);
                                          await cartProvider.updateCart(size, context, cartProductData, false);
                                        }else{
                                          await cartProvider.addCart(products[index].id, size, context, products[index]);
                                        }
                                      }
                                    }, 
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: productProvider.quickOrderQuantites[products[index].id] != null &&  productProvider.quickOrderQuantites[products[index].id]! >= 1 
                                        ? Theme.of(context).primaryColor
                                        : Colors.transparent.withValues(alpha: 0.0),
                                      elevation: 0,
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.fromLTRB(condition ? 13 : 10, 0, 0, 0),
                                      shadowColor: Colors.transparent.withValues(alpha: 0.0),
                                      overlayColor: condition 
                                        ? Colors.white12
                                        : Colors.transparent.withValues(alpha: 0.1),
                                      shape: RoundedRectangleBorder(
                                        side: condition 
                                        ? BorderSide.none 
                                        : BorderSide(color: Colors.grey.shade300),
                                        borderRadius: BorderRadius.circular(5)
                                      )
                                    ),
                                    child: Icon(
                                      CupertinoIcons.plus,
                                      color: condition 
                                      ? Colors.white
                                      : Theme.of(context).primaryColor,
                                      size: condition ? 13 : 20,
                                    ) 
                                  ),
                                ),
                              ),
                              condition || cartProvider.cartQuantities[products[index].id] != null
                              ? SizedBox(
                                  width: 40,
                                  height: 50,
                                  child: AnimatedSize(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        if (fromQuickOrder != null) {
                                          // Decrease the quantity of the product
                                          productProvider.incrementQuickOrderQuantity(
                                            productPrice: products[index].finalPrice, 
                                            productId: products[index].id,
                                            // index: index,
                                          );
                                          // Remove the product from the selected list
                                          productProvider.addSelectedProducts(
                                            SelectedProductModel(
                                              id: products[index].id, 
                                              productName: products[index].name,
                                              productQuantity: products[index].quantity, 
                                              quantityIndex: index, 
                                              quantity: productProvider.quickOrderQuantites[products[index].id]!, 
                                              listPrice: products[index].price, 
                                              finalPrice: products[index].finalPrice
                                            )
                                          );
                                        }else{
                                          if (cartProvider.cartQuantities[products[index].id]  != null && cartProvider.cartQuantities[products[index].id]  == 1) {
                                            cartProvider.confirmDelete(id: products[index].id, size: size, context: context);
                                          } else {
                                            cartProvider.incrementQuantity(productId: products[index].id);
                                            List<Map<String, dynamic>> cartProductData = [];
                                            cartProvider.cartQuantities.forEach((key, value) {
                                              cartProductData.add({
                                                "prdt_id": key,
                                                "prdt_qty": value,
                                                "prdt_total": value * products[index].finalPrice
                                              });
                                            },);
                                            await cartProvider.updateCart(size, context, cartProductData, false);
                                          }
                                        }
                                      }, 
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent.withValues(alpha: 0.0),
                                        elevation: 0,
                                        alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                                        shadowColor: Colors.transparent.withValues(alpha: 0.0),
                                        overlayColor: Colors.transparent.withValues(alpha: 0.1),
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(color: Colors.grey.shade300),
                                          borderRadius: BorderRadius.circular(5)
                                        )
                                      ),
                                      child: Icon(
                                        CupertinoIcons.minus,
                                        color: Theme.of(context).primaryColor,
                                        size: 15,
                                      )
                                    ),
                                  ),
                                )
                              : Container()
                            ],
                          ),
                        ),
                      
                      ],
                    ),
                  ),
                ),
                SizedBox(height: products.length - 1 == index ? 105 :0,)
              ],
            );
          },
        );
      }
    );
  }
}