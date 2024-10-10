import 'dart:convert';
import 'dart:io';

import 'package:app_3/data/encrypt_ids.dart';
import 'package:app_3/helper/page_transition_helper.dart';
import 'package:app_3/helper/shared_preference_helper.dart';
import 'package:app_3/model/invoice_model.dart';
import 'package:app_3/model/ordered_product_model.dart';
import 'package:app_3/model/orders_model.dart';
import 'package:app_3/model/vacation_model.dart';
import 'package:app_3/providers/address_provider.dart';
import 'package:app_3/providers/api_provider.dart';
import 'package:app_3/providers/cart_items_provider.dart';
import 'package:app_3/providers/subscription_provider.dart';
import 'package:app_3/repository/app_repository.dart';
import 'package:app_3/screens/on_boarding/otp_page.dart';
import 'package:app_3/screens/on_boarding/signin_page.dart';
import 'package:app_3/service/api_service.dart';
import 'package:app_3/widgets/common_widgets.dart/snackbar_widget.dart';
import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfileProvider extends ChangeNotifier{
  AppRepository profileRepository = AppRepository(ApiService("https://maduraimarket.in/api"));
  // AppRepository profileRepository = AppRepository(ApiService("http://192.168.1.5/pasumaibhoomi/public/api"));
  SharedPreferences prefs = SharedPreferencesHelper.getSharedPreferences();

  // Order Section Data
  bool reordered = false;
  List<OrderInfo> orderInfoData = [];
  double discountAmount = 0;
  String orderTotal = "";
  List<ProductOrdered> orderedProducts = [];
  String selectedFilter = "";
  List<String> filterOption = ['3 months', '6 months', '9 months', ];

  

  // invoice Data
  List<InvoiceModel> invoices = [];
  
  // Vacation Data
  List<VacationsModel> vacations = [];


  void setFilter({bool? isCleared, required String filter}){
    if (isCleared ?? false) {
      selectedFilter = "";
    }else{
      selectedFilter = filter;
    }
    notifyListeners();
  }

  // Query options
  String? selectedQuery;
  List<String> queryOptions = [
    "Payment issue",
    "Refund",
    "Wrong product delivered",
    "Late delivery",
    "Wrong Subscription product",
    "Other"
  ];

  // Set selected Query
  void selectQuery(int? index){
    if (index != null) {
      selectedQuery = queryOptions[index];
    }else{
      selectedQuery = null;
    }
    notifyListeners();
  } 

  // Update Profile
  Future<void> updateProfile(Map<String, dynamic> profileData, Size size, BuildContext context, bool isMobileEdited) async {
    final response = await profileRepository.updateProfile(profileData);
    String decryptedResponse = decryptAES(response.body).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '');
    final decodedResponse = json.decode(decryptedResponse);
    debugPrint('Update Profile Response: $decodedResponse, Status Code: ${response.statusCode}', wrapWidth: 1064);
     final updateProfileMessage = snackBarMessage(
      context: context, 
      message: decodedResponse['message'], 
      backgroundColor: Theme.of(context).primaryColor, 
      sidePadding: size.width * 0.1, 
      bottomPadding: size.height * 0.05
    );
    if (response.statusCode == 200) {
      await prefs.setString('firstname', profileData["first_name"]);
      await prefs.setString("lastname", profileData["last_name"]);
      await prefs.setString("mail", profileData["email"]);
      await prefs.setString("mobile", profileData["mobile_no"]);
      if (isMobileEdited) {
        Navigator.pop(context);
        try {
          print("Mobile Edited: $isMobileEdited");
          ScaffoldMessenger.of(context).showSnackBar(updateProfileMessage);
          Navigator.pushReplacement(context, SideTransistionRoute(screen: const OtpPage(fromRegister: false,),),);
        } catch (e) {
          print("Something erong $e");
        }
      }else{
        ScaffoldMessenger.of(context).showSnackBar(updateProfileMessage).closed.then((value) {
          Navigator.pop(context);
          Navigator.pop(context);
        },);
      }
    } else {
      print('Error: ${response.body}');
    }
    notifyListeners();
  }


  // User ordered List
  Future<void> orderList({String? filter}) async {
    Map<String, dynamic> orderListData = {
      'customer_id': prefs.getString('customerId'),
      'sort_by': filter ?? '1y'
    };
    print(orderListData);
    final response = await profileRepository.orderList(orderListData);
    String decryptedResponse = decryptAES(response.body).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '');
    final decodedResponse = json.decode(decryptedResponse);
    debugPrint('Response Order list: $decodedResponse, Status Code: ${response.statusCode}', wrapWidth: 1064);
    
    if (response.statusCode == 200) {
      List<dynamic> results = decodedResponse['results'] as List;
      print('Orders List length before parsing: ${results.length}');
      orderInfoData.clear();
      selectedFilter = filter != null 
        ? filter == "1y" 
          ? "" : filter == "3m" ? "3 months" : filter == "6m" ? "6 months" : filter == "9m"
          ? "9 months" : "" : ""; 
      orderInfoData = results.map((order) => OrderInfo.fromMap(order)).toList();
      print('Orders List length after parsing: ${orderInfoData.length}');
    } else {
      print('Failed to fetch data: $decodedResponse');
      throw "${decodedResponse["message"]} && Something went wrong ${response.statusCode}";
    }
    notifyListeners();
  }


  // Order Detail
  Future<void> orderDetail(int orderId) async {
    Map<String, dynamic> orderData = {
      'order_id': orderId, 
      'customer_id': prefs.getString("customerId")
    };
    print("Order Data : $orderData");
    final response = await profileRepository.orderDetail(orderData);
    String decryptedResponse = decryptAES(response.body).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '');
    final decodedResponse = json.decode(decryptedResponse);
    print('Order Detail Response: $decodedResponse, Status Code: ${response.statusCode}');

    if (response.statusCode == 200) {
      discountAmount = double.parse(decodedResponse["results"]["discount_amount"].toString());
     
      List<dynamic> orderedProductsList = decodedResponse["results"]["product_data"] as List;
      orderedProducts.clear();
      orderedProducts = orderedProductsList.map((product) => ProductOrdered.fromJson(product),).toList();
    } else {
      print('Failed to fetch data: ${response.statusCode}');
    }
  }

  void clearCouponAmount(){
    discountAmount = 0;
    notifyListeners();
  }

  // Re-order Product
  Future<void> reOrder(int orderId, BuildContext context, Size size) async {
    Map<String, dynamic> reorderData = {'customer_id': prefs.getString("customerId"), 'order_id': orderId};
    final response = await profileRepository.reOrder(reorderData);
    String decryptedResponse = decryptAES(response.body).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '');
    final decodedResponse = json.decode(decryptedResponse);
    print('Re-order Detail Response: $decodedResponse, Status Code: ${response.statusCode}');
    // final reOrderedMessage = snackBarMessage(
    //   context: context, 
    //   message: decodedResponse['message'], 
    //   backgroundColor: Theme.of(context).primaryColor, 
    //   sidePadding: size.width * 0.1, 
    //   bottomPadding: size.height * 0.05
    // );
    if (response.statusCode == 200) {
      
      messagePopUp(context, size, decodedResponse["message"], "assets/icons/happy-face.png");
      // ScaffoldMessenger.of(context).showSnackBar(reOrderedMessage).closed.then((event) async {
      Future.delayed(const Duration(seconds: 2), () async {
        await orderList().then((value) {
          Navigator.pop(context);
        },);
      },);
      // });
      
    } else {
      print('Error: ${response.body}');
    }
    notifyListeners();
  }

  // Re-order Product
  Future<void> cancelOrder(int orderId, BuildContext context, Size size) async {
    Map<String, dynamic> reorderData = {'customer_id': prefs.getString("customerId"), 'order_id': orderId};
    final response = await profileRepository.cancelOrder(reorderData);
    String decryptedResponse = decryptAES(response.body).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '');
    final decodedResponse = json.decode(decryptedResponse);
    print('Cancel Order Response: $decodedResponse, Status Code: ${response.statusCode}');
    // final cancelOrderedMessage = snackBarMessage(
    //   context: context, 
    //   message: decodedResponse['message'], 
    //   backgroundColor: Theme.of(context).primaryColor, 
    //   sidePadding: size.width * 0.1, 
    //   bottomPadding: size.height * 0.05
    // );
    if (response.statusCode == 200) {
      // ScaffoldMessenger.of(context).showSnackBar(cancelOrderedMessage);
      messagePopUp(context, size, decodedResponse["message"], "assets/icons/sad-face.png");
      // orderInfoData.removeWhere((element) => element.orderId == orderId,);,
      Future.delayed(const Duration(seconds: 2), () async {
        await orderList().then((value) {
          Navigator.pop(context);
          Navigator.pop(context);
        },);
      },);
    } else {
      print('Error: ${response.body}');
    }
    notifyListeners();
  }


 
  // Invoices API
  Future<String?> getInvoice() async {
    Map<String, dynamic> invoiceData = {
      'customer_id': prefs.getString('customerId')
    };
    final response = await profileRepository.invoices(invoiceData);
    String decryptedResponse = decryptAES(response.body).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '');
    final decodedResponse = json.decode(decryptedResponse);
    print('Invoice List Response: $decodedResponse, Status Code: ${response.statusCode}');
    if (response.statusCode == 200) {
      if (decodedResponse["status"] == "not_found") {
        invoices = [];
        notifyListeners();
        return null;
      }else{
        List<dynamic> invoiceList = decodedResponse['results'] as List;
        invoices = invoiceList.map((invoice) => InvoiceModel.fromJson(invoice) ,).toList();
        notifyListeners();
        return "success";
      }
    } else {
      print('Failed to fetch data: ${response.statusCode}');
    }
    notifyListeners();
    return null;
  }

  Future<void> downloadInvoice(String fileName, BuildContext context, Size size) async {
    final storagePermission = await Permission.manageExternalStorage.request();
    if (storagePermission.isGranted) {
      try {
        final downloadDirectory = Directory("/storage/emulated/0/Download");
        if (!await downloadDirectory.exists()) {
          await downloadDirectory.create();
        }
        
        final response = await http.get(Uri.parse("https://maduraimarket.in/public/pdf/$fileName"));
        if (response.statusCode == 200) {
          // Define the file path
          final filePath = '${downloadDirectory.path}/$fileName';
          File file = File(filePath);

          if (file.existsSync()) {
            ScaffoldMessenger.of(context).showSnackBar(snackBarMessage(
              context: context,
              message: "File Already exists",
              showCloseIcon: false,
              duration: const Duration(seconds: 20),
              snackBarAction: SnackBarAction(
                label: "Open",
                textColor: Colors.white,
                onPressed: () async {
                  if (file.existsSync()) {
                    OpenFile.open(file.path);
                  }
                },
              ),
              backgroundColor: Theme.of(context).primaryColor,
              sidePadding: size.width * 0.1,
              bottomPadding: size.height * 0.05,
            ));
          } else {
            if (response.contentLength != null && response.contentLength! > 0) {
              // Write the response body bytes to the file
              await file.writeAsBytes(response.bodyBytes);
              ScaffoldMessenger.of(context).showSnackBar(
                snackBarMessage(
                  context: context,
                  duration: const Duration(seconds: 20),
                  message: "File Downloaded",
                  snackBarAction: SnackBarAction(
                    label: "Open",
                    onPressed: () async {
                      OpenFile.open(file.path);
                    },
                    textColor: Colors.white,
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                  sidePadding: size.width * 0.1,
                  bottomPadding: size.height * 0.05,
                ),
              );
            }
          }
        }
      } catch (e) {
        print("Error: $e");
      }
    } else if (storagePermission.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        snackBarMessage(
          context: context,
          duration: const Duration(seconds: 20),
          message: "Storage permission is required",
          snackBarAction: SnackBarAction(
            label: "Access",
            onPressed: () async {
              await openAppSettings();
            },
            textColor: Colors.white,
          ),
          backgroundColor: Theme.of(context).primaryColor,
          sidePadding: size.width * 0.1,
          bottomPadding: size.height * 0.05,
        ),
      );
    } else if (storagePermission.isPermanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        snackBarMessage(
          context: context,
          duration: const Duration(seconds: 20),
          message: "Storage permission is required",
          snackBarAction: SnackBarAction(
            label: "Access",
            onPressed: () async {
              await openAppSettings();
            },
            textColor: Colors.white,
          ),
          backgroundColor: Theme.of(context).primaryColor,
          sidePadding: size.width * 0.1,
          bottomPadding: size.height * 0.05,
        ),
      );
    } else {
      print("Permission is denied");
    }
  }
 

  // Vacation List
  Future<void> vacationList() async {
    Map<String, dynamic> vacationData = {
      "customer_id": prefs.getString('customerId')
    };
    final response = await profileRepository.vacationList(vacationData);
    String decryptedData = decryptAES(response.body).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '');
    final decodedResponse = json.decode(decryptedData);
    debugPrint('Response: $decodedResponse, Status Code: ${response.statusCode}', wrapWidth: 1064);
    if (response.statusCode == 200) {
      final results = decodedResponse["results"];
      vacations.clear();
      if (decodedResponse["message"] == "No Vacation") {
        throw Exception(decodedResponse["message"]);
        // notifyListeners();
      }
      vacations = results.map<VacationsModel>((result) => VacationsModel.fromJson(result)).toList();
      print('Vacatioons length: ${vacations.length}');
      notifyListeners();
    } else {
      print('Something went wrong ${response.body}');
      // throw "${decodedResponse["message"]} && Something went wrong ${response.statusCode}";
    }
    
  }

  // Add Vacation
  Future<void> addVacation(Map<String, dynamic> addData, Size size, BuildContext context) async {
    addData["customer_id"] = prefs.getString('customerId');
    print(addData);
    final response = await profileRepository.addVacation(addData);
    String decryptedData = decryptAES(response.body).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '');
    final decodedResponse = json.decode(decryptedData);
    debugPrint('Add Vacation Response: $decodedResponse, Status Code: ${response.statusCode}', wrapWidth: 1064);
    final addVacationMessage = snackBarMessage(
      context: context, 
      message: decodedResponse['message'], 
      backgroundColor: Theme.of(context).primaryColor, 
      sidePadding: size.width * 0.1, 
      bottomPadding: size.height * 0.05
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(addVacationMessage).closed.then((value) async {
        await vacationList();
      },);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(addVacationMessage);
      print('Failed: ${response.body}');
    }
    notifyListeners();
                                
  }

  // Destroy Vacation
  Future<void> deleteVacation(int id, BuildContext context, Size size) async {
    Map<String, dynamic> deleteData = {
      "vacation_id": id,
    };
    final response = await profileRepository.destroyVacation(deleteData);
    String decryptedData = decryptAES(response.body).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '');
    final decodedResponse = json.decode(decryptedData);
    debugPrint('Response: $decodedResponse, Status Code: ${response.statusCode}', wrapWidth: 1064);
    final deleteVacationMessage = snackBarMessage(
      context: context, 
      message: decodedResponse['message'], 
      backgroundColor: Theme.of(context).primaryColor, 
      sidePadding: size.width * 0.1, 
      bottomPadding: size.height * 0.05
    );
    if (response.statusCode == 200) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(deleteVacationMessage).closed.then((value) async {
        if (vacations.isEmpty) {
          notifyListeners();
        }
        await vacationList();
      },);
      notifyListeners();
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(deleteVacationMessage);
      print('Failed: ${response.body}');
    }
    notifyListeners();
  }

  // Update vacation
  Future<void> updateVacation(Map<String, dynamic> updateData, Size size, BuildContext context) async {
    updateData["customer_id"] = prefs.getString('customerId');
    print(updateData);
    final response = await profileRepository.updateVacation(updateData);
    String decryptedData = decryptAES(response.body).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '');
    final decodedResponse = json.decode(decryptedData);
    debugPrint('Response: $decodedResponse, Status Code: ${response.statusCode}', wrapWidth: 1064);
    final updateVacationMessage = snackBarMessage(
      context: context, 
      message: decodedResponse['message'], 
      backgroundColor: Theme.of(context).primaryColor, 
      sidePadding: size.width * 0.1, 
      bottomPadding: size.height * 0.05
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(updateVacationMessage).closed.then((value) async {
        await vacationList();
      },);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(updateVacationMessage);
      print('Failed: ${response.body}');
    }
    notifyListeners();
  }

  // Raise a Query API
  Future<void> raiseAQueryAPI(String comment, Size size, BuildContext context) async {
    Map<String, dynamic> queryData = {
      "customer_id": prefs.getString("customerId"),
      "queries": selectedQuery ?? "",
      "comments": comment
    };
    print("query Data: $queryData");
    selectQuery(null);
    final response = await profileRepository.raiseAQuery(queryData);
    String decryptedData = decryptAES(response.body).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '');
    final decodedResponse = json.decode(decryptedData);
    debugPrint('Query Response: $decodedResponse, Status Code: ${response.statusCode}', wrapWidth: 1064);
    final queryRaisedMessage = snackBarMessage(
      context: context, 
      message: decodedResponse['message'], 
      backgroundColor: Theme.of(context).primaryColor, 
      sidePadding: size.width * 0.1, 
      bottomPadding: size.height * 0.05
    );
    if (response.statusCode == 200 && decodedResponse["status"] == "success") {
      ScaffoldMessenger.of(context).showSnackBar(queryRaisedMessage).closed.then((value) async {
        selectQuery(null);
        Navigator.pop(context);
      },);
    }else{
       ScaffoldMessenger.of(context).showSnackBar(queryRaisedMessage);
      print("Error in raise Query: $decodedResponse");
    }
    notifyListeners();
  }

  // Confirm Cancel Order
  Future<void> confirmCancelOrder(int orderId, BuildContext context, Size size) async {
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
            height: 180,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Center(
                        child: AppTextWidget(text: "Cancel order", fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 16,),
                      Center(
                        child: Text(
                           "Do you want to cancel this order?",
                           textAlign: TextAlign.center,
                           style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w400
                           ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: ElevatedButton(
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
                      await cancelOrder(orderId, context, size);
                    }, 
                    child: const AppTextWidget(
                      text: "Yes", 
                      fontSize: 14, fontWeight: FontWeight.w400, 
                      fontColor: Colors.red,)
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

  // Confirm delete vacation
  void confirmDeleteVacation(int id, BuildContext context, Size size){
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
            height: 180,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Center(
                        child: AppTextWidget(text: "Delete vacation", fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 16,),
                      Center(
                        child: Text(
                           "Do you want to delete this vacation?",
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
                  child: ElevatedButton(
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
                      await deleteVacation(id, context, size);
                    }, 
                    child: const AppTextWidget(
                      text: "Confirm", 
                      fontSize: 14, fontWeight: FontWeight.w400, 
                      fontColor: Colors.red,)
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
                    child: const AppTextWidget(text: "Cancel", fontSize: 14, fontWeight: FontWeight.w400, fontColor: Colors.grey,)
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

  // Confirm Edit profile Message
  void confirmEditProfile(Map<String, dynamic> profileData, Size size, BuildContext context, bool isMobileEdited){
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
            height: isMobileEdited ? 200 : 180,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      const Center(
                        child: AppTextWidget(
                          text: "Update profile", 
                          fontSize: 20, 
                          fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 16,),
                      !isMobileEdited
                      ? const Center(
                          child: Text(
                            "Are you sure to update profile?",
                            style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w400
                            ),
                          ),
                        )
                      : Center(
                          child: Column(
                            children: [
                             const Text(
                              "OTP sent to your new mobile number",
                              style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w400
                              ),
                            ),
                            Text(
                              profileData["mobile_no"],
                              style:  TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500,
                                color: Theme.of(context).primaryColor
                              ),
                            )
                            ],
                          ),
                        )
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: ElevatedButton(
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
                      await updateProfile(profileData, size, context, isMobileEdited);
                    }, 
                    child: const AppTextWidget(
                      text: "Confirm", 
                      fontSize: 14, fontWeight: FontWeight.w400, 
                      fontColor: Colors.red,)
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
                    child: const AppTextWidget(text: "Cancel", fontSize: 14, fontWeight: FontWeight.w400, fontColor: Colors.grey,)
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

  // confirm logout
  void confirmLogout(BuildContext context, Size size){
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
            height: 180,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Center(
                        child: AppTextWidget(text: "Logout", fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 16,),
                      Center(
                        child: Text(
                           "Do you want logout?",
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
                  child: Consumer4<ApiProvider,  AddressProvider, SubscriptionProvider, CartProvider>(
                    builder: (context, apiProvider,  addressProvider, subscription, cartProvider, child) {
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
                          Navigator.pop(context);
                          // Clear User identity
                          await prefs.clear();
                          print("${prefs.getString("customerId")}");
                          // Clear Orders and Subscription of current user
                          orderInfoData.clear();
                          orderedProducts.clear();
                          subscription.activeSubscriptions.clear();
                          subscription.historyProducts.clear();
                          invoices.clear();
                          vacations.clear();
                          // Go to Home after logout and re login
                          apiProvider.setIndex(0);
                          apiProvider.setQuick(false);
                          // Remove Wishlist Products
                          apiProvider.clearCoupon();
                          apiProvider.clearQuickOrder();
                          // Remove Cart Items
                          cartProvider.clearCartItems();
                          // Remove Addresses
                          addressProvider.addresses.clear();
                          Navigator.pushAndRemoveUntil(context, downToTop(screen: const LoginPage()), (route) => false,);
                        }, 
                        child: const AppTextWidget(
                          text: "Confirm", 
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
                    child: const AppTextWidget(text: "Cancel", fontSize: 14, fontWeight: FontWeight.w400, fontColor: Colors.grey,)
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

  void messagePopUp(BuildContext context, Size size, String message, String image){
    showDialog(
      context: context, 
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
          // backgroundColor: Colors.transparent.withOpacity(0.1),
          child: SizedBox(
            height: size.height * 0.3,
            // width: size.width * 0.,
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const SizedBox(height: 30,),
                Center(
                  child: SizedBox(
                    height: size.height * 0.1,
                    width:  size.width * 0.2,
                    child: Image.asset(
                      image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                
                Center(child: AppTextWidget(
                  text: message, 
                  textAlign: TextAlign.center,
                  fontSize: 18, fontWeight: FontWeight.w500, fontColor: Theme.of(context).primaryColorDark,)),
                // const SizedBox(height: 10,),
                AppTextWidget(text: "Thank you!", fontSize: 16, fontWeight: FontWeight.w400, fontColor: Theme.of(context).primaryColorDark,),
                const SizedBox(height: 30,),
              ],
            ),
          ),
        );
      },
    );
  }

  
}