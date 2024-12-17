import 'package:app_3/screens/sub-screens/checkout/model/card_model.dart';
import 'package:flutter/material.dart';

import '../model/upi_model.dart';

class PaymentProivider extends ChangeNotifier{
  bool isCardPayment = false;
  List<bool> isExpanded = [false, false, false];
  final List<CardModel> cards = [];
  final List<UpiModel> upis =[];


  void cardPayement({bool? status}){
    isCardPayment = status ?? false;
    notifyListeners();
  }

  void expandSelectedPaymentOption(int index){
    for (var i = 1; i <= isExpanded.length; i++) {
      isExpanded[i - 1] = i == index;
      print(isExpanded);
    }
    notifyListeners();
  }
}