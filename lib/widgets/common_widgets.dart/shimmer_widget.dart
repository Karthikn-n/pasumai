import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerCarosouelView extends StatelessWidget {
  const ShimmerCarosouelView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return SizedBox(
      height: size.height * 0.25,
      child:  ListView.builder(
        itemCount: 3,
        scrollDirection: Axis.horizontal, // Number of shimmer items
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: size.height * 0.05,
                width: size.width * 0.45,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}