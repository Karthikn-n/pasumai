import 'dart:convert';

import 'package:app_3/screens/sub-screens/checkout/model/card_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../data/encrypt_ids.dart';
import '../../../../helper/shared_preference_helper.dart';
import '../../../../repository/app_repository.dart';
import '../../../../service/api_service.dart';
import '../../../../widgets/common_widgets.dart/snackbar_widget.dart';
import '../model/upi_model.dart';

class PaymentProivider extends ChangeNotifier{
  bool isCardPayment = false;
  List<bool> isExpanded = [false, false, false];
  List<CardModel> cards = [];
  int selectedCard = -1;
  int selectedUPi = -1;
  List<UpiModel> upis =[];
  AppRepository paymentRepo = AppRepository(ApiService("https://maduraimarket.in/api"));
  // AppRepository apiRepository = AppRepository(ApiService("http://192.168.1.5/pasumaibhoomi/public/api"));
  SharedPreferences prefs = SharedPreferencesHelper.getSharedPreferences();

  // store other payment details here 
  Map<String, dynamic> paymentDetails = {};
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

  void selectCard(int index){
    selectedCard = index;
    if (selectedUPi > -1) {
      selectedUPi = -1;
    }
    notifyListeners();
  }
  void selectUpi(int index){
    selectedUPi = index;
    if (selectedCard > -1) {
      selectedCard = -1;
    }
    notifyListeners();
  }
  // Card list
  Future<void> cardUpiList() async {
    cards.clear();
    upis.clear();
    // final Map<String, dynamic> userdata = {"customer_id": prefs.getString("customerId")};
    // final response = await paymentRepo.cardUpiList(userdata);
    // final decryptedResponse = decryptAES(response.body).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), "");
    // final decodedReponse = json.decode(decryptedResponse);
    // print('Card Upi list response: $decodedReponse, Stauts code: ${response.statusCode}');
    // if (response.statusCode == 200 ) {
    //   if (decodedReponse["upi_data"] != "No UPI data" ) {
    //     List<dynamic> upiData = decodedReponse["upi_data"];
    //     upis = upiData.map((upi) => UpiModel.fromMap(upi),).toList();
    //   }
    //   if (decodedReponse["upi_data"] != "No Card data") {
    //     List<dynamic> cardData = decodedReponse["card_data"];
    //     cards = cardData.map((card) => CardModel.fromMap(card),).toList();
    //   }
    // }
    // else{
    //   print('CardUPi Error: $decodedReponse');
    // }
    notifyListeners();
  }
  
  // Add card and Upi Id
  Future<void> addPaymentMethod({
    required Map<String, dynamic> paymentData, 
    bool? isCard, 
    required Size size,
    bool? isDelete,
    bool? isCardDelete,
    required BuildContext context
  }) async {
    paymentData["customer_id"] =  prefs.getString("customerId");
    isCard != null ? paymentData["holder_name"] = "${prefs.getString('firstname') ?? ""} ${prefs.getString('lastname') ?? ""}"  : null;
    final response = isDelete != null 
    ? isCardDelete != null ? await paymentRepo.deleteCard(paymentData) : await paymentRepo.deleteUpi(paymentData) 
    : isCard != null  ? await paymentRepo.addCard(paymentData) : await paymentRepo.addUpi(paymentData);
    final decryptedResponse = decryptAES(response.body).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), "");
    final decodedReponse = json.decode(decryptedResponse);
    print('Add payment method response: $decodedReponse, Stauts code: ${response.statusCode}');
    if (response.statusCode == 200) {
      SnackBar wishlistMessage = snackBarMessage(
        context: context, 
        message: decodedReponse["message"], 
        backgroundColor: Theme.of(context).primaryColor, 
        sidePadding: size.width * 0.1, 
        bottomPadding: size.height * 0.05
      );
      ScaffoldMessenger.of(context).showSnackBar(wishlistMessage);
      await cardUpiList();
    }
    else{
      print('Add payment Error: $decodedReponse');
    }
    notifyListeners();
  }

  // Set payment details
  void setPaymentDetail(Map<String, dynamic> paymentData){
    paymentDetails = paymentData;
    notifyListeners();
  }

  // Get payment details
  Map<String, dynamic> get paymentData => paymentDetails;

}