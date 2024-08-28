// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:app_3/helper/page_transition_helper.dart';
import 'package:app_3/helper/shared_preference_helper.dart';
import 'package:app_3/model/pre_order_model.dart';
import 'package:app_3/providers/address_provider.dart';
import 'package:app_3/providers/profile_provider.dart';
import 'package:app_3/providers/subscription_provider.dart';
import 'package:app_3/repository/app_repository.dart';
import 'package:app_3/screens/main_screens/profile_screen.dart';
import 'package:app_3/screens/sub-screens/subscription/preorder_subscribe_screen.dart';
import 'package:app_3/service/api_service.dart';
import 'package:app_3/widgets/common_widgets.dart/app_bar.dart';
import 'package:app_3/widgets/common_widgets.dart/button_widget.dart';
import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/encrypt_ids.dart';
import '../../../widgets/screen_widgets.dart';

class ProductSubScription extends StatefulWidget {
  const ProductSubScription({super.key});

  @override
  State<ProductSubScription> createState() => _ProductSubScriptionState();
}

class _ProductSubScriptionState extends State<ProductSubScription> {
  late String name;
  late String image;
  late int price;
  late int finalPrice;
  late int productId;
  final AppRepository subscribeRepository = AppRepository(ApiService('https://maduraimarket.in/api'));
  // final AppRepository subscribeRepository = AppRepository(ApiService('http://192.168.1.5/pasumaibhoomi/public/api'));
  SharedPreferences prefs = SharedPreferencesHelper.getSharedPreferences();
  List<String> buttonNames = ['Everyday', 'Weekdays', 'Custom'];
  int selectedIndex = -1;
  bool dateNeeded = false;
  int dailyQuantity = 1; 
  DateTime? subscriptionDate;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    image = 'https://maduraimarket.in/public/image/product/${args['image']}';
    // image = 'http://192.168.1.5/pasumaibhoomi/public/image/product/${args['image']}' ?? 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSlmXlc1HC_GM_uqdExVH_lQxPQw0LCOQUuhQ&s';
    name = args['name'] ?? '';
    price = args['price'];
    finalPrice = int.parse(args['final']);
    productId = args['id'];
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Subscription',
        needBack: true,
        onBack: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            Center(
              child: Container(
                height: 320,
                width: 320,
                margin: const EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // Product details
            Container(
              margin: EdgeInsets.only(
                left: size.width > 600 ? size.height * 0.55 : size.height * 0.015, 
                right: size.width > 600 ? size.height * 0.55 : size.height * 0.015
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Consumer <SubscriptionProvider>(
                    builder: (context, value, child) {
                      return GestureDetector(
                        onTap: () async {
                          // value.
                          Navigator.push(context, SideTransistionRoute(screen: const NewProfileScreen()));
                        },
                        child: AppTextWidget(
                          text: name, 
                          fontSize: 18, 
                          fontWeight: FontWeight.w600
                        ),
                      );
                    },
                  ),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      AppTextWidget(
                        text: 'Price: ₹$finalPrice ', 
                        fontSize: 14, 
                        fontColor: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500
                      ),
                      Text(
                        '₹$price', 
                        style: const TextStyle(
                          fontSize: 12,
                          decoration: TextDecoration.lineThrough,
                          color: Colors.black54,
                          decorationColor: Colors.red, 
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ],
                  )
                ],
              )
            ),
            // Start Date Picker
             Padding(
              padding: const EdgeInsets.all(12),
              child: ListTile(
                
                minTileHeight: size.height * 0.05,
                focusColor: Colors.transparent.withOpacity(0.1),
                title: subscriptionDate != null
                ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const AppTextWidget(
                      text: 'Subscription start from: ', 
                      fontSize: 14, 
                      fontWeight: FontWeight.w400
                    ),
                    AppTextWidget(
                      text: DateFormat('dd MMM yyyy').format(subscriptionDate!).toString(), 
                      fontSize: 14, 
                      fontWeight: FontWeight.w600,
                      fontColor: Theme.of(context).primaryColor,
                    )
                  ],
                )
                : const AppTextWidget(
                    text: 'When do you want to start subscription?', 
                    fontSize: 13, 
                    fontWeight: FontWeight.w400
                  ),
                onTap: () async {
                  DateTime? startDate = await showDatePicker(
                    context: context, 
                    firstDate: DateTime.now().add(const Duration(days: 1)), 
                    lastDate: DateTime(2100),
                    initialDate: DateTime.now().add(const Duration(days: 1))
                  );
                  if (startDate != null) {
                    subscriptionDate = startDate;
                    setState(() {
                      dateNeeded = false;
                    });
                  }
                },
                trailing: subscriptionDate != null ? null : const Icon(CupertinoIcons.calendar),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: dateNeeded ? Colors.red: Colors.black38)
                ),
              ),
            ),
            // const SizedBox(height: 10,),
            dateNeeded 
            ? const Padding(
              padding: EdgeInsets.only(left: 12.0),
              child: AppTextWidget(
                text: '* Subscription date is required', 
                fontSize: 14, 
                fontWeight: FontWeight.w500,
                fontColor: Colors.red,
              ),
            )
            : Container(),
            const SizedBox(height: 10,),
            // Subscription buttons
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                // margin: EdgeInsets.only(top: 60, left:screenWidth > 600 ? screenHeight * 0.5 :screenHeight * 0.001, right: screenWidth > 600 ? screenHeight * 0.5 :1),
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border(
                    top: BorderSide(color: Colors.grey.shade300),
                    bottom: BorderSide(color: Colors.grey.shade300)
                  ),
                  color: Colors.grey.shade200
                ),
                child: Container(
                  margin: EdgeInsets.only(left: size.width > 600 ? size.height * 0.001 : size.height * 0.001),
                  child: Row(
                    children: List.generate(
                      buttonNames.length, 
                      (index) => buttons(buttonNames[index], index, context, size)
                    )
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buttons(
    String name, 
    int currentindex, 
    BuildContext context, Size size){
    bool isSelected = currentindex == selectedIndex;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = currentindex;
        });
        if (selectedIndex == 0) {
          everyDay(context, dailyQuantity, size);
        } else if (selectedIndex == 1) {
          weekDay(context, size);
        } else if (selectedIndex == 2) {
          custom(context, size, finalPrice);
        }
      },
      child: Container(
        height: 40,
        width: 95,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isSelected ? Colors.green.shade500 : Colors.black),
          color: isSelected? Colors.green.shade400 : Colors.transparent.withOpacity(0.0)
        ),
        margin: const EdgeInsets.only(left: 7,right: 7),
        child: Center(
          child: Text(
            name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400
            ),
          ),
        ),
      ),
    );
  }
  
  //every day subscription
  void everyDay(BuildContext context, int dailyQuantity, Size size,) {
    int morningQuantity = dailyQuantity;
    int eveningQuantity = dailyQuantity;
    // List<String> days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    showModalBottomSheet(
      context: context,
      sheetAnimationStyle: AnimationStyle(
        curve: Curves.elasticInOut,
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              margin: const EdgeInsets.only(left: 10, right: 10, top: 20),
              height: 350,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text(
                      'Quantity',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(height: 5,),
                    headBar(),
                    const SizedBox(height: 20,),
                    Container(
                      margin: const EdgeInsets.only(left: 40, right: 10),
                      child: Column(
                        children: [
                          // Checkbox and Quantity counter for Morning
                          Row(
                            children: [
                              // Checkbox for Morning
                              Checkbox(
                                activeColor: Theme.of(context).primaryColor,
                                fillColor: morningQuantity > 0 
                                ? WidgetStatePropertyAll(Theme.of(context).primaryColor)
                                : null,
                                checkColor: morningQuantity > 0 ? Colors.white : null,
                                value: morningQuantity > 0,
                                onChanged: (value) {
                                  setState(() {
                                    morningQuantity = value! ? dailyQuantity : 0;
                                  });
                                },
                              ),
                              const Text('Morning'),
                              const SizedBox(width: 10,),
                              // Quantity counter for Morning
                              GestureDetector(
                                onTap: () {
                                  if (morningQuantity > 1) {
                                    setState(() {
                                      morningQuantity--;
                                    });
                                  }
                                },
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.green.shade200),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Center(
                                    child: Icon(Icons.remove),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10,),
                              SizedBox(
                                height: 40,
                                width: 40,
                                child: Center(
                                  child: Text('$morningQuantity'),
                                ),
                              ),
                              const SizedBox(width: 10,),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    morningQuantity++;
                                  });
                                },
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.green.shade200),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Center(
                                    child: Icon(Icons.add),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20,),
                          // Checkbox and Quantity counter for Evening
                          Row(
                            children: [
                              // Checkbox for Evening
                              Checkbox(
                                activeColor: Theme.of(context).primaryColor,
                                fillColor: eveningQuantity > 0 
                                ? WidgetStatePropertyAll(Theme.of(context).primaryColor)
                                : null,
                                checkColor: eveningQuantity > 0 ? Colors.white : null,
                                value: eveningQuantity > 0,
                                onChanged: (value) {
                                  setState(() {
                                    eveningQuantity = value! ? dailyQuantity : 0;
                                  });
                                },
                              ),
                              const Text('Evening'),
                              const SizedBox(width: 10,),
                              // Quantity counter for Evening
                              GestureDetector(
                                onTap: () {
                                  if (eveningQuantity > 1) {
                                    setState(() {
                                      eveningQuantity--;
                                    });
                                  }
                                },
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.green.shade200),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Center(
                                    child: Icon(Icons.remove),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10,),
                              SizedBox(
                                height: 40,
                                width: 40,
                                child: Center(
                                  child: Text('$eveningQuantity'),
                                ),
                              ),
                              const SizedBox(width: 10,),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    eveningQuantity++;
                                  });
                                },
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.green.shade200),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Center(
                                    child: Icon(Icons.add),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40,),
                    Consumer2<AddressProvider, ProfileProvider>(
                      builder: (context, value, activeSub, child) {
                        return ButtonWidget(
                          buttonName: 'Subscribe', 
                          onPressed: () async {
                            if (value.addresses.isEmpty) {
                              Navigator.pop(context);
                              value.addAddressToSubcribe(context, size);
                            }else{
                              if (subscriptionDate != null) {
                                double amount = (morningQuantity + eveningQuantity) * double.parse(finalPrice.toString());
                                List<int> quantityMap = [morningQuantity, eveningQuantity];
                                Map<String, dynamic> everyDayData = {
                                  'product_id': productId,
                                  'customer_id': prefs.getString('customerId'),
                                  'frequency': 'everyday',
                                  'amount': amount,
                                  'payment_status': 'Pending',
                                  'status': 'Active',
                                  'day': 'Everyday',
                                  'start_date': subscriptionDate.toString(),
                                  'quantity': quantityMap,
                                  'product_price': finalPrice,
                                  'address_id': value.currentAddress!.id
                                };
                                print('Every day subscriptin: $everyDayData');
                                final response = await subscribeRepository.subscribeProduct(everyDayData);
                                String decryptedData = decryptAES(response.body).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '');
                                final decodedResponse = json.decode(decryptedData);
                                print('Subscription Response: $decodedResponse, Status Code: ${response.statusCode}');
                                
                                if (response.statusCode == 200 && decodedResponse["status"] == "success") {
                                  // ScaffoldMessenger.of(context).showSnackBar(subscribedMessage);
                                  final preOrderData = PreOrderModel.fromJson(decodedResponse["data"]);
                                  await activeSub.activeSubscription();
                                  Navigator.of(context).pop();
                                  Navigator.push(context, SideTransistionRoute(
                                    screen: const PreOrderProductsScreen(),
                                    args: {'preOrderData': preOrderData}
                                  ));
                                }else{
                                  // ScaffoldMessenger.of(context).showSnackBar(subscribedMessage);
                                  print('Error: ${response.body}');
                                }
                              }else{
                              setState((){
                                  dateNeeded = true;
                                });
                                Navigator.pop(context);
                              }
                            }
                          },
                        );
                      }
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  
  }

  // week day subscription
  void weekDay(BuildContext context, Size size) {
    List<String> weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
    List<List<int>> quantities = List<List<int>>.generate(5, (index) => [1, 1]);

    showModalBottomSheet(
      showDragHandle: true,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return StatefulBuilder(
              builder: (context, setState) {
                return SingleChildScrollView(
                  controller: scrollController,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      margin: const EdgeInsets.only(left: 15, right: 15, top: 20),
                      child: Center(
                        child: Column(
                          children: [
                            const Text(
                              'Quantity',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w300
                              ),
                            ),
                            const SizedBox(height: 5,),
                            headBar(),
                            const SizedBox(height: 10,),
                            Column(
                              children: List.generate(
                                5,
                                (index) => Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Day name
                                    Container(
                                      margin: const EdgeInsets.only(top: 13, right: 50),
                                      child: Text(
                                        weekdays[index],
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    // Checkbox for Morning
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            Checkbox(
                                              activeColor: Theme.of(context).primaryColor,
                                              fillColor: quantities[index][0] > 0 
                                              ? WidgetStatePropertyAll(Theme.of(context).primaryColor)
                                              : null,
                                              checkColor: quantities[index][0] > 0 ? Colors.white : null,
                                              // value: morningQuantities[index] > 0,
                                              value: quantities[index][0] > 0,
                                              onChanged: (value) {
                                                setState(() {
                                                  quantities[index][0] = value! ? 1 : 0;
                                                  // morningQuantities[index] = value! ? 1 : 0;
                                                });
                                              },
                                            ),
                                            const Expanded(
                                              child: Text('Morning'),
                                            ),
                                            // Quantity counter for Morning
                                            Container(
                                              height: 40,
                                              margin: const EdgeInsets.only(left: 45, right: 10),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                    if (quantities[index][0] > 1) {
                                                      setState(() {
                                                        quantities[index][0]--;
                                                      });
                                                    }
                                                      // if (morningQuantities[index] > 1) {
                                                      //   setState(() {
                                                      //     morningQuantities[index]--;
                                                      //   });
                                                      // }
                                                    },
                                                    child: Container(
                                                      height: 40,
                                                      width: 40,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(color: Colors.green.shade200),
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                      child: const Center(
                                                        child: Icon(Icons.remove),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  SizedBox(
                                                    height: 30,
                                                    width: 40,
                                                    child: Center(
                                                      child: Text('${quantities[index][0]}'),
                                                      // child: Text('${morningQuantities[index]}'),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  GestureDetector(
                                                    onTap: () {
                                                    setState(() {
                                                      quantities[index][0]++;
                                                    });
                                                    },
                                                    child: Container(
                                                      height: 40,
                                                      width: 40,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(color: Colors.green.shade200),
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                      child: const Center(
                                                        child: Icon(Icons.add),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        // Checkbox for Evening
                                        Row(
                                          children: [
                                            Checkbox(
                                              activeColor: Theme.of(context).primaryColor,
                                              fillColor: quantities[index][1] > 0 
                                              ? WidgetStatePropertyAll(Theme.of(context).primaryColor)
                                              : null,
                                              checkColor: quantities[index][1] > 0 ? Colors.white : null,
                                              value: quantities[index][1] > 0,
                                              onChanged: (value) {
                                                setState(() {
                                                  quantities[index][1] = value! ? 1 : 0;
                                                });
                                              }
                                            ),
                                            const Expanded(
                                              child: Text('Evening'),
                                            ),
                                            // Quantity counter for Evening
                                            Container(
                                              height: 40,
                                              margin: const EdgeInsets.only(left: 45, right: 10),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      if (quantities[index][1] > 1) {
                                                      setState(() {
                                                        quantities[index][1]--;
                                                      });
                                                    }
                                                    },
                                                    child: Container(
                                                      height: 40,
                                                      width: 40,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(color: Colors.green.shade200),
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                      child: const Center(
                                                        child: Icon(Icons.remove),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  SizedBox(
                                                    height: 30,
                                                    width: 40,
                                                    child: Center(
                                                      child: Text('${quantities[index][1]}'),
                                                      // child: Text('${eveningQuantities[index]}'),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        quantities[index][1]++;
                                                        // eveningQuantities[index]++;
                                                      });
                                                    },
                                                    child: Container(
                                                      height: 40,
                                                      width: 40,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(color: Colors.green.shade200),
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                      child: const Center(
                                                        child: Icon(Icons.add),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20, bottom: 20),
                              child: Consumer2<AddressProvider, ProfileProvider>(
                                builder: (context, value, activeSub, child) {
                                  return ButtonWidget(
                                    icon: CupertinoIcons.shopping_cart,
                                    buttonName: 'Subscribe', 
                                    onPressed: () async {
                                      if (subscriptionDate != null) {
                                        await weekdaysubscribe(weekdays, quantities, 'weekday', finalPrice, value.currentAddress!.id).then((value) async {
                                          await activeSub.activeSubscription();
                                        },);
                                      }else{
                                        setState((){
                                          dateNeeded = true;
                                        });
                                        Navigator.pop(context);
                                      }
                                    } ,
                                  );
                                }
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  String getDayName(int index) {
    // Implement a function to get the day name based on the index
    // You can customize this based on your requirements
    switch (index) {
      case 0:
        return 'sunday:';
      case 1:
        return 'monday:';
      case 2:
        return 'tuesday:';
      case 3:
        return 'wednesday:';
      case 4:
        return 'thursday:';
      case 5:
        return 'friday:';
      case 6:
        return 'saturday:';
      default:
        return '';
    }
  }

  // custom subscribe 
  void custom(BuildContext context, Size size, int price) {
    List<String> weekdays = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    List<List<int>> quantities = List<List<int>>.generate(7, (index) => [1, 1]);

    showModalBottomSheet(
      showDragHandle: true,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return StatefulBuilder(
              builder: (context, setState) {
                return SingleChildScrollView(
                  controller: scrollController,
                  child: Container(
                    margin: const EdgeInsets.only(left: 15, right: 15, top: 20),
                    child: Center(
                      child: Column(
                        children: [
                          const Text(
                            'Quantity',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w300
                            ),
                          ),
                          const SizedBox(height: 5,),
                          headBar(),
                          const SizedBox(height: 10,),
                          Column(
                            children: List.generate(
                              7,
                              (index) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Day name
                                  Container(
                                    margin: const EdgeInsets.only(top: 13, right: 50),
                                    child: Text(
                                      weekdays[index],
                                      // getDayName(index),
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  // Checkbox for Morning
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Checkbox(
                                            activeColor: Theme.of(context).primaryColor,
                                            fillColor: quantities[index][0] > 0 
                                            ? WidgetStatePropertyAll(Theme.of(context).primaryColor)
                                            : null,
                                            checkColor: quantities[index][0] > 0 ? Colors.white : null,
                                            value: quantities[index][0] > 0,
                                            // value: morningQuantities[index] > 0,
                                            onChanged: (value) {
                                              setState(() {
                                                quantities[index][0] = value! ? 1 : 0;
                                                // morningQuantities[index] = value! ? 1 : 0;
                                              });
                                            },
                                          ),
                                          const Expanded(
                                            child: Text('Morning'),
                                          ),
                                          // Quantity counter for Morning
                                          Container(
                                            height: 40,
                                            margin: const EdgeInsets.only(left: 45, right: 10),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.stretch,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    if (quantities[index][0] > 1) {
                                                      setState(() {
                                                        quantities[index][0]--;
                                                      });
                                                    }
                                                  },
                                                  child: Container(
                                                    height: 40,
                                                    width: 40,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(color: Colors.green.shade200),
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    child: const Center(
                                                      child: Icon(Icons.remove),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                SizedBox(
                                                  height: 30,
                                                  width: 40,
                                                  child: Center(
                                                    child: Text('${quantities[index][0]}'),
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      quantities[index][0]++;
                                                    });
                                                  },
                                                  child: Container(
                                                    height: 40,
                                                    width: 40,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(color: Colors.green.shade200),
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    child: const Center(
                                                      child: Icon(Icons.add),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Checkbox for Evening
                                      Row(
                                        children: [
                                          Checkbox(
                                            activeColor: Theme.of(context).primaryColor,
                                            fillColor: quantities[index][1] > 0 
                                            ? WidgetStatePropertyAll(Theme.of(context).primaryColor)
                                            : null,
                                            checkColor: quantities[index][1] > 0 ? Colors.white : null,
                                            value: quantities[index][1] > 0,
                                            // value: eveningQuantities[index] > 0,
                                            onChanged: (value) {
                                              setState(() {
                                                quantities[index][1] = value! ? 1 : 0;
                                                // eveningQuantities[index] = value! ? 1 : 0;
                                              });
                                            },
                                          ),
                                          const Expanded(
                                            child: Text('Evening'),
                                          ),
                                          // Quantity counter for Evening
                                          Container(
                                            height: 40,
                                            margin: const EdgeInsets.only(left: 45, right: 10),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.stretch,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    // if (eveningQuantities[index] > 1) {
                                                    //   setState(() {
                                                    //     eveningQuantities[index]--;
                                                    //   });
                                                    // }
                                                    if (quantities[index][1] > 1) {
                                                    setState(() {
                                                      quantities[index][1]--;
                                                    });
                                                  }
                                                  },
                                                  child: Container(
                                                    height: 40,
                                                    width: 40,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(color: Colors.green.shade200),
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    child: const Center(
                                                      child: Icon(Icons.remove),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                SizedBox(
                                                  height: 30,
                                                  width: 40,
                                                  child: Center(
                                                    // child: Text('${eveningQuantities[index]}'),
                                                    child: Text('${quantities[index][1]}'),
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      // eveningQuantities[index]++;
                                                      quantities[index][1]++;
                                                    });
                                                  },
                                                  child: Container(
                                                    height: 40,
                                                    width: 40,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(color: Colors.green.shade200),
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    child: const Center(
                                                      child: Icon(Icons.add),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 20, bottom: 20),
                            child: Consumer2<AddressProvider, ProfileProvider>(
                              builder: (context, value, activeSub, child) {
                                return ButtonWidget(
                                  icon: CupertinoIcons.shopping_cart,
                                  buttonName: 'Subscribe', 
                                  onPressed: () async {
                                    if (subscriptionDate != null) {
                                      await weekdaysubscribe(weekdays, quantities,'custom', price, value.currentAddress!.id).then((value) async {
                                        await activeSub.activeSubscription();
                                      },);
                                      Navigator.pop(context);
                                    }else{
                                      setState((){
                                        dateNeeded = true;
                                    });
                                      Navigator.pop(context);
                                    }
                                  } ,
                                );
                              }
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  // weekday subscribe api
  Future<void> weekdaysubscribe(List<String> weekdays, List<List<int>> quantities, String plan, int price, int addressId) async {
    List<Map<String, dynamic>> quantityList = [];
    double totalAmount = 0;
    List<String> selectedWeekdays = [];
    List<String> selectedWeekdaysList = [];
    List<List<int>> selectedQuantities = [];
    
    for (int i = 0; i < weekdays.length; i++) {
        selectedWeekdays.add(weekdays[i]);
        selectedQuantities.add(quantities[i]);
        Map<String, dynamic> dayQuantity = {
           'day': "${selectedWeekdays[i][0].toLowerCase()}${selectedWeekdays[i].substring(1)}",
          "quantity": [
            quantities[i][0], 
            quantities[i][1],
          ]
          };
        quantityList.add(dayQuantity);
        double amount = (quantities[i][0] + quantities[i][1]) * double.parse(finalPrice.toString());
        totalAmount += amount;
      }
      for (var i = 0; i < selectedWeekdays.length; i++) {
          selectedWeekdaysList.add("${selectedWeekdays[i][0].toLowerCase()}${selectedWeekdays[i].substring(1)}");
        }
        Map<String, dynamic> weekDayData = {
          'product_id': productId,
          'customer_id': prefs.getString('customerId'),
          'day': selectedWeekdaysList,
          'frequency': plan,
          'payment_status': 'Pending',
          'status': 'Active',
          'quantity': quantityList,
          'amount':  totalAmount,
          'start_date': subscriptionDate.toString(),
          'product_price': finalPrice,
          'address_id': addressId
        };
        print("$plan : $weekDayData");
        final response = await subscribeRepository.subscribeProduct(weekDayData);
        String decryptedData = decryptAES(response.body).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '');
        final decodedResponse = json.decode(decryptedData);
        print('Subscribed Product Response: $decodedResponse, Status code: ${response.statusCode}');
        if (response.statusCode == 200 && decodedResponse["status"] == "success") {
          final preOrderData = PreOrderModel.fromJson(decodedResponse["data"]);
          Navigator.of(context).pop();
          Navigator.push(context, SideTransistionRoute(
            screen: const PreOrderProductsScreen(),
            args: {'preOrderData': preOrderData}
          ));
          print("Why it not moving");
        }else{
          // ScaffoldMessenger.of(context).showSnackBar(subscribedMessage);
          print('Error: ${response.body}');
        }
    
  }



}
