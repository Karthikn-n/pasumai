import 'package:app_3/helper/page_transition_helper.dart';
import 'package:app_3/model/active_subscription_model.dart';
import 'package:app_3/providers/address_provider.dart';
import 'package:app_3/providers/subscription_provider.dart';
import 'package:app_3/screens/sub-screens/address_selection_screen.dart';
import 'package:app_3/widgets/common_widgets.dart/app_bar.dart';
import 'package:app_3/widgets/common_widgets.dart/button_widget.dart';
import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:app_3/widgets/shimmer_widgets/shimmer_parent.dart';
import 'package:app_3/widgets/subscription_widgets/subscription_detail_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RenewSubscriptionWidget extends StatefulWidget {
  final int index;
  final ActiveSubscriptionModel product;
  const RenewSubscriptionWidget({super.key, required this.index ,required this.product});

  @override
  State<RenewSubscriptionWidget> createState() => _RenewSubscriptionWidgetState();
}

class _RenewSubscriptionWidgetState extends State<RenewSubscriptionWidget> {

  bool needStartDate = false;
  bool isLoading = false;
  bool isFetching = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    // Map args = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Renew Subscription', 
        needBack: true, 
        onBack: () => Navigator.pop(context),
      ),
      body: Consumer2<SubscriptionProvider, AddressProvider>(
        builder: (context, renewProvider, addressProvider,  child) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Detail
                  const SizedBox(height: 20,),
                  const AppTextWidget(text: 'Product detail', fontSize: 18, fontWeight: FontWeight.w500), 
                  const SizedBox(height: 12,),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    // Product image and Product name
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: size.height * 0.08,
                          width: size.width * 0.16,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: 'https://maduraimarket.in/public/image/product/${widget.product.productImage}'
                              // imageUrl: 'http://192.168.1.5/pasumaibhoomi/public/image/product/${product.productImage}'
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
                              AppTextWidget(
                                text: widget.product.productName,
                                fontSize: 14, fontWeight: FontWeight.w500,
                                maxLines: 2,
                              ),
                              const SizedBox(height: 4,),
                              Row(
                                children: [
                                  SizedBox(
                                    width: size.width * 0.15, 
                                    child: const AppTextWidget(text: "Price", fontSize: 14, fontWeight: FontWeight.w400)
                                  ),
                                  AppTextWidget(text:"₹${widget.product.productPrice}", fontSize: 12, fontWeight: FontWeight.w500, fontColor: Theme.of(context).primaryColor,),
                                ],
                              ),
                              // const SizedBox(height: 4,),
                              // Row(
                              //   children: [
                              //     SizedBox(
                              //       width: size.width * 0.3, 
                              //       child: const AppTextWidget(text: "Quantity: ", fontSize: 15, fontWeight: FontWeight.w500)
                              //     ),
                              //     AppTextWidget(text:"${product.}", fontSize: 14, fontWeight: FontWeight.w400),
                              //   ],
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16,),
                  // Subscription Detail
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const AppTextWidget(text: 'Subscription detail', fontSize: 18, fontWeight: FontWeight.w500),
                      needStartDate 
                        ? const AppTextWidget(text: "* start date is required", fontSize: 12, fontWeight: FontWeight.w400, fontColor: Colors.red,)
                        : Container()
                    ],
                  ), 
                  const SizedBox(height: 12,),
                  // Subscription Detail Box
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Column(
                      children: [
                        // subscription ID
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: size.width * 0.44,
                                  child: const AppTextWidget(text: "Subscription ID", fontSize: 14, fontWeight: FontWeight.w500)
                                ),
                                AppTextWidget(text: "${widget.product.subId} ", fontSize: 12, fontWeight: FontWeight.w400),
                              ],
                            ),
                            AppTextWidget(
                              text: widget.product.status, 
                              fontSize: 12, 
                              fontWeight: FontWeight.w500,
                              fontColor: widget.product.status == "Active"
                                ? Theme.of(context).primaryColor
                                : Colors.orange,
                            )
                          ],
                        ),
                        const SizedBox(height: 10,),
                        // Subscriptin Start Date
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: size.width * 0.44,
                              child: const AppTextWidget(
                                text: "Start date", 
                                fontSize: 14, 
                                fontWeight: FontWeight.w500
                              ),
                            ),
                            isFetching
                              ? const ShimmerParent(height: 10, width: 35)
                              : Expanded(
                                child: Row(
                                  children: [
                                    AppTextWidget(
                                      text: renewProvider.renewStartDate![widget.index] != null
                                      ? DateFormat("dd MMM yyyy").format(renewProvider.renewStartDate![widget.index]!)
                                      : "Pick a date",
                                      maxLines: 2,
                                      textOverflow: TextOverflow.ellipsis, 
                                      fontSize: 12, 
                                      fontColor: needStartDate ? Colors.red : null,
                                      fontWeight: FontWeight.w400
                                    ),
                                    const SizedBox(width: 8,),
                                    GestureDetector(
                                    onTap: () async {
                                      DateTime? renewDate = await showDatePicker(
                                        context: context, 
                                        firstDate: DateTime.now(), 
                                        lastDate: DateTime(2100),
                                        helpText: "Renew Date",
                                        initialDate: DateTime.now(),
                                      );
                                      if (renewDate != null) {
                                        renewProvider.setStartDate(renewDate, widget.index);
                                        setState(() {
                                          needStartDate = false;
                                          isFetching = true;
                                        });
                                        try {
                                          await renewProvider.renewSubscriptionApi(
                                          {
                                            "sub_id": widget.product.subId, 
                                            "bal_amt": widget.product.customerBalacne,
                                            "renewal_date": DateFormat("yyyy-MM-dd").format(renewDate),
                                            "prdt_price": widget.product.productPrice,
                                          }, context, 
                                            size, 
                                            widget.index
                                          );
                                        } catch (e) {
                                          print("Can't Renew subscription: $e");
                                        } finally {
                                          setState(() {
                                            isFetching = false;
                                          });
                                        }
                                      }else{
                                        renewProvider.setStartDate(null, widget.index);
                                        setState(() {
                                          needStartDate = false;
                                        });
                                      }
                                    },
                                    child: Icon(
                                      CupertinoIcons.calendar, 
                                      size: 20,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  )
                                  ],
                                ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4,),
                        // Subscription End Date
                        SubscriptionDetailWidget(
                          title: 'End date', 
                          shimmerValue:  isFetching ? const ShimmerParent(height: 10, width: 35) : null,
                          value: renewProvider.renewSubscriptionResponse?[widget.index] != null 
                          ? DateFormat("dd MMM yyyy").format(DateTime.parse(renewProvider.renewSubscriptionResponse![widget.index]!.endDate))
                          : "End date"
                        ),
                        const SizedBox(height: 4,),
                        // Subscription grace date
                        SubscriptionDetailWidget(
                            title: 'Grace date: ', 
                            shimmerValue:  isFetching ? const ShimmerParent(height: 10, width: 35) : null,
                            value: renewProvider.renewSubscriptionResponse![widget.index] != null 
                            ? DateFormat("dd MMM yyyy").format(DateTime.parse(renewProvider.renewSubscriptionResponse![widget.index]!.graceDate))
                            : "No date",
                            valueWeight: FontWeight.w500,
                            valueColor: Colors.orange,
                          ),
                        // const SizedBox(height: 4,),
                        // // subscription product price
                        // SubscriptionDetailWidget(
                        //   title: 'Product price: ', 
                        //   value: "₹${product.productPrice}",
                        // ),
                        const SizedBox(height: 4,),
                        // Plan
                        SubscriptionDetailWidget(
                          title: 'Subscription plan', 
                          value: "${widget.product.frequency[0].toUpperCase()}${widget.product.frequency.substring(1)}",
                        ),
                        const SizedBox(height: 4,),
                        SubscriptionDetailWidget(
                          title: 'Total days', 
                          shimmerValue:  isFetching ? const ShimmerParent(height: 10, width: 35) : null,
                          value: renewProvider.renewSubscriptionResponse![widget.index] == null 
                          ? "0 day"
                          : "${renewProvider.renewSubscriptionResponse![widget.index]!.totalDays} days",
                        ),
                        const SizedBox(height: 4,),
                        SubscriptionDetailWidget(
                          title: 'Total quantity', 
                          shimmerValue:  isFetching ? const ShimmerParent(height: 10, width: 15) : null,
                          value: renewProvider.renewSubscriptionResponse![widget.index] == null 
                          ? "0"
                          : renewProvider.renewSubscriptionResponse![widget.index]!.totalQty,
                        ),
                        const SizedBox(height: 4,),
                        // payment status
                        SubscriptionDetailWidget(
                          title: 'Your balance', 
                          value: "₹${widget.product.customerBalacne}",
                        ),
                        const SizedBox(height: 4,),
                        // total amount
                        SubscriptionDetailWidget(
                            title: 'Total', 
                            shimmerValue: isFetching ? const ShimmerParent(height: 10, width: 35) : null,
                            valueColor: Theme.of(context).primaryColor,
                            valueWeight: FontWeight.w500,
                            value: renewProvider.renewSubscriptionResponse![widget.index] == null 
                            ? "₹0"
                            : "₹${renewProvider.renewSubscriptionResponse![widget.index]!.finalTotal}"
                          ),
                        const SizedBox(height: 4,),
                      ],
                    ),
                  ),
                  // Address Detail
                  const SizedBox(height: 16,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const AppTextWidget(text: 'Delivery details', fontSize: 18, fontWeight: FontWeight.w500),
                      GestureDetector(
                        onTap: () {
                        Navigator.push(context, downToTop(screen: const AddressSelectionScreen()));
                      },
                       child: AppTextWidget(text: "Change address", fontSize: 12, fontWeight: FontWeight.w500, fontColor: Theme.of(context).primaryColor,)
                      )
                    ],
                  ), 
                  const SizedBox(height: 12,),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300)
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: size.width * 0.7,
                                    child: AppTextWidget(
                                      text: addressProvider.currentAddress!.location, 
                                      fontSize: 14, 
                                      fontWeight: FontWeight.w500
                                    ),
                                  ),
                                ],
                              ), 
                            ],
                          ),
                          const SizedBox(height: 5,),
                          AppTextWidget(
                            text: '${addressProvider.currentAddress!.flatNo}, ' 
                            '${addressProvider.currentAddress!.floorNo}, ' 
                            '${addressProvider.currentAddress!.address}, '
                            '${addressProvider.currentAddress!.landmark}, '
                            '${addressProvider.currentAddress!.location}, ' 
                            '${addressProvider.currentAddress!.region}, ',
                            fontSize: 12, 
                            maxLines: 5,
                            fontWeight: FontWeight.w300
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16,),
                  SizedBox(
                    width: double.infinity,
                    child: isLoading
                    ? const LoadingButton()
                    : ButtonWidget(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      buttonName: 'Confirm', 
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        try {
                          if (renewProvider.renewStartDate![widget.index] != null) {
                            await renewProvider.rePreorder({
                            "subscription_id": widget.product.subId,
                            "final_total": renewProvider.renewSubscriptionResponse![widget.index]!.finalTotal,
                            "renewal_date": DateFormat("yyyy-MM-dd").format(renewProvider.renewStartDate![widget.index]!),
                            "address": addressProvider.currentAddress!.id,
                            }, context, size).then((value) async {
                              await renewProvider.activeSubscription();
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },);
                          }else{
                            setState(() {
                              needStartDate = true;
                            });
                          }
                        } catch (e) {
                          print("Can't renew it: $e");
                        } finally {
                          setState(() {
                            isLoading = false;
                          });
                        }
                        
                      }
                    )
                  ),
                  const SizedBox(height: 20,)
                ],// 9585976305
                
              ),
            ),
          );
        }
      ),
    );
  }
}