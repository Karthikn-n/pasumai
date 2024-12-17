import 'package:app_3/screens/sub-screens/filter/components/common_filter.dart';
import 'package:flutter/material.dart';

class FilterProvider extends ChangeNotifier{
  String? selectedFilter;
  // List of filter options
  List<String> filters = [
    'Prices', 'Quantity', 'Discount', 'Category', 'Rating',
  ];

  // Price Ranges
  List<String> priceRange = ["100 below", "100-150","150-200", "200-300","300 above", ];
  List<bool> isPriceChecked = [false, false, false, false, false];
  void priceSelected(int? index,){
    isPriceChecked[index!] = !isPriceChecked[index];
    notifyListeners();
  } 

  // Volums
  List<String> volumes = ["100ml", "250ml", "500ml", "1L", "100g","200g","250g","500g"];
  List<bool> isVolChecked = [false, false, false, false, false, false, false, false, false];
  void quantitySelected(int? index,){
    isVolChecked[index!] = !isVolChecked[index];
    notifyListeners();
  } 

  // discounts
  List<String> discounts = ["below 10%", "20%-30%", "30%-50%", ];
  List<bool> isdisCountsChecked = [false, false, false, false, false];
  void disCountSelected(int? index,){
    isdisCountsChecked[index!] = !isdisCountsChecked[index];
    notifyListeners();
  } 

  // Categories
  List<String> categories = ["dairy", "beverage", "sweet", "food", "ice cream", "batter", "breads",];
  List<bool> isCategoryChecked = [false, false, false, false, false, false, false, false];
  void catSelected(int? index,){
    isCategoryChecked[index!] = !isCategoryChecked[index];
    notifyListeners();
  } 

  // Common for select the filter option from the left side of the panel
  void selectFilter(int? index){
    selectedFilter = index != null ? filters[index] : filters[0];
    notifyListeners();
  }

  Widget selectedFilterOption(int index){
    switch (index) {
      case 0:
        return CommonFilter(options: priceRange, ischecked: isPriceChecked, select: priceSelected);
      case 1:
        return CommonFilter(options: volumes, ischecked: isVolChecked, select: quantitySelected);
      case 2:
        return CommonFilter(options: discounts, ischecked: isdisCountsChecked, select: disCountSelected);
      case 3:
        return CommonFilter(options: categories, ischecked: isCategoryChecked, select: catSelected);
      default:
        return Container();
    }
  }
}