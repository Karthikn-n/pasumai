import 'dart:convert';

import 'package:app_3/data/encrypt_ids.dart';
import 'package:app_3/helper/page_transition_helper.dart';
import 'package:app_3/helper/shared_preference_helper.dart';
import 'package:app_3/model/address_model.dart';
import 'package:app_3/model/region_model.dart';
import 'package:app_3/repository/app_repository.dart';
import 'package:app_3/service/api_service.dart';
import 'package:app_3/widgets/common_widgets.dart/snackbar_widget.dart';
import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:app_3/widgets/sub_screen_widgets/new_address_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressProvider extends ChangeNotifier{

  static final AppRepository _addressRepository = AppRepository(ApiService("https://maduraimarket.in/api"));
  // static final AppRepository _addressRepository = AppRepository(ApiService('http://192.168.1.5/pasumaibhoomi/public/api'));
  static final SharedPreferences _prefs = SharedPreferencesHelper.getSharedPreferences();
  List<AddressModel> addresses = [];
  // List<AddressListmodel> addressesList = [];
  List<RegionModel> regionLocationsList = [];
  AddressModel? currentAddress;
  // AddressModel? currentAddress;
  String mapAddress = "";
  TextEditingController mapAddressController = TextEditingController();


  // Set Current Delivery Address
  void setCurrentAddress({AddressModel? address, int? addressId}) {
    currentAddress = address;
    notifyListeners();
  }

  // Get all the regions and locations
  Future<void> getRegionLocation() async {
    final response = await _addressRepository.regionLocation();
    String decryptedResponse = decryptAES(response.body).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '');
    final decodedResponse = json.decode(decryptedResponse);
    print('Region and Location Response: $decodedResponse');
    if (response.statusCode == 200) {
      regionLocationsList.clear();
      List<dynamic> regions = decodedResponse['results'] as List;
      regionLocationsList = regions.map((region) => RegionModel.fromMap(region),).toList();
      // print(object)
      print('Regions and Location length: ${regionLocationsList.length}');
    } else {
      print('Error: ${response.body}');
    }
    notifyListeners();
  }

  // Get All the Address of the User
  Future<void> getAddressesAPI({bool? newUser}) async {
    Map<String, dynamic> addressData = {
      'customer_id': _prefs.getString('customerId')
    };
    final response = await _addressRepository.getAddresses(addressData);
    String decryptedResponse = decryptAES(response.body).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '');
    final decodedResponse = json.decode(decryptedResponse);
    print('Address List Response: $decodedResponse, Status Code: ${response.statusCode}');
    if (response.statusCode == 200) {
      final List<dynamic> addressJson = decodedResponse['results'];
      addresses.clear();
      addresses = addressJson.map((json) => AddressModel.fromJson(json)).toList();
      currentAddress = addresses.firstWhere((element) => element.defaultAddress == "1",);
      print('Addresss Length: ${addresses.length}');
      
    } else {
      print('Error: ${response.body}');
    }
    notifyListeners();
  }

  // Add new Address for the User
  Future<void> addAddressAPI(BuildContext context, Size size, Map<String, dynamic> addressData) async {
    print('Address Data: $addressData');
    final response = await _addressRepository.addAddress(addressData);
    String decryptedresponse = decryptAES(response.body).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '');
    final decodedResponse = json.decode(decryptedresponse);
    print('Add Address Response: $decodedResponse, Status Code: ${response.statusCode}');

    final responseMessage = snackBarMessage(
      context: context, 
      message: decodedResponse['message'], 
      backgroundColor: Theme.of(context).primaryColor, 
      sidePadding: size.width * 0.1, 
      bottomPadding: size.height * 0.05
    );
    if (response.statusCode == 200 && decodedResponse['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(responseMessage).closed.then((value) async {
        await getAddressesAPI();
      },);
    } else {
      print('Error: ${response.body}');
    }
    notifyListeners();
  }

  // Update Address for the User
  Future<void> updateAddressAPI(BuildContext context, Size size, Map<String, dynamic> updateData) async {
    final response = await _addressRepository.updateAddress(updateData);
    String decryptedresponse = decryptAES(response.body).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '');
    final decodedResponse = json.decode(decryptedresponse);
    print('Update Address Response: $decodedResponse, Status Code: ${response.statusCode}');

    final responseMessage = snackBarMessage(
      context: context, 
      message: decodedResponse['message'], 
      backgroundColor: Theme.of(context).primaryColor, 
      sidePadding: size.width * 0.1, 
      bottomPadding: size.height * 0.05
    );
    if (response.statusCode == 200 && decodedResponse['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(responseMessage).closed.then((value) async {
        await getAddressesAPI();
      },);
    } else {
      print('Error: ${response.body}');
    }
    notifyListeners();
  }

  // Update Address for the User
  Future<void> addressDefault(BuildContext context, Size size, int id) async {
    Map<String, dynamic> defaultData = {
      "address_id": id,
      "customer_id": _prefs.getString("customerId")
    };
    print(defaultData);
    final response = await _addressRepository.defaultAddress(defaultData);
    String decryptedresponse = decryptAES(response.body).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '');
    final decodedResponse = json.decode(decryptedresponse);
    print('Default Address Response: $decodedResponse, Status Code: ${response.statusCode}');

    final responseMessage = snackBarMessage(
      context: context, 
      message: decodedResponse['message'], 
      backgroundColor: Theme.of(context).primaryColor, 
      sidePadding: size.width * 0.1, 
      bottomPadding: size.height * 0.05
    );
    if (response.statusCode == 200 && decodedResponse['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(responseMessage).closed.then((value) async {
        await getAddressesAPI();
      },);
    } else {
      print('Error: ${response.body}');
    }
    notifyListeners();
  }

  // Delete Address From the Entry
  Future<void> deleteAddress(BuildContext context, Size size, int id, int index) async {
   
    Map<String, dynamic> deleteAddressData = {'address_id': id};
    final response = await _addressRepository.deleteAddress(deleteAddressData);
    String decryptedResponse = decryptAES(response.body).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '');
    final decodedResponse = json.decode(decryptedResponse);
    debugPrint('Delete Address Response: $decodedResponse, Status Code: ${response.statusCode}');
    final deleteAddressMessage = snackBarMessage(
      context: context, 
      // duration: const Duration(seconds: 2),
      message: decodedResponse["message"], 
      backgroundColor: Theme.of(context).primaryColor, 
      sidePadding: size.width * 0.1, 
      bottomPadding: size.height * 0.05
    );
    if (response.statusCode == 200 && decodedResponse["status"] == "success") {
      ScaffoldMessenger.of(context).showSnackBar(deleteAddressMessage).closed.then((value) async {
        if (addresses.length == 1) {
          addresses.clear();
          notifyListeners();
        }else{
          addresses.removeAt(index);
          await getAddressesAPI();
        }
      },);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(deleteAddressMessage);
      print('Something went wrng : ${response.body}');
    }
    notifyListeners();
  }

  void setAddressFromMap(String addrees){
    mapAddressController.text = addrees;
    notifyListeners();
  }

  void clearMapAddress(){
    mapAddressController.clear();
    mapAddressController.text = "";
    print("Map address: ${mapAddressController.text}");
    notifyListeners();
  }

  // Notify to user to add address if they have no address on checkout or subscribe
  void addnewAddress(BuildContext context, Size size){
    final addAddress = snackBarMessage(
      context: context, 
      message: "Add address to proceed", 
      backgroundColor: Theme.of(context).primaryColor, 
      sidePadding: 12, 
      showCloseIcon: false,
      duration: const Duration(seconds: 40),
      bottomPadding: size.height * 0.07,
      snackBarAction: SnackBarAction(
        label: "Add", 
        textColor: Colors.white,
        onPressed: () => Navigator.push(context, downToTop(screen: const NewAddressFormWidget())) ,
      )
    );
    ScaffoldMessenger.of(context).showSnackBar(addAddress);
    notifyListeners();
  }

  // Get confirm message for Deleting address
  void confirmDelete(BuildContext context, Size size, int id, int index){
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
                        child: AppTextWidget(text: "Delete address", fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 16,),
                      Center(
                        child: Text(
                           "Do you want to remove this address from the list?",
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
                      await deleteAddress(context, size, id, index).then((value) => Navigator.pop(context),);
                    }, 
                    child: const AppTextWidget(
                      text: "Confirm", 
                      fontSize: 14, fontWeight: FontWeight.w400, 
                      fontColor: Colors.red,)
                  ),
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

  // Set As Default Message
  void setAddressDefault(BuildContext context, Size size, int id,){
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
                        child: AppTextWidget(text: "Default address", fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 16,),
                      Center(
                        child: Text(
                           "Do you want set this address default?",
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
                      await addressDefault(context, size, id,).then((value) => Navigator.pop(context),);
                    }, 
                    child: const AppTextWidget(
                      text: "Yes", 
                      fontSize: 14, fontWeight: FontWeight.w400, 
                      fontColor: Colors.red,)
                  ),
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

  // Add Address Message
  void addAddressToSubcribe(BuildContext context, Size size){
    ScaffoldMessenger.of(context).showSnackBar(
      snackBarMessage(
        context: context,
        duration: const Duration(seconds: 5),
        message: "Add address to Subscribe Product",
        showCloseIcon: false,
        snackBarAction: SnackBarAction(
          label: "Add",
          onPressed: () {
           try {
              Navigator.push(context, downToTop(screen: const NewAddressFormWidget()));
           } catch (e) {
             print("error $e");
           }
          },
          textColor: Colors.white,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        sidePadding: size.width * 0.05,
        bottomPadding: size.height * 0.05,
      ),
    );
  
  }
}