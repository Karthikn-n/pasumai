import 'package:app_3/data/constants.dart';
import 'package:app_3/helper/page_transition_helper.dart';
import 'package:app_3/model/orders_model.dart';
import 'package:app_3/providers/profile_provider.dart';
import 'package:app_3/widgets/common_widgets.dart/button_widget.dart';
import 'package:app_3/widgets/common_widgets.dart/shimmer_profile_widget.dart';
import 'package:app_3/widgets/common_widgets.dart/snackbar_widget.dart';
import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:app_3/widgets/profile_screen_widgets/order_detail_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersHistoryWidget extends StatelessWidget {
  const OrdersHistoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Consumer<ProfileProvider>(
      builder: (context, provider, child) {
        return provider.orderInfoData.isEmpty
           ? FutureBuilder(
            future: provider.orderList(), 
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: AppTextWidget(
                          text: "Order history", 
                          fontSize: 18, 
                          fontWeight: FontWeight.w500
                        ),
                      ),
                      SizedBox(height: 12,),
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
                    text: "No orders",
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                );
              } else if(snapshot.hasError) {
                return Center(
                  child: AppTextWidget(
                    text: snapshot.error.toString(),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                );
              } else{
                return Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const AppTextWidget(
                                  text: "Order history", 
                                  fontSize: 18, 
                                  fontWeight: FontWeight.w500
                                ),
                                provider.selectedFilter.isNotEmpty
                                ? GestureDetector(
                                  onTap: () async {
                                    await provider.orderList(filter: "1y");
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.grey.shade300)
                                    ),
                                    child: Row(
                                      children: [
                                        AppTextWidget(
                                          text: provider.selectedFilter, 
                                          fontSize: 14, 
                                          fontWeight: FontWeight.w500
                                        ),
                                        const SizedBox(width: 4,),
                                        GestureDetector(
                                          onTap: () async {
                                            await provider.orderList(filter: "1y");
                                          },
                                          child: const Icon(CupertinoIcons.xmark_circle, size: 17, color: Colors.red,)
                                        )
                                      ],
                                    ),
                                  ),
                                )
                                : Container()
                              ],
                            ),
                            PopupMenuButton(
                              color: Colors.white,
                              elevation: 2,
                              style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(Theme.of(context).scaffoldBackgroundColor)
                              ),
                              itemBuilder: (context) {
                                return provider.filterOption.map((option) {
                                  return PopupMenuItem(
                                    onTap: () async {
                                      print("clear selected 1");
                                      await provider.orderList(
                                        filter: option == "3 months" 
                                        ? "3m" : option == "6 months" 
                                        ? "6m" : option == "9 months" 
                                        ? "9m" : ""
                                      );
                                    },
                                    child: AppTextWidget(
                                      text: option, 
                                      fontSize: 14, 
                                      fontColor: provider.selectedFilter == option ? Theme.of(context).primaryColor : null,
                                      fontWeight: FontWeight.w500
                                    )
                                  );
                                },).toList();
                              } ,
                              child: AppTextWidget(
                                text: "Filter", 
                                fontSize: 14, 
                                fontWeight: FontWeight.w500,
                                fontColor: Theme.of(context).primaryColor,
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 15,),
                      Expanded(
                        child: orderedProducts( size: size)
                      )
                    ],
                  ),
                );
              }
            },
          )
           : Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            const AppTextWidget(
                              text: "Order history", 
                              fontSize: 16, 
                              fontWeight: FontWeight.w500
                            ),
                            provider.selectedFilter.isNotEmpty
                            ? GestureDetector(
                              onTap: () async {
                                 await provider.orderList(filter: "1y");
                              },
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey.shade300)
                                ),
                                child: Row(
                                  children: [
                                    AppTextWidget(
                                      text: provider.selectedFilter, 
                                      fontSize: 14, 
                                      fontWeight: FontWeight.w500
                                    ),
                                    const SizedBox(width: 4,),
                                    GestureDetector(
                                      onTap: () async {
                                        await provider.orderList(filter: "1y");
                                      },
                                      child: const Icon(CupertinoIcons.xmark_circle, size: 17, color: Colors.red,)
                                    )
                                  ],
                                ),
                              ),
                            )
                            : Container()
                          ],
                        ),
                        PopupMenuButton(
                          color: Colors.white,
                          elevation: 2,
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(Theme.of(context).scaffoldBackgroundColor)
                          ),
                          itemBuilder: (context) {
                            return provider.filterOption.map((option) {
                              return PopupMenuItem(
                                onTap: () async {
                                  await provider.orderList(
                                    filter: option == "3 months" 
                                    ? "3m" : option == "6 months" 
                                    ? "6m" : option == "9 months" 
                                    ? "9m" : ""
                                  );
                                },
                                child: AppTextWidget(
                                  text: option, 
                                  fontSize: 14, 
                                  fontColor: provider.selectedFilter == option ? Theme.of(context).primaryColor : null,
                                  fontWeight: FontWeight.w500
                                )
                              );
                            },).toList();
                          } ,
                          child: AppTextWidget(
                            text: "Filter", 
                            fontSize: 14, 
                            fontWeight: FontWeight.w500,
                            fontColor: Theme.of(context).primaryColor,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 15,),
                  Expanded(
                    child: orderedProducts(size: size)
                  )
                ],
              ),
            );
              
      },
    );
  }

  // Ordered Product list
  Widget orderedProducts({List<OrderInfo>? filteredProducts, required Size size}) {
    return Consumer2<ProfileProvider, Constants>(
      builder: (context, orderProvider, scrollController, child) {
        List<OrderInfo> orders = filteredProducts != null 
        ? filteredProducts.reversed.toList() 
        : orderProvider.orderInfoData.reversed.toList();
        return CupertinoScrollbar(
          controller: scrollController.orderHistoryScrollController,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ListView.builder(
              controller: scrollController.orderHistoryScrollController,
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.grey.shade300
                        )
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: size.width *0.3,
                                    child: const AppTextWidget(text: 'Order ID', fontSize: 14, fontWeight: FontWeight.w500)
                                  ),
                                  AppTextWidget(text: '${orders[index].orderId}', fontSize: 12, fontWeight: FontWeight.w400),
                                ],
                              ),
                              // SizedBox(
                              //   width: size.width * 0.6,
                              //   child: AppTextWidget(
                              //     text: "Order ID: ${orders[index].orderId}",
                              //     // : "order" , 
                              //     fontSize: 16, 
                              //     fontWeight: FontWeight.w500,
                              //     // maxLines: 1,
                              //     textOverflow: TextOverflow.ellipsis,
                              //   ),
                              // ),
                              InkWell(
                                splashColor: Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                onTap: () async {
                                  print("Order ID: ${orders[index].orderId}");
                                  orderProvider.clearCouponAmount();
                                  await orderProvider.orderDetail(orders[index].orderId).then((value) {
                                    Navigator.push(context, downToTop(screen: const OrderDetailWidget(), args: {"orderDetail": orders[index]}));
                                  },);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                  child: AppTextWidget(
                                    text: "See detail", 
                                    fontSize: 12, 
                                    fontWeight: FontWeight.w400,
                                    fontColor: Theme.of(context).primaryColor,
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 5,),
                          Row(
                            children: [
                              SizedBox(
                                width: size.width *0.3,
                                child: const AppTextWidget(text: 'Products', fontSize: 14, fontWeight: FontWeight.w500)
                              ),
                              AppTextWidget(text: '${orders[index].quantity}', fontSize: 12, fontWeight: FontWeight.w400),
                            ],
                          ),
                          const SizedBox(height: 5,),
                          Row(
                            children: [
                              SizedBox(
                                width: size.width *0.29,
                                child: const AppTextWidget(text: 'Ordered on', fontSize: 14, fontWeight: FontWeight.w500)
                              ),
                              AppTextWidget(text: orders[index].orderOn, fontSize: 12, fontWeight: FontWeight.w400),
                            ],
                          ),
                          const SizedBox(height: 5,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: size.width *0.3,
                                child: const AppTextWidget(text: 'Address', fontSize: 14, fontWeight: FontWeight.w500)
                              ),
                              Expanded(child: AppTextWidget(text: orders[index].address, fontSize: 12, fontWeight: FontWeight.w400)),
                            ],
                          ),
                          const SizedBox(height: 5,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: size.width *0.3,
                                child: const AppTextWidget(text: 'Total', fontSize: 14, fontWeight: FontWeight.w500)
                              ),
                              Expanded(child: AppTextWidget(text: '₹${orders[index].total}', fontSize: 12, fontWeight: FontWeight.w400)),
                            ],
                          ),
                          const SizedBox(height: 5,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                               SizedBox(
                                 width: size.width *0.3,
                                 child: const AppTextWidget(text: 'Status', fontSize: 14, fontWeight: FontWeight.w500)),
                              Expanded(
                                  child: AppTextWidget(
                                  text: orders[index].status, 
                                  fontSize: 12, 
                                  fontWeight: FontWeight.w400,
                                  fontColor: orders[index].status == "Pending" || orders[index].status == "Cancelled"
                                    ? Colors.orange
                                    : Theme.of(context).primaryColor,
                                )
                              ),
                            ],
                          ),
                          const SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: size.height * 0.05,
                                width: size.width * 0.42,
                                child: ButtonWidget(
                                  buttonName: 'Reorder', 
                                  borderRadius: 8,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  onPressed: () async {
                                    await orderProvider.reOrder(orders[index].orderId,  context, size);
                                  }
                                ),
                              ),
                              SizedBox(
                                width: size.width * 0.42,
                                height: size.height * 0.05,
                                child: ButtonWidget(
                                  fontColor: Colors.black,
                                  buttonColor: Colors.transparent,
                                  buttonName: 'Cancel', 
                                  borderRadius: 8,
                                  splashColor: Colors.transparent.withOpacity(0.1),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  bordercolor: Colors.red,
                                  onPressed: () async {
                                    if (orders[index].status == "Cancelled") {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        snackBarMessage(context: context, message: "Already Product Cancelled", backgroundColor: Theme.of(context).primaryColor, sidePadding: size.width * 0.1, bottomPadding: size.height * 0.05)
                                      );
                                    }else{
                                      orderProvider.confirmCancelOrder(orders[index].orderId, context, size);
                                    }
                                  }
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: orders.length - 1 ==  index ? 70:  10,)
                  ],
                );
              },
            ),
          ),
        );
      }
    );
  }


  // Filter Options for 
}