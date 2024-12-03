import 'dart:convert';

import 'package:app_3/data/encrypt_ids.dart';
import 'package:app_3/helper/shared_preference_helper.dart';
import 'package:app_3/model/cart_products_model.dart';
import 'package:app_3/repository/app_repository.dart';
import 'package:app_3/service/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartRepository {
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
  }

   // Create Quantities
  void createCartQuantities() {
    cartQuantities.clear();
    for (var i = 0; i < cartItems.length; i++) {
      cartQuantities[cartItems[i].id] = cartItems[i].quantity;
    }
    print("Cart Quantities: $cartQuantities");
  }
  
  // Clear Cart items
  void clearCartItems(){
    cartItems.clear();
    totalCartAmount = 0;
    totalCartProduct = 0;
    print("Cart Order is remvoed from cart");
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
      totalCartAmount = decodedResponse["cart_total"];
    } else {
      print('Something went wrong ${response.body}');
    }
  }

}