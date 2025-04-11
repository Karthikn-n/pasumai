import 'dart:convert';

import 'package:app_3/data/encrypt_ids.dart';
import 'package:app_3/helper/page_transition_helper.dart';
import 'package:app_3/helper/shared_preference_helper.dart';
import 'package:app_3/model/cart_products_model.dart';
import 'package:app_3/model/products_model.dart';
import 'package:app_3/repository/app_repository.dart';
import 'package:app_3/screens/main_screens/bottom_bar.dart';
import 'package:app_3/screens/sub-screens/checkout/checkout_screen.dart';
import 'package:app_3/service/api_service.dart';
import 'package:app_3/widgets/common_widgets.dart/snackbar_widget.dart';
import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider extends ChangeNotifier{
  static final SharedPreferences prefs = SharedPreferencesHelper.getSharedPreferences();
  static final cartRepository = AppRepository(ApiService("https://maduraimarket.in/api"));
  // static final cartRepository = AppRepository(ApiService("http://192.168.1.5/pasumaibhoomi/public/api"));

  int totalCartProduct = 0;
  int totalCartAmount = 0;
  List<CartProducts> cartItems = [];
  Map<int, int> cartQuantities = {};

  // cart Quantity
  void incrementQuantity({bool? isIncrement, required int productId}){
    if (isIncrement ?? false) {
      cartQuantities[productId] = cartQuantities[productId]! + 1;
      totalCartProduct++;
      // totalAmount
      totalCartAmount += int.parse(cartItems.firstWhere((element) => element.id == productId,).price); 
      print("Quantites: $cartQuantities");
    }else{
      cartQuantities[productId] = cartQuantities[productId]! - 1;
      totalCartProduct--;
      totalCartAmount -= int.parse(cartItems.firstWhere((element) => element.id == productId,).price);
      print("Quantites: $cartQuantities");
    }
    notifyListeners();
  }

   // Create Quantities
  void createCartQuantities() {
    cartQuantities.clear();
    for (var i = 0; i < cartItems.length; i++) {
      cartQuantities[cartItems[i].id] = cartItems[i].quantity;
    }
    print("Cart Quantities: $cartQuantities");
    notifyListeners();
  }
  
  // Clear Cart items
  void clearCartItems(){
    cartItems.clear();
    totalCartAmount = 0;
    totalCartProduct = 0;
    print("Cart Order is remvoed from cart");
    notifyListeners();
  }


  // Call Cart Item APi if there is already present
  Future<void> cartItemsAPI() async {
    
    Map<String, dynamic> userData = {
      "customer_id": prefs.getString('customerId')
    };
    final response = await cartRepository.mycart(userData);
    String decryptedData = decryptAES(response.body).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '');
    final decodedResponse = json.decode(decryptedData);
    print('My Cart Response: $decodedResponse, Status Code: ${response.statusCode}');

    if (response.statusCode == 200) {
      List<dynamic> results = decodedResponse["results"] as List;
      cartItems = results.map((result) => CartProducts.fromJson(result)).toList();
      createCartQuantities();
      totalCartProduct = int.parse(decodedResponse['cart_count'].toString());
      totalCartAmount = int.tryParse(decodedResponse["cart_total"]?.toString() ?? '0') ?? 0;
    } else {
      print('Something went wrong ${response.body}');
    }
  }

  // Remove Cart Item from the List
  Future<void> removeCart(int id, Size size, BuildContext context, int index) async {
    Map<String, dynamic> removeCartData = {
      'product_id': id,
      'customer_id': prefs.getString('customerId')
    };
    final response = await cartRepository.removeCart(removeCartData);
    String decryptedResponse = decryptAES(response.body).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '');
    final decodedResponse = json.decode(decryptedResponse);
    print('Remove Cart Response: $decodedResponse, Status Code: ${response.statusCode}');
    final removedMessage = snackBarMessage(
      context: context, 
      message: 'Removed Successfully',
      backgroundColor: Theme.of(context).primaryColor, 
      sidePadding: size.width * 0.1, 
      bottomPadding: size.height * 0.07
    );
    if (response.statusCode == 200 && decodedResponse['status'] == 'success') {
     ScaffoldMessenger.of(context).showSnackBar(removedMessage).closed.then((value) async {
       totalCartProduct--;
       print("Total AMount: $totalCartAmount");
       totalCartAmount -= int.parse(cartItems.firstWhere((element) => element.id == id,).price);
       cartQuantities.remove(id);
       cartItems.removeWhere((element) => element.id == id,);
        notifyListeners();
     },);
    } else {
      print('Something went wrng : ${response.body}');
    }
  }

  // Add a Product to Cart
  Future<void> addCart(int productId, Size size, BuildContext context, Products product) async {
    Map<String, dynamic> productsData = {
      'product_id': productId,
      'customer_id': prefs.getString('customerId'),
    };
    final response = await cartRepository.addCart(productsData);
    String decryptedData = decryptAES(response.body).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '');
    final decodedResponse = json.decode(decryptedData);
    print('Add Cart Response: $decodedResponse, Status Code: ${response.statusCode}');

    final addCartMessage = snackBarMessage(
      context: context, 
      message: decodedResponse['message'], 
      backgroundColor: Theme.of(context).primaryColor, 
      sidePadding: size.width * 0.1, 
      bottomPadding: size.height * 0.05
    );
    if (response.statusCode ==  200 && decodedResponse['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(addCartMessage).closed.then((value) async {   
          cartItems.add(
            CartProducts(
              id: product.id, 
              name: product.name, 
              price: product.finalPrice.toString(), 
              image: product.image, 
              listPrice: product.price.toString(),
              quantity: 1, 
              total: product.finalPrice.toString()
            )
          );
          cartQuantities[productId] = 1;
          totalCartProduct++;
          totalCartAmount += product.finalPrice;
          print("Total AMount: $totalCartAmount");
          await cartItemsAPI();
          notifyListeners();
      },);
    }else {
      ScaffoldMessenger.of(context).showSnackBar(addCartMessage);
      print('Failed: $decodedResponse');
    }
  }

  // Update Cart for Check out
  Future<void> updateCart(Size size, BuildContext context, List<Map<String, dynamic>> cartProductData, bool isFinal) async {
       Map<String, dynamic> updateCartData = {
      'product_data': cartProductData,
      'customer_id': prefs.getString('customerId'),
    };
      final response = await cartRepository.updateCart(updateCartData);
      String decryptedResponse = decryptAES(response.body).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), "");
      final decodedResponse = json.decode(decryptedResponse);
      print('Cart Update Response: $decodedResponse, Status Code: ${response.statusCode}');
      if (response.statusCode == 200 && decodedResponse['status'] == 'success') {
        isFinal
        ? Navigator.push(context, SideTransistionRoute(screen: const CheckoutScreen(fromCart: false,),))
        : notifyListeners();  
      }else{
        print("Error: $decodedResponse");
      }
      notifyListeners();
    }


   // Cart Checkout
  Future<void> cartCheckOut(BuildContext context, Size size, Map<String, dynamic> checkoutData) async {
    final response = await cartRepository.cartCheckout(checkoutData);
    String decryptedResponse= decryptAES(response.body).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '');
    final decodedResponse = json.decode(decryptedResponse);
    debugPrint("Cart Placed Response: $decodedResponse, Status code: ${response.statusCode}", wrapWidth: 1064);
    //  final quickOrderMessage = snackBarMessage(
    //   context: context, 
    //   message: decodedResponse['message'], 
    //   backgroundColor: Theme.of(context).primaryColor, 
    //   sidePadding: size.width * 0.1, 
    //   bottomPadding: size.height * 0.05
    // );
    if (response.statusCode == 200 && decodedResponse["status"] == "success") {
      clearCartItems();
      confirmOrder(context, size);
       Future.delayed(const Duration(seconds: 2), () {
        Navigator.pop(context);
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const BottomBar(),),
          (route) => false
        );
      },);
      // ScaffoldMessenger.of(context).showSnackBar(quickOrderMessage).closed.then((value){
      // });
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  void confirmDelete({int? id, Size? size, int? index, BuildContext? context}) {
    showDialog(
      context: context!,
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
                        child: AppTextWidget(text: "Remove item", fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 16,),
                      Center(
                        child: Text(
                           "Do you want to remove this item from the cart?",
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
                      backgroundColor: Colors.transparent.withValues(alpha: 0.0),
                      shadowColor: Colors.transparent.withValues(alpha: 0.0),
                      elevation: 0,
                      overlayColor: Colors.transparent.withValues(alpha: 0.1)
                    ),
                    onPressed: () async{
                      await removeCart(id!, size!, context, index!).then((value) => Navigator.pop(context),);
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
                      backgroundColor: Colors.transparent.withValues(alpha: 0.0),
                      shadowColor: Colors.transparent.withValues(alpha: 0.0),
                      elevation: 0,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero
                      ),
                      overlayColor: Colors.transparent.withValues(alpha: 0.1)
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
 
  void confirmOrder(BuildContext context, Size size,){
    showDialog(
      context: context, 
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
          // backgroundColor: Colors.transparent.withValues(alpha: 0.1),
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
                      "assets/icons/happy-face.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                
                AppTextWidget(text: "Order Placed Successfully", fontSize: 18, fontWeight: FontWeight.w600, fontColor: Theme.of(context).primaryColorDark,),
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

