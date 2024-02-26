import 'package:app_3/screens/bottom_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../data/cart_repo.dart';
import '../data/common_data.dart';
class AddedProduct {
  final String name;
  final String image;
  int quantity;
  final String weight;
  final String price;

  AddedProduct({
    required this.name,
    required this.image,
    required this.quantity,
    required this.weight,
    required this.price,
  });
}
class Product {
  final String name;
  final String weight;
  final String image;
  int quantity;
  final String price;

  Product(this.name, this.weight, this.image, this.quantity, this.price);
}
   List<List<Product>> productCategories = [
    [
      Product('Family Dairy Pack', '250 g', products[0], 0, '199'),
      Product('Ice Coffee with Chocolate', '350 g', products[1], 0, '100'),
      Product('Milk soup', '500g', products[2], 0, '210'),
      Product('Panneer Roast with Noodles ', '800g', products[3], 0, '89'),
    ],
    [
      Product('Egg Noodels', '400 g', products[4], 0, '110'),
      Product('Chicken leg Pieces', '150 g', products[5], 0, '250'),
    ],
    [
      Product('Fish Fry', '200 g', products[6], 0, '350'),
      Product('Whole Chicken', '1 Kg', products[7], 0, '410'),
    ],
  ];
  
class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  List<AddedProduct> selectedProducts = [];
  List<String> categoriesName = [
    'Dairy Products',
    'Vegetables',
    'Fruits'
  ];

  List<bool> isCategoryExpanded = List.generate(3, (index) => false);

  
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(
          Icons.location_pin,
          size: 24,
        ),
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Quick order',
          style: TextStyle(
            fontSize: 14
          ),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Icon(Icons.menu),
          )
        ],
      ),
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: screenWidth > 600?  screenHeight * 0.2: screenHeight * 0.135),
            child: CustomScrollView(
              // physics: BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                    expandedHeight: screenWidth > 600?  screenHeight * 0.4 : screenHeight * 0.150,
                    floating: true,
                    pinned: true,
                    surfaceTintColor: Colors.transparent,
                    automaticallyImplyLeading: false,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Image.asset(
                        'assets/category/Banner1.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, categoryIndex) {
                        return Column(
                          children: [
                            Container(
                              width: screenWidth > 600 ? screenHeight * 1.5 : screenHeight * 0.45,
                              height: 60,
                              margin: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                children: [
                                  Container(
                                    width: 3,
                                    height: double.infinity,
                                    color: const Color(0xFF60B47B),
                                  ),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(8),
                                          bottomRight: Radius.circular(8)
                                        ),
                                        border: Border(
                                          right: BorderSide(color: Colors.grey.shade300),
                                          top: BorderSide(color: Colors.grey.shade300),
                                          bottom: BorderSide(color: Colors.grey.shade300),
                                        )
                                      ),
                                      child: ListTile(
                                        title: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(categoriesName[categoryIndex], style: const TextStyle(fontWeight: FontWeight.w800),),
                                          ],
                                        ),
                                        trailing: Icon(
                                          isCategoryExpanded[categoryIndex] 
                                          ? Icons.arrow_circle_down_outlined 
                                          : Icons.arrow_circle_right_outlined, 
                                          size: 26, 
                                          color: const Color(0xFF60B47B),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            isCategoryExpanded[categoryIndex] = !isCategoryExpanded[categoryIndex];
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            if (isCategoryExpanded[categoryIndex])
                              Container(
                                width: screenWidth > 600 ? screenHeight * 1.5 : screenHeight * 0.45,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF3F3F3),
                                ),
                                child: Column(
                                  children: [
                                    for(var product in productCategories[categoryIndex])
                                      Column(
                                        children: [
                                          ListTile(
                                            title:  SizedBox(
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    height: 60,
                                                    width: 60,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                        BorderRadius.circular(8),
                                                        child: CachedNetworkImage(
                                                          imageUrl: product.image,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  const SizedBox(width: 8),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        width:screenWidth > 600 ? screenHeight * 0.67 : screenHeight * 0.18,
                                                        child: Text(
                                                          '${product.name} (${product.weight})',
                                                          maxLines: 2,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.w600,
                                                            letterSpacing: -0.5,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          const Icon(
                                                            Icons.currency_rupee,
                                                            size: 12,
                                                          ),
                                                          Text(
                                                            product.price,
                                                            style: const TextStyle(
                                                              fontSize: 12
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  // quality counter
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(18),
                                                    ),
                                                    margin: EdgeInsets.only(
                                                      bottom: screenHeight * 0.011, 
                                                      top: screenHeight * 0.011, 
                                                      left: screenWidth > 600 ? screenWidth * 0.15 : screenHeight * 0.026
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            updateQuantity(
                                                              categoryIndex, 
                                                              productCategories[categoryIndex].indexOf(product), 
                                                              productCategories[categoryIndex][productCategories[categoryIndex].indexOf(product)].quantity -1
                                                            );
                                                          },
                                                          child: Container(
                                                            margin: EdgeInsets.zero,
                                                            height: 25,
                                                            width: 25,
                                                            decoration: BoxDecoration(
                                                              color: Colors.grey.shade300, 
                                                              borderRadius: const BorderRadius.only(
                                                                topLeft: Radius.circular(8),
                                                                bottomLeft: Radius.circular(8),
                                                              ),
                                                              border: Border(
                                                                top: BorderSide(color: Colors.grey.shade300),
                                                                bottom: BorderSide(color: Colors.grey.shade300),
                                                                left:  BorderSide(color: Colors.grey.shade300)
                                                              )
                                                            ),
                                                            child: Icon(
                                                              productCategories[categoryIndex][productCategories[categoryIndex].indexOf(product)].quantity == 1
                                                              ? Icons.delete_outline
                                                              : Icons.remove,
                                                              size: 14,
                                                              color: productCategories[categoryIndex][productCategories[categoryIndex].indexOf(product)].quantity == 1 ? Colors.red : Colors.black,
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(height: 8),
                                                        Container(
                                                          height: 25,
                                                          width: 25,
                                                          decoration: BoxDecoration(
                                                            border: Border(
                                                              top: BorderSide(color: Colors.grey.shade300),
                                                              bottom: BorderSide(color: Colors.grey.shade300),
                                                            )
                                                          ),
                                                          // margin: const EdgeInsets.only(left: 5, right: 5),
                                                          child: Center(
                                                            child: Text(
                                                              '${productCategories[categoryIndex][productCategories[categoryIndex].indexOf(product)].quantity}',
                                                              style: const TextStyle(
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(height: 8),
                                                        GestureDetector(
                                                          onTap: () {
                                                            updateQuantity(
                                                              categoryIndex, 
                                                              productCategories[categoryIndex].indexOf(product), 
                                                              productCategories[categoryIndex][productCategories[categoryIndex].indexOf(product)].quantity +  1
                                                            );
                                                          },
                                                          child: Container(
                                                            margin: EdgeInsets.zero,
                                                            height: 25,
                                                            width: 25,
                                                            decoration: BoxDecoration(
                                                              color: productCategories[categoryIndex][productCategories[categoryIndex].indexOf(product)].quantity >= 1 ? const Color(0xFF60B47B): Colors.grey.shade300  , 
                                                              borderRadius: const BorderRadius.only(
                                                                topRight: Radius.circular(8),
                                                                bottomRight: Radius.circular(8)
                                                              )
                                                            ),
                                                            child: const Icon(
                                                              Icons.add,
                                                              size: 14,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                      ),
                                    ],
                                  )
                                
                                ]     
                              ),
                            ),
                          ],
                        );

                      },
                    childCount: productCategories.length
                    )
                  )
            
              ],
            ),
          ),
          // total amount
          Positioned(
            // left: screenWidth > 600 ? screenHeight * 0.55 : screenHeight * 0.04,
            // right: screenHeight * 0.000,
            top: screenWidth > 600?  screenHeight * 0.55: screenHeight * 0.75,
            // bottom: screenWidth > 600?  screenHeight * 0.0: 0,
            child: Container(
              height: screenWidth > 600 ? screenHeight * 0.4 : screenHeight * 0.2,
              width: screenWidth * 1,
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.black12)),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(26), 
                  topRight: Radius.circular(26)
                )
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 10, left: 20, 
                      right: MediaQuery.of(context).size.width > 600 ? 20: 20, 
                      bottom: MediaQuery.of(context).size.width > 600 ? 8 : 10),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Total:',
                            style: TextStyle(
                              fontSize: 18, 
                              fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          calculateTotalAmount() == 0
                          ? 'Add Somthing'
                          : '₹${calculateTotalAmount()}', 
                          style: const TextStyle(
                            fontSize: 18, 
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      navigateToNextPage();
                    },
                    child: Container(
                      width: screenWidth > 600 ? screenHeight * 1.2: screenHeight * 0.4,
                      height: screenWidth > 600 ? screenHeight * 0.1 : screenHeight * 0.05,
                      decoration: BoxDecoration(
                        color: const Color(0xFF60B47B),
                        borderRadius: BorderRadius.circular(8)
                      ),
                      child: const Center(
                        child: Text(
                          'View cart',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              
              ),
            ),
          )
        
        ],
      ),
    );
  }
  
  int maxQuantity = 25;

  void updateQuantity(int index, int productIndex,int newQuantity) {
    if (newQuantity >= 0) {
      setState(() {
       productCategories[index][productIndex].quantity = newQuantity;
      });
    }
  }

  double calculateTotalAmount() {
    double totalAmount = 0;
    for (var category in productCategories) {
      for (var product in category) {
        totalAmount += product.quantity * int.parse(product.price);
      }
    }
    return totalAmount;
  }

  Widget sorting(String name, IconData icon, double width, double? size){
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade400)
      ),
      height: 30,
      width:  width,
      child: Container(
        margin: const EdgeInsets.only(left: 13),
        child: Row(
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 12
              ),
            ),
            Icon(
              icon,
              size: size ,
            )
          ],
        ),
      ),
    );
  }
  void showSortingpopUP(BuildContext context){
    showDialog(
      context: context, 
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)
          ),
          elevation: 0,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Popup Card Content',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Handle button click
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  void navigateToNextPage() {
    // Filter products with non-zero quantity
    List<AddedProduct> selectedProducts = [];
    for (var category in productCategories) {
      for (var product in category) {
        if (product.quantity > 0) {
          selectedProducts.add(AddedProduct(
            name: product.name,
            image: product.image,
            quantity: product.quantity,
            price: product.price, 
            weight: product.weight,
          ));
        }
      }
    }
    CartRepository().clearProducts();
    CartRepository().addedProducts.addAll(selectedProducts);
    Navigator.of(context).push(_createhomeRoute());
  }
  PageRouteBuilder _createhomeRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => BottomBar(selectedIndex: 1,),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOutCirc;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      var offsetAnimation = animation.drive(tween);

      return SlideTransition(position: offsetAnimation, child: child);
    },
    // settings: const RouteSettings(
    //   arguments: {'selectedIndex' : 1}
    // )
  );
}



}
