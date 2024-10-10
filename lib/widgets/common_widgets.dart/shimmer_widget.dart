import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerCarosouelView extends StatelessWidget {
  const ShimmerCarosouelView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(),
      body: SizedBox(
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
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: size.height * 0.3,
                        width:  size.width * 0.7,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8,),
                    SizedBox(
                      width: size.width  *0.7,
                      child: Row(
                        // crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  decoration:  BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  height: 25,
                                  width: size.width * 0.4,
                                ), 
                              ),
                              const SizedBox(height: 4,),
                              Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  decoration:  BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  height: 25,
                                  width: size.width * 0.25,
                                ), 
                              )
                            ],
                          ),
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration:  BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              // height: 25,
                              // width: 60,
                              child: const Text("Subscribe"),
                            ), 
                          )
                            
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