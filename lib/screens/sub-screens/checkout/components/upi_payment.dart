import 'package:app_3/screens/sub-screens/checkout/components/add_upi_card.dart';
import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../providers/api_provider.dart';
import '../../../../providers/cart_items_provider.dart';
import '../../../../providers/profile_provider.dart';
import '../../../../widgets/common_widgets.dart/button_widget.dart';
import '../provider/payment_proivider.dart';

class UpiPayment extends StatelessWidget {
  final String amount;
  final bool fromCart;
  const UpiPayment({super.key, required this.amount, required this.fromCart});

  @override
  Widget build(BuildContext context) {
    return Consumer<PaymentProivider>(
      builder: (context, paymentProvider, child) {
        return Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.grey.shade200),
              bottom: BorderSide(color: Colors.grey.shade200)
            )
          ),
          child: ExpansionTile(
            shape: const RoundedRectangleBorder(
              side: BorderSide.none
            ),
            iconColor: Colors.black,
            collapsedShape: const RoundedRectangleBorder(side: BorderSide.none),
            title: const AppTextWidget(
              text: "UPI", 
              fontWeight: FontWeight.w500
            ),
            backgroundColor: Colors.grey.withValues(alpha: 0.1),
            leading: Image.asset("assets/icons/checkout/upi-icon.png", height: 20, width: 20,),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  child: Column(
                    children: paymentProvider.upis.isEmpty
                    ? [
                      AddUpiCard(amount: amount, isTapped: true, fromCart: fromCart,)
                    ]
                    : List.generate(
                      paymentProvider.upis.length,
                      (index) {
                        return Column(
                          children: [
                            Container(
                              width: double.infinity,
                              // margin: const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                // borderRadius: BorderRadius.circular(8),
                                color: Theme.of(context).scaffoldBackgroundColor,
                              ),
                              child: RadioListTile(
                                value: index, 
                                overlayColor: WidgetStatePropertyAll(Colors.transparent.withValues(alpha: 0.1)),
                                groupValue: paymentProvider.selectedUPi,
                                onChanged: (value) {
                                  paymentProvider.selectUpi(index);
                                },
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    AppTextWidget(
                                      text: paymentProvider.upis[index].upiProvider, 
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        await paymentProvider.addPaymentMethod(
                                          paymentData: {"upi_id": paymentProvider.upis[index].id}, 
                                          size: MediaQuery.sizeOf(context), 
                                          context: context,
                                          isDelete: true, isCardDelete: true
                                          );
                                      }, 
                                      icon: const Icon(CupertinoIcons.delete)
                                    )
                                  ],
                                ),
                                subtitle: AppTextWidget(
                                  text: "****${paymentProvider.upis[index].upiId.substring(12)}", 
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                ),
                              )
                            ),
                            
                            paymentProvider.upis.length - 1== index
                            ? Column(
                              spacing: 10,
                              children: [
                                AddUpiCard(amount: amount, isTapped: true, fromCart: fromCart,),
                                paymentProvider.selectedUPi > -1
                                ? Consumer3<ApiProvider, CartProvider, ProfileProvider>(
                                    builder: (context, provider, cartProvider, profileProvider, child) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      child: ButtonWidget(
                                        height: kToolbarHeight - 10,
                                        width: double.infinity,
                                        borderRadius: 5,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        buttonName: "Pay $amount", 
                                        onPressed: () async {
                                          
                                          Map<String, dynamic> paymentData = paymentProvider.paymentData;
                                          paymentData["payment_method"] ="Upi";
                                          /// Quick order Checkout if user add products from quick order this API gives response
                                          if (fromCart) {
                                            await provider.quickOrderCheckOut(context, MediaQuery.sizeOf(context), paymentData ).then((value) async {
                                              provider.clearCoupon();
                                              await profileProvider.orderList();
                                              /// Once order placed it will remove coupon from checkout session
                                              print("Order Placed from Quick order");
                                            });
                                          }else{
                                            /// Cart Checkout if the user added product from cart this API gives response
                                            await cartProvider.cartCheckOut(context, MediaQuery.sizeOf(context), paymentData).then((value) async {
                                              provider.clearCoupon();
                                              await profileProvider.orderList();
                                            },);
                                            
                                          }
                                        },
                                      ),
                                    );
                                  }
                                )
                                : Container()
                              ],
                            )
                            : Container()
                          ],
                        );
                      }, 
                    ),
                  ),
                )
              )
            ],
          ),
        );
      }
    );
  }
}