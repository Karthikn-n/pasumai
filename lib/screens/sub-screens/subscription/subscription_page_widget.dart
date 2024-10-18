import 'package:app_3/helper/cache_manager_helper.dart';
import 'package:app_3/helper/page_transition_helper.dart';
import 'package:app_3/providers/subscription_provider.dart';
import 'package:app_3/screens/sub-screens/subscription/product_subscribe.dart';
import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class SubscriptionPageWidget extends StatelessWidget {
  const SubscriptionPageWidget({super.key});

  @override 
  Widget build(BuildContext context) {
    Size size =MediaQuery.sizeOf(context);
    return Consumer<SubscriptionProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: ListView.builder(
            itemCount: provider.subscribeProducts.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 10, bottom:index == provider.subscribeProducts.length - 1 ? 30 : 10),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: index == provider.subscribeProducts.length - 1 
                        ? BorderSide.none
                        : BorderSide(color: Colors.grey.shade300)
                      ),
                      // borderRadius: BorderRadius.circular(10)
                    ),
                    child: GestureDetector(
                      onTap: () => Navigator.push(context, SideTransistionRoute(
                        screen: ProductSubScription(product: provider.subscribeProducts[index],),
                      )),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Product Image
                          Stack(
                            children: [
                              SizedBox(
                                width: 94,
                                height: 105,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: CachedNetworkImage(
                                    // imageUrl: 'http://192.168.1.5/pasumaibhoomi/public/image/product/${provider.subscribeProducts[index].image}',
                                    imageUrl: 'https://maduraimarket.in/public/image/product/${provider.subscribeProducts[index].image}',
                                    fit: BoxFit.cover,
                                    cacheManager: CacheManagerHelper.cacheIt(key: provider.subscribeProducts[index].image),
                                  ),
                                ),
                              ),
                              // Positioned(
                              //   top: 15,
                              //   left: 10,
                              //   child: provider.subscribeProducts[index].subscribed == "Subscribed"
                              //   ? SizedBox(
                              //       height: 20,
                              //       width: 20,
                              //       child: Lottie.asset(
                              //         "assets/lottie/Animation.json"
                              //       )
                              //     )
                              //   : Container(),
                              // )
                                // SizedBox(
                                //   height: 20,
                                //   width: 20,
                                //   child: Lottie.asset(
                                //     "assets/lottie/Animation.json"
                                //   )
                                // )
                            ],
                          ),
                          SizedBox(
                            width: size.width * 0.5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Product Name and Quantity
                                AppTextWidget(
                                  text: "${provider.subscribeProducts[index].name}/${provider.subscribeProducts[index].quantity}", 
                                  fontSize: 14, 
                                  maxLines: 2,
                                  textOverflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.w400
                                ),
                                const SizedBox(height: 5,),
                                // Product Description
                                AppTextWidget(
                                  text: provider.subscribeProducts[index].description.replaceAll("<p>", ""), 
                                  fontSize: 12, 
                                  maxLines: 2,
                                  fontColor: Colors.grey,
                                  textOverflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.w300
                                ),
                                const SizedBox(height: 5,),
                                Row(
                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Product Final price
                                    Row(
                                      children: [
                                        AppTextWidget(
                                          text: "₹${provider.subscribeProducts[index].finalPrice.toString()}", 
                                          fontSize: 14, 
                                          fontColor: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        const SizedBox(width: 5,),
                                        // Product Price 
                                        Text(
                                          "₹${provider.subscribeProducts[index].price.toString()}",
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
                                    const SizedBox(width: 5,),
                                    provider.subscribeProducts[index].subscribed == "Subscribed"
                                    ? SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: Lottie.asset(
                                          "assets/lottie/Animation.json"
                                        )
                                      )
                                    : Container()
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Add to Cart Button
                          SizedBox(
                            width: 40,
                            height: 105,
                            child: ElevatedButton(
                              onPressed: () => Navigator.push(context, SideTransistionRoute(
                                screen: ProductSubScription(product: provider.subscribeProducts[index],),
                              )), 
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent.withOpacity(0.0),
                                elevation: 0,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.fromLTRB(18, 0, 0, 0),
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
                                  CupertinoIcons.chevron_right,
                                  color: Theme.of(context).primaryColor,
                                  size: 20,
                                ),
                              )
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: index == provider.subscribeProducts.length - 1 ? 40 : 0,)
                ],
              );
            },
          ),
        );
      }
    );
  
  }
}