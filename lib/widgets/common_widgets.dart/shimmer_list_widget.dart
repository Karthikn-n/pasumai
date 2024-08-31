import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerListWidget extends StatelessWidget {
  const ShimmerListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
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
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: SizedBox(
                width: 94,
                height: 105,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                )
              ),
            ),
            // Product Details
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                width: size.width * 0.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Name and Quantity
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: RichText(
                        text: TextSpan(
                          text: " ",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).primaryColor
                          ),
                          children: const [
                            TextSpan(
                              text: "                  ",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black
                              )
                            )
                          ]
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    
                    const SizedBox(height: 5,),
                    // Product Description
                    const AppTextWidget(
                      text:"""
              
                      """, 
                      fontSize: 12, 
                      maxLines: 2,
                      fontColor: Colors.black54,
                      textOverflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.w400
                    ),
                    const SizedBox(height: 5,),
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Product Final price
                        AppTextWidget(
                          text: "   ", 
                          fontSize: 15, 
                          fontWeight: FontWeight.w400,
                        ),
                        SizedBox(width: 5,),
                        // Product Price 
                        Text(
                          "    ",
                          style: TextStyle(
                            fontSize: 13, 
                            fontWeight: FontWeight.w400,
                            decorationThickness: 2,
                            decorationColor: Colors.red,
                            color: Colors.black54,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Increment and Decrement Button
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 105,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
          ),
          ),
        );
      }, 
    );
  }
}