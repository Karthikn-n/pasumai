import 'package:app_3/screens/sub-screens/checkout/components/card_payment.dart';
import 'package:app_3/screens/sub-screens/checkout/components/cash_on_deliver.dart';
import 'package:app_3/screens/sub-screens/checkout/components/total_amount.dart';
import 'package:app_3/screens/sub-screens/checkout/components/upi_payment.dart';
import 'package:app_3/widgets/common_widgets.dart/app_bar.dart';
import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  final String totalAmount;
  const PaymentScreen({super.key, required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBarWidget(
        title: "Payment",
        fontSize: 16,
        needBack: true,
        onBack: () {
          Navigator.pop(context);
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10,),
              // Total amount in the checkout screen
             Padding(
               padding: const EdgeInsets.symmetric(horizontal: 12),
               child: TotalAmount(totalAmount: totalAmount),
             ),
             const SizedBox(height: 10,),
             // Tile for debit card payment
             CardPayment(amount: totalAmount,),
             // UPI method tile
             UpiPayment(amount: totalAmount),
             // Cash on delivery tile
             CashOnDelivery(amount: totalAmount,)
            ],
          ),
        )
      ),
    );
  }
}