import 'dart:convert';

import 'package:app_3/data/encrypt_ids.dart';
import 'package:app_3/helper/shared_preference_helper.dart';
import 'package:app_3/model/products_model.dart';
import 'package:app_3/model/renew_subscription_model.dart';
import 'package:app_3/providers/profile_provider.dart';
import 'package:app_3/repository/app_repository.dart';
import 'package:app_3/service/api_service.dart';
import 'package:app_3/widgets/common_widgets.dart/snackbar_widget.dart';
import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubscriptionProvider extends ChangeNotifier{
  final SharedPreferences prefs = SharedPreferencesHelper.getSharedPreferences();
  final AppRepository subscribeRepository = AppRepository(ApiService("https://maduraimarket.in/api"));
  // final AppRepository subscribeRepository = AppRepository(ApiService("http://192.168.1.5/pasumaibhoomi/public/api"));
  List<Products> subscribeProducts = [];
  List<RenewSubscriptionModel?>? renewSubscriptionResponse;
  List<DateTime?>? renewStartDate;

  // Get all the Subscribe Product in Login Page
  Future<void> getSubscribProducts() async {
     // Call SubScribe Product API
    final response = await subscribeRepository.subscribedProducts();
    String decrptedData = decryptAES(response.body);
    final decodedResponse = json.decode(decrptedData.replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), ''));
    print('Subscribe Product Response: $decodedResponse, Code: ${response.statusCode}');
    if (response.statusCode == 200) {
      final List<dynamic> productJson = decodedResponse['products'];
      List<Products> productsList = productJson.map((json) => Products.fromJson(json)).toList();
      subscribeProducts = productsList;
    } else {
      print('Error: ${response.body}');
    }
    notifyListeners();
  }


  // Re-new Subscription
  Future<void> renewSubscriptionApi(Map<String, dynamic> data, BuildContext context, Size size, int index) async {
    final response = await subscribeRepository.renewsubscription(data);
    String decrptedData = decryptAES(response.body);
    final decodedResponse = json.decode(decrptedData.replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), ''));
    debugPrint('Renew Subscription Response: $decodedResponse, Code: ${response.statusCode}', wrapWidth: 1064);
    if (response.statusCode == 200) {
        renewSubscriptionResponse!.insert(
            index, 
            RenewSubscriptionModel(
            totalQty: decodedResponse["total_qty"].toString(), 
            totalDays: decodedResponse["total_days"].toString(), 
            totalAmount: decodedResponse["total"].toString(), 
            endDate: decodedResponse["end_date"], 
            graceDate: decodedResponse["grace_date"], 
            finalTotal: decodedResponse["final_total"].toString()
          )
        );
        // print('Renew subscription: ${renewSubscriptionResponse!.subscription.amount}');
    } else {
      print('Error: ${response.body}');
    }
    notifyListeners();
  }

  // Pre-order Subscription products
  Future<void> preorderAPi(BuildContext context, Size size) async {
    Map<String, dynamic> preOrderData = {
      "customer_id": prefs.getString("customerId")
    };
    final response = await subscribeRepository.preOrderReceipts(preOrderData);
    String decrptedData = decryptAES(response.body);
    final decodedResponse = json.decode(decrptedData.replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), ''));
    print('Pre order Subscription Response: $decodedResponse, Code: ${response.statusCode}');
     final renewsubscriptionMessage = snackBarMessage(
      context: context, 
      message: decodedResponse['message'], 
      backgroundColor: Theme.of(context).primaryColor, 
      sidePadding: size.width * 0.1, 
      duration: const Duration(seconds: 2),
      bottomPadding: size.height * 0.85
    );
    if (response.statusCode == 200 && decodedResponse["status"] == "success") {
      ScaffoldMessenger.of(context).showSnackBar(renewsubscriptionMessage).closed.then((value) {
          Navigator.pop(context);
          Navigator.pop(context);
      },);
    } else {
      print('Error: ${response.body}');
    }
    notifyListeners();
  }
  
  // Cancel Subscription
  Future<void> cancelSubscription(int id, Size size, BuildContext context,) async {
    Map<String, dynamic> cancelData =  {
      'customer_id': prefs.getString('customerId'),
      'sub_id': id
    };
    final response = await subscribeRepository.cancelSubscription(cancelData);
    String decrptedData = decryptAES(response.body);
    final decodedResponse = json.decode(decrptedData.replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), ''));
    print('Canncel Subscription Response: $decodedResponse, Code: ${response.statusCode}');
     final cancelSubscriptinoMessage = snackBarMessage(
      context: context, 
      message: decodedResponse['message'], 
      backgroundColor: Theme.of(context).primaryColor, 
      sidePadding: size.width * 0.1,
      bottomPadding: size.height * 0.7
    );
    if(response.statusCode == 200 && decodedResponse['status'] == "Success"){
     ScaffoldMessenger.of(context).showSnackBar(cancelSubscriptinoMessage);
    }else{
      print('Success: ${response.body}');
    }
    notifyListeners();
  }
  
  // Resume Subscription
  Future<void> resumeSub(int id, Size size, BuildContext context,) async {
    Map<String, dynamic> resumeData =  {
      'customer_id': prefs.getString('customerId'),
      'subscription_id': id
    };
    final response = await subscribeRepository.resumeSubscription(resumeData);
    String decrptedData = decryptAES(response.body);
    final decodedResponse = json.decode(decrptedData.replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), ''));
    print('Resume Subscription Response: $decodedResponse, Code: ${response.statusCode}');
     final resumeSubscriptinoMessage = snackBarMessage(
      context: context, 
      message: decodedResponse['message'], 
      backgroundColor: Theme.of(context).primaryColor, 
      sidePadding: size.width * 0.1, 
      bottomPadding: size.height * 0.7
    );
    if(response.statusCode == 200 && decodedResponse['status'] == "Success"){
     ScaffoldMessenger.of(context).showSnackBar(resumeSubscriptinoMessage);
     print("Called");
    }else{
      print('Success: ${response.body}');
    }
  }
  
  // Re-Pre-Order Subscription Products in Profile Screen
  Future<void> rePreorder(Map<String, dynamic> data, BuildContext context, Size size) async {
    print("Renew Data: $data");
    final response = await subscribeRepository.confirmReSubscription(data);
    String decrptedData = decryptAES(response.body);
    final decodedResponse = json.decode(decrptedData.replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), ''));
    print('Confirm Re-Subscription Response: $decodedResponse, Code: ${response.statusCode}');
     final renewsubscriptionMessage = snackBarMessage(
      context: context, 
      message: decodedResponse['message'], 
      backgroundColor: Theme.of(context).primaryColor, 
      sidePadding: size.width * 0.1, 
      bottomPadding: size.height * 0.85
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(renewsubscriptionMessage);
    } else {
      print('Error: ${response.body}');
    }
    notifyListeners();
  }

  // Renew Start Date Setter
  void setStartDate(DateTime? date, int index){
    if (date != null) {
      renewStartDate!.insert(index, date);
    }else{
      renewStartDate![index] = null;
      renewSubscriptionResponse![index] = null;
    }
    notifyListeners();
  }

  void generateData(int length){
    renewSubscriptionResponse = List.generate(length, (index) => null,);
    renewStartDate = List.generate(length, (index) => null,);
  }

  // Confirm Cancel Subscription
  Future<void> confirmCancelSubscription(int id, Size size, BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Set your desired border radius
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            // padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            height: 200,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Center(
                        child: AppTextWidget(text: "Cancel Subscription", fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 16,),
                      Center(
                        child: Text(
                           "Do you want to cancel this subscription?",
                           textAlign: TextAlign.center,
                           style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400
                           ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: Consumer<ProfileProvider>(
                    builder: (context, profile, child) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero
                          ),
                          backgroundColor: Colors.transparent.withOpacity(0.0),
                          shadowColor: Colors.transparent.withOpacity(0.0),
                          elevation: 0,
                          overlayColor: Colors.transparent.withOpacity(0.1)
                        ),
                        onPressed: () async{
                          await cancelSubscription(id, size, context).then((value) async{
                            await profile.activeSubscription().then((value) async {
                              await profile.subscriptionHistoryAPI().then((value) {
                                Navigator.pop(context);
                              },);
                            },);
                          },);
                        }, 
                        child: const AppTextWidget(
                          text: "Yes", 
                          fontSize: 14, fontWeight: FontWeight.w400, 
                          fontColor: Colors.red,)
                      );
                    }
                  )
                ),
                
                SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent.withOpacity(0.0),
                      shadowColor: Colors.transparent.withOpacity(0.0),
                      elevation: 0,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero
                      ),
                      overlayColor: Colors.transparent.withOpacity(0.1)
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }, 
                    child: const AppTextWidget(text: "No", fontSize: 14, fontWeight: FontWeight.w400, fontColor: Colors.grey,)
                  ),
                ),
                const SizedBox(height: 10,)
              ],
            ),
          )
        );
      },
    );
  
  }
}