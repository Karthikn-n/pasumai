
import 'dart:convert';

import 'package:app_3/data/encrypt_ids.dart';
import 'package:app_3/helper/shared_preference_helper.dart';
import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/products_model.dart';
import '../../providers/cart_items_provider.dart';

class SearchScreen extends StatefulWidget {
  final FocusNode focusNode;
  const SearchScreen({super.key, required this.focusNode});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  FocusNode? initialfoucs;
  TextEditingController searchController = TextEditingController();
  String query ='';
  List<Products> searchedProducts = [];
  SharedPreferences prefs = SharedPreferencesHelper.getSharedPreferences();

   @override
  void initState(){
    super.initState();
    initialfoucs = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(initialfoucs);
    },);
  }

  @override
  void dispose() {
    initialfoucs!.dispose();
    searchController.dispose();
    super.dispose();
  }

  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          systemNavigationBarDividerColor: Colors.black
        ),
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10, right: 0),
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(CupertinoIcons.back, )
          ),
        ),
        // leadingWidth: 30,
        title: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: size.width * 0.85
          ),
          child: TextFormField(
            controller: searchController,
            focusNode: initialfoucs ?? widget.focusNode,
            cursorColor: Colors.black.withOpacity(0.5),
            onChanged: (value) {
              setState(() {
                getProducts(searchController.text);
              });
            },
            decoration: InputDecoration(
              hintText: 'Search',
              hintStyle: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color:Colors.black.withOpacity(0.5)
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    getProducts(searchController.text);
                  });
                },
                icon: const Icon(
                 CupertinoIcons.search, 
                 size: 18,
                ) 
              ),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: Colors.white)
              ),
              disabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: Colors.white)
              ),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: Colors.white)
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(
                  color: Colors.white
                )
              )
            ),
          )
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.1),
          child: Container(
            color: Colors.black.withOpacity(0.5),
            height: 1.0,
          )
        ),
      ),
      body: Container(
        color: Colors.white,
        child: FutureBuilder<List<Products>>(
          future: getProducts(searchController.text), 
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No Products Found'));
            } else {
              searchedProducts = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.only(top: 10),
                child: searchProduct(size, context),
              );
            }
          },
        ),
      ),
    );
  }

  Future<List<Products>> getProducts(String name) async {
    Map<String, dynamic> userData = {
      'product_name': name
    };
    String jsonData = json.encode(userData);
    
    String encryptedUserData = encryptAES(jsonData);
    String url = 'https://maduraimarket.in/api/productsearch';
    // String url = 'http://192.168.1.5/pasumaibhoomi/public/api/productsearch';
    final response = await http.post(
      Uri.parse(url), 
      body: {'data': encryptedUserData.replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '')}
    );
    print('Response Code: ${response.statusCode}');
    if (response.statusCode == 200) {
      String decryptedData = decryptAES(response.body);
      final responseJson = json.decode(decryptedData.replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), ''));
      print('Response Body: $responseJson');
      final List<dynamic> productJson = responseJson['results'];
      List<Products> productsList = productJson.map((json) => Products.fromJson(json)).toList();
      return productsList;
    } else {
      print('Error: ${response.body}');
      throw Exception('Failed to load products');
    }
  }
  

  Widget searchProduct(Size size, BuildContext context,){
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: ListView.builder(
          itemCount: searchedProducts.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: index == searchedProducts.length - 1 
                      ? BorderSide.none
                      : BorderSide(color: Colors.grey.shade300)
                    ),
                    // borderRadius: BorderRadius.circular(10)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Product Image
                      SizedBox(
                        width: 94,
                        height: 105,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            // imageUrl: 'http://192.168.1.5/pasumaibhoomi/public/image/product/${products[index].image}',
                            imageUrl: 'https://maduraimarket.in/public/image/product/${searchedProducts[index].image}',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product Name and Quantity
                            AppTextWidget(
                              text: "${searchedProducts[index].name}/${searchedProducts[index].quantity}", 
                              fontSize: 16, 
                              maxLines: 2,
                              textOverflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.w500
                            ),
                            const SizedBox(height: 5,),
                            // Product Description
                            AppTextWidget(
                              text: searchedProducts[index].description.replaceAll("<p>", ""), 
                              fontSize: 12, 
                              maxLines: 2,
                              fontColor: Colors.black54,
                              textOverflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.w400
                            ),
                            const SizedBox(height: 5,),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                // Product Final price
                                AppTextWidget(
                                  text: "₹${searchedProducts[index].finalPrice.toString()}", 
                                  fontSize: 15, 
                                  fontWeight: FontWeight.w400,
                                ),
                                const SizedBox(width: 5,),
                                // Product Price 
                                Text(
                                  "₹${searchedProducts[index].price.toString()}",
                                  style: const TextStyle(
                                    fontSize: 13, 
                                    fontWeight: FontWeight.w400,
                                    decorationThickness: 2,
                                    decorationColor: Colors.red,
                                    color: Colors.black54,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Add to Cart Button
                      Consumer<CartProvider>(
                        builder: (context, cartProvider, child) {
                          return SizedBox(
                            width: 45,
                            height: 105,
                            child: ElevatedButton(
                              onPressed: () async => await cartProvider.addCart(searchedProducts[index].id, size, context, searchedProducts[index]), 
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent.withOpacity(0.0),
                                elevation: 0,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.fromLTRB(13, 0, 0, 0),
                                shadowColor: Colors.transparent.withOpacity(0.0),
                                overlayColor: Colors.transparent.withOpacity(0.1),
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(5)
                                )
                              ),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                                child: Icon(
                                  CupertinoIcons.cart_badge_plus,
                                  color: Theme.of(context).primaryColor,
                                  size: 20,
                                ),
                              )
                            ),
                          );
                        },
                      )
                    
                    ],
                  ),
                ),
                // const SizedBox(height: 10,)
              ],
            );
          },
        ),
      );
  }

 

}

