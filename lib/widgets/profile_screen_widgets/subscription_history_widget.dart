import 'package:app_3/model/active_subscription_model.dart';
import 'package:app_3/providers/subscription_provider.dart';
import 'package:app_3/widgets/common_widgets.dart/shimmer_profile_widget.dart';
import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubscriptionHistoryWidget extends StatelessWidget {
  SubscriptionHistoryWidget({super.key});
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Consumer<SubscriptionProvider>(
      builder: (context, provider, child) {
        return provider.historyProducts.isEmpty
          ? FutureBuilder(
            future: provider.subscriptionHistoryAPI(), 
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Expanded(
                  child: Column(
                    children: [
                      AppTextWidget(
                        text: "Subscription history", 
                        fontSize: 16, 
                        fontWeight: FontWeight.w500
                      ),
                      SizedBox(height: 15,),
                      // LinearProgressIndicator(
                      //   // minHeight: 1,
                      //   color: Theme.of(context).primaryColor,
                      //   backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                      // ),
                       Expanded(child: ShimmerProfileWidget())
                    ],
                  ),
                );
              }else if(!snapshot.hasData){
                return const Center(
                  child: AppTextWidget(
                    text: "No history found",
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                );
              } else{
                return Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppTextWidget(
                        text: "Subscription history", 
                        fontSize: 16, 
                        fontWeight: FontWeight.w500
                      ),
                      const SizedBox(height: 15,),
                      Expanded(
                        child: subscripitionHistoryList(size, provider.historyProducts)
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
                  const AppTextWidget(
                    text: "Subscription history", 
                    fontSize: 16, 
                    fontWeight: FontWeight.w500
                  ),
                  const SizedBox(height: 15,),
                  Expanded(
                    child: subscripitionHistoryList(size, provider.historyProducts)
                  )
                ],
              ),
            );
      } 
    );
  }
// History product List
  Widget subscripitionHistoryList(Size size, List<ActiveSubscriptionModel> historyProductsList){
    return Consumer<SubscriptionProvider>(
      builder: (context, activeSub, child) {
        List<ActiveSubscriptionModel> historyProducts = historyProductsList.reversed.toList();
        return CupertinoScrollbar(
          controller: _scrollController,
          child: ListView.builder(
            controller: _scrollController,
            itemCount: historyProducts.length,
            itemBuilder: (context, index) {
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
                                  imageUrl: 'https://maduraimarket.in/public/image/product/${historyProducts[index].productImage}'
                                  // imageUrl: 'http://192.168.1.5/pasumaibhoomi/public/image/product/${historyProducts[index].productImage}'
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
                                  SizedBox(
                                    width: size.width * 0.42,
                                    child: AppTextWidget(
                                      text: historyProducts[index].productName, 
                                      fontSize: 15, fontWeight: FontWeight.w500,
                                      maxLines: 2,
                                    ),
                                  ),
                                  const SizedBox(height: 4,),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.35,
                                        child: const AppTextWidget(text: "Price: ", fontSize: 14, fontWeight: FontWeight.w500)
                                      ),
                                      AppTextWidget(text:"₹${historyProducts[index].productPrice}", fontSize: 13, fontWeight: FontWeight.w400),
                                    ],
                                  ),
                                  const SizedBox(height: 4,),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.35, 
                                        child: const AppTextWidget(text: "Start date: ", fontSize: 14, fontWeight: FontWeight.w500)
                                      ),
                                      AppTextWidget(text:historyProducts[index].startDate, fontSize: 13, fontWeight: FontWeight.w400),
                                    ],
                                  ),
                                  const SizedBox(height: 4,),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.35, 
                                        child: const AppTextWidget(text: "Frequency: ", fontSize: 14, fontWeight: FontWeight.w500)
                                      ),
                                      AppTextWidget(text: "${historyProducts[index].frequency[0].toUpperCase()}${historyProducts[index].frequency.substring(1)}", fontSize: 13, fontWeight: FontWeight.w400),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.35, 
                                        child: const AppTextWidget(text: "Status: ", fontSize: 14, fontWeight: FontWeight.w500)
                                      ),
                                      AppTextWidget(
                                        text: historyProducts[index].status, 
                                        fontSize: 13, fontWeight: FontWeight.w500,
                                        fontColor: historyProducts[index].status == "Active"
                                          ? Theme.of(context).primaryColor
                                          : Colors.orange,
                                      ),
                                    ],
                                  ),
                                  historyProducts[index].frequency == "everyday"
                                  ? Column(
                                      children: [
                                        const SizedBox(height: 4,),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: size.width * 0.35, 
                                                child: const AppTextWidget(text: "Morning quantity: ", fontSize: 14, fontWeight: FontWeight.w500)
                                              ),
                                              AppTextWidget(text: "${historyProducts[index].frequencyMobData[0].mrgQuantity}", fontSize: 13, fontWeight: FontWeight.w400),
                                            ],
                                          ),
                                          const SizedBox(height: 4,),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: size.width * 0.35, 
                                                child: const AppTextWidget(text: "Evening quantity: ", fontSize: 14, fontWeight: FontWeight.w500)
                                              ),
                                              AppTextWidget(text: "${historyProducts[index].frequencyMobData[0].evgQuantity}", fontSize: 13, fontWeight: FontWeight.w400),
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
                        // Subscription Detail
                        historyProducts[index].frequency == "everyday"
                        ? Container()
                        : Row(
                            children: [
                              SizedBox(
                                height: size.height * 0.1,
                                width: size.width * 0.2,
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    AppTextWidget(text: "Day: ", fontSize: 15, fontWeight: FontWeight.w500),
                                    // SizedBox(height: 4,),
                                    AppTextWidget(text: "Morning: ", fontSize: 15, fontWeight: FontWeight.w500),
                                    // SizedBox(height: 4,),
                                    AppTextWidget(text: "Evening: ", fontSize: 15, fontWeight: FontWeight.w500),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.1,
                                width: size.width * 0.67,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: historyProducts[index].frequencyMobData.length,
                                  itemBuilder: (context, dayIndex) {
                                    return Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            AppTextWidget(
                                              text: "${historyProducts[index].frequencyMobData[dayIndex].day[0].toUpperCase()}${historyProducts[index].frequencyMobData[dayIndex].day.substring(1, 3)}", 
                                              fontSize: 15, 
                                              fontWeight: FontWeight.w500
                                            ),
                                            // const SizedBox(height: 7,),
                                            AppTextWidget(text: historyProducts[index].frequencyMobData[dayIndex].mrgQuantity.toString(), fontSize: 14, fontWeight: FontWeight.w500),
                                            // const SizedBox(height: 7,),
                                            AppTextWidget(text: historyProducts[index].frequencyMobData[dayIndex].evgQuantity.toString(), fontSize: 14, fontWeight: FontWeight.w500),
                                          ],
                                        ),
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
                  SizedBox(height: historyProducts.length -1 == index ? 70 : 10,)
                ],
              );
            },
          ),
        );
      }
    );
  }
}