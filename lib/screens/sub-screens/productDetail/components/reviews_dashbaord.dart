import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:flutter/material.dart';

class ReviewsDashbaord extends StatelessWidget {
  final List<int> ratings;
  final int totalRating;
  const ReviewsDashbaord({super.key, required this.ratings, required this.totalRating});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      children: List.generate(
        5, (index) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 43,
                child: AppTextWidget(text: "${index + 1} star", fontWeight: FontWeight.w500)
              ),
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.7,
                child: LinearProgressIndicator(
                  minHeight: 8,
                  valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                  backgroundColor: Colors.grey.withValues(alpha: 0.4),
                  value: ratings[index] /totalRating,
                ),
              ),
              // const SizedBox(width: 5,),
              SizedBox(
                width: 32,
                child: AppTextWidget(text: "${((ratings[index]/ totalRating) * 100).round()}%", fontWeight: FontWeight.w500)
              ),
            ],
          );
        },
      ),
    );
  }
}