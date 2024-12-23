import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:flutter/material.dart';

class TotalAmount extends StatelessWidget {
  final String totalAmount;
  const TotalAmount({super.key, required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).primaryColor.withValues(alpha: 0.3)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const AppTextWidget(
            text: "Total amount", 
            fontWeight: FontWeight.w400, 
            fontSize: 14,
          ),
          AppTextWidget(
            text: totalAmount, 
            fontWeight: FontWeight.w500, 
            fontSize: 16,
          )
        ],
      ),
    );
  }
}