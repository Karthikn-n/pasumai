import 'package:flutter/material.dart';

class AppTextWidget extends StatelessWidget{
  final String text;
  final double? fontSize;
  final FontWeight fontWeight;
  final Color? fontColor;
  final int? maxLines;
  final TextDecoration? decoration;
  final double? textDecorationThickness;
  final Color? textDecorationColor;
  final double? letterSpacing;
  final TextAlign? textAlign;
  final TextOverflow? textOverflow;
  const AppTextWidget({
    required this.text,
    this.fontSize,
    required this.fontWeight,
    this.fontColor,
    this.maxLines,
    this.textAlign,
    this.letterSpacing,
    this.decoration,
    this.textDecorationColor,
    this.textDecorationThickness,
    this.textOverflow,
    super.key
  });

  @override
  Widget build(BuildContext context){
    return Text(
      text,
      maxLines: maxLines,
      textAlign: textAlign,
      style: TextStyle(
        
        color: fontColor, 
        decoration: TextDecoration.none,
        fontSize: fontSize,
        decorationColor: textDecorationColor,
        decorationThickness: textDecorationThickness,
        overflow: textOverflow,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing
      ),
    );
  }
}