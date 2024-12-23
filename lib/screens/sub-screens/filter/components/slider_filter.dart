import 'package:app_3/model/products_model.dart';
import 'package:app_3/screens/sub-screens/filter/components/filter_provider.dart';
import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PriceSlider extends StatelessWidget {
  final double startValue;
  final double endValue;
  final double min;
  final double max;
  final bool isAmount;
  final int? division;
  final String start;
  final String end;
  final List<Products> products;
  final Function(RangeValues? value) pickValues;
  const PriceSlider(
    this.start, this.end, this.products,
    {
    super.key, 
    required this.startValue, 
    required this.endValue, 
    required this.pickValues,
    required this.min,
    required this.isAmount,
    required this.max,
    this.division
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(),
        AppTextWidget(
          text: "$start- $end", 
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        // Range picker
        Consumer<FilterProvider>(
          builder: (context, filter, child) {
            return RangeSlider(
              values: RangeValues(startValue, endValue), 
              min: min,
              inactiveColor: Colors.grey.shade300,
              max: max,
              overlayColor: const WidgetStatePropertyAll(Colors.transparent),
              divisions: division,
              labels: RangeLabels(startValue.round().toString(), endValue.round().toString()),
              onChangeStart: (value) {
                pickValues(value);
                if (isAmount) {
                  filter.filterProduct(products: products);
                }else{
                  filter.filterProduct(products: products,);
                }
              },
              onChangeEnd: (value) {
                pickValues(value);
                if (isAmount) {
                  filter.filterProduct(products: products, start: value.start, end: value.end, isAmount: true);
                }else{
                  filter.filterProduct(products: products, discountStart: value.start, discountEnds: value.end);
                }
              },
              onChanged: (value) {
                pickValues(value);
                if (isAmount) {
                  filter.filterProduct(products: products, start: value.start, end: value.end, isAmount: true);
                }else{
                  filter.filterProduct(products: products, discountStart: value.start, discountEnds: value.end);
                }
              },
            );
          }
        ),
        InkWell(
          onTap: () {
            pickValues(RangeValues(min, max));
          },
          child: const AppTextWidget(text: "Reset price range", fontWeight: FontWeight.w400),
        )
      ],
    );
  }
}