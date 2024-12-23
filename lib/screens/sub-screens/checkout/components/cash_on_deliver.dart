import 'package:app_3/screens/sub-screens/checkout/provider/payment_proivider.dart';
import 'package:app_3/widgets/common_widgets.dart/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../providers/api_provider.dart';
import '../../../../providers/cart_items_provider.dart';
import '../../../../providers/profile_provider.dart';
import '../../../../widgets/common_widgets.dart/text_widget.dart';

class CashOnDelivery extends StatelessWidget {
  final String amount;
  final bool fromCart;
  const CashOnDelivery({super.key, required this.amount, required this.fromCart});

  @override
  Widget build(BuildContext context) {
    return Consumer<PaymentProivider>(
      builder: (context, paymentProvider, child) {
        return Container(
          decoration: BoxDecoration(
            border: Border(
              // top: BorderSide(color: Colors.grey.shade200),
              bottom: BorderSide(color: Colors.grey.shade200)
            )
          ),
          child: ExpansionTile(
            shape: const RoundedRectangleBorder(
              side: BorderSide.none
            ),
            iconColor: Colors.black,
            initiallyExpanded: paymentProvider.isExpanded[2],
            collapsedShape: const RoundedRectangleBorder(side: BorderSide.none),
            title: const AppTextWidget(
              text: "Cash on delivery", 
              fontWeight: FontWeight.w500
            ),
            backgroundColor: Colors.grey.withValues(alpha: 0.1),
            leading: Image.asset("assets/icons/checkout/cash-on-delivery.png", height: 20, width: 20,),
             onExpansionChanged: (isExpanded) {
              if (isExpanded) {
                paymentProvider.expandSelectedPaymentOption(2);
              }
            },
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  child: paymentProvider.isCardPayment
                    ? const LoadingButton(
                        height: kToolbarHeight - 10,
                        width: double.infinity,
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Consumer3<ApiProvider, CartProvider, ProfileProvider>(
                          builder: (context, provider, cartProvider, profileProvider, child) {
                            return ButtonWidget(
                              buttonName: "Pay $amount", 
                              height: kToolbarHeight - 10,
                              width: double.infinity,
                              borderRadius: 5,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              onPressed: () async {
                                  Map<String, dynamic> paymentData = paymentProvider.paymentData;
                                  paymentData["payment_method"] ="cash on delivery";
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
                            );
                          }
                        ),
                      ),
                ),
              )
            ],
          ),
        );
      }
    );
  }
}