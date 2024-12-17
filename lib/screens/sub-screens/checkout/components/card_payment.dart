import 'package:app_3/screens/sub-screens/checkout/provider/payment_proivider.dart';
import 'package:app_3/widgets/common_widgets.dart/button_widget.dart';
import 'package:app_3/widgets/common_widgets.dart/input_field_widget.dart';
import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class CardPayment extends StatefulWidget {
  final String amount;
  const CardPayment({super.key, required this.amount});

  @override
  State<CardPayment> createState() => _CardPaymentState();
}

class _CardPaymentState extends State<CardPayment> {
  final TextEditingController _carNumberController = TextEditingController();
  final TextEditingController _validThruController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final GlobalKey<FormState> _cardKey = GlobalKey<FormState>();
  @override
  void initState(){
    super.initState();
   
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
          bottom: BorderSide(color: Colors.grey.shade200)
        )
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Consumer<PaymentProivider>(
        builder: (context, paymentProvider, child) {
          return ExpansionTile(
            shape: const RoundedRectangleBorder(
              side: BorderSide.none
            ),
            initiallyExpanded: paymentProvider.isExpanded[1],
            onExpansionChanged: (isExpanded) {
              if (isExpanded) {
                paymentProvider.expandSelectedPaymentOption(1);
              }
            },
            iconColor: Colors.black,
            collapsedShape: const RoundedRectangleBorder(side: BorderSide.none),
            title: const AppTextWidget(
              text: "Credit / Debit / ATM card", 
              fontWeight: FontWeight.w500
            ),
            backgroundColor: Colors.grey.withValues(alpha: 0.1),
            leading: Image.asset("assets/icons/checkout/debit-card.png", height: 20, width: 20,),
            children: paymentProvider.cards.isNotEmpty 
            ? []
            : [
              // NOTE section
              Center(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Note: ",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: Theme.of(context).primaryColorDark.withAlpha(128),
                        ),
                      ),
                      TextSpan(
                        text: "Please ensure your card can be used for online transactions.",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          height: 1.5,
                          color: Theme.of(context).primaryColorDark.withAlpha(128),
                        ),
                      ),
                    ],
                  )
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  child: Form(
                    key: _cardKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8,
                      children: [
                        const AppTextWidget(text: "Card number", fontWeight: FontWeight.w400, fontSize: 14,),
                        // Card text field
                        TextFields(
                          isObseure: false, 
                          borderRadius: 5,
                          maxLength: 19,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            CardNumberInputFormatter()
                          ],
                          controller: _carNumberController,
                          textInputAction: TextInputAction.next,
                          hintText: "xxxx xxxx xxxx xxxx",
                          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null && value!.isEmpty || _carNumberController.length < 19) {
                              return "Enter a valid card number";
                            }else{
                              return null;
                            }
                          },
                        ),
                        const SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Valid thru field
                            Column(
                              spacing: 8,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const AppTextWidget(text: "Valid Thru", fontWeight: FontWeight.w400, fontSize: 14,),
                                // Card text field
                                SizedBox(
                                  width: MediaQuery.sizeOf(context).width / 2.4,
                                  child: TextFields(
                                    isObseure: false, 
                                    borderRadius: 5,
                                    enableSuggestions: false,
                                    maxLength: 7,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      ExpireDateInputFormatter()
                                    ],
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    controller: _validThruController,
                                    textInputAction: TextInputAction.next,
                                    hintText: "MM / YY",
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null && value!.isEmpty || value.length < 7) {
                                        return "Enter valid month/year";
                                      }else{
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            // Cvv
                            Column(
                              spacing: 8,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const AppTextWidget(text: "CVV", fontWeight: FontWeight.w400, fontSize: 14,),
                                // Card text field
                                SizedBox(
                                  width: MediaQuery.sizeOf(context).width / 2.4,
                                  child: TextFields(
                                    isObseure: false, 
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    borderRadius: 5,
                                    controller: _cvvController,
                                    enableSuggestions: false,
                                    maxLength: 3,
                                    textInputAction: TextInputAction.next,
                                    hintText: "CVV",
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null && value!.isEmpty || _carNumberController.length < 3) {
                                        return "Enter a valid cvv";
                                      }else{
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            
                          ],
                        ),
                        const SizedBox(height: 10,),
                        // Pay buton
                        paymentProvider.isCardPayment
                        ? const LoadingButton(
                            width: double.infinity,
                            height: kToolbarHeight - 10,
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: ButtonWidget(
                              height: kToolbarHeight - 10,
                              width: double.infinity,
                              borderRadius: 5,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              buttonName: "Pay ${widget.amount}", 
                              onPressed: () {
                                if (_cardKey.currentState!.validate()) {
                                  
                                }
                              },
                            ),
                          )
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        }
      ),
    );
  }
}

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final String digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), ''); // Remove non-digit characters
    final StringBuffer formatted = StringBuffer();

    for (int i = 0; i < digitsOnly.length; i++) {
      formatted.write(digitsOnly[i]);
      if ((i + 1) % 4 == 0 && i + 1 != digitsOnly.length) {
        formatted.write(' '); // Add space after every 4 digits
      }
    }

    return TextEditingValue(
      text: formatted.toString(),
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class ExpireDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final String digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), ''); // Remove non-digit characters
    final StringBuffer formatted = StringBuffer();

    for (int i = 0; i < digitsOnly.length; i++) {
      formatted.write(digitsOnly[i]);
      if ((i) == 1  && i + 1 != digitsOnly.length) {
        formatted.write(' / '); // Add space after every 4 digits
      }
    }

    return TextEditingValue(
      text: formatted.toString(),
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}