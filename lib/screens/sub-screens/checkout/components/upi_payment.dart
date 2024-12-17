import 'package:app_3/screens/sub-screens/checkout/components/add_upi_card.dart';
import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/payment_proivider.dart';

class UpiPayment extends StatelessWidget {
  final String amount;
  const UpiPayment({super.key, required this.amount});

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
                    children: List.generate(
                      paymentProvider.upis.length + 1,
                      (index) {
                        return AddUpiCard(amount: amount, isTapped: true,);
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