import 'package:app_3/widgets/shimmer_widgets/shimmer_parent.dart';
import 'package:flutter/material.dart';

class ShimmerSubscriptionWidget extends StatelessWidget {
  const ShimmerSubscriptionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey)
              ),
              child: Row(
                children: [
                  ShimmerParent(height: size.height * 0.13, width: size.width * 0.26),
                  const SizedBox(width: 6,),
                   Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                      ShimmerParent(height: 20, width: size.width * 0.4),
                      const SizedBox(height: 4,),
                      ...List.generate(6, (index) {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ShimmerParent(height: 14, width: size.width * 0.35),
                                const SizedBox(width: 20,),
                                const ShimmerParent(height: 14, width: 40),
                              ],
                            ),
                            const SizedBox(height: 4,)
                          ],
                        );
                      },)
                     ],
                   ),
                ],
              ),
            ),
            const SizedBox(height: 10,),
          ],
        );
      }
    );
  }
}