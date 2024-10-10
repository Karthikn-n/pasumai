import 'package:app_3/widgets/shimmer_widgets/shimmer_parent.dart';
import 'package:flutter/material.dart';

class ShimmerCarosouelView extends StatelessWidget {
  const ShimmerCarosouelView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return SizedBox(
      child: SizedBox(
        height: size.height * 0.4,
        child:  ListView.builder(
          itemCount: 3,
          scrollDirection: Axis.horizontal, // Number of shimmer items
          itemBuilder: (context, index) {
            return Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Image Loader
                    ShimmerParent(height: size.height * 0.3, width: size.width * 0.7),
                    const SizedBox(height: 8,),
                    SizedBox(
                      width: size.width  * 0.7,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Product name loader
                              ShimmerParent(height: 25, width: size.width * 0.4),
                              const SizedBox(height: 4,),
                              // Product price loader
                              ShimmerParent(height: 25, width: size.width * 0.25),
                            ],
                          ),
                          // Cart/Subscribe button loader
                          const ShimmerParent(height: 30, width: 60),
                            
                        ],
                      ),
                    ),
                   
                  ],
                ),
                const SizedBox(width: 10,)
              ],
            );
          },
        ),
      ),
    );
  }
}