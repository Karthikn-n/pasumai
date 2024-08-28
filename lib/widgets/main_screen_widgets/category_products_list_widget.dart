import 'package:app_3/providers/cart_items_provider.dart';
import 'package:app_3/model/products_model.dart';
import 'package:app_3/providers/api_provider.dart';
import 'package:app_3/service/connectivity_helper.dart';
import 'package:app_3/widgets/common_widgets.dart/app_bar.dart';
import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryProductsListWidget extends StatelessWidget {
  final String categoryName;
  final bool? isFeaturedProduct;
  final bool? isBestSellerProduct;
  const CategoryProductsListWidget({super.key, required this.categoryName, this.isFeaturedProduct, this.isBestSellerProduct});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    final connectivityCheck = Provider.of<ConnectivityService>(context);
    if (connectivityCheck.isConnected) {
      return Consumer<ApiProvider>(
        builder: (context, categoryProvider, child) {
          if (isFeaturedProduct ?? false) {
            return productListing(categoryProvider.featuredproductData, size, context);
          }else if(isBestSellerProduct ?? false){
            return productListing(categoryProvider.bestSellerProducts, size, context);
          }else{
            return productListing(categoryProvider.categoryProducts, size, context);
          }
        },
      );
    } else {
      return Scaffold(
        appBar: AppBarWidget(
          title: 'Quick order', 
          needBack: true, 
          onBack: () => Navigator.pop(context),
        ),
        body: Center(
          child: Image.asset('assets/category/nointernet.png'),
        ),
      );
    } 
  }

  // Product List Widget
  Widget productListing(List<Products> products, Size size, BuildContext context){
    return Scaffold(
      appBar: AppBarWidget(
        title: categoryName,
        needBack: true,
        onBack: () => Navigator.pop(context),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Container(
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
                      SizedBox(
                        width: 94,
                        height: 105,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            // imageUrl: 'http://192.168.1.5/pasumaibhoomi/public/image/product/${products[index].image}',
                            imageUrl: 'https://maduraimarket.in/public/image/product/${products[index].image}',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product Name and Quantity
                            AppTextWidget(
                              text: "${products[index].name}/${products[index].quantity}", 
                              fontSize: 16, 
                              maxLines: 2,
                              textOverflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.w500
                            ),
                            const SizedBox(height: 5,),
                            // Product Description
                            AppTextWidget(
                              text: products[index].description.replaceAll("<p>", ""), 
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
                                  text: "₹${products[index].finalPrice.toString()}", 
                                  fontSize: 15, 
                                  fontWeight: FontWeight.w400,
                                ),
                                const SizedBox(width: 5,),
                                // Product Price 
                                Text(
                                  "₹${products[index].price.toString()}",
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
                      // Add to Cart Button
                      Consumer<CartProvider>(
                        builder: (context, cartProvider, child) {
                          return SizedBox(
                            width: 45,
                            height: 105,
                            child: ElevatedButton(
                              onPressed: () async => await cartProvider.addCart(products[index].id, size, context, products[index]), 
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent.withOpacity(0.0),
                                elevation: 0,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.fromLTRB(13, 0, 0, 0),
                                shadowColor: Colors.transparent.withOpacity(0.0),
                                overlayColor: Colors.transparent.withOpacity(0.1),
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(5)
                                )
                              ),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                                child: Icon(
                                  CupertinoIcons.cart_badge_plus,
                                  color: Theme.of(context).primaryColor,
                                  size: 20,
                                ),
                              )
                            ),
                          );
                        },
                      )
                    
                    ],
                  ),
                ),
                // const SizedBox(height: 10,)
              ],
            );
          },
        ),
      )
    );
  
  }

  // // Filter Bottom sheet
  // void fillterSheet(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context, 
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.zero
  //     ),
  //     builder: (context) {
  //       return StatefulBuilder(builder: (context, setState) {
  //         return Consumer<ApiProvider>(
  //           builder: (context, provider, child) {
  //             int selectedAttributeIndex = 0; // Keep track of the selected attribute's index
  //             String selectedOption = ''; // Keep track of the selected option
  //             return Container(
  //               padding: const EdgeInsets.fromLTRB(12, 20, 12, 0),
  //               height: 240,
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Container(
  //                   decoration: const BoxDecoration(
  //                     border: Border(
  //                       right: BorderSide(color: Colors.black54)
  //                     )
  //                   ),
  //                   height: 50.0 * provider.attributesList.length,
  //                   width: 150,
  //                   child: ListView.builder(
  //                     physics: const NeverScrollableScrollPhysics(),
  //                     itemCount: provider.attributesList.length,
  //                     itemBuilder: (context, index) {
  //                       return ListTile(
  //                         minLeadingWidth: 5,
  //                         leading: Radio(
  //                           value: provider.attributesList, 
  //                           groupValue: provider.selectedAttribute,
  //                           onChanged: (value) {
  //                             setState((){
  //                               provider.setFilters(isAttribute: true, attribute: provider.attributesList[index].name, option: null);
  //                             });
  //                           },
  //                         ),
  //                         title: AppTextWidget(text: provider.attributesList[index].name, fontSize: 12, fontWeight: FontWeight.w500),
  //                       );
  //                     },
  //                   ),
  //                   ),
  //                   Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       const Text(
  //                         'Select Option:',
  //                         style: TextStyle(fontWeight: FontWeight.bold),
  //                       ),
  //                       DropdownButton<String>(
  //                         value: provider.selectedOption,
  //                         hint: const Text("Option"),
  //                         onChanged: (value) {
  //                           setState(() {
  //                             provider.setFilters(option: value);// Apply filter when option changes
  //                           });
  //                         },
  //                         items: provider.selectedAttribute != null
  //                         ? provider.attributesList.firstWhere((element) => element.name == provider.selectedAttribute,).optionData.map<DropdownMenuItem<String>>((option) {
  //                           return DropdownMenuItem<String>(
  //                             value: option.name,
  //                             child: Text(option.name),
  //                           );
  //                         }).toList()
  //                         : [],
  //                       ),
  //                     ],
  //                   ),
                
  //                 ],
  //               ),
  //             );
  //           }
  //         );
  //       });
  
  //     },
  //   );
  // }

}