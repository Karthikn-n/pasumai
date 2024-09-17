import 'package:app_3/model/selected_product_model.dart';
import 'package:app_3/providers/address_provider.dart';
import 'package:app_3/providers/api_provider.dart';
import 'package:app_3/service/connectivity_helper.dart';
import 'package:app_3/widgets/common_widgets.dart/app_bar.dart';
import 'package:app_3/widgets/common_widgets.dart/shimmer_list_widget.dart';
import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuickOrderScreen extends StatelessWidget {
  const QuickOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final connectivityService = Provider.of<ConnectivityService>(context);
    // final apiProvider = Provider.of<ApiProvider>(context);
    Size size = MediaQuery.sizeOf(context);
    if (!connectivityService.isConnected) {
      return Scaffold(
        appBar: const AppBarWidget(
          title: 'Quick order',
          // needBack: true,
          // onBack: () => apiProvider.setQuick(false),
        ),
        body: Center(
          child: Image.asset('assets/category/nointernet.png'),
        ),
      );
    } else {
      return Consumer2<ApiProvider, AddressProvider>(
          builder: (context, productProvider, addressProvider, child) {
          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              print("Result: $result");
              productProvider.setQuick(false);
            },
            child: Scaffold(
              appBar: const AppBarWidget(
                title: 'Quick order',
              ),
              body: productProvider.quickOrderProductsList.isEmpty
              ? FutureBuilder(
                future: productProvider.quickOrderProducts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const ShimmerListWidget();
                  }else if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
                    return quickorderWidget(size, context);
                  }else{
                    return quickorderWidget(size, context);
                  }
                }
              )
              : quickorderWidget(size, context)
            )
              
          );
        }
      );
    }
  }

  // Quick order widget
  Widget quickorderWidget(Size size, BuildContext context){
    return Consumer2<ApiProvider, AddressProvider>(
      builder: (context, productProvider, addressProvider, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // List Of Products
              ListView.builder(
                itemCount: productProvider.quickOrderProductsList.length,
                itemBuilder: (context, index) {
                  bool condition = productProvider.quickOrderQuantites[productProvider.quickOrderProductsList[index].id] != null &&  productProvider.quickOrderQuantites[productProvider.quickOrderProductsList[index].id]! >= 1;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: index == productProvider.quickOrderProductsList.length - 1 
                            ? BorderSide.none
                            : BorderSide(color: Colors.grey.shade300)
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
                                  // imageUrl: 'http://192.168.1.5/pasumaibhoomi/public/image/product/${productProvider.quickOrderProductsList[index].image}',
                                  imageUrl: 'https://maduraimarket.in/public/image/product/${productProvider.quickOrderProductsList[index].image}',
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
                                  productProvider.quickOrderQuantites[productProvider.quickOrderProductsList[index].id] != null && productProvider.quickOrderQuantites[productProvider.quickOrderProductsList[index].id]! > 0
                                  ? RichText(
                                    text: TextSpan(
                                      text: "${productProvider.quickOrderQuantites[productProvider.quickOrderProductsList[index].id]}x ",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context).primaryColor
                                      ),
                                      children: [
                                        TextSpan(
                                          text: "${productProvider.quickOrderProductsList[index].name}/${productProvider.quickOrderProductsList[index].quantity}",
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
                                    text: "${productProvider.quickOrderProductsList[index].name}/${productProvider.quickOrderProductsList[index].quantity}", 
                                    fontSize: 16, 
                                    maxLines: 2,
                                    textOverflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.w500
                                  ),
                                  const SizedBox(height: 5,),
                                  // Product Description
                                  AppTextWidget(
                                    text: productProvider.quickOrderProductsList[index].description.replaceAll("<p>", ""), 
                                    fontSize: 12, 
                                    maxLines: 2,
                                    fontColor: Colors.black54,
                                    textOverflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.w400
                                  ),
                                  const SizedBox(height: 5,),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      // Product Final price
                                      AppTextWidget(
                                        text: "₹${productProvider.quickOrderProductsList[index].finalPrice.toString()}", 
                                        fontSize: 15, 
                                        fontWeight: FontWeight.w400,
                                      ),
                                      const SizedBox(width: 5,),
                                      // Product Price 
                                      Text(
                                        "₹${productProvider.quickOrderProductsList[index].price.toString()}",
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
                                    height: productProvider.quickOrderQuantites[productProvider.quickOrderProductsList[index].id] != null 
                                    && productProvider.quickOrderQuantites[productProvider.quickOrderProductsList[index].id]! >= 1 ? 50: 105,
                                    child: AnimatedSize(
                                      duration: const Duration(milliseconds: 500),
                                      curve: Curves.easeInOut,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          productProvider.incrementQuickOrderQuantity(
                                            productPrice: productProvider.quickOrderProductsList[index].finalPrice, 
                                            productId: productProvider.quickOrderProductsList[index].id,
                                            isIncrement: true
                                          );
                                          // Add the product to selected list
                                          productProvider.addSelectedProducts(
                                            SelectedProductModel(
                                              id: productProvider.quickOrderProductsList[index].id, 
                                              productName: productProvider.quickOrderProductsList[index].name,
                                              productQuantity: productProvider.quickOrderProductsList[index].quantity, 
                                              quantityIndex: index, 
                                              quantity: productProvider.quickOrderQuantites[productProvider.quickOrderProductsList[index].id]!, 
                                              listPrice: productProvider.quickOrderProductsList[index].price, 
                                              finalPrice: productProvider.quickOrderProductsList[index].finalPrice
                                            ),
                                          );
                                        }, 
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: productProvider.quickOrderQuantites[productProvider.quickOrderProductsList[index].id] != null &&  productProvider.quickOrderQuantites[productProvider.quickOrderProductsList[index].id]! >= 1 
                                            ? Theme.of(context).primaryColor
                                            : Colors.transparent.withOpacity(0.0),
                                          elevation: 0,
                                          alignment: Alignment.centerLeft,
                                          padding: EdgeInsets.fromLTRB(condition ? 13 : 10, 0, 0, 0),
                                          shadowColor: Colors.transparent.withOpacity(0.0),
                                          overlayColor: condition 
                                            ? Colors.white12
                                            : Colors.transparent.withOpacity(0.1),
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
                                  // productProvider.quantities[index] >= 1
                                  // ? AppTextWidget(
                                  //   text: , 
                                  //   fontSize: 13, 
                                  //   fontWeight: FontWeight.w400,
                                  //   fontColor: Colors.black54,
                                  // )
                                  // : Container(),
                                  condition
                                  ? SizedBox(
                                      width: 40,
                                      height: 50,
                                      child: AnimatedSize(
                                        duration: const Duration(milliseconds: 500),
                                        curve: Curves.easeInOut,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            // Decrease the quantity of the product
                                            productProvider.incrementQuickOrderQuantity(
                                              productPrice: productProvider.quickOrderProductsList[index].finalPrice, 
                                              productId: productProvider.quickOrderProductsList[index].id,
                                              // index: index,
                                            );
                                            // Remove the product from the selected list
                                            productProvider.addSelectedProducts(
                                              SelectedProductModel(
                                                id: productProvider.quickOrderProductsList[index].id, 
                                                productName: productProvider.quickOrderProductsList[index].name,
                                                productQuantity: productProvider.quickOrderProductsList[index].quantity, 
                                                quantityIndex: index, 
                                                quantity: productProvider.quickOrderQuantites[productProvider.quickOrderProductsList[index].id]!, 
                                                listPrice: productProvider.quickOrderProductsList[index].price, 
                                                finalPrice: productProvider.quickOrderProductsList[index].finalPrice
                                              )
                                            );
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
                      SizedBox(height: productProvider.quickOrderProductsList.length - 1 == index ? 105 :0,)
                    ],
                  );
                },
              ),
              Positioned(
                top: size.height * 0.74,
                child: productProvider.totalQuickOrderProduct >= 1 
                ? GestureDetector(
                  onTap: () async {
                    if (addressProvider.addresses.isEmpty) {
                      addressProvider.addnewAddress(context, size);
                    }else{
                      List<Map<String, dynamic>> productDataList = [];
                      print("Quantites: ${productProvider.quickOrderQuantites}");
                      for (int i = 0; i < productProvider.quickOrderProductsList.length; i++) {
                        if (productProvider.quickOrderQuantites[productProvider.quickOrderProductsList[i].id] != null &&  productProvider.quickOrderQuantites[productProvider.quickOrderProductsList[i].id]! > 0) {
                          productProvider.quickOrderQuantites.forEach((key, value) {
                            if (value > 0) {
                               productDataList.add({
                                'prdt_id': key,
                                'prdt_qty': value,
                                'prdt_total': value * productProvider.quickOrderProductsList.firstWhere((element) => element.id == key,).finalPrice,
                              });
                            }
                          },);
                        }
                      }
                      print("Quick order product Data: $productDataList");
                      await productProvider.addQuickorder(context, size, productDataList).then((value) {
                        productProvider.clearCoupon();
                      },);
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
                          text: productProvider.totalQuickOrderProduct > 1
                            ? "${productProvider.totalQuickOrderProduct} items | ₹${productProvider.totalQuickOrderAmount}"
                            : "${productProvider.totalQuickOrderProduct} item | ₹${productProvider.totalQuickOrderAmount}",
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
    );
  }
}