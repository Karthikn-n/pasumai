import 'package:app_3/helper/cache_manager_helper.dart';
import 'package:app_3/helper/shared_preference_helper.dart';
import 'package:app_3/model/products_model.dart';
import 'package:app_3/providers/address_provider.dart';
import 'package:app_3/providers/profile_provider.dart';
import 'package:app_3/providers/subscription_provider.dart';
import 'package:app_3/repository/app_repository.dart';
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


class ProductSubScription extends StatefulWidget {
  final Products product;
  const ProductSubScription({super.key, required this.product});

  @override
  State<ProductSubScription> createState() => _ProductSubScriptionState();
}

class _ProductSubScriptionState extends State<ProductSubScription> {

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
    return Scaffold(
      appBar: AppBarWidget(
        title: widget.product.name,
        needBack: true,
        onBack: () => Navigator.pop(context),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            Center(
              child: Stack(
                children: [
                  SizedBox(
                    height: 320,
                    width: 320,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: "https://maduraimarket.in/public/image/product/${widget.product.image}",
                        fit: BoxFit.cover,
                        cacheManager: CacheManagerHelper.cacheIt(key: widget.product.image),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    top: 20,
                    child: widget.product.subscribed == "Subscribed"
                    ? Container(
                      // width: 320,
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        // color: Color(0xFFEA2B01),
                        color: Color.fromARGB(255, 255, 98, 0),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(2),
                          bottomRight: Radius.circular(2)
                        )
                      ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/icons/crown.png",
                              height: 20,
                              width: 20,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 4,),
                            const AppTextWidget(
                              fontColor: Colors.white, 
                              text: "Subscribed", 
                              fontWeight: FontWeight.w500, 
                              fontSize: 12,
                            ),
                          ],
                        )
                      )
                    : Container(),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20,),
            // Product details
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: size.width * 0.65,
                      child: Row(
                        children: [
                          AppTextWidget(
                            text: "${widget.product.name}/", 
                            fontSize: 16, 
                            fontWeight: FontWeight.w500
                          ),
                          AppTextWidget(
                            text: widget.product.quantity, 
                            fontSize: 16, 
                            fontWeight: FontWeight.w500
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        AppTextWidget(
                          text: '₹${widget.product.finalPrice} ', 
                          fontSize: 14, 
                          fontColor: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500
                        ),
                        Text(
                          '₹${widget.product.price}', 
                          style: const TextStyle(
                            fontSize: 14,
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                            decorationColor: Colors.grey, 
                            fontWeight: FontWeight.w500
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 5,),
                AppTextWidget(
                  text: widget.product.description.replaceAll("<p>", "").replaceAll("</p>", ""), 
                  fontSize: 12, 
                  fontWeight: FontWeight.w300
                ),
              ],
            ),
            const SizedBox(height: 20,),
            dateNeeded 
            ? const AppTextWidget(
              text: '* Subscription start date is required', 
              fontSize: 12, 
              fontWeight: FontWeight.w400,
              fontColor: Colors.red,
            )
            : Container(),
            dateNeeded ? const SizedBox(height: 5,) : Container(),
            // Start Date Picker
             ListTile(
               minTileHeight: size.height * 0.05,
               focusColor: Colors.transparent.withValues(alpha: 0.1),
               title: subscriptionDate != null
               ? Row(
                 crossAxisAlignment: CrossAxisAlignment.center,
                //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   const AppTextWidget(
                     text: 'Subscription start from: ', 
                     fontSize: 12, 
                     fontWeight: FontWeight.w400
                   ),
                   AppTextWidget(
                     text: DateFormat('dd MMM yyyy').format(subscriptionDate!).toString(), 
                     fontSize: 12, 
                     fontWeight: FontWeight.w500,
                     fontColor: Theme.of(context).primaryColor,
                   )
                 ],
               )
               : const AppTextWidget(
                   text: 'When do you want to start subscription?', 
                   fontSize: 12, 
                   fontWeight: FontWeight.w400
                 ),
               onTap: () async {
                 DateTime? startDate = await showDatePicker(
                   context: context, 
                   firstDate: DateTime.now().add(const Duration(days: 1)), 
                   lastDate: DateTime(2100),
                   initialDate: DateTime.now().add(const Duration(days: 1)),
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
            const SizedBox(height: 20,),
            // Subscription buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(buttonNames.length, (index) {
                bool isSelected = index == selectedIndex;
                return SizedBox(
                  width: size.width * 0.3,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: isSelected ? Theme.of(context).primaryColor : Colors.grey
                        )
                      ),
                      backgroundColor: isSelected? Theme.of(context).primaryColor : Colors.transparent.withValues(alpha: 0.0),
                      shadowColor: Colors.transparent.withValues(alpha: 0.0),
                      overlayColor: isSelected ? Colors.white24 : Colors.transparent.withValues(alpha: 0.1)
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      setState(() {
                        selectedIndex = index;
                      });
                      if (selectedIndex == 0) {
                        everyDay(context, dailyQuantity, size);
                      } else if (selectedIndex == 1) {
                        weekDay(context, size);
                      } else if (selectedIndex == 2) {
                        custom(context, size, widget.product.finalPrice);
                      }
                    }, 
                    child: AppTextWidget(
                      text: buttonNames[index], 
                      fontSize: 12, 
                      fontColor: isSelected? Colors.white : Colors.black,
                      fontWeight: FontWeight.w500
                    )
                  ),
                );
              },),
            ),
          ],
        ),
      ),
    );
  }
  
  //every day subscription
  void everyDay(BuildContext context, int dailyQuantity, Size size,) {
    int morningQuantity = dailyQuantity;
    int eveningQuantity = dailyQuantity;
    bool quantityNeeded = false;
    // List<String> days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    showModalBottomSheet(
      context: context,
      sheetAnimationStyle: const AnimationStyle(
        curve: Curves.elasticInOut,
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (sheetContext, sheetState) {
            return SizedBox(
              height: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20,),
                  const AppTextWidget(
                    text: 'Select quantity',
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  const AppTextWidget(
                    text: 'This product will be delivered every day of this month',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                  const SizedBox(height: 20,),
                  // The Quantity 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                          sheetState(() {
                            morningQuantity = value! ? dailyQuantity : 0;
                          });
                        },
                      ),
                      // const SizedBox(width: 10,),
                      const AppTextWidget(text: "Morning", fontSize: 14, fontWeight: FontWeight.w500),
                      const SizedBox(width: 10,),
                      // Quantity counter for Morning
                      GestureDetector(
                        onTap: () {
                          if (morningQuantity > 0) {
                            sheetState(() {
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
                            child: Icon(CupertinoIcons.minus, size: 20,),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5,),
                      SizedBox(
                        height: 40,
                        width: 40,
                        child: Center(
                          child: AppTextWidget(
                            text: "$morningQuantity", 
                            fontSize: 14, 
                            fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                      const SizedBox(width: 5,),
                      GestureDetector(
                        onTap: () {
                          sheetState(() {
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
                            child: Icon(CupertinoIcons.add, size: 20,),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10,),
                    ],
                  ),
                  const SizedBox(height: 20,),
                  // Checkbox and Quantity counter for Evening
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                          sheetState(() {
                            eveningQuantity = value! ? dailyQuantity : 0;
                          });
                        },
                      ),
                      const AppTextWidget(text: "Evening", fontSize: 14, fontWeight: FontWeight.w500),
                      const SizedBox(width: 10,),
                      // Quantity counter for Evening
                      GestureDetector(
                        onTap: () {
                          if (eveningQuantity > 0) {
                            sheetState(() {
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
                            child: Icon(Icons.remove, size: 20,),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5,),
                      SizedBox(
                        height: 40,
                        width: 40,
                        child: Center(
                          child: AppTextWidget(
                            text: "$eveningQuantity", 
                            fontSize: 14, 
                            fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                      const SizedBox(width: 5,),
                      GestureDetector(
                        onTap: () {
                          sheetState(() {
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
                            child: Icon(Icons.add, size: 20,),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10,),
                    ],
                  ),
                  const SizedBox(height: 20,),
                  SizedBox(
                    width: size.width * 0.8,
                    child: Consumer2<AddressProvider, SubscriptionProvider>(
                      builder: (providerContext, addressProvider, activeSub, child) {
                        return ButtonWidget(
                          height: kToolbarHeight - 10,
                          buttonName: 'Subscribe', 
                          onPressed: () async {
                            print("subscription data: $subscriptionDate");
                            if (subscriptionDate != null) {
                              if (addressProvider.addresses.isEmpty) {
                                Navigator.pop(sheetContext);
                                addressProvider.addAddressToSubcribe(context, size);
                              } else{
                                double amount = (morningQuantity + eveningQuantity) * double.parse(widget.product.finalPrice.toString());
                                List<int> quantityMap = [morningQuantity, eveningQuantity];
                                Map<String, dynamic> everyDayData = {
                                  'product_id': widget.product.id,
                                  'customer_id': prefs.getString('customerId'),
                                  'frequency': 'everyday',
                                  'amount': amount,
                                  'payment_status': 'Pending',
                                  'status': 'Active',
                                  'day': 'Everyday',
                                  'start_date': subscriptionDate.toString(),
                                  'quantity': quantityMap,
                                  'product_price': widget.product.finalPrice,
                                  'address_id': addressProvider.currentAddress!.id
                                };
                                print('Every day subscriptin: $everyDayData');
                                if (amount == 0.0) {
                                  sheetState(() {
                                    quantityNeeded = true;
                                  });
                                }else{
                                  sheetState(() {
                                    quantityNeeded = false;
                                  });
                                  Navigator.pop(sheetContext);
                                  await activeSub.addSubscription(context, size, everyDayData);
                                }
                              }
                            }else{
                              setState((){
                                dateNeeded = true;
                              });
                              Navigator.pop(sheetContext);
                            }
                            
                          },
                        );
                      }
                    ),
                  ),
                  quantityNeeded 
                  ? const Column(
                      children: [
                        SizedBox(height: 5,),
                        AppTextWidget(
                          text: "* atleast one quantity need to subscribe", 
                          fontWeight: FontWeight.w500, 
                          fontColor: Colors.red,
                          fontSize: 12,
                        ),
                      ],
                    )
                  : Container()
                ],
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
    bool quantityNeeded = false;
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (sheetContext) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 1,
          expand: false,
          builder: (dragContext, scrollController) {
            return StatefulBuilder(
              builder: (stateContext, sheetState) {
                return SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20,),
                      const AppTextWidget(text: "Select qunatity", fontSize: 18, fontWeight: FontWeight.w500),
                      const AppTextWidget(
                        text: "This product will be delivered except Saturday and Sunday of this month", 
                        fontSize: 12, fontWeight: FontWeight.w400,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20,),
                      Container(
                        margin: const EdgeInsets.only(left: 35),
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                            5,
                            (index) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Day name
                                Container(
                                  margin: const EdgeInsets.only(left: 8),
                                  child: AppTextWidget(text: weekdays[index], fontSize: 16, fontWeight: FontWeight.w500)
                                ),
                                const SizedBox(height: 10,),
                                // Checkbox for Morning
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
                                        sheetState(() {
                                          quantities[index][0] = value! ? 1 : 0;
                                          // morningQuantities[index] = value! ? 1 : 0;
                                        });
                                      },
                                    ),
                                    SizedBox(
                                      width: size.width * 0.17,
                                      child: const AppTextWidget(text: "Morning", fontSize: 14, fontWeight: FontWeight.w400)
                                    ),
                                    // Quantity counter for Morning
                                    const SizedBox(width: 25,),
                                    GestureDetector(
                                      onTap: () {
                                      if (quantities[index][0] > 0) {
                                        sheetState(() {
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
                                          child: Icon(CupertinoIcons.minus, size: 20,),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    SizedBox(
                                      height: 30,
                                      width: 40,
                                      child: Center(
                                        child: AppTextWidget(text: "${quantities[index][0]}", fontSize: 14, fontWeight: FontWeight.w500)
                                        // child: Text('${morningQuantities[index]}'),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    GestureDetector(
                                      onTap: () {
                                        sheetState(() {
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
                                          child: Icon(CupertinoIcons.add, size: 20,),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10,)
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
                                        sheetState(() {
                                          quantities[index][1] = value! ? 1 : 0;
                                        });
                                      }
                                    ),
                                    SizedBox(
                                      width: size.width * 0.17,
                                      child: const AppTextWidget(text: "Evening", fontSize: 14, fontWeight: FontWeight.w400)
                                    ),
                                    const SizedBox(width: 25,),
                                    // Quantity counter for Evening
                                    GestureDetector(
                                      onTap: () {
                                        if (quantities[index][1] > 0) {
                                        sheetState(() {
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
                                          child: Icon(Icons.remove, size: 20,),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    SizedBox(
                                      height: 30,
                                      width: 40,
                                      child: Center(
                                        child: AppTextWidget(text: "${quantities[index][1]}", fontSize: 14, fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    GestureDetector(
                                      onTap: () {
                                        sheetState(() {
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
                                          child: Icon(CupertinoIcons.add, size: 20,),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10,)
                                  ],
                                ),
                                const SizedBox(height: 10,)
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: Consumer3<AddressProvider, ProfileProvider, SubscriptionProvider>(
                          builder: (providerContext, value, activeSub, subProvider, child) {
                            return ButtonWidget(
                              height: kToolbarHeight - 10,
                              buttonName: 'Subscribe', 
                              onPressed: () async {
                                if (subscriptionDate != null) {
                                  if (value.addresses.isEmpty) {
                                    Navigator.pop(sheetContext);
                                    value.addAddressToSubcribe(context, size);
                                  }else{
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
                                      double amount = (quantities[i][0] + quantities[i][1]) * double.parse(widget.product.finalPrice.toString());
                                      totalAmount += amount;
                                    }
                                    for (var i = 0; i < selectedWeekdays.length; i++) {
                                      selectedWeekdaysList.add("${selectedWeekdays[i][0].toLowerCase()}${selectedWeekdays[i].substring(1)}");
                                    }
                                      
                                    Map<String, dynamic> weekDaySubscriptionData = {
                                      'product_id': widget.product.id,
                                      'customer_id': prefs.getString('customerId'),
                                      'day': selectedWeekdaysList,
                                      'frequency': "weekday",
                                      'payment_status': 'Pending',
                                      'status': 'Active',
                                      'quantity': quantityList,
                                      'amount':  totalAmount,
                                      'start_date': subscriptionDate.toString(),
                                      'product_price': widget.product.finalPrice,
                                      'address_id': value.currentAddress!.id
                                    };
                                    print("Weekday subscription data: $weekDaySubscriptionData");
                                    if (totalAmount == 0) {
                                      sheetState((){
                                        quantityNeeded = true;
                                      });
                                    }else{
                                      sheetState((){
                                        quantityNeeded = false;
                                      });
                                      Navigator.pop(sheetContext);
                                      await subProvider.addSubscription(context, size, weekDaySubscriptionData);
                                    }
                                  }
                                }else{
                                  setState((){
                                    dateNeeded = true;
                                  });
                                  Navigator.pop(sheetContext);
                                }
                              } ,
                            );
                          }
                        ),
                      ),
                      quantityNeeded 
                        ? const Column(
                            children: [
                              SizedBox(height: 5,),
                              AppTextWidget(
                                text: "* atleast one quantity need to subscribe", 
                                fontWeight: FontWeight.w500, 
                                fontColor: Colors.red,
                                fontSize: 12,
                              ),
                              SizedBox(height: 20,),
                            ],
                          )
                        : const SizedBox(height: 20,)
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  // custom subscribe 
  void custom(BuildContext context, Size size, int price) {
    List<String> weekdays = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    List<List<int>> quantities = List<List<int>>.generate(7, (index) => [1, 1]);
    // ignore: unused_local_variable
    bool quantityNeeded = false;
    showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (sheetContext) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 1,
          expand: false,
          builder: (dragContext, scrollController) {
            return StatefulBuilder(
              builder: (stateContext, sheetState) {
                return SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      const SizedBox(height: 20,),
                      const AppTextWidget(text: "Select quantity", fontSize: 18, fontWeight: FontWeight.w500),
                      const AppTextWidget(
                        text: "This product will be delivered only selected day of this month", 
                        fontSize: 12, fontWeight: FontWeight.w400,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20,),
                      Container(
                        margin: const EdgeInsets.only(left: 40),
                        child: Column(
                          children: List.generate(
                            7,
                            (index) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Day name
                                Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  child: AppTextWidget(text: weekdays[index], fontSize: 16, fontWeight: FontWeight.w500)
                                ),
                                const SizedBox(height: 10,),
                                // Checkbox for Morning
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
                                        sheetState(() {
                                          quantities[index][0] = value! ? 1 : 0;
                                          // morningQuantities[index] = value! ? 1 : 0;
                                        });
                                      },
                                    ),
                                    SizedBox(
                                      width: size.width * 0.17,
                                      child: const AppTextWidget(text: "Morning", fontSize: 14, fontWeight: FontWeight.w400)
                                    ),
                                    // Quantity counter for Morning
                                    const SizedBox(width: 25,),
                                    GestureDetector(
                                      onTap: () {
                                        if (quantities[index][0] > 0) {
                                          sheetState(() {
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
                                          child: Icon(CupertinoIcons.minus, size: 20,),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    SizedBox(
                                      height: 30,
                                      width: 40,
                                      child: Center(
                                        child: AppTextWidget(text: "${quantities[index][0]}", fontSize: 14, fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    GestureDetector(
                                      onTap: () {
                                        sheetState(() {
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
                                          child: Icon(CupertinoIcons.add, size: 20,),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10,)
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
                                        sheetState(() {
                                          quantities[index][1] = value! ? 1 : 0;
                                          // eveningQuantities[index] = value! ? 1 : 0;
                                        });
                                      },
                                    ),
                                     SizedBox(
                                      width: size.width * 0.17,
                                      child: const AppTextWidget(text: "Evening", fontSize: 14, fontWeight: FontWeight.w400)
                                    ),
                                    const SizedBox(width: 25,),
                                    // Quantity counter for Evening
                                    GestureDetector(
                                      onTap: () {
                                        if (quantities[index][1] > 0) {
                                        sheetState(() {
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
                                          child: Icon(CupertinoIcons.minus, size: 20,),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    SizedBox(
                                      height: 30,
                                      width: 40,
                                      child: Center(
                                        child: AppTextWidget(text: "${quantities[index][1]}", fontSize: 14, fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    GestureDetector(
                                      onTap: () {
                                        sheetState(() {
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
                                          child: Icon(CupertinoIcons.add, size: 20,),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10,)
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20,),
                        child: Consumer2<AddressProvider, SubscriptionProvider>(
                          builder: (providerContext, value, activeSub, child) {
                            return ButtonWidget(
                              height: kToolbarHeight - 10,
                              buttonName: 'Subscribe', 
                              onPressed: () async {
                                if (subscriptionDate != null) {
                                  if (value.addresses.isEmpty) {
                                    Navigator.pop(sheetContext);
                                    value.addAddressToSubcribe(context, size);
                                  }else{
                                  // Subscription Products
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
                                      double amount = (quantities[i][0] + quantities[i][1]) * double.parse(widget.product.finalPrice.toString());
                                      totalAmount += amount;
                                    }
                                    for (var i = 0; i < selectedWeekdays.length; i++) {
                                      selectedWeekdaysList.add("${selectedWeekdays[i][0].toLowerCase()}${selectedWeekdays[i].substring(1)}");
                                    }
                                    Map<String, dynamic> customSubscriptionData = {
                                      'product_id': widget.product.id,
                                      'customer_id': prefs.getString('customerId'),
                                      'day': selectedWeekdaysList,
                                      'frequency': "custom",
                                      'payment_status': 'Pending',
                                      'status': 'Active',
                                      'quantity': quantityList,
                                      'amount':  totalAmount,
                                      'start_date': subscriptionDate.toString(),
                                      'product_price': widget.product.finalPrice,
                                      'address_id': value.currentAddress!.id
                                    };
                                    print("Custome subscription data: $customSubscriptionData");
                                    if (totalAmount == 0) {
                                      sheetState((){
                                        quantityNeeded = true;
                                      });
                                    }else{
                                      sheetState((){
                                        quantityNeeded = false;
                                      });
                                      Navigator.pop(sheetContext);
                                      await activeSub.addSubscription(context, size, customSubscriptionData);
                                    }
                                   
                                  }
                                }else{
                                  setState((){
                                    dateNeeded = true;
                                  });
                                  Navigator.pop(sheetContext);
                                }
                              } ,
                            );
                          }
                        ),
                      ),
                      quantityNeeded 
                      ? const Column(
                          children: [
                            SizedBox(height: 5,),
                            AppTextWidget(
                              text: "* atleast one quantity need to subscribe", 
                              fontWeight: FontWeight.w500, 
                              fontColor: Colors.red,
                              fontSize: 12,
                            ),
                            SizedBox(height: 20,),
                          ],
                        )
                      : const SizedBox(height: 20,)
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
