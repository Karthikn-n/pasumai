import 'package:app_3/widgets/common_widgets.dart/button_widget.dart';
import 'package:app_3/widgets/common_widgets.dart/input_field_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../widgets/common_widgets.dart/text_widget.dart';

class AddUpiCard extends StatefulWidget {
  final String amount;
  final bool isTapped;
  const AddUpiCard({super.key, required this.amount, required this.isTapped});

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
      child: 
      ExpansionTile(
        title: const AppTextWidget(
          text: "Add new UPI ID", 
          fontWeight: FontWeight.w500
        ),
        iconColor: Colors.black,
        collapsedShape: const RoundedRectangleBorder(side: BorderSide.none),
        backgroundColor: Colors.grey.withValues(alpha: 0.1),
        trailing: const Icon(CupertinoIcons.plus, size: 24,),
        leading: Radio(
          value: true, 
          groupValue: widget.isTapped, 
          onChanged: (value) {
            
          },
        ),
        children: [
          const AppTextWidget(text: "UPI ID", fontWeight: FontWeight.w400, fontSize: 14,),
          // UPI text field
          Row(
            children: [
              SizedBox(
                width: MediaQuery.sizeOf(context).width / 1.5,
                child: TextFields(
                  isObseure: false, 
                  borderRadius: 5,
                  controller: _upiIdController,
                  textInputAction: TextInputAction.next,
                  hintText: "Enter your UPI ID",
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  keyboardType: TextInputType.number,
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
                width: MediaQuery.sizeOf(context).width / 4,
                borderRadius: 5,
                buttonName: "Verify", 
                onPressed: () {
                  
                },
              )
            ],
          ),
          const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ButtonWidget(
              height: kToolbarHeight - 10,
              width: double.infinity,
              borderRadius: 5,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              buttonName: "Pay ${widget.amount}", 
              onPressed: () {
              },
            ),
          )
        ],
      ),
    );
  }
}