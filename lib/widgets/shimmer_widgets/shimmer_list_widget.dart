import 'package:app_3/widgets/shimmer_widgets/shimmer_parent.dart';
import 'package:flutter/material.dart';

class ShimmerListWidget extends StatelessWidget {
  const ShimmerListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        decoration: BoxDecoration(
        border: Border(
          bottom: index == 5 
          ? BorderSide.none
          : BorderSide(color: Colors.grey.shade300)
        ),
        // borderRadius: BorderRadius.circular(10)
        ),
        child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Product Image
          const ShimmerParent(height: 105, width: 94),
          // Product Details
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Name
              ShimmerParent(height: 30, width: size.width * 0.6),
              const SizedBox(height: 6,),
              // Product Description
              ShimmerParent(height: 20, width: size.width * 0.6),
              const SizedBox(height: 6,),
              ShimmerParent(height: 20, width: size.width * 0.3),
            ],
          ),
          // Increment and Decrement Button
          const Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerParent(height: 45, width: 40),
              SizedBox(height: 6,),
              ShimmerParent(height: 45, width: 40),
            ],
          ),
        ],
        ),
        );
      }, 
    );
  }
}