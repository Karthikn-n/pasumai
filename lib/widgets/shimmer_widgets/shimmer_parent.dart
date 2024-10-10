import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerParent extends StatelessWidget {
  final double height;
  final double width;
  const ShimmerParent({super.key, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        decoration:  BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        height: height,
        width: width,
      ), 
    );
  }
}