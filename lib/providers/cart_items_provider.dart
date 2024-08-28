import 'dart:convert';

import 'package:app_3/data/encrypt_ids.dart';
import 'package:app_3/helper/page_transition_helper.dart';
import 'package:app_3/helper/shared_preference_helper.dart';
import 'package:app_3/model/cart_products_model.dart';
import 'package:app_3/model/products_model.dart';
import 'package:app_3/repository/app_repository.dart';
import 'package:app_3/screens/main_screens/bottom_bar.dart';
import 'package:app_3/screens/sub-screens/cart/checkout_screen.dart';
import 'package:app_3/service/api_service.dart';
import 'package:app_3/widgets/common_widgets.dart/snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider extends ChangeNotifier{
  static final SharedPreferences prefs = SharedPreferencesHelper.getSharedPreferences();
  static final cartRepository = AppRepository(ApiService("https://maduraimarket.in/api"));
  // static final cartRepository = AppRepository(ApiService("http://192.168.1.5/pasumaibhoomi/public/api"));
  int totalProduct = 0;
  int total = 0;
  List<CartProducts> cartItems = [];



  void incrementQuantity({bool? isIncrement, required int index}){
    if (isIncrement ?? false) {
      cartItems[index].quantity++;
      totalProduct++;
      // totalAmount
      total += int.parse(cartItems[index].price); 
    }else{
      cartItems[index].quantity--;
      totalProduct--;
      total -= int.parse(cartItems[index].price);
    }
    notifyListeners();
  }



  void clearCartItems(){
    cartItems.clear();
    total = 0;
    totalProduct = 0;
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
  
      totalProduct = int.parse(decodedResponse['cart_count']);
      total = decodedResponse["cart_total"];
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
      bottomPadding: size.height * 0.8
    );
    if (response.statusCode == 200 && decodedResponse['status'] == 'success') {
     ScaffoldMessenger.of(context).showSnackBar(removedMessage).closed.then((value) async {
       totalProduct--;
       total -= int.parse(cartItems[index].price);
       cartItems.removeAt(index);
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
      bottomPadding: size.height * 0.85
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
          totalProduct++;
          total += product.finalPrice;
          await cartItemsAPI();
          notifyListeners();
      },);
    }else {
      ScaffoldMessenger.of(context).showSnackBar(addCartMessage);
      print('Failed: $decodedResponse');
    }
  }

  // Update Cart for Check out
  Future<void> updateCart(Size size, BuildContext context, List<Map<String, dynamic>> cartProductData) async {
       Map<String, dynamic> updateCartData = {
      'product_data': cartProductData,
      'customer_id': prefs.getString('customerId'),
    };
      final response = await cartRepository.updateCart(updateCartData);
      String decryptedResponse = decryptAES(response.body).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), "");
      final decodedResponse = json.decode(decryptedResponse);
      print('Cart Update Response: $decodedResponse, Status Code: ${response.statusCode}');
      if (response.statusCode == 200 && decodedResponse['status'] == 'success') {
        
        Navigator.push(context, SideTransistionRoute(screen: const CheckoutScreen(fromCart: false,),));  
      }else{
        print("Error: $decodedResponse");
      }
    }


   // Cart Checkout
  Future<void> cartCheckOut(BuildContext context, Size size, Map<String, dynamic> checkoutData) async {
    final response = await cartRepository.cartCheckout(checkoutData);
    String decryptedResponse= decryptAES(response.body).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '');
    final decodedResponse = json.decode(decryptedResponse);
    debugPrint("Cart Placed Response: $decodedResponse, Status code: ${response.statusCode}", wrapWidth: 1064);
     final quickOrderMessage = snackBarMessage(
      context: context, 
      message: decodedResponse['message'], 
      backgroundColor: Theme.of(context).primaryColor, 
      sidePadding: size.width * 0.1, 
      bottomPadding: size.height * 0.75
    );
    if (response.statusCode == 200 && decodedResponse["status"] == "success") {
      clearCartItems();
      ScaffoldMessenger.of(context).showSnackBar(quickOrderMessage).closed.then((value){
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => BottomBar(selectedIndex: 0),),
          (route) => false
        );
      });
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  
}

