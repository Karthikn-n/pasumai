import 'package:app_3/providers/address_provider.dart';
import 'package:app_3/providers/api_provider.dart';
import 'package:app_3/providers/cart_items_provider.dart';
import 'package:app_3/service/connectivity_helper.dart';
import 'package:app_3/widgets/common_widgets.dart/app_bar.dart';
import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

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
        body: Consumer3<CartProvider, AddressProvider, ApiProvider>(
          builder: (context, cartProvider, addressProvider, apiProvider, child) {
            return  cartProvider.cartItems.isEmpty
            ? const Center(
              child: AppTextWidget(text: "No products", fontSize: 15, fontWeight: FontWeight.w500),
            )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // List Of Products
                    ListView.builder(
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
                                        cartProvider.cartItems[index].quantity >= 1 
                                        ? RichText(
                                          text: TextSpan(
                                            text: "${cartProvider.cartItems[index].quantity}x ",
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
                                        // // Product Description
                                        // AppTextWidget(
                                        //   text: cartProvider.cartItems[index].description.replaceAll("<p>", ""), 
                                        //   fontSize: 12, 
                                        //   maxLines: 2,
                                        //   fontColor: Colors.black54,
                                        //   textOverflow: TextOverflow.ellipsis,
                                        //   fontWeight: FontWeight.w400
                                        // ),
                                        // const SizedBox(height: 5,),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            // Product Final price
                                            AppTextWidget(
                                              text: "₹${cartProvider.cartItems[index].price.toString()}", 
                                              fontSize: 15, 
                                              fontWeight: FontWeight.w400,
                                            ),
                                            const SizedBox(width: 5,),
                                            // Product Price 
                                            Text(
                                              "₹${cartProvider.cartItems[index].listPrice.toString()}",
                                              style: const TextStyle(
                                                fontSize: 13, 
                                                fontWeight: FontWeight.w400,
                                                decorationThickness: 2,
                                                decorationColor: Colors.red,
                                                color: Colors.black54,
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
                                              onPressed: () => cartProvider.incrementQuantity(index: index, isIncrement: true), 
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: cartProvider.cartItems[index].quantity >= 1 
                                                  ? Theme.of(context).primaryColor
                                                  : Colors.transparent.withOpacity(0.0),
                                                elevation: 0,
                                                alignment: Alignment.centerLeft,
                                                padding: EdgeInsets.fromLTRB(cartProvider.cartItems[index].quantity >= 1 ? 13 : 10, 0, 0, 0),
                                                shadowColor: Colors.transparent.withOpacity(0.0),
                                                overlayColor: cartProvider.cartItems[index].quantity >= 1 
                                                  ? Colors.white12
                                                  : Colors.transparent.withOpacity(0.1),
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
                                                size: cartProvider.cartItems[index].quantity >= 1 ? 13 : 20,
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
                                                onPressed: () {
                                                  // Decrease the quantity of the product
                                                  if (cartProvider.cartItems[index].quantity  == 1) {
                                                    confirmDelete(cartProvider.cartItems[index].id, size, index, context);
                                                    } else {
                                                    cartProvider.incrementQuantity(index: index);
                                                  }
                                                }, 
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.transparent.withOpacity(0.0),
                                                  elevation: 0,
                                                  alignment: Alignment.centerLeft,
                                                  padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                                                  shadowColor: Colors.transparent.withOpacity(0.0),
                                                  overlayColor: Colors.transparent.withOpacity(0.1),
                                                  shape: RoundedRectangleBorder(
                                                    side: BorderSide(color: Colors.grey.shade300),
                                                    borderRadius: BorderRadius.circular(5)
                                                  )
                                                ),
                                                child: Icon(
                                                  cartProvider.cartItems[index].quantity == 1
                                                  ? CupertinoIcons.delete
                                                  : CupertinoIcons.minus,
                                                  color: cartProvider.cartItems[index].quantity == 1
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
                            SizedBox(height: cartProvider.cartItems.length - 1 == index ? 105 :0,)
                          ],
                        );
                      },
                    ),
                    Positioned(
                      top: size.height * 0.74,
                      child: cartProvider.totalProduct >= 1 
                      ? GestureDetector(
                        onTap: () async {
                          if (addressProvider.addresses.isEmpty) {
                            addressProvider.addnewAddress(context, size);
                          }else{
                            List<Map<String, dynamic>> cartProductData = [];
                            for (var i = 0; i < cartProvider.cartItems.length; i++) {
                              cartProductData.add({
                                "prdt_id": cartProvider.cartItems[i].id,
                                "prdt_qty": cartProvider.cartItems[i].quantity,
                                "prdt_total": cartProvider.cartItems[i].quantity * int.parse(cartProvider.cartItems[i].price)
                              });
                            }
                            apiProvider.clearCoupon();
                            await cartProvider.updateCart(size, context, cartProductData);
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
                                color: Colors.transparent.withOpacity(0.2)
                              ),
                            ],
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).primaryColor
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppTextWidget(
                                text: cartProvider.totalProduct > 1
                                  ? "${cartProvider.totalProduct} items | ₹${cartProvider.total}"
                                  : "${cartProvider.totalProduct} item | ₹${cartProvider.total}",
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

  // Delete the product from cart
  void confirmDelete( int id, Size size, int index, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Set your desired border radius
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            // padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            height: 200,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Center(
                        child: AppTextWidget(text: "Remove item", fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 16,),
                      Center(
                        child: Text(
                           "Do you want to remove this item from the cart?",
                           textAlign: TextAlign.center,
                           style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400
                           ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: Consumer<CartProvider>(
                    builder: (context, provider, child) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero
                          ),
                          backgroundColor: Colors.transparent.withOpacity(0.0),
                          shadowColor: Colors.transparent.withOpacity(0.0),
                          elevation: 0,
                          overlayColor: Colors.transparent.withOpacity(0.1)
                        ),
                        onPressed: () async{
                          await provider.removeCart(id, size, context, index).then((value) => Navigator.pop(context),);
                        }, 
                        child: const AppTextWidget(
                          text: "Confirm", 
                          fontSize: 14, fontWeight: FontWeight.w400, 
                          fontColor: Colors.red,)
                      );
                    }
                  ),
                ),
                
                SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent.withOpacity(0.0),
                      shadowColor: Colors.transparent.withOpacity(0.0),
                      elevation: 0,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero
                      ),
                      overlayColor: Colors.transparent.withOpacity(0.1)
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }, 
                    child: const AppTextWidget(text: "Cancel", fontSize: 14, fontWeight: FontWeight.w400, fontColor: Colors.grey,)
                  ),
                ),
                const SizedBox(height: 10,)
              ],
            ),
          )
        );
      },
    );
  
  }

}