import 'dart:convert';

import 'package:app_3/data/encrypt_ids.dart';
import 'package:app_3/data/profile_data.dart';
import 'package:app_3/helper/page_transition_helper.dart';
import 'package:app_3/helper/shared_preference_helper.dart';
import 'package:app_3/model/category_model.dart';
import 'package:app_3/model/products_model.dart';
import 'package:app_3/model/selected_product_model.dart';
import 'package:app_3/model/wishlist_products_model.dart';
import 'package:app_3/repository/app_repository.dart';
import 'package:app_3/screens/main_screens/bottom_bar.dart';
import 'package:app_3/screens/on_boarding/otp_page.dart';
import 'package:app_3/screens/sub-screens/cart/checkout_screen.dart';
import 'package:app_3/service/api_service.dart';
import 'package:app_3/widgets/common_widgets.dart/snackbar_widget.dart';
import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;

class ApiProvider extends ChangeNotifier{

  AppRepository apiRepository = AppRepository(ApiService("https://maduraimarket.in/api"));
  // AppRepository apiRepository = AppRepository(ApiService("http://192.168.1.5/pasumaibhoomi/public/api"));
  SharedPreferences prefs = SharedPreferencesHelper.getSharedPreferences();

  bool isQuick = false;

  // Data For Home screen
  List<String> banners = [];
  List<Products> featuredproductData = [];
  List<Products> bestSellerProducts = [];
  List<CategoryModel> categories = [];
  // Data for wishlist 
  List<WishlistProductsModel> wishlistProducts = [];
  String? message;
  String? removedMessage;
  // Category list
  List<Products> categoryProducts = [];
  List<Products> filteredProducts = [];
  List<Attributes> attributesList = [
    Attributes(
      id: 1, 
      name: "Quantity", 
      optionData: [
        OptionData(id: 1, name: "500ml"),
        OptionData(id: 1, name: "1L"),
        OptionData(id: 1, name: "2L"),
      ]
    ),
    Attributes(
      id: 2, 
      name: "Size", 
      optionData: [
        OptionData(id: 1, name: "s"),
        OptionData(id: 1, name: "m"),
        OptionData(id: 1, name: "l"),
      ]
    ),
  ]; 
  bool clearFilter = false;
  String? selectedAttribute;
  String? selectedOption;

  // Quick Order data
  List<SelectedProductModel> selectedProducts = [];
  List<int> quantities = []; 
  int totalAmount = 0;
  int totalProduct = 0;

  // Coupon Data
  bool isCouponApplied = false;
  String discountAmount = "";
  String newTotal = "";


  // Provider for quick order back
  void setQuick(bool quick){
    isQuick = quick;
    notifyListeners();
  }
  // User Register API
  Future<void> registerUser(Map<String, dynamic> registerData, BuildContext context, Size size) async {
    try{
    final response = await apiRepository.registration(registerData);
    String decryptedResponse =  decryptAES(response.body).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '');
    final decodedResponse = json.decode(decryptedResponse);
    print('Registration Response: $decodedResponse, Status Code: ${response.statusCode}');
    final registrationMessage = snackBarMessage(
      context: context, 
      message: decodedResponse['message'], 
      backgroundColor: Theme.of(context).primaryColor, 
      sidePadding: size.width * 0.1, 
      bottomPadding: size.height * 0.85
    );
    if (response.statusCode == 200 && decodedResponse['message'] == "Registered successfully")  {
      prefs.setString('customerId', decodedResponse["customer_id"].toString());
      try {
        ScaffoldMessenger.of(context).showSnackBar(registrationMessage).closed.then((value){
          prefs.setBool("registered", true);
          prefs.setString("mobile", registerData["mobile_no"]);
          Navigator.push(context, SideTransistionRoute(screen: const OtpPage(),));
        });
      } catch (e) {
        print('Error decoding JSON: $e');
      }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(registrationMessage);
      print('Error: ${response.body}');
    }
    } catch(e){
      print('Something wrong: $e');
    }
    notifyListeners();
  }

  // Login API
  Future<void> userLogin(String mobileNo, Size size, BuildContext context) async {
    Map<String, dynamic> userData = {
      "mobile_no": mobileNo
    };
    // Call Login API
    final response = await apiRepository.signin(userData);
    // Decrypt the Data 
    String decryptedData = decryptAES(response.body).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '');
    final decodedResponse = json.decode(decryptedData);
    SnackBar loginMessage = snackBarMessage(
      context: context, 
      message: decodedResponse['message'], 
      backgroundColor: const Color(0xFF60B47B), 
      sidePadding: size.width * 0.1, 
      bottomPadding: size.height * 0.85
    );
    debugPrint('Login Response: $decodedResponse, Status Code: ${response.statusCode}', wrapWidth: 1064);
    if (response.statusCode == 200 && decodedResponse['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(loginMessage).closed.then(
        (value) async {
          // Save User id In Cache
          prefs.setString('customerId', decodedResponse["customer_id"].toString());
          print("Customer ID: ${prefs.getString("customerId")}");
          prefs.setString("mobile", mobileNo);
          Navigator.push(context, SideTransistionRoute(
            screen: const OtpPage(), 
          ));
        },
      );
      
    }else{
        ScaffoldMessenger.of(context).showSnackBar(loginMessage);
    }
    notifyListeners();
  }

  
  // Resend OTP api
  Future<void> resendOTP(BuildContext context, Size size, String mobileNo) async {
    Map<String, dynamic> resendOtpData = {
      'mobile_no': mobileNo,
    };
   
    final response = await apiRepository.resendOtp(resendOtpData);
    String decryptedData = decryptAES(response.body).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '');
    final decodedResponse = json.decode(decryptedData);
    print('Resend OTP Response: $decodedResponse, Status Code: ${response.statusCode}');
      SnackBar resendOtpMessage = snackBarMessage(
      context: context, 
      message: decodedResponse['message'], 
      backgroundColor: const Color(0xFF60B47B), 
      sidePadding: size.width * 0.1, 
      bottomPadding: size.height * 0.85
    );
    if (response.statusCode == 200) {
     ScaffoldMessenger.of(context).showSnackBar(resendOtpMessage);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(resendOtpMessage);
      print('Error: ${response.body}');
    }
  }

  // All Products List API
  Future<void> allProducts(int catId) async {
    Map<String, dynamic> productData = {'cat_id': catId};
    final response = await apiRepository.allProducts(productData);
    String decrptedResponse = decryptAES(response.body).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '');
    final decodedResponse = json.decode(decrptedResponse);
    debugPrint('All Products Response: $decodedResponse, Status Code: ${response.statusCode}');
    if (response.statusCode == 200) {
      final List<dynamic> productJson = decodedResponse['products'];
      List<Products> productsList = productJson.map((json) => Products.fromJson(json)).toList();
      categoryProducts.clear();
      categoryProducts = productsList;
      if (catId == 1) {
        createQuantities();
      }
      attributesList = decodedResponse['attributes'].map<Attributes>((attr) => Attributes.fromJson(attr)).toList();
    } else {
      print('Error: ${response.body}');
    }
  }

  // Create A inital quantites for the quick order
  void createQuantities(){
    if (quantities.isEmpty) {
      quantities = List.generate(categoryProducts.length, (index) => 0,);
    }
    print("Quantities: $quantities");
    notifyListeners();
  }

  // Increment and decrement in quick order
  void incrementQuickOrderQuantity({bool? isIncreament, required int productPrice, required int index}){
    if (isIncreament ?? false) {
     quantities[index]++;
     
     totalProduct++;
     totalAmount +=  productPrice;
      print("Quantities: $quantities, Total: $totalAmount, Product: $totalProduct");
    }else{
      if (quantities[index] > 0) {
        quantities[index]--;
        totalAmount -= productPrice; 
      }
      totalProduct--;
      print("Quantities: $quantities, Total: $totalAmount, Product: $totalProduct");
    }
    notifyListeners();
  }
  
  
  // Store selected quick order 
  void addSelectedProducts(SelectedProductModel product){
    // selectedProducts.clear();
    selectedProducts.removeWhere((element) => element.id == product.id,);
    selectedProducts.add(product);
    selectedProducts.removeWhere((element) => element.quantity < 1,);
    print("Selected Products : ${selectedProducts.length}");
    notifyListeners();
  }

  void clearOrder(){
    quantities.clear();
    totalAmount = 0;
    totalProduct =0;
    selectedProducts.clear();
    print("Previous order is cleared");
    notifyListeners();
  }
  // // Filter Function
  // void filterProducts(bool? isFeaturedProduct, bool? isBestSeller) {
  //   if (clearFilter) {
  //       filteredProducts.clear(); 
  //   } else {
  //     if (isFeaturedProduct ?? false) {
  //       filteredProducts.clear(); 
  //       filteredProducts = featuredproductData.where((product) {
  //         return product.quantity == selectedOption;
  //       }).toList();
  //     }
  //   }
  //   notifyListeners();
  // }

  // // clear Filter
  // void clearFilters() {
  //   clearFilter = true;
  //   notifyListeners();
  // }

  // // Select Filtes
  // void setFilters({String? attribute, String? option, bool? isAttribute}){
  //   if (isAttribute ?? false) {
  //     selectedAttribute = attribute;
  //   }else{
  //     selectedOption = option;
  //   }
  //   notifyListeners();
  // }

  // Get Banners List from the API
  Future<void> getFeturedProducts() async {
    final response = await apiRepository.featuredProducts();
    String decryptedResponse= decryptAES(response.body).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '');
    final decodedResponse= json.decode(decryptedResponse);
    debugPrint('Featured Decrypted Data: $decodedResponse, Status Code: ${response.statusCode}', wrapWidth: 1064);
    if (response.statusCode == 200) {
      final List<dynamic> productJson = decodedResponse['products'];
      List<Products> productsList = productJson.map((product) => Products.fromJson(product)).toList();
      featuredproductData = productsList;
    } else {
      print('Featured Products Error: ${response.body}');
    }
    notifyListeners();
  }
  
  // Best seller Products
  Future<void> getBestSellers() async {
    final response = await apiRepository.bestSellers();
    print('Best Seller Products Response: ${response.body}, Code: ${response.statusCode}');
    String decryptedResponse= decryptAES(response.body).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '');
    final decodedResponse = json.decode(decryptedResponse);
    debugPrint('Best Seller Response: $decryptedResponse, Status Code: ${response.statusCode}', wrapWidth: 1064);
    if (response.statusCode == 200) {
      final List<dynamic> productJson = decodedResponse['products'];
      List<Products> productsList = productJson.map((product) => Products.fromJson(product)).toList();
      bestSellerProducts = productsList;
    } else {
      print('Featured Products Error: ${response.body}');
    }
    notifyListeners();
  }

  // Categories 
  Future<void> getCatgories() async {
    final response = await apiRepository.categories();
    String decryptedResponse = decryptAES(response.body).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '');
    final decodedResponse = json.decode(decryptedResponse);
    debugPrint('Category Response: $decodedResponse, Status code: ${response.statusCode}', wrapWidth: 1064);
    if (response.statusCode == 200) {
      final List<dynamic> categoriesReponse = decodedResponse['results'];
      List<CategoryModel> categoryList = categoriesReponse.map((json) => CategoryModel.fromMap(json)).toList();
      categories = categoryList;
    } else {
      print('Error Banner: ${response.body}');
    }
    notifyListeners();
  }

  // Get Banners
  Future<void> getBanners() async {
    // Get Banners and print Response
    final response = await apiRepository.banners();
    String decryptedResponse = decryptAES(response.body).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '');
    final decodedResponse = json.decode(decryptedResponse);
    print('Banners Response: $decodedResponse, Status Code: ${response.statusCode}');
    if (response.statusCode == 200) {
      banners.clear();
        for (var result in decodedResponse['results']) {
          String bannerImage = result['image'];
          banners.add(bannerImage);
        }
      prefs.setStringList('banners', banners);
    } else {
      print('Error Banner: ${response.body}');
    }
    notifyListeners();
  }

  // Wishlist products
  Future<void> wishlistProductsAPI() async {
    Map<String, dynamic> wishlistData = {'customer_id': prefs.getString("customerId")};
    final response = await apiRepository.wishlistProducts(wishlistData);
    
    final decryptedResponse = decryptAES(response.body).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), "");
    final decodedReponse = json.decode(decryptedResponse);
    print('Wishlist Products response: $decodedReponse, Stauts code: ${response.statusCode}');
    if (response.statusCode == 200) {
      if (decodedReponse["message"] != null && decodedReponse['status'] == "not_found") {
        message = decodedReponse['message'];
      }else{
        List<dynamic> wishlistItems = decodedReponse['results'];
        wishlistProducts = wishlistItems.map((product) => WishlistProductsModel.fromMap(product),).toList();
        // Navigator.push(context, downToTop(screen: WishlistProducts(wishlistProducts: wishlistProducts)));
      }
    }
    else{
      print('Wishlist Error: $decodedReponse');
    }
    notifyListeners();
  }

  // Delete Product From wishlist
  Future<void> removeWishlist(int productId, String name, String quantity) async {
    Map<String, dynamic> removeWishlistProductData = {
      "customer_id": prefs.getString("customerId"),
      "product_id": productId
    };
    final response = await apiRepository.removeWishlist(removeWishlistProductData);
    final decryptedResponse = decryptAES(response.body).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), "");
    final decodedReponse = json.decode(decryptedResponse);
    print('Wishlist Remove response: $decodedReponse, Stauts code: ${response.statusCode}');
    if (response.statusCode == 200) {
      removedMessage = "Product Removed from Wishlist";
      wishlistProducts.removeWhere((element) => element.productId == productId,);
      prefs.remove('$productId$name$quantity');
    }
    else{
      print('Wishlist Error: $decodedReponse');
    }
    notifyListeners();
  }

  // Add Quick Order
  Future<void> addQuickorder(BuildContext context, Size size, List<Map<String, dynamic>> quickOrderProductData) async {
    Map<String, dynamic> quickOrderData = {
      'product_data': quickOrderProductData,
      'customer_id': prefs.getString('customerId'),
    };
    final response = await apiRepository.quickorder(quickOrderData);
    String decryptedResponse = decryptAES(response.body).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), "");
    final decodedResponse = json.decode(decryptedResponse);
    print('Quick Order Response: $decodedResponse, Status code: ${response.statusCode}');
    final quickOrderMessage = snackBarMessage(
      context: context, 
      message: decodedResponse['message'], 
      backgroundColor: Theme.of(context).primaryColor, 
      sidePadding: size.width * 0.1, 
      bottomPadding: size.height * 0.85
    );
    if (response.statusCode == 200 && decodedResponse["status"] == "success") {
      // ScaffoldMessenger.of(context).showSnackBar(quickOrderMessage).closed.then((value) {
        Navigator.push(context, SideTransistionRoute(
          screen: const CheckoutScreen(), 
          args: {'items': totalProduct, 'amount': totalAmount, 'fromQuick': true}
        ));
      // },);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(quickOrderMessage);
    }
  }

  // apply a Coupon
  Future<void> applyCoupon(String couponCode, Size size, String total, BuildContext context) async {
   if (isCouponApplied) {
       /// Coupon applied message
      final appliedMessage = snackBarMessage(
        context: context, 
        message: 'Coupon Already applied', 
        backgroundColor: Theme.of(context).primaryColor, 
        sidePadding: size.width * 0.1, 
        bottomPadding: size.height * 0.75
      );
      ScaffoldMessenger.of(context).showSnackBar(appliedMessage);
   }else{
      Map<String, dynamic> couponData = {
        'coupon_code': couponCode.toString(),
        'customer_id': prefs.getString('customerId'),
        "total": total.toString()
      };
      print(json.encode(couponData));
      /// If couponApplied[Default false] is true it will show already applied message
      /// Otherwise it try to apply the coupon
      /// Try to apply the coupon based on coupon data body: {"data": json.encode(couponData)});
      final response = await apiRepository.applyCoupon(couponData);
      final decryptResponse = decryptAES(response.body).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '');
      final decodedResponse = json.decode(decryptResponse);
      print('Decoded Coupon Response: $decodedResponse, Status code: ${response.statusCode}');
      if (response.statusCode == 200 && decodedResponse["status"] == "success") {
        final couponMessage = snackBarMessage(
          context: context, 
          message: 'Coupon applied Successfully', 
          backgroundColor: Theme.of(context).primaryColor, 
          sidePadding: size.width * 0.1, 
          bottomPadding: size.height * 0.75
        );
        ScaffoldMessenger.of(context).showSnackBar(couponMessage);
        isCouponApplied = true;
        discountAmount = decodedResponse['discount'].toString();
        newTotal = decodedResponse['new_total'].toString();
      } else {
        print('Error: $decodedResponse');
      }
   }
    
    notifyListeners();
  }

  // apply a Coupon
  Future<void> applyCouponQuickOrder(String couponCode, Size size, String total, BuildContext context) async {
    if (isCouponApplied) {
       /// Coupon applied message
      final appliedMessage = snackBarMessage(
        context: context, 
        message: 'Coupon Already applied', 
        backgroundColor: Theme.of(context).primaryColor, 
        sidePadding: size.width * 0.1, 
        bottomPadding: size.height * 0.75
      );
      ScaffoldMessenger.of(context).showSnackBar(appliedMessage);
    }else{
      Map<String, dynamic> couponData = {
        'coupon_code': couponCode,
        'customer_id': prefs.getString('customerId'),
        "total": total
      };
      print("coupon: $couponData");
      /// If couponApplied[Default false] is true it will show already applied message
      /// Otherwise it try to apply the coupon
      /// Try to apply the coupon based on coupon data
      final response = await apiRepository.applyCouponQuickOrder(couponData);
      // final response = await http.post(Uri.parse("https://maduraimarket.in/api/apply-coupon-quick-order"), body: {"data": json.encode(couponData)});
      final decryptResponse = decryptAES(response.body).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '');
      final decodedResponse = json.decode(decryptResponse);
      // final decodedResponse = json.decode(response.body);
      print('Decoded Quick order Coupon Response: $decodedResponse, Status code: ${response.statusCode}');
      if (response.statusCode == 200 && decodedResponse["status"] == "success") {
        final couponMessage = snackBarMessage(
          context: context, 
          message: 'Coupon applied Successfully', 
          backgroundColor: Theme.of(context).primaryColor, 
          sidePadding: size.width * 0.1, 
          bottomPadding: size.height * 0.75
        );
        ScaffoldMessenger.of(context).showSnackBar(couponMessage);
        isCouponApplied = true;
        print("Is coupon applied: $isCouponApplied");
        discountAmount = decodedResponse['discount'].toString();
        newTotal = decodedResponse['new_total'].toString();
      } else {
        print('Error: $decodedResponse');
      }
    }
    notifyListeners();
  }

  void clearCoupon(){
    isCouponApplied = false;
    print("Is coupon applied: $isCouponApplied");
    discountAmount = "";
    newTotal ="";
    notifyListeners();
  }

  // Quick order Checkout
  Future<void> quickOrderCheckOut(BuildContext context, Size size, Map<String, dynamic> checkoutData) async {
    final response = await apiRepository.quickOrderCheckout(checkoutData);
    String decryptedResponse= decryptAES(response.body).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '');
    final decodedResponse = json.decode(decryptedResponse);
    debugPrint("Quick order Placed Response: $decodedResponse, Status code: ${response.statusCode}", wrapWidth: 1064);
     final quickOrderMessage = snackBarMessage(
      context: context, 
      message: decodedResponse['message'], 
      backgroundColor: Theme.of(context).primaryColor, 
      sidePadding: size.width * 0.1, 
      bottomPadding: size.height * 0.75
    );
    if (response.statusCode == 200 && decodedResponse["status"] == "success") {
      clearOrder();
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

  
  // Remove wishlist Message
  void removeWishlistMessage(int productId, String name, String quantity, BuildContext context){
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
                        child: AppTextWidget(text: "Remove wishlist", fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 16,),
                      Center(
                        child: Text(
                           "Do you want remove this product from wishlist?",
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
                      await removeWishlist(productId, name, quantity).then((value) => Navigator.pop(context),);
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

}