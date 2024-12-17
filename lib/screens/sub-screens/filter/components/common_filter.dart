import 'package:app_3/providers/api_provider.dart';
import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'filter_provider.dart';

class CommonFilter extends StatelessWidget {
  final List<String> options;
  final List<bool> ischecked;
  final Function(int? index) select;
  final bool? isPrice;
  const CommonFilter({
    super.key, 
    required this.options, 
    required this.ischecked, 
    required this.select,
    this.isPrice
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
              },
              title: AppTextWidget(text:options[index], fontWeight: FontWeight.w400, fontSize: 12,),
            );
          },
        );
      },
    );
  }
}