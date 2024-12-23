import 'package:app_3/helper/cache_manager_helper.dart';
import 'package:app_3/helper/page_transition_helper.dart';
import 'package:app_3/providers/address_provider.dart';
import 'package:app_3/providers/api_provider.dart';
import 'package:app_3/providers/cart_items_provider.dart';
import 'package:app_3/screens/sub-screens/category_list_screen.dart';
import 'package:app_3/service/connectivity_helper.dart';
import 'package:app_3/widgets/common_widgets.dart/app_bar.dart';
import 'package:app_3/widgets/common_widgets.dart/button_widget.dart';
import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool isLoading  = false;
  @override
  Widget build(BuildContext context) {
    final connectivityService = Provider.of<ConnectivityService>(context);
    Size size = MediaQuery.sizeOf(context);
    if (!connectivityService.isConnected) {
      return Scaffold(
        appBar: const AppBarWidget( title: 'Cart',),
        body: Center(
          child: Image.asset('assets/category/nointernet.png'),
        ),
      );
    } else {
      return Scaffold(
        appBar: const AppBarWidget( title: 'Cart',),
        body: Consumer3<AddressProvider, ApiProvider, CartProvider>(
          builder: (context,addressProvider, apiProvider, cartProvider, child) {
            return  cartProvider.cartItems.isEmpty
            ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 120,
                    width: 120,
                    child: Image.asset(
                      "assets/icons/sad-face.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 10,),
                  const AppTextWidget(text: "No products", fontSize: 18, fontWeight: FontWeight.w500),
                ],
              ),
            )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // List Of Products
                    ListView.builder(
                      key: const PageStorageKey("Cartscreen"),
                      itemCount: cartProvider.cartItems.length,
                      itemBuilder: (context, index) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(top: 10, bottom: 10),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Colors.grey.shade300)
                                ),
                                // borderRadius: BorderRadius.circular(10)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Product Image
                                  SizedBox(
                                    width: 94,
                                    height: 105,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: CachedNetworkImage(
                                        // imageUrl: 'http://192.168.1.5/pasumaibhoomi/public/image/product/${cartProvider.cartItems[index].image}',
                                        imageUrl: 'https://maduraimarket.in/public/image/product/${cartProvider.cartItems[index].image}',
                                        fit: BoxFit.cover,
                                        cacheManager: CacheManagerHelper.cacheIt(key: cartProvider.cartItems[index].image),
                                      ),
                                    ),
                                  ),
                                  // Product Details
                                  SizedBox(
                                    width: size.width * 0.5,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Product Name and Quantity
                                        cartProvider.cartQuantities[cartProvider.cartItems[index].id] != null 
                                        ? RichText(
                                          text: TextSpan(
                                            text: "${cartProvider.cartQuantities[cartProvider.cartItems[index].id]}x ",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Theme.of(context).primaryColor
                                            ),
                                            children: [
                                              TextSpan(
                                                text: cartProvider.cartItems[index].name,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black
                                                )
                                              )
                                            ]
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        )
                                        : AppTextWidget(
                                          text: "${cartProvider.cartItems[index].name}/${cartProvider.cartItems[index].quantity}", 
                                          fontSize: 16, 
                                          maxLines: 2,
                                          textOverflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.w500
                                        ),
                                        const SizedBox(height: 5,),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            // Product Final price
                                            AppTextWidget(
                                              text: "₹${cartProvider.cartItems[index].price.toString()}", 
                                              fontSize: 14, 
                                              fontWeight: FontWeight.w500,
                                              fontColor: Theme.of(context).primaryColor,
                                            ),
                                            const SizedBox(width: 5,),
                                            // Product Price 
                                            Text(
                                              "₹${cartProvider.cartItems[index].listPrice.toString()}",
                                              style: const TextStyle(
                                                fontSize: 14, 
                                                fontWeight: FontWeight.w500,
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
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 40,
                                          height: cartProvider.cartItems[index].quantity >= 1 ? 50: 105,
                                          child: AnimatedSize(
                                            duration: const Duration(milliseconds: 500),
                                            curve: Curves.easeInOut,
                                            child: ElevatedButton(
                                              // increment the quantity
                                              onPressed: () async {
                                                cartProvider.incrementQuantity(productId: cartProvider.cartItems[index].id, isIncrement: true);
                                                List<Map<String, dynamic>> cartProductData = [];
                                                // print(cartProvider.cartItems[index].id);
                                                cartProvider.cartQuantities.forEach((key, value) {
                                                  print("quantity: $value");
                                                  print("value: ${cartProvider.cartItems.firstWhere((element) => element.id == key,).price}");
                                                  cartProductData.add({
                                                    "prdt_id": key,
                                                    "prdt_qty": value,
                                                    "prdt_total": value * int.parse(cartProvider.cartItems.firstWhere((element) => element.id == key,).price)
                                                  });
                                                  
                                                },);
                                                // for (var i = 0; i < apiProvider.cartItems.length; i++) {
                                                // }
                                                apiProvider.clearCoupon();
                                                await cartProvider.updateCart(size, context, cartProductData, false);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: cartProvider.cartItems[index].quantity >= 1 
                                                  ? Theme.of(context).primaryColor
                                                  : Colors.transparent.withValues(alpha: 0.0),
                                                elevation: 0,
                                                alignment: Alignment.centerLeft,
                                                padding: EdgeInsets.fromLTRB(cartProvider.cartItems[index].quantity >= 1 ? 13 : 10, 0, 0, 0),
                                                shadowColor: Colors.transparent.withValues(alpha: 0.0),
                                                overlayColor: cartProvider.cartItems[index].quantity >= 1 
                                                  ? Colors.white12
                                                  : Colors.transparent.withValues(alpha: 0.1),
                                                shape: RoundedRectangleBorder(
                                                  side: cartProvider.cartItems[index].quantity >= 1 
                                                  ? BorderSide.none 
                                                  : BorderSide(color: Colors.grey.shade300),
                                                  borderRadius: BorderRadius.circular(5)
                                                )
                                              ),
                                              child: Icon(
                                                CupertinoIcons.plus,
                                                color: cartProvider.cartItems[index].quantity >= 1 
                                                ? Colors.white
                                                : Theme.of(context).primaryColor,
                                                size: cartProvider.cartQuantities[cartProvider.cartItems[index].id] != null ? 13 : 20,
                                              ) 
                                            ),
                                          ),
                                        ),
                                        cartProvider.cartItems[index].quantity >= 1
                                        ? SizedBox(
                                            width: 40,
                                            height: 50,
                                            child: AnimatedSize(
                                              duration: const Duration(milliseconds: 500),
                                              curve: Curves.easeInOut,
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  // Decrease the quantity of the product
                                                  if (cartProvider.cartQuantities[cartProvider.cartItems[index].id]  == 1) {
                                                    cartProvider.confirmDelete(id: cartProvider.cartItems[index].id, size: size, index: index, context:context);
                                                    } else {
                                                    cartProvider.incrementQuantity(productId: cartProvider.cartItems[index].id);
                                                    List<Map<String, dynamic>> cartProductData = [];
                                                    cartProvider.cartQuantities.forEach((key, value) {
                                                      cartProductData.add({
                                                        "prdt_id": key,
                                                        "prdt_qty": value,
                                                        "prdt_total": value * int.parse(cartProvider.cartItems.firstWhere((element) => element.id == key,).price)
                                                      });
                                                    },);
                                                    apiProvider.clearCoupon();
                                                    await cartProvider.updateCart(size, context, cartProductData, false);
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
                                                  cartProvider.cartQuantities[cartProvider.cartItems[index].id]== 1
                                                  ? CupertinoIcons.delete
                                                  : CupertinoIcons.minus,
                                                  color: cartProvider.cartQuantities[cartProvider.cartItems[index].id] == 1
                                                  ? Colors.red
                                                  : Theme.of(context).primaryColor,
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
                            cartProvider.cartItems.length - 1 == index
                            ? Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10,),
                                  InkWell(
                                    radius: 20,
                                    splashColor: Colors.transparent,
                                    onTap: () {
                                      Navigator.push(context, ReverseSideTransistionRoute(screen: const CategoryListScreen()));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: AppTextWidget(
                                        text: "< Continue shopping", 
                                        fontWeight: FontWeight.w500, 
                                        fontColor: Theme.of(context).primaryColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                            : Container(),
                            SizedBox(height: cartProvider.cartItems.length - 1 == index ? 105 :0,),
                            // 
                          ],
                        );
                      },
                    ),
                    Positioned(
                      top: size.height * 0.74,
                      child: cartProvider.totalCartProduct >= 1 
                      ? isLoading
                      ? LoadingButton(
                        width: size.width * 0.94,
                      )
                      : GestureDetector(
                        onTap: () async {
                          setState(() {
                            isLoading = true;
                          });
                          try {
                            if (addressProvider.addresses.isEmpty) {
                              addressProvider.addnewAddress(context, size);
                            }else{
                              List<Map<String, dynamic>> cartProductData = [];
                              cartProvider.cartQuantities.forEach((key, value) {
                                cartProductData.add({
                                  "prdt_id": key,
                                  "prdt_qty": value,
                                  "prdt_total": value * int.parse(cartProvider.cartItems.firstWhere((element) => element.id == key,).price)
                                });
                              },);
                              apiProvider.clearCoupon();
                              await cartProvider.updateCart(size, context, cartProductData, true);
                            }
                          } catch (e) {
                            print("Can't add to cart $e");
                          } finally {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                        child: Container(
                          height: 50,
                          width: size.width * 0.94,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                spreadRadius: 1.0,
                                blurRadius: 1.0,
                                offset: const Offset(0, 1),
                                color: Colors.transparent.withValues(alpha: 0.2)
                              ),
                            ],
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).primaryColor
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppTextWidget(
                                text: cartProvider.totalCartProduct > 1
                                  ? "${cartProvider.totalCartProduct} items | ₹${cartProvider.totalCartAmount}"
                                  : "${cartProvider.totalCartProduct} item | ₹${cartProvider.totalCartAmount}",
                                fontSize: 16, 
                                fontWeight: FontWeight.w600,
                                fontColor: Colors.white,
                              ),
                              const Row(
                                children: [
                                  AppTextWidget(
                                    text: "Checkout ", 
                                    fontSize: 15, 
                                    fontWeight: FontWeight.w600, 
                                    fontColor: Colors.white,
                                  ),
                                  Icon(CupertinoIcons.chevron_right, size: 20, color: Colors.white,)
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                      : Container()
                    )
                  ],
                ),
              );
          },
        ),
      
      );
    }
  }

}