import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerProfileWidget extends StatelessWidget {
  const ShimmerProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              direction: ShimmerDirection.ttb,
              highlightColor: Colors.grey.shade100,
              child: Container(
                height: size.height * 0.15,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
                ),
              ), 
            ),
            const SizedBox(height: 10,)
          ],
        );
      },
    );
  }
}