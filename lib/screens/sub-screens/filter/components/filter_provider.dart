import 'package:app_3/screens/sub-screens/filter/components/common_filter.dart';
import 'package:app_3/screens/sub-screens/filter/components/slider_filter.dart';
import 'package:app_3/service/api_service.dart';
import 'package:flutter/material.dart';

import '../../../../model/products_model.dart';
import '../../../../repository/app_repository.dart';

class FilterProvider extends ChangeNotifier{
  String? selectedFilter;
  List<Products> filteredProducts = [];
  // List<CategoryModel> categoryIds = [];
  AppRepository apiRepository = AppRepository(ApiService("https://maduraimarket.in/api"));
  // List of filter options
  List<String> filters = [
    'Prices', 'Quantity', 'Discount',
  ];

  // Price Ranges
  double startValue = 10;
  double endValue = 1000;
  void priceSelected(RangeValues? values,){
    startValue = values!.start;
    endValue = values.end;
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
  double discountStart = 10.0;
  double discountEnds = 65.0;
  void disCountSelected(RangeValues? value,){
    discountStart = value!.start;
    discountEnds = value.end;
    notifyListeners();
  } 

  // Categories
  // List<String> categories = ["dairy", "beverage", "sweet", "food", "ice cream", "batter", "breads",];
  // List<bool> isCategoryChecked = [false, false, false, false, false, false, false, false];
  // void catSelected(int? index,){
  //   isCategoryChecked[index!] = !isCategoryChecked[index];
  //   notifyListeners();
  // } 

  // Common for select the filter option from the left side of the panel
  void selectFilter(int? index){
    selectedFilter = index != null ? filters[index] : filters[0];
    notifyListeners();
  }

  // Filter product based on the options
  void filterProduct({
    required List<Products> products, 
    double? start, double? end, bool? isAmount,
    String? quantity, 
    String? categories,
    bool? isQuantity,
    double? discountStart, double? discountEnds
  }) async {
     if (isAmount != null) {
      if (filteredProducts.isNotEmpty) {
         filteredProducts = filteredProducts.where((element) => element.finalPrice <= endValue && element.finalPrice >= startValue,).toList();
      }else{
        filteredProducts = products.where((element) => element.finalPrice <= endValue && element.finalPrice >= startValue,).toList();
      }
     }
     if (quantity != null) {
       if (filteredProducts.isNotEmpty) {
         filteredProducts = filteredProducts.where((element) => element.quantity.toLowerCase() == quantity.toLowerCase()).toList();
       } else {
          filteredProducts = products.where((element) => element.quantity.toLowerCase() == quantity.toLowerCase()).toList();
       }
     }
     if (discountStart != null && discountEnds != null) {
       if (filteredProducts.isNotEmpty) {
         filteredProducts = filteredProducts.where((element) => double.parse(element.offerAmount!) >= discountStart && double.parse(element.offerAmount!) <= discountEnds ).toList();
       } else {
          filteredProducts = products.where((element) => double.parse(element.offerAmount!) >= discountStart && double.parse(element.offerAmount!) <= discountEnds ).toList();
       }
     }
    // if (filteredProducts.isNotEmpty) {
    //     filteredProducts = filteredProducts.where((element) {
    //     if (discountStart != null && discountEnds != null && (double.parse(element.offerAmount!) < discountStart && double.parse(element.offerAmount!) > discountEnds)) {
    //       return false;
    //     }
    //     if (quantity != null && element.quantity.toLowerCase() != quantity.toLowerCase()) {
    //       return false;
    //     }
    //     if (start != null && end != null && (element.finalPrice < start && element.finalPrice > end)) {
    //       return true;
    //     }
        
    //     return true;
    //   },).toList();
    // }{
    //   filteredProducts = products.where((element) {
    //   if (discountStart != null && discountEnds != null && (double.parse(element.offerAmount!) < discountStart && double.parse(element.offerAmount!) > discountEnds)) {
    //     return false;
    //   }
    //   if (quantity != null && element.quantity.toLowerCase() != quantity.toLowerCase()) {
    //     return false;
    //   }
    //   if (start != null && end != null && (element.finalPrice < start && element.finalPrice >= end)) {
    //     return false;
    //   }
      
    //   return true;
    // },).toList();
    // }

    print("Filtered producsts length: ${filteredProducts.length}");
    notifyListeners();
  }
  // Get Categories for the fitler
  // Future<void> getCatgories() async {
  //   final response = await apiRepository.categories();
  //   String decryptedResponse = decryptAES(response.body).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '');
  //   final decodedResponse = json.decode(decryptedResponse);
  //   debugPrint('Category Response: $decodedResponse, Status code: ${response.statusCode}', wrapWidth: 1064);
  //   if (response.statusCode == 200) {
  //     final List<dynamic> categoriesReponse = decodedResponse['results'];
  //     List<CategoryModel> categoryList = categoriesReponse.map((json) => CategoryModel.fromMap(json)).toList();
  //     // categoryIds = categoryList;
  //   }  else {
  //     print('Error Banner: ${response.body}');
  //   }
  //   notifyListeners();
  // }
  Widget selectedFilterOption(int index, List<Products> products){
    switch (index) {
      case 0:
        return PriceSlider("₹${startValue.round()}", "₹${endValue.round().toString()}", products, isAmount: true, startValue: startValue, endValue: endValue, pickValues: priceSelected, min: 10, max: 1000,);
      case 1:
        return CommonFilter(options: volumes, ischecked: isVolChecked, select: quantitySelected, products: products, isQuantity: true,);
      case 2:
        return PriceSlider("${discountStart.round()}%", "${discountEnds.round()}%", products, startValue: discountStart, endValue: discountEnds, pickValues: disCountSelected, min: 0, max: 65, division: 13, isAmount: false,);
      // case 3:
      //   return Consumer<ApiProvider>(
      //     builder: (context, prodvider, child) {
      //       return CommonFilter(options: prodvider.categories.map((e) => e.categoryName,).toList(), ischecked: isCategoryChecked, select: catSelected, products: products,);
      //     }
      //   );
      default:
        return Container();
    }
  }
}