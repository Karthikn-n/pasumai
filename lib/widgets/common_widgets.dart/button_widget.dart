import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String buttonName;
  final double? width;
  final Color? buttonColor;
  final double? fontSize;
  final IconData? icon;
  final Color? fontColor;
  final FontWeight? fontWeight;
  final double? borderRadius;
  final Color? bordercolor;
  final VoidCallback onPressed;
  const ButtonWidget({
    super.key, 
    this.width,
    this.buttonColor,
    this.fontSize, 
    this.icon,
    this.fontWeight,
    this.borderRadius,
    this.fontColor,
    this.bordercolor,
    required this.buttonName,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return SizedBox(
      width: width ?? size.width * 0.8,
      height: size.height * 0.065,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: buttonColor ?? Theme.of(context).primaryColor,
          surfaceTintColor: Colors.transparent.withOpacity(0.0),
          shadowColor: Colors.transparent.withOpacity(0.0),
          overlayColor: Colors.white38,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 10),
            side: BorderSide(
              color: bordercolor ?? Colors.transparent.withOpacity(0.0)
            )
          )
        ),
        onPressed: onPressed, 
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppTextWidget(
              text: buttonName,
              fontSize: fontSize ?? 20, 
              fontWeight: fontWeight ?? FontWeight.w400,
              fontColor: fontColor ?? Colors.white,
            ),
            // const SizedBox(width: 5,),
            // Icon(icon, size: 20, color: Colors.white,),
          ],
        )
      ),
    );
  }
}