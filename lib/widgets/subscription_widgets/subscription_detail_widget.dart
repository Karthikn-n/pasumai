import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:flutter/cupertino.dart';

class SubscriptionDetailWidget extends StatelessWidget {
  final String title;
  final String value;
  final Color? valueColor;
  final Color? titleColor;
  final double? width;
  final FontWeight? valueWeight;
  const SubscriptionDetailWidget({
    super.key, 
    required this.title, 
    required this.value,
    this.titleColor,
    this.width,
    this.valueWeight,
    this.valueColor
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Row(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: width ?? size.width * 0.44,
          child: AppTextWidget(
            text: title, 
            fontSize: 14, 
            fontWeight: FontWeight.w500
          ),
        ),
        Expanded(
          child: AppTextWidget(
            text: value,
            maxLines: 2,
            textOverflow: TextOverflow.ellipsis, 
            fontSize: 12, 
            fontColor: valueColor,
            fontWeight: valueWeight ?? FontWeight.w400
          ),
        ),
      ],
    );
  
  }
}


