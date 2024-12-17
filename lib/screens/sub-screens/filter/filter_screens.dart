import 'package:app_3/widgets/common_widgets.dart/app_bar.dart';
import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/filter_provider.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: "Filter",
        needBack: true,
        onBack: () {
          Navigator.pop(context);
        },
      ),
      body: Consumer<FilterProvider>(
        builder: (context, filterProvider, child){
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                // fitler categories
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.4,
                  child: Column(
                    children: List.generate(
                      filterProvider.filters.length, 
                      (index) {
                        return ListTile(
                          tileColor: filterProvider.selectedFilter != null 
                            ? filterProvider.selectedFilter == filterProvider.filters[index]
                              ? Theme.of(context).scaffoldBackgroundColor
                              : Colors.grey.shade200
                            : index ==0 ? Theme.of(context).scaffoldBackgroundColor : Colors.grey.shade200,
                          title: AppTextWidget(text: filterProvider.filters[index], fontWeight: FontWeight.w500, fontSize: 14,),
                          onTap: () {
                            filterProvider.selectFilter(index);
                          },
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    // width: MediaQuery.sizeOf(context).width * 0.4,
                    child: filterProvider.selectedFilterOption(
                      filterProvider.selectedFilter != null ? filterProvider.filters.indexOf(filterProvider.selectedFilter!) : 0
                    ),
                  ),
                )
              ],
            ),
          );
        }
      ),
    );
  }
}