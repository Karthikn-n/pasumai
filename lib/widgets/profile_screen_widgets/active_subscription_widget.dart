import 'package:app_3/data/constants.dart';
import 'package:app_3/helper/cache_manager_helper.dart';
import 'package:app_3/helper/page_transition_helper.dart';
import 'package:app_3/model/active_subscription_model.dart';
import 'package:app_3/providers/subscription_provider.dart';
import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:app_3/widgets/profile_screen_widgets/renew_subscription_widget.dart';
import 'package:app_3/widgets/shimmer_widgets/shimmer_subscription_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../screens/sub-screens/profile/edit_subscription.dart';

class ActiveSubscriptionWidget extends StatelessWidget {
  const ActiveSubscriptionWidget({super.key});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Consumer<SubscriptionProvider>(
      builder: (context, provider, child) {
        return provider.activeSubscriptions.isEmpty
          ? FutureBuilder(
            future: provider.activeSubscription(), 
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: AppTextWidget(
                          text: "Active subscriptions", 
                          fontSize: 16, 
                          fontWeight: FontWeight.w500
                        ),
                      ),
                      SizedBox(height: 15,),
                      Expanded(child: ShimmerSubscriptionWidget())
                    ],
                  ),
                );
              }else if(!snapshot.hasData){
                return const Center(
                  child: AppTextWidget(
                    text: "No active subscriptions",
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                );
              } else{
                return Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: AppTextWidget(
                          text: "Active subscriptions", 
                          fontSize: 16, 
                          fontWeight: FontWeight.w500
                        ),
                      ),
                      const SizedBox(height: 15,),
                      Expanded(
                        child: activeSubscriptionList(size, provider.activeSubscriptions)
                      )
                    ],
                  ),
                );
              }
            },
          )
          : Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: AppTextWidget(
                      text: "Active subscriptions", 
                      fontSize: 16, 
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  const SizedBox(height: 15,),
                  Expanded(
                    child: activeSubscriptionList(size, provider.activeSubscriptions)
                  )
                ],
              ),
            );
      } 
    );
  }

  // Active subscription Widget
  Widget activeSubscriptionList(Size size, List<ActiveSubscriptionModel> subscritionProducts){
    return Consumer2<SubscriptionProvider, Constants>(
      builder: (context, activeSub, scrollController, child) {
        List<ActiveSubscriptionModel> subscripedProducts = subscritionProducts.reversed.toList();
        return CupertinoScrollbar(
          thumbVisibility: true,
          controller: scrollController.activeSubScrollController,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ListView.builder(
              controller: scrollController.activeSubScrollController,
              itemCount: subscripedProducts.length,
              itemBuilder: (context, index) {
                List<String> options = subscripedProducts[index].status == "Cancelled" ? ["Resume"] : ["Edit", "Renew", "Cancel"];
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300)
                      ),
                      child: Column(
                        children: [
                          // Product Detail
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: size.height * 0.13,
                                width: size.width * 0.26,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    cacheManager: CacheManagerHelper.cacheIt(key: subscripedProducts[index].productImage),
                                    imageUrl: 'https://maduraimarket.in/public/image/product/${subscripedProducts[index].productImage}'
                                    // imageUrl: 'http://192.168.1.5/pasumaibhoomi/public/image/product/${subscripedProducts[index].productImage}'
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10,),
                              // Product Name
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Product name
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: size.width * 0.42,
                                          child: AppTextWidget(
                                            text: subscripedProducts[index].productName, 
                                            fontSize: 16, fontWeight: FontWeight.w500,
                                            maxLines: 2,
                                          ),
                                        ),
                                        // More Options
                                        PopupMenuButton(
                                          color: Colors.white,
                                          tooltip: "Show menu",
                                          child: const Icon(CupertinoIcons.ellipsis_vertical, size: 20,),
                                          itemBuilder: (popUpcontext) {
                                            return options.map((option) {
                                             return PopupMenuItem(
                                              onTap: () async {
                                                if (option == "Cancel") {
                                                  activeSub.userCancelSubscription();
                                                  await activeSub.confirmCancelSubscription(subscripedProducts[index].subId, size, context);
                                                }else if(option == "Resume"){
                                                  await activeSub.resumeSub(subscripedProducts[index].subId, size, context).then((value) async {
                                                    await activeSub.activeSubscription().then((value) async {
                                                      await activeSub.subscriptionHistoryAPI();
                                                    },);
                                                  },);
                                                   
                                                }else if(option == "Renew") {
                                                  if (activeSub.renewStartDate == null || activeSub.renewStartDate!.isEmpty) {
                                                    // if (activeSub.renewStartDate!.isEmpty) {
                                                      activeSub.generateData(subscripedProducts.length);
                                                      print("Length: ${activeSub.renewStartDate!.length}");
                                                      Navigator.push(context, SideTransistionRoute(
                                                        screen: RenewSubscriptionWidget(product: subscripedProducts[index], index: index,), 
                                                        args: {'subId': subscripedProducts[index].subId}
                                                      ));
                                                    // }
                                                  }else{
                                                      print("Length 2: ${activeSub.renewStartDate!.length}");
                                                      Navigator.push(context, SideTransistionRoute(
                                                        screen: RenewSubscriptionWidget(product: subscripedProducts[index], index: index,), 
                                                        args: {'subId': subscripedProducts[index].subId}
                                                      ));
                                                    }
                                                }else{
                                                  if (subscripedProducts[index].frequency == 'custom') {
                                                    customChange(context, subscripedProducts[index], size);
                                                  }else if (subscripedProducts[index].frequency== 'weekday') {
                                                    weekDayChange(context, subscripedProducts[index], size);
                                                  }else if (subscripedProducts[index].frequency == 'everyday') {
                                                    everyDayChange(context, subscripedProducts[index], size);
                                                  }
                                                }
                                              },
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  AppTextWidget(
                                                    text: option, 
                                                    fontSize: 14, 
                                                    fontWeight: FontWeight.w500
                                                  ),
                                                  activeSub.isCancellingSubscription 
                                                    ? const SizedBox(
                                                      width: 5,
                                                      child: LinearProgressIndicator(
                                                        minHeight: 3,
                                                      ),
                                                    ) 
                                                  : Container()
                                                ],
                                              )) ;
                                            },).toList();
                                          },
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 4,),
                                    // Product Price
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: size.width * 0.35,
                                          child: const AppTextWidget(text: "Price", fontSize: 14, fontWeight: FontWeight.w500)
                                        ),
                                        AppTextWidget(
                                          text:"₹${subscripedProducts[index].productPrice}", 
                                          fontSize: 12, 
                                          fontWeight: FontWeight.w500,
                                          fontColor: Theme.of(context).primaryColor,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4,),
                                    // Subscription start date
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: size.width * 0.35, 
                                          child: const AppTextWidget(text: "Start date", fontSize: 14, fontWeight: FontWeight.w500)
                                        ),
                                        AppTextWidget(text:subscripedProducts[index].startDate, fontSize: 12, fontWeight: FontWeight.w400),
                                      ],
                                    ),
                                    const SizedBox(height: 4,),
                                    // Frequency subscription
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: size.width * 0.35, 
                                          child: const AppTextWidget(text: "Frequency", fontSize: 14, fontWeight: FontWeight.w500)
                                        ),
                                        AppTextWidget(text: "${subscripedProducts[index].frequency[0].toUpperCase()}${subscripedProducts[index].frequency.substring(1)}", fontSize: 12, fontWeight: FontWeight.w400),
                                      ],
                                    ),
                                    const SizedBox(height: 4,),
                                    // Current status
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: size.width * 0.35, 
                                          child: const AppTextWidget(text: "Status", fontSize: 14, fontWeight: FontWeight.w500)
                                        ),
                                        AppTextWidget(
                                          text: subscripedProducts[index].status, 
                                          fontSize: 12, fontWeight: FontWeight.w500,
                                          fontColor: subscripedProducts[index].status == "Active"
                                            ? Theme.of(context).primaryColor
                                            : Colors.orange,
                                        ),
                                      ],
                                    ),
                                    // Subscription quantity
                                    subscripedProducts[index].frequency == "everyday"
                                    ? Column(
                                        children: [
                                          const SizedBox(height: 4,),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: size.width * 0.35, 
                                                  child: const AppTextWidget(text: "Morning", fontSize: 14, fontWeight: FontWeight.w500)
                                                ),
                                                AppTextWidget(text: "${subscripedProducts[index].frequencyMobData[0].mrgQuantity}", fontSize: 12, fontWeight: FontWeight.w400),
                                              ],
                                            ),
                                            const SizedBox(height: 4,),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: size.width * 0.35, 
                                                  child: const AppTextWidget(text: "Evening", fontSize: 14, fontWeight: FontWeight.w500)
                                                ),
                                                AppTextWidget(text: "${subscripedProducts[index].frequencyMobData[0].evgQuantity}", fontSize: 12, fontWeight: FontWeight.w400),
                                              ],
                                            ),
                                        ],
                                      )
                                    : Container()
                                  ],
                                ),
                              ),
                            ],
                          ),
                          // Subscription quantity 
                          subscripedProducts[index].frequency == "everyday"
                          ? Container()
                          : Row(
                              children: [
                                SizedBox(
                                  width: size.width * 0.2,
                                  child: const Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      AppTextWidget(text: "Day", fontSize: 14, fontWeight: FontWeight.w500),
                                      // SizedBox(height: 4,),
                                      AppTextWidget(text: "Morning", fontSize: 14, fontWeight: FontWeight.w500),
                                      // SizedBox(height: 4,),
                                      AppTextWidget(text: "Evening", fontSize: 14, fontWeight: FontWeight.w500),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: size.height * 0.1,
                                  width: size.width * 0.67,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: subscripedProducts[index].frequencyMobData.length,
                                    itemBuilder: (context, dayIndex) {
                                      return Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              AppTextWidget(
                                                text: "${subscripedProducts[index].frequencyMobData[dayIndex].day[0].toUpperCase()}${subscripedProducts[index].frequencyMobData[dayIndex].day.substring(1,3)}", 
                                                fontSize: 14, 
                                                fontWeight: FontWeight.w500
                                              ),
                                              // const SizedBox(height: 7,),
                                              AppTextWidget(text: subscripedProducts[index].frequencyMobData[dayIndex].mrgQuantity.toString(), fontSize: 12, fontWeight: FontWeight.w400),
                                              // const SizedBox(height: 7,),
                                              AppTextWidget(text: subscripedProducts[index].frequencyMobData[dayIndex].evgQuantity.toString(), fontSize: 12, fontWeight: FontWeight.w400),
                                            ],
                                          ),
                                          // SizedBox(
                                          //   height: size.height * 0.1,
                                          //   child: const VerticalDivider(
                                          //     thickness: 1,
                                          //     color: Colors.black12,
                                          //   ),
                                          // ),
                                          const SizedBox(width: 10,)
                                        ],
                                      );
                                    },
                                  ),
                                )
                              
                              ],
                            )
                        ],
                      ),
                    ),
                    SizedBox(height: subscripedProducts.length -1 == index ? 70 : 10,)
                  ],
                );
              },
            ),
          ),
        );
      }
    );
  }
}