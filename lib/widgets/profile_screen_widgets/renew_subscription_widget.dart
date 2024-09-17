import 'package:app_3/helper/page_transition_helper.dart';
import 'package:app_3/model/active_subscription_model.dart';
import 'package:app_3/providers/address_provider.dart';
import 'package:app_3/providers/subscription_provider.dart';
import 'package:app_3/screens/sub-screens/address_selection_screen.dart';
import 'package:app_3/widgets/common_widgets.dart/app_bar.dart';
import 'package:app_3/widgets/common_widgets.dart/button_widget.dart';
import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
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
                  const AppTextWidget(text: 'Product Detail', fontSize: 17, fontWeight: FontWeight.w500), 
                  const SizedBox(height: 20,),
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
                          height: size.height * 0.13,
                          width: size.width * 0.26,
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
                                fontSize: 16, fontWeight: FontWeight.w500,
                                maxLines: 2,
                              ),
                              const SizedBox(height: 4,),
                              Row(
                                children: [
                                  SizedBox(
                                    width: size.width * 0.3, 
                                    child: const AppTextWidget(text: "Final price: ", fontSize: 15, fontWeight: FontWeight.w500)
                                  ),
                                  AppTextWidget(text:"₹${widget.product.productPrice}", fontSize: 14, fontWeight: FontWeight.w400),
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
                  const SizedBox(height: 20,),
                  // Subscription Detail
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const AppTextWidget(text: 'Subscription Detail', fontSize: 17, fontWeight: FontWeight.w500),
                      needStartDate 
                        ? const AppTextWidget(text: "* start date is required", fontSize: 13, fontWeight: FontWeight.w400, fontColor: Colors.red,)
                        : Container()
                    ],
                  ), 
                  const SizedBox(height: 20,),
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
                                const AppTextWidget(text: "Subscription ID: ", fontSize: 16, fontWeight: FontWeight.w500),
                                AppTextWidget(text: "${widget.product.subId} ", fontSize: 15, fontWeight: FontWeight.w500),
                              ],
                            ),
                            AppTextWidget(
                              text: widget.product.status, 
                              fontSize: 15, 
                              fontWeight: FontWeight.w400,
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
                              width: size.width * 0.42,
                              child: const AppTextWidget(
                                text: "Start date", 
                                fontSize: 15, 
                                fontWeight: FontWeight.w500
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  AppTextWidget(
                                    text: renewProvider.renewStartDate![widget.index] != null
                                    ? DateFormat("dd MMM yyyy").format(renewProvider.renewStartDate![widget.index]!)
                                    : "Pick a date",
                                    maxLines: 2,
                                    textOverflow: TextOverflow.ellipsis, 
                                    fontSize: 14, 
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
                                        });
                                        await renewProvider.renewSubscriptionApi(
                                        {
                                        "sub_id": widget.product.subId, 
                                        "bal_amt": widget.product.customerBalacne,
                                        "renewal_date": DateFormat("yyyy-MM-dd").format(renewDate),
                                        "prdt_price": widget.product.productPrice,
                                      }, context, size, widget.index);
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
                          title: 'End date: ', 
                          value: renewProvider.renewSubscriptionResponse?[widget.index] != null 
                          ? DateFormat("dd MMM yyyy").format(DateTime.parse(renewProvider.renewSubscriptionResponse![widget.index]!.endDate))
                          : "End date"),
                        const SizedBox(height: 4,),
                        // Subscription grace date
                        SubscriptionDetailWidget(
                          title: 'Grace date: ', 
                          value: renewProvider.renewSubscriptionResponse![widget.index] != null 
                          ? DateFormat("dd MMM yyyy").format(DateTime.parse(renewProvider.renewSubscriptionResponse![widget.index]!.graceDate))
                          : "No date",
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
                          title: 'Subscription plan: ', 
                          value: "${widget.product.frequency[0].toUpperCase()}${widget.product.frequency.substring(1)}",
                        ),
                        const SizedBox(height: 4,),
                        SubscriptionDetailWidget(
                          title: 'Total days: ', 
                          value: renewProvider.renewSubscriptionResponse![widget.index] == null 
                          ? "0 day"
                          : "${renewProvider.renewSubscriptionResponse![widget.index]!.totalDays} days",
                        ),
                        const SizedBox(height: 4,),
                        SubscriptionDetailWidget(
                          title: 'Total Quantity: ', 
                          value: renewProvider.renewSubscriptionResponse![widget.index] == null 
                          ? "0"
                          : renewProvider.renewSubscriptionResponse![widget.index]!.totalQty,
                        ),
                        const SizedBox(height: 4,),
                        // payment status
                        SubscriptionDetailWidget(
                          title: 'Your Balance: ', 
                          value: "₹${widget.product.customerBalacne}",
                        ),
                        const SizedBox(height: 4,),
                        // total amount
                        SubscriptionDetailWidget(
                          title: 'Total: ', 
                          value: renewProvider.renewSubscriptionResponse![widget.index] == null 
                          ? "₹0"
                          : "₹${renewProvider.renewSubscriptionResponse![widget.index]!.finalTotal}"),
                        const SizedBox(height: 4,),
                      ],
                    ),
                  ),
                  // Address Detail
                  const SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const AppTextWidget(text: 'Address Detail', fontSize: 17, fontWeight: FontWeight.w500),
                      GestureDetector(
                        onTap: () {
                        Navigator.push(context, downToTop(screen: const AddressSelectionScreen()));
                      },
                       child: AppTextWidget(text: "Change Address", fontSize: 13, fontWeight: FontWeight.w500, fontColor: Theme.of(context).primaryColor,)
                      )
                    ],
                  ), 
                  const SizedBox(height: 20,),
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
                                      fontSize: 15, 
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
                            fontSize: 14, 
                            maxLines: 5,
                            fontWeight: FontWeight.w400
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  SizedBox(
                    width: double.infinity,
                    child: ButtonWidget(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      buttonName: 'Confirm', 
                      onPressed: () async {
                        if (renewProvider.renewStartDate![widget.index] != null) {
                          await renewProvider.rePreorder({
                          "subscription_id": widget.product.subId,
                          "final_total": renewProvider.renewSubscriptionResponse![widget.index]!.finalTotal,
                          "renewal_date": DateFormat("yyyy-MM-dd").format(renewProvider.renewStartDate![widget.index]!),
                          "address": addressProvider.currentAddress!.id,
                          }, context, size).then((value) async {
                            await renewProvider.activeSubscription();
                            Navigator.pop(context);
                          },);
                        }else{
                          setState(() {
                            needStartDate = true;
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