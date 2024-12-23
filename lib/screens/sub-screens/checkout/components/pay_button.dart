import 'package:app_3/screens/sub-screens/checkout/provider/payment_proivider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../providers/api_provider.dart';
import '../../../../providers/cart_items_provider.dart';
import '../../../../providers/profile_provider.dart';
import '../../../../widgets/common_widgets.dart/button_widget.dart';

class PayButton extends StatelessWidget {
  final String amount;
  final bool fromCart;
  final VoidCallback? onPressed;
  const PayButton({super.key, required this.amount,required this.onPressed, required this.fromCart});

  @override
  Widget build(BuildContext context) {
    return  Consumer4<ApiProvider, CartProvider, ProfileProvider, PaymentProivider>(
      builder: (context, provider, cartProvider, profileProvider, paymentProvider, child) {
        return ButtonWidget(
          height: kToolbarHeight - 10,
          width: double.infinity,
          borderRadius: 5,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          buttonName: "Pay $amount", 
          onPressed: onPressed ?? () async {
            Map<String, dynamic> paymentData = paymentProvider.paymentData;
            paymentData["payment_method"] ="card";
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
    );
                        
  }
}