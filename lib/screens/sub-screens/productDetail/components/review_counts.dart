import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReviewCounts extends StatelessWidget {
  final int average;
  final double? iconSize;
  const ReviewCounts({super.key, required this.average, this.iconSize});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) {
        return index < average 
          ? Icon(CupertinoIcons.star_fill, size: iconSize ?? 20, color: Colors.yellow,)
          : Icon(CupertinoIcons.star, size: iconSize ?? 20, color: Colors.yellow,);
      },),
    );
  }
}