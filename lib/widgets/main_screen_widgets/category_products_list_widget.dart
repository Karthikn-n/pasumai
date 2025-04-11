import 'package:app_3/data/constants.dart';
import 'package:app_3/helper/cache_manager_helper.dart';
import 'package:app_3/helper/page_transition_helper.dart';
import 'package:app_3/providers/cart_items_provider.dart';
import 'package:app_3/model/products_model.dart';
import 'package:app_3/providers/api_provider.dart';
import 'package:app_3/screens/main_screens/bottom_bar.dart';
import 'package:app_3/screens/sub-screens/filter/filter_screens.dart';
import 'package:app_3/service/connectivity_helper.dart';
import 'package:app_3/widgets/common_widgets.dart/app_bar.dart';
import 'package:app_3/widgets/search/search_widget.dart';
import 'package:app_3/widgets/shimmer_widgets/shimmer_list_widget.dart';
import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../screens/sub-screens/productDetail/product_detail_screen.dart';

class CategoryProductsListWidget extends StatelessWidget {
  final String categoryName;
  final bool? isFeaturedProduct;
  final bool? isBestSellerProduct;
  final int? categoryId;
  const CategoryProductsListWidget({super.key, required this.categoryName, this.isFeaturedProduct, this.isBestSellerProduct, this.categoryId});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    final connectivityCheck = Provider.of<ConnectivityService>(context);
    final categoryProvider = Provider.of<ApiProvider>(context,listen: false);
    if (connectivityCheck.isConnected) {
      if (isFeaturedProduct ?? false) {
        return productListing(categoryProvider.featuredproductData, categoryProvider.categoryBanner, size, context);
      }else if(isBestSellerProduct ?? false){
        return productListing(categoryProvider.bestSellerProducts, categoryProvider.categoryBanner, size, context);
      }else{
        return 
        categoryId != null
        ? FutureBuilder(
          future: categoryProvider.allProducts(categoryId!), 
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                appBar: AppBarWidget(
                  title: categoryName,
                  needBack: true,
                  onBack: () => Navigator.pop(context),
                ),
                body: const ShimmerListWidget()
              );
            }else{
              return productListing(categoryProvider.categoryProducts, categoryProvider.categoryBanner, size, context);
            }
          },
        )
        : 
        Container();
      }
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
  Widget productListing(List<Products> products, String? bannerImage, Size size, BuildContext context){
    final scrollController = Provider.of<Constants>(context).categoriesController;
    return Scaffold(
      appBar: AppBarWidget(
        title: categoryName,
        needBack: true,
        onBack: () => Navigator.pop(context),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, NoAnimateTransistion(screen: FilterScreen(products: products,)));
            }, 
            icon: SizedBox(
              height: 24,
              width: 24,
              child: Image.asset("assets/icons/filter.png"),
            )
          ),
          IconButton(
            onPressed: () {
              Navigator.push(context, NoAnimateTransistion(screen: SearchWidget(products: products,)));
            }, 
            icon: const Icon(CupertinoIcons.search)
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          CupertinoScrollbar(
            controller: scrollController,
            child: products.isEmpty
            ? const Center(
              child: AppTextWidget(text: "No Products", fontSize: 15, fontWeight: FontWeight.w500),
            )
            : CustomScrollView(
                controller: scrollController,
                slivers: [
                  bannerImage == null || isBestSellerProduct != null || isBestSellerProduct != null
                  ? const SliverToBoxAdapter()
                  : SliverAppBar(
                      automaticallyImplyLeading: false,
                      expandedHeight: size.height * 0.18,
                      backgroundColor: Colors.white,
                      surfaceTintColor: Colors.transparent.withValues(alpha: 0.0),
                      flexibleSpace: FlexibleSpaceBar(
                        background: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: SizedBox(
                            height: size.height * 0.1,
                            width: double.infinity,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              // clipBehavior: Clip.none,
                              child: CachedNetworkImage(
                                imageUrl: "https://maduraimarket.in/public/image/category/$bannerImage",
                                fit: BoxFit.scaleDown,
                                cacheManager: CacheManagerHelper.cacheIt(key: bannerImage,),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        children: [
                          SizedBox(
                            height:( size.height * 0.17) * products.length,
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: products.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(context, SideTransistionRoute(
                                          screen: ProductDetailScreen(productDetail: products[index], 
                                          category: categoryName)
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
                                            SizedBox(
                                              width: size.width * 0.5,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  // Product Name and Quantity
                                                  Consumer<CartProvider>(
                                                      builder: (context, productProvider, child) {
                                                      return RichText(
                                                        maxLines: 2,
                                                        overflow: TextOverflow.ellipsis,
                                                        text: TextSpan(
                                                          text: productProvider.cartQuantities[products[index].id] != null
                                                          ? "${productProvider.cartQuantities[products[index].id]}x "
                                                          : "", 
                                                          style: TextStyle(
                                                            fontSize: 16, 
                                                            fontWeight: FontWeight.w500,
                                                            color: Theme.of(context).primaryColor
                                                          ),
                                                          children: [
                                                            TextSpan(
                                                              text: "${products[index].name}/${products[index].quantity}", 
                                                              style: const TextStyle(
                                                                fontSize: 14, 
                                                                color: Colors.black,
                                                                fontWeight: FontWeight.w400
                                                              )
                                                            )
                                                          ]
                                                        ),
                                                      );
                                                    }
                                                  ),
                                                  const SizedBox(height: 5,),
                                                  // Product Description
                                                  AppTextWidget(
                                                    text: products[index].description.replaceAll("<p>", "").replaceAll("</p>", ""), 
                                                    fontSize: 12, 
                                                    maxLines: 2,
                                                    fontColor: Colors.grey,
                                                    textOverflow: TextOverflow.ellipsis,
                                                    fontWeight: FontWeight.w300
                                                  ),
                                                  const SizedBox(height: 5,),
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      // Product Final price
                                                      AppTextWidget(
                                                        text: "₹${products[index].finalPrice.toString()}", 
                                                        fontSize: 14, 
                                                        fontColor: Theme.of(context).primaryColor,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                      const SizedBox(width: 5,),
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
                                            // Add to Cart Button
                                            Consumer<CartProvider>(
                                              builder: (context, cartProvider, child) {
                                                return SizedBox(
                                                  height: 105,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      SizedBox(
                                                        width: 40,
                                                        height: cartProvider.cartQuantities[products[index].id] != null ? 50: 105,
                                                        child: AnimatedSize(
                                                          duration: const Duration(milliseconds: 500),
                                                          curve: Curves.easeInOut,
                                                          child: ElevatedButton(
                                                            onPressed: () async {
                                                              // print("prod ")
                                                              if(cartProvider.cartQuantities[products[index].id] == null){
                                                                await cartProvider.addCart(products[index].id, size, context, products[index]);
                                                              }else{
                                                                cartProvider.incrementQuantity(productId: products[index].id, isIncrement: true);
                                                                List<Map<String, dynamic>> cartProductData = [];
                                                                // print(cartProvider.cartItems[index].id);
                                                                cartProvider.cartQuantities.forEach((key, value) {
                                                                
                                                                  cartProductData.add({
                                                                    "prdt_id": key,
                                                                    "prdt_qty": value,
                                                                    "prdt_total": value * products[index].finalPrice
                                                                  });
                                                                  
                                                                },);
                                                                await cartProvider.updateCart(size, context, cartProductData, false);
                                                              }
                                                            }, 
                                                            style: ElevatedButton.styleFrom(
                                                              backgroundColor: cartProvider.cartQuantities[products[index].id] != null 
                                                                ? Theme.of(context).primaryColor
                                                                : Colors.transparent.withValues(alpha: 0.0),
                                                              elevation: 0,
                                                              alignment: Alignment.centerLeft,
                                                              padding: EdgeInsets.fromLTRB(cartProvider.cartQuantities[products[index].id] != null ? 13 : 10, 0, 0, 0),
                                                              shadowColor: Colors.transparent.withValues(alpha: 0.0),
                                                              overlayColor: cartProvider.cartQuantities[products[index].id] != null 
                                                                ? Colors.white12
                                                                : Colors.transparent.withValues(alpha: 0.1),
                                                              shape: RoundedRectangleBorder(
                                                                side: cartProvider.cartQuantities[products[index].id] != null
                                                                ? BorderSide.none 
                                                                : BorderSide(color: Colors.grey.shade300),
                                                                borderRadius: BorderRadius.circular(5)
                                                              )
                                                            ),
                                                            child: Icon(
                                                              cartProvider.cartQuantities[products[index].id] != null 
                                                              ? CupertinoIcons.plus
                                                              : CupertinoIcons.cart_badge_plus,
                                                              color: cartProvider.cartQuantities[products[index].id] != null 
                                                              ? Colors.white
                                                              : Theme.of(context).primaryColor,
                                                              size: cartProvider.cartQuantities[products[index].id] != null ? 13 : 20,
                                                            ) 
                                                          ),
                                                        ),
                                                      ),
                                                      cartProvider.cartQuantities[products[index].id] != null
                                                      ? SizedBox(
                                                          width: 40,
                                                          height: 50,
                                                          child: AnimatedSize(
                                                            duration: const Duration(milliseconds: 500),
                                                            curve: Curves.easeInOut,
                                                            child: ElevatedButton(
                                                              onPressed: () async {
                                                                // Decrease the quantity of the product
                                                                if (cartProvider.cartQuantities[products[index].id]  != null && cartProvider.cartQuantities[products[index].id]  == 1) {
                                                                  cartProvider.confirmDelete(id: products[index].id, size: size, index: index, context: context);
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
                                                                cartProvider.cartQuantities[products[index].id]  != null && cartProvider.cartQuantities[products[index].id]  == 1
                                                                ? CupertinoIcons.delete
                                                                : CupertinoIcons.minus,
                                                                color: cartProvider.cartQuantities[products[index].id]  != null && cartProvider.cartQuantities[products[index].id]  == 1
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
                                                );
                                              },
                                            )
                                          
                                          ],
                                        ),
                                      ),
                                    ),
                                    // const SizedBox(height: 10,)
                                  ],
                                );
                              },
                            ),
                          ),
                          Consumer<CartProvider>(
                            builder: (context, provider, child) {
                              return provider.cartQuantities.isEmpty
                                ? Container()
                                : const SizedBox(height: 50,);
                            },
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
          ),
          Positioned(
            bottom: 10,
            child: Consumer2<CartProvider, ApiProvider>(
              builder: (providerContext, cartProvider, navigation, child) {
                return cartProvider.cartQuantities.isEmpty
                  ? Container()
                  : GestureDetector(
                      onTap: () async {
                        navigation.setIndex(1);
                        // p
                        Navigator.push(context, SideTransistionRoute(screen: const BottomBar()));
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
                                  text: "View cart", 
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
                    );
                            
              },
            )
          )
        ],
      ),
      // floatingActionButton: ,
    );
  
  }
}