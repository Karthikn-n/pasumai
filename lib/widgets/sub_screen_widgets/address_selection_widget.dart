import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:flutter/material.dart';

Widget locationSelectButton({
  required BuildContext context,
  required Size size,
  required IconData leading,
  required IconData suffixIcon,
  required String title
}){
  return SizedBox(
    height: size.height * 0.08,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              leading,
              color: Theme.of(context).primaryColor,
              size: 18,
            ),
            const SizedBox(width: 5,),
            AppTextWidget(
              text: title, 
              fontSize: 16, 
              fontWeight: FontWeight.w600,
              fontColor: Theme.of(context).primaryColor,
            )
          ],
        ),
        Text(String.fromCharCode(suffixIcon.codePoint),
          style: TextStyle(
            inherit: false,
            fontSize: 17,
            fontWeight: FontWeight.w800,
            fontFamily: suffixIcon.fontFamily,
            package: suffixIcon.fontPackage,
            color:  Theme.of(context).primaryColor,
          ),
        )
      ],
    ),
  );     
}


