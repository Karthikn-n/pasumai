import 'package:app_3/providers/api_provider.dart';
import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../model/products_model.dart';
import 'filter_provider.dart';

class CommonFilter extends StatelessWidget {
  final List<String> options;
  final List<bool> ischecked;
  final bool? isQuantity;
  final List<Products> products;
  final Function(int? index) select;
  const CommonFilter({
    super.key, 
    this.isQuantity,
    required this.products,
    required this.options, 
    required this.ischecked, 
    required this.select,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<FilterProvider, ApiProvider>(
      builder: (context, filter, apiProvider, child) {
        return  ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: options.length,
            itemBuilder: (context, index) {
              return CheckboxListTile(
                value: ischecked[index],
                onChanged: (value) {
                  select(index);
                  if (ischecked[index]) {
                    if (isQuantity != null) {
                      filter.filterProduct(products: products, isQuantity: true, quantity: options[index]);
                    }else{
                      filter.filterProduct(products: products, isQuantity: true, quantity: options[index]);
                    }
                  }
                },
                title: AppTextWidget(text:options[index], fontWeight: FontWeight.w400, fontSize: 12,),
              );
            },
          );
      },
    );
  }
}