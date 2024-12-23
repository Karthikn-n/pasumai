import 'package:app_3/widgets/common_widgets.dart/app_bar.dart';
import 'package:app_3/widgets/common_widgets.dart/button_widget.dart';
import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/products_model.dart';
import 'components/filter_provider.dart';

class FilterScreen extends StatefulWidget {
  final List<Products> products;
  const FilterScreen({super.key, required this.products});

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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
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
                      // Filter body options
                      Expanded(
                        child: SizedBox(
                          // width: MediaQuery.sizeOf(context).width * 0.4,
                          child: filterProvider.selectedFilterOption(
                            filterProvider.selectedFilter != null ? filterProvider.filters.indexOf(filterProvider.selectedFilter!) : 0, widget.products
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, right: 8, left: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: "${filterProvider.filteredProducts.length}",
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w500
                          ),
                          children: [
                            TextSpan(
                              text: filterProvider.filteredProducts.length <= 1 ? "\nproduct found" : "\nproducts found",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400
                              )
                            )
                          ]
                        ),
                      ),
                      ButtonWidget(
                        width: MediaQuery.sizeOf(context).width * 0.3,
                        height: kToolbarHeight - 16,
                        borderRadius: 5,
                        buttonName: "Apply", 
                        fontSize: 14,
                        onPressed: (){
                          for (var element in filterProvider.filteredProducts) {
                            print(element.toJson());
                          }
                          // debugPrint("${filterProvider.filteredProducts.map((e) => e.toJson(),)}", wrapWidth: 1064);
                        }
                      ),
                    ],
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