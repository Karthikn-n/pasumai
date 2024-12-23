import 'package:app_3/widgets/common_widgets.dart/button_widget.dart';
import 'package:app_3/widgets/common_widgets.dart/input_field_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../providers/api_provider.dart';
import '../../../../providers/cart_items_provider.dart';
import '../../../../providers/profile_provider.dart';
import '../../../../widgets/common_widgets.dart/text_widget.dart';
import '../provider/payment_proivider.dart';

class AddUpiCard extends StatefulWidget {
  final String amount;
  final bool isTapped;
  final bool fromCart;
  const AddUpiCard({super.key, required this.amount, required this.isTapped, required this.fromCart});

  @override
  State<AddUpiCard> createState() => _AddUpiCardState();
}

class _AddUpiCardState extends State<AddUpiCard> {
  
  final TextEditingController _upiIdController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
        )
      ),
      child: Consumer4<ApiProvider, CartProvider, ProfileProvider, PaymentProivider>(
        builder: (context, provider, cartProvider, profileProvider, paymentProvider, child) {
          return ExpansionTile(
            title: const AppTextWidget(
              text: "Add new UPI ID", 
              fontWeight: FontWeight.w500
            ),
            shape: const RoundedRectangleBorder(
              side: BorderSide.none
            ),
            onExpansionChanged: (value) {
              if(value && paymentProvider.selectedUPi > -1){
                paymentProvider.selectUpi(-1);
              }
            },
            iconColor: Colors.black,
            collapsedShape: const RoundedRectangleBorder(side: BorderSide.none),
            backgroundColor: Colors.grey.withValues(alpha: 0.1),
            leading: const Icon(CupertinoIcons.add),
            children: [
              Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppTextWidget(text: "UPI ID", fontWeight: FontWeight.w400, fontSize: 14,),
                  // UPI text field
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.65,
                        child: TextFields(
                          isObseure: false, 
                          borderRadius: 5,
                          controller: _upiIdController,
                          textInputAction: TextInputAction.next,
                          hintText: "Enter your UPI ID",
                          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          validator: (value) {
                            if (value == null && value!.isEmpty) {
                              return "Enter a valid UPI ID";
                            }else{
                              return null;
                            }
                          },
                        ),
                      ),
                      ButtonWidget(
                        width: MediaQuery.sizeOf(context).width * 0.28,
                        borderRadius: 5,
                        buttonName: "Verify", 
                        onPressed: () {
                          
                        },
                      )
                    ],
                  ),
                  // const SizedBox(height: 10,),
                  paymentProvider.selectedUPi > -1
                  ? Container()
                  : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: ButtonWidget(
                      height: kToolbarHeight - 10,
                      width: double.infinity,
                      borderRadius: 5,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      buttonName: "Pay ${widget.amount}", 
                      onPressed: () async {
                        Map<String, dynamic> paymentData = {
                          "upi_id" : _upiIdController.text,
                          "provider_name": "Google pay"
                        };
                        await paymentProvider.addPaymentMethod(
                          paymentData: paymentData, 
                          size: MediaQuery.sizeOf(context), 
                          context: context
                        );
                        Map<String, dynamic> paymentDetails = paymentProvider.paymentData;
                        paymentDetails["payment_method"] ="Upi";
                        /// Quick order Checkout if user add products from quick order this API gives response
                        if (widget.fromCart) {
                          await provider.quickOrderCheckOut(context, MediaQuery.sizeOf(context), paymentDetails ).then((value) async {
                            provider.clearCoupon();
                            await profileProvider.orderList();
                            /// Once order placed it will remove coupon from checkout session
                            print("Order Placed from Quick order");
                          });
                        }else{
                          /// Cart Checkout if the user added product from cart this API gives response
                          await cartProvider.cartCheckOut(context, MediaQuery.sizeOf(context), paymentDetails).then((value) async {
                            provider.clearCoupon();
                            await profileProvider.orderList();
                          },);
                          
                        }
                      },
                    ),
                  )
                
        
                ],
              )
            ],
          );
        }
      ),
    );
  }
}