
import 'dart:async';

import 'package:app_3/helper/cache_manager_helper.dart';
import 'package:app_3/providers/address_provider.dart';
import 'package:app_3/helper/page_transition_helper.dart';
import 'package:app_3/providers/api_provider.dart';
import 'package:app_3/providers/locale_provider.dart';
import 'package:app_3/providers/subscription_provider.dart';
import 'package:app_3/screens/main_screens/bottom_bar.dart';
import 'package:app_3/screens/main_screens/search_screen.dart';
import 'package:app_3/screens/sub-screens/address_selection_screen.dart';
import 'package:app_3/screens/sub-screens/wishlist_products.dart';
import 'package:app_3/service/connectivity_helper.dart';
import 'package:app_3/widgets/common_widgets.dart/app_bar.dart';
import 'package:app_3/widgets/common_widgets.dart/input_field_widget.dart';
import 'package:app_3/widgets/shimmer_widgets/shimmer_carousel_widget.dart';
import 'package:app_3/widgets/common_widgets.dart/snackbar_widget.dart';
import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:app_3/widgets/main_screen_widgets/category_products_list_widget.dart';
import 'package:app_3/widgets/main_screen_widgets/home_screen_products_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key,});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  PageController bannerController = PageController();


  int _currentPage = 0;
  Timer? _timer;
  DateTime? currentPress;

  // Remove all the activity from memory to avoid memory leaks
  @override
  void dispose() {
    bannerController.dispose();
    _timer?.cancel();
    super.dispose();
  }
  

  @override
  Widget build(BuildContext context) {
    final connectivityService = Provider.of<ConnectivityService>(context);
    // load the content based on internet connection
    if (connectivityService.isConnected) {
      return homePage(context);
    } else {
      return Scaffold(
        appBar: const AppBarWidget(title: 'Home'),
        body: Center(
          child: Image.asset('assets/category/nointernet.png'),
        ),
      );
    }
  }


  Widget homePage(BuildContext context){
    final addressProvider = Provider.of<AddressProvider>(context);
    
    final localeProvider = Provider.of<LocaleProvider>(context);
    Size size = MediaQuery.sizeOf(context);
    return Consumer<ApiProvider>(
      builder: (context, provider, child) {
        return PopScope(
          canPop: provider.isQuick ? false : true,
          onPopInvokedWithResult: (didPop, result) {
            final now = DateTime.now();
            if(currentPress == null || now.difference(currentPress!) > const Duration(seconds: 2)){
              currentPress = now;
              ScaffoldMessenger.of(context).showSnackBar(
                snackBarMessage(
                  context: context, 
                  message: "Press again to exit", 
                  backgroundColor: Theme.of(context).primaryColor, 
                  sidePadding: size.width * 0.1, 
                  bottomPadding: size.height * 0.03,
                  duration: const Duration(milliseconds: 1500)
                )
              );
              return;
            } else {
              SystemNavigator.pop();
            }
            
          },
          child: provider.serverDown
          ? Scaffold(
              appBar: AppBar(
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Icon(
                      CupertinoIcons.heart_fill, 
                      size: 28,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
              body: const Center(
                child: AppTextWidget(
                  text: "Unable to load content. Our services are currently down. Please try again later.", 
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.start,
                ),
              ),
            )
          : Scaffold(
              backgroundColor: Colors.white,
              appBar: provider.isQuick ? null
              : AppBar(
                surfaceTintColor: Colors.transparent.withOpacity(0.0),
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1.0),
                  child: Container(
                    color: Colors.grey.withOpacity(0.3),  // Choose your preferred underline color
                    height: 1.0,         // Height of the underline
                  ),
                ),
                title: addressProvider.addresses.isEmpty
                  ? GestureDetector(
                    onTap: () async {
                      await Navigator.push(context, downToTop(screen: const AddressSelectionScreen()));
                    },
                    child: SizedBox(
                      width: size.width * 0.4,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppTextWidget(text: 'Select address...', fontSize: 14, fontWeight: FontWeight.w500),
                              AppTextWidget(text: 'Tamilnadu, India', fontSize: 12, fontWeight: FontWeight.w500)
                            ],
                          ),
                          Icon(CupertinoIcons.chevron_down, size: 18,)
                        ],
                      ),
                    ),
                  )
                  : InkWell(
                      splashColor: Colors.transparent.withOpacity(0.1),
                      onTap: () async {
                        // await addressProvider.getRegionLocation();
                        Navigator.push(context, downToTop(screen: const AddressSelectionScreen()));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: size.width * 0.65,
                                child: AppTextWidget(
                                  text: 'Selected address', 
                                  fontSize: 16, 
                                  maxLines: 1,
                                  textOverflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.w500,
                                  fontColor: Colors.black.withOpacity(0.8),
                                ),
                              ),
                              SizedBox(
                                width:size.width * 0.65,
                                child: AppTextWidget(
                                  text: '${addressProvider.currentAddress!.address} ${addressProvider.currentAddress!.location.toString()}, ${addressProvider.currentAddress!.region.toString()}, ${addressProvider.currentAddress!.landmark}, ${addressProvider.currentAddress!.pincode}', 
                                  fontSize: 12, 
                                  maxLines: 1,
                                  textOverflow: TextOverflow.ellipsis,
                                  fontColor: Colors.black.withOpacity(0.5),
                                  fontWeight: FontWeight.w400
                                ),
                              ),
                            ],
                          ),
                          const Icon(CupertinoIcons.chevron_down, size: 18,)
                        ],
                      ),
                    ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 15, top: 10),
                    child: Consumer<ApiProvider>(
                      builder: (context, wishlistProductProvider, child) {
                        return IconButton(
                          tooltip: "Wishlist",
                          style: ElevatedButton.styleFrom(
                            // overlayColor: Colors.grey.shade400
                          ),
                          onPressed: () async {
                            wishlistProductProvider.wishlistProductsAPI();
                            Navigator.push(context, downToTop(screen: const WishlistProducts()));
                          },
                          icon:  Icon(
                            CupertinoIcons.heart_fill, 
                            size: 28,
                            color: Theme.of(context).primaryColor,
                          ),
                        );
                      }
                    )
                  )
                ],
              ),
              body: Consumer<ApiProvider>(
                builder: (context, provider, child) {
                  return CustomScrollView(
                    key: const PageStorageKey("Homescreen"),
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        // banners
                        SliverAppBar(
                          expandedHeight: size.height * 0.180,
                          // floating: true,
                          // snap: true,
                          automaticallyImplyLeading: false,
                          // pinned: true,
                          backgroundColor: Colors.white,
                          surfaceTintColor: Colors.transparent.withOpacity(0.0),
                          flexibleSpace: FlexibleSpaceBar(
                            background: Stack(
                              children: [
                                // Banner Images
                                PageView.builder(
                                  controller: bannerController,
                                  itemCount: provider.banners.length,
                                  itemBuilder: (context, index) {
                                    // List<String> storedBanners = prefs.getStringList('banners') ?? banners;
                                    String imageUrl = 'https://maduraimarket.in/public/image/banner/${provider.banners[index]}';
                                    // String imageUrl = 'http://192.168.1.5/pasumaibhoomi/public/image/banner/${provider.banners[index]}';
                                    return SizedBox(
                                      // width: size.width,
                                      height: size.height * 0.1,
                                      child: CachedNetworkImage(
                                        imageUrl: imageUrl,
                                        fit: BoxFit.fitWidth,
                                        cacheManager: CacheManagerHelper.cacheIt(key: provider.banners[index]),
                                      )
                                    );
                                  },
                                  onPageChanged: (int page) {
                                    setState(() {
                                      _currentPage = page;
                                    });
                                  },
                                ),
                                // Page indicator
                                Padding(
                                  padding: EdgeInsets.only(top: size.height * 0.15),
                                  child: _buildDotIndicator(provider.banners),
                                ),
                              ],
                            )
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20),
                                // Search text field
                                TextFields(
                                  hintText: 'Search Dairy, Food & Groceries', 
                                  isObseure: false, 
                                  textInputAction: TextInputAction.done,
                                  readOnly: true,
                                  suffixIcon: const Icon(CupertinoIcons.search, color: Colors.grey,),
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen(focusNode: FocusNode(),)));
                                  },
                                ),
                                const SizedBox(height: 20),
                                // Category list
                                SizedBox(
                                  height: 210,
                                  // width: size.width,
                                  child: Center(
                                    child: ListView.builder(
                                      itemCount: provider.categories.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        String imageUrl = 'https://maduraimarket.in/public/image/category/${provider.categories[index].categoryImage}';   
                                        // String imageUrl = 'http://192.168.1.5/pasumaibhoomi/public/image/category/${provider.categories[index].categoryImage}';   
                                        return Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                // await provider.allProducts(provider.categories[index].categoryId).then((value){
                                                  Navigator.of(context).push(MaterialPageRoute(
                                                    builder: (context) => CategoryProductsListWidget(categoryName: provider.categories[index].categoryName, categoryId: provider.categories[index].categoryId,)
                                                  ));
                                                // });
                                              },
                                              child: SizedBox(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Card(
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(10)
                                                      ),
                                                      elevation: 3,
                                                      child: SizedBox(
                                                        height: 200,
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(10),
                                                          child: CachedNetworkImage(
                                                            imageUrl: imageUrl,
                                                            fit: BoxFit.cover,
                                                            cacheManager: CacheManagerHelper.cacheIt(key: provider.categories[index].categoryImage),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    // AppTextWidget(
                                                    //   text: provider.categories[index].categoryName, 
                                                    //   fontSize: 14, 
                                                    //   maxLines: 1,
                                                    //   fontWeight: FontWeight.w400,
                                                    //   textOverflow: TextOverflow.ellipsis,
                                                    // )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10,)
                                          ],
                                        );
                                      }
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16,),
                                // Subscribe products Heading
                                GestureDetector(
                                  onTap: () async {
                                    await provider.quickOrderProducts();
                                  },
                                  child: AppTextWidget(
                                    text: localeProvider.of(context).subscriptionProducts, 
                                    fontSize: 18, 
                                    fontWeight: FontWeight.w500
                                  ),
                                ),
                                // Subscription Products List
                                const SizedBox(height: 12,),
                                Consumer<SubscriptionProvider>(
                                  builder: (context, value, child) {
                                    return  value.subscribeProducts.isEmpty
                                    ? FutureBuilder(
                                      future: value.getSubscribProducts(), 
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                          return const ShimmerCarosouelView();
                                        }else{
                                          return HomeScreenProducts(
                                            products: value.subscribeProducts, 
                                            icon: Container(
                                              padding: const EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8),
                                                color: Theme.of(context).primaryColor,
                                              ),
                                              child: const AppTextWidget(
                                                text: "Subscribe", fontSize: 12, 
                                                fontWeight: FontWeight.w500,
                                                fontColor: Colors.white,
                                              )
                                            ), 
                                            // Move to Next View all Screen
                                            onViewall: () { 
                                              provider.setIndex(3);
                                              Navigator.of(context).push(PageRouteBuilder(
                                                pageBuilder: (context, animation, secondaryAnimation) =>  const BottomBar(),
                                                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                                  return child;
                                                },
                                                transitionDuration: Duration.zero,
                                              ));
                                            },
                                          );
                                        }
                                      } ,
                                    )
                                      // Subscribe product list
                                    : HomeScreenProducts(
                                      products: value.subscribeProducts.sublist(0, 5), 
                                      icon: Container(), 
                                      onViewall: () { 
                                        provider.setIndex(3);
                                        Navigator.of(context).push(PageRouteBuilder(
                                          pageBuilder: (context, animation, secondaryAnimation) =>  const BottomBar(),
                                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                            return child;
                                          },
                                          transitionDuration: Duration.zero,
                                        ));
                                      },
                                    );
                                  },
                                ),
                                const SizedBox(height: 6,),
                                // Featured Products Heading
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    AppTextWidget(
                                      text: localeProvider.of(context).featuredProducts, 
                                      fontSize: 18, 
                                      fontWeight: FontWeight.w500
                                    ),
                                    // GestureDetector(
                                    //   onTap: () {
                                    //     // Move to Featured List Page
                                    //     Navigator.of(context).push(MaterialPageRoute(
                                    //       builder: (context) => const CategoryProductsListWidget(categoryName: "Featured Products", isFeaturedProduct: true,)
                                    //     ));
                                    //   },
                                    //   child: Row(
                                    //     children: [
                                    //       Text(
                                    //         'View all',
                                    //         style: TextStyle(
                                    //           color: Theme.of(context).primaryColor,
                                    //           fontSize: size.width > 600 ?  size.height * 0.034: size.height * 0.018,
                                    //           fontWeight: FontWeight.bold
                                    //         ),
                                    //       ),
                                    //       // SizedBox(width: size.width * 0.003,),
                                    //       Icon(
                                    //         Icons.arrow_forward_ios_sharp,
                                    //         color: Theme.of(context).primaryColor,
                                    //         size:  size.width > 600 ?  size.height * 0.034: size.height * 0.014,
                                    //       )
                                    //     ],
                                    //   ),
                                  
                                    // )
                                  
                                  ],
                                ),
                                const SizedBox(height: 12,),
                                // Featured Products list
                                HomeScreenProducts(
                                  products: provider.featuredproductData.sublist(0, 5), 
                                  onViewall: () {  
                                    Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => const CategoryProductsListWidget(categoryName: "Featured Products", isFeaturedProduct: true,)
                                    ));
                                  },
                                ),
                                const SizedBox(height: 6,),
                                // Best Seller Heading
                                Row(
                                  // crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: size.width * 0.7,
                                      child: AppTextWidget(
                                        text: localeProvider.of(context).bestseller, 
                                        fontSize: 18, 
                                        textOverflow: TextOverflow.fade,
                                        fontWeight: FontWeight.w500
                                      ),
                                    ),
                                    // View all Button
                                    // GestureDetector(
                                    //   onTap: () {
                                    //     print("Best Seller: ${provider.bestSellerProducts.length}");
                                    //      Navigator.of(context).push(MaterialPageRoute(
                                    //       builder: (context) => const CategoryProductsListWidget(categoryName: "Best Seller", isBestSellerProduct: true,)
                                    //     ));
                                    //   },
                                    //   child: Row(
                                    //     mainAxisAlignment: MainAxisAlignment.center,
                                    //     children: [
                                    //       Text(
                                    //         'View all',
                                    //         style: TextStyle(
                                    //           fontSize: 14,
                                    //           color: Theme.of(context).primaryColor,
                                    //           fontWeight: FontWeight.w500
                                    //         ),
                                    //       ),
                                    //       Icon(
                                    //         Icons.arrow_forward_ios_sharp,
                                    //         color: Theme.of(context).primaryColor,
                                    //         size:  size.width > 600 ?  size.height * 0.034: size.height * 0.014,
                                    //       )
                                    //     ],
                                    //   ),
                                    // )
                                  
                                  ],
                                ),
                                const SizedBox(height: 12,),
                                // Best Seller Products List
                                HomeScreenProducts(
                                  products: provider.bestSellerProducts, 
                                  onViewall: () { 
                                    Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => const CategoryProductsListWidget(categoryName: "Best Seller", isBestSellerProduct: true,)
                                    ));
                                  },
                                ),
                                const SizedBox(height: 60,),
                                
                              ],
                            ),
                          ),
                        )
                      ]
                    );
                }
              ),
            ),
        );
      }
    ); 
  }

  Widget _buildDotIndicator(List<String> banners) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: banners.map((banner) {
        int index = banners.indexOf(banner);
        return Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index ? Colors.white : Colors.grey,
          ),
        );
      }).toList(),
    );
  }


}

