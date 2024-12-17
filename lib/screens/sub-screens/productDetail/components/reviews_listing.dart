import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'review_counts.dart';

class ReviewsListing extends StatefulWidget {
  final int reviews;
  const ReviewsListing({super.key, required this.reviews});

  @override
  State<ReviewsListing> createState() => _ReviewsListingState();
}

class _ReviewsListingState extends State<ReviewsListing> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: (size.height * 0.25) * widget.reviews,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.reviews,
        itemBuilder: (context, index) {
          return Column(
            spacing: 8,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey.shade400))
                ),
                child: Column(
                  spacing: 8,
                  children: [
                    // Profile name and profile image
                    Row(
                      spacing: 5,
                      children: [
                        Icon(CupertinoIcons.profile_circled, size: 24, color: Colors.grey.shade400,),
                        const AppTextWidget(text: "Rathan patel", fontWeight: FontWeight.w500)
                      ],
                    ),
                    // Rating and date
                    Row(
                      spacing: 5,
                      children: [
                        ReviewCounts(average: (4.5).toInt(), iconSize: 14,),
                        AppTextWidget(text: DateFormat("dd/MM/yyyy").format(DateTime.now()), fontWeight: FontWeight.w400, fontSize: 12,)
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      },
                      child: AppTextWidget(
                        text: "This product truly stands out with its exceptional quality and performance. From the moment I started using it, I noticed the attention to detail in its design and functionality. The build is sturdy, and it feels premium, ensuring long-term reliability. Its features are intuitive, making it easy to use, even for beginners. The product has consistently delivered great results, meeting and even exceeding my expectations in various tasks. Additionally, the customer support team is responsive and helpful, which adds immense value to the purchase. Overall, I’m extremely satisfied and would highly recommend this product to anyone looking for a top-tier option in its category!", 
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        maxLines: isExpanded ? null : 3,
                      ),
                    ),
                    Container()
                  ],
                ),
              ),
              Container()
            ],
          );
        },
      ),
    );
  }
}