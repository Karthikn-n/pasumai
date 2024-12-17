import 'package:app_3/screens/sub-screens/checkout/provider/payment_proivider.dart';
import 'package:app_3/widgets/common_widgets.dart/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../widgets/common_widgets.dart/text_widget.dart';

class CashOnDelivery extends StatelessWidget {
  final String amount;
  const CashOnDelivery({super.key, required this.amount});

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
                    ? LoadingButton(
                        height: kToolbarHeight - 10,
                        width: double.infinity,
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: ButtonWidget(
                          buttonName: "Pay $amount", 
                          height: kToolbarHeight - 10,
                          width: double.infinity,
                          borderRadius: 5,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          onPressed: () {
                            
                          },
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