import 'package:app_3/helper/shared_preference_helper.dart';
import 'package:app_3/model/active_subscription_model.dart';
import 'package:app_3/providers/subscription_provider.dart';
import 'package:app_3/widgets/common_widgets.dart/button_widget.dart';
import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';



void everyDayChange(BuildContext context, ActiveSubscriptionModel edit, Size size) {
  int morningQuantity = edit.frequencyMobData[0].mrgQuantity;
  int eveningQuantity = edit.frequencyMobData[0].evgQuantity;
  List<int> quantityMap = [morningQuantity, eveningQuantity];
  bool quantityNeeded = false;
  showModalBottomSheet(
    context: context,
    sheetAnimationStyle: AnimationStyle(
      curve: Curves.elasticInOut,
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, sheetState) {
          return SizedBox(
            height: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20,),
                const AppTextWidget(text: "Quantity", fontSize: 24, fontWeight: FontWeight.w400),
                const SizedBox(height: 20,),
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
                          morningQuantity = value! ? edit.frequencyMobData[0].mrgQuantity : 0;
                        });
                      },
                    ),
                    const AppTextWidget(text: "Morning", fontSize: 14, fontWeight: FontWeight.w400),
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
                    const SizedBox(width: 10,),
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
                    const SizedBox(width: 10,),
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
                          child: Icon(CupertinoIcons.add),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10,)
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
                          eveningQuantity = value! ? edit.frequencyMobData[0].evgQuantity : 0;
                        });
                      },
                    ),
                    const AppTextWidget(text: "Evening", fontSize: 14, fontWeight: FontWeight.w400),
                    const SizedBox(width: 10,),
                    // Quantity counter for Evening
                    GestureDetector(
                      onTap: () {
                        if (eveningQuantity > 1) {
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
                          child: Icon(CupertinoIcons.minus, size: 20,),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10,),
                    SizedBox(
                      height: 40,
                      width: 40,
                      child: Center(
                        child: AppTextWidget(
                          text: "$eveningQuantity", 
                          fontSize: 15, 
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                    const SizedBox(width: 10,),
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
                          child: Icon(Icons.add),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10,),
                  ],
                ),
                const SizedBox(height: 20,),
                Consumer<SubscriptionProvider>(
                    builder: (context, provider, child) {
                    return SizedBox(
                      width: size.width * 0.8,
                      child: ButtonWidget(
                        buttonName: "Update", 
                        onPressed: () async {
                          quantityMap[0] = morningQuantity;
                          quantityMap[1] = eveningQuantity;
                          SharedPreferences prefs = SharedPreferencesHelper.getSharedPreferences();
                          Map<String, dynamic> editEveryDayData = {
                            'sub_id': edit.subId,
                            'subscription_id': edit.subRefId,
                            'product_id': edit.productId,
                            'customer_id': prefs.getString('customerId'),
                            'day': 'everyday',
                            'frequency': edit.frequency,
                            'payment_status': 'Pending',
                            'status': 'Active',
                            "product_price": edit.productPrice,
                            'quantity':  quantityMap,
                            'amount':  (quantityMap[0] + quantityMap[1]) * edit.productPrice,
                          };
                          print("Every day edit subscription data: $editEveryDayData");
                          if ((quantityMap[0] + quantityMap[1]) * edit.productPrice == 0) {
                            sheetState((){
                              quantityNeeded = true;
                            });
                          }else{
                            sheetState((){
                              quantityNeeded = false;
                            });
                            await provider.editSubscription(context, size, editEveryDayData);
                          }
                        } 
                      ),
                    );
                  }
                ),
                 quantityNeeded 
                  ? const Column(
                      children: [
                        SizedBox(height: 5,),
                        AppTextWidget(
                          text: "* atleast one quantity need to update", 
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

// week day
void weekDayChange(BuildContext context, ActiveSubscriptionModel edit, Size size) {
  List<String> weekdays = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday'];
  List<List<int>> quantities = List<List<int>>.generate(edit.frequencyMobData.length, (index) => [edit.frequencyMobData[index].mrgQuantity, edit.frequencyMobData[index].evgQuantity]);
  bool quantityNeeded = false;
  showModalBottomSheet(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 1,
        expand: false,
        builder: (dragContext, scrollController) {
          return StatefulBuilder(
            builder: (context, sheetState) {
              return SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  children: [
                    const SizedBox(height: 20,),
                    const AppTextWidget(text: "Qunatity", fontSize: 24, fontWeight: FontWeight.w400),
                    const SizedBox(height: 20,),
                    Container(
                      margin: const EdgeInsets.only(left: 40),
                      child: Column(
                        children: List.generate(
                          edit.frequencyMobData.length,
                          (index) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Day name
                              Container(
                                margin: const EdgeInsets.only(left: 10),
                                child: AppTextWidget(
                                  text:  "${edit.frequencyMobData[index].day[0].toUpperCase()}${edit.frequencyMobData[index].day.substring(1)}", 
                                  fontSize: 15, 
                                  fontWeight: FontWeight.w500
                                )
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
                                        if (value!) {
                                          quantities[index][0] = 1; // Default to 1 when checked
                                        } else {
                                          quantities[index][0] = 0; // Set to 0 when unchecked
                                        }
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    width: size.width * 0.15,
                                    child: const AppTextWidget(text: "Morning", fontSize: 14, fontWeight: FontWeight.w400)
                                  ),
                                  const SizedBox(width: 25,),
                                  // Quantity counter for Morning
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
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    height: 30,
                                    width: 40,
                                    child: Center(
                                      child: AppTextWidget(text: "${quantities[index][0]}", fontSize: 14, fontWeight: FontWeight.w500)
                                    ),
                                  ),
                                  const SizedBox(width: 10),
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
                                    value:quantities[index][1] > 0,
                                    onChanged: (value) {
                                      // sheetState(() {
                                      //   quantities[index][1] = value! ? quantities[index][1] : 0;
                                      // });
                                       sheetState(() {
                                      if (value!) {
                                        quantities[index][1] = 1; // Default to 1 when checked
                                      } else {
                                        quantities[index][1] = 0; // Set to 0 when unchecked
                                      }
                                    });
                                    },
                                  ),
                                   SizedBox(
                                    width: size.width * 0.15,
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
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    height: 30,
                                    width: 40,
                                    child: Center(
                                      child: AppTextWidget(text: "${quantities[index][1]}", fontSize: 14, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
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
                                        child: Icon(CupertinoIcons.add),
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
                    Consumer<SubscriptionProvider>(
                      builder: (context, provider, child) {
                        return SizedBox(
                          width: size.width * 0.8,
                          child: ButtonWidget(
                            buttonName: "Update", 
                            onPressed: () async {
                              List<Map<String, dynamic>> quantityList = [];
                              double totalAmount = 0;
                              SharedPreferences prefs = SharedPreferencesHelper.getSharedPreferences();
                              List<String> selectedWeekdays = [];
                              List<List<int>> selectedQuantities = [];
                              for (int i = 0; i < edit.frequencyMobData.length; i++) {
                                selectedWeekdays.add(weekdays[i]);
                                selectedQuantities.add(quantities[i]);
                    
                                Map<String, dynamic> dayQuantity = {
                                  'day': "${weekdays[i][0].toLowerCase()}${weekdays[i].substring(1)}",
                                  'quantity': 
                                    [ quantities[i][0],
                                    quantities[i][1],]
                                  ,
                                };
                                quantityList.add(dayQuantity);
                    
                                int amount = (quantities[i][0] + quantities[i][1]) * edit.productPrice;
                                totalAmount += amount;
                              }
                              Map<String, dynamic> editWeekdaySubscribeData = {
                                'sub_id':  edit.subId,
                                'subscription_id': edit.subRefId,
                                'product_id': edit.productId,
                                'customer_id': prefs.getString('customerId'),
                                'day': selectedWeekdays,
                                'frequency': edit.frequency,
                                'payment_status': 'Pending',
                                'status': 'Active',
                                "product_price": edit.productPrice,
                                'quantity': quantityList,
                                'amount':  totalAmount,
                              };
                              print("Week Day Edit subscription: $editWeekdaySubscribeData");
                              if (totalAmount == 0) {
                                sheetState((){
                                  quantityNeeded = true;
                                });
                              }else{
                                sheetState((){
                                  quantityNeeded = false;
                                });
                                await provider.editSubscription(context, size, editWeekdaySubscribeData);
                              }
                            }
                          ),
                        );
                      }
                    ),
                    quantityNeeded 
                    ? const Column(
                        children: [
                          SizedBox(height: 5,),
                          AppTextWidget(
                            text: "* atleast one quantity need to update", 
                            fontWeight: FontWeight.w500, 
                            fontColor: Colors.red,
                            fontSize: 12,
                          ),
                          // SizedBox(height: 20,),
                        ],
                      )
                    : const SizedBox(height: 5,)
                  ],
                ),
              );
            },
          );
        }
      );
    },
  );

}

// custom 
void customChange(BuildContext context, ActiveSubscriptionModel edit, Size size) {
  List<List<int>> quantities = List<List<int>>.generate(edit.frequencyMobData.length, (index) => [edit.frequencyMobData[index].mrgQuantity, edit.frequencyMobData[index].evgQuantity]);
  bool quantityNeeded = false;
  showModalBottomSheet(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 1,
        expand: false,
        builder: (dragContext, scrollController) {
          return StatefulBuilder(
            builder: (context, sheetState) {
              return SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  children: [
                    const SizedBox(height: 20,),
                    const AppTextWidget(text: "Quantity", fontSize: 24, fontWeight: FontWeight.w400),
                    const SizedBox(height: 20,),
                    Container(
                      margin: const EdgeInsets.only(left: 40),
                      child: Column(
                        children: List.generate(
                          edit.frequencyMobData.length,
                          (index) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Day name
                              Container(
                                margin: const EdgeInsets.only(left: 10),
                                child: AppTextWidget(
                                  text: "${edit.frequencyMobData[index].day[0].toUpperCase()}${edit.frequencyMobData[index].day.substring(1)}", 
                                  fontSize: 15, 
                                  fontWeight: FontWeight.w500
                                )
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
                                    onChanged: (value) {
                                      sheetState(() {
                                        if (value!) {
                                          quantities[index][0] = 1; // Default to 1 when checked
                                        } else {
                                          quantities[index][0] = 0; // Set to 0 when unchecked
                                        }
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    width: size.width * 0.15,
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
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    height: 30,
                                    width: 40,
                                    child: Center(
                                      child: AppTextWidget(
                                        text: "${quantities[index][0]}", 
                                        fontSize: 14, fontWeight: FontWeight.w400
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
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
                                        if (value!) {
                                          quantities[index][1] = 1; // Default to 1 when checked
                                        } else {
                                          quantities[index][1] = 0; // Set to 0 when unchecked
                                        }
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    width: size.width * 0.15,
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
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    height: 30,
                                    width: 40,
                                    child: Center(
                                      child: AppTextWidget(
                                        text: "${quantities[index][1]}", 
                                        fontSize: 14, fontWeight: FontWeight.w500
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
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
                                        child: Icon(CupertinoIcons.add, size: 20),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10,)
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Consumer<SubscriptionProvider>(
                      builder: (context, provider, child) {
                        return SizedBox(
                          width: size.width * 0.8,
                          child: ButtonWidget(
                            buttonName: "Update", 
                            onPressed: () async {
                              List<String> weekdays = ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday'];
                              List<Map<String, dynamic>> quantityList = [];
                              double totalAmount = 0;
                              SharedPreferences prefs = SharedPreferencesHelper.getSharedPreferences();
                              List<String> selectedWeekdays = [];
                              List<List<int>> selectedQuantities = [];
                              for (int i = 0; i < edit.frequencyMobData.length; i++) {
                                selectedWeekdays.add(weekdays[i]);
                                selectedQuantities.add(quantities[i]);
                                Map<String, dynamic> dayQuantity = {
                                  'day': "${weekdays[i][0].toLowerCase()}${weekdays[i].substring(1)}",
                                  'quantity': 
                                    [ quantities[i][0],
                                    quantities[i][1],]
                                  ,
                                };
                                quantityList.add(dayQuantity);
                                int amount = (quantities[i][0] + quantities[i][1]) * edit.productPrice;
                                totalAmount += amount;
                              }
                              Map<String, dynamic> editCustomSubscribeData = {
                                'sub_id':  edit.subId,
                                'subscription_id': edit.subRefId,
                                'product_id': edit.productId,
                                'customer_id': prefs.getString('customerId'),
                                'day': selectedWeekdays,
                                'frequency': edit.frequency,
                                'payment_status': 'Pending',
                                'status': 'Active',
                                "product_price": edit.productPrice,
                                'quantity': quantityList,
                                'amount':  totalAmount,
                              };
                              print("Custome Edit subscription: $editCustomSubscribeData");
                              if (totalAmount == 0) {
                                sheetState((){
                                  quantityNeeded = true;
                                });
                              }else{
                                sheetState((){
                                  quantityNeeded = false;
                                });
                                await provider.editSubscription(context, size, editCustomSubscribeData);
                              }
                            }
                          ),
                        );
                      }
                    ),
                    quantityNeeded 
                    ? const Column(
                        children: [
                          SizedBox(height: 5,),
                          AppTextWidget(
                            text: "* atleast one quantity need to update", 
                            fontWeight: FontWeight.w500, 
                            fontColor: Colors.red,
                            fontSize: 12,
                          ),
                          // SizedBox(height: 20,),
                        ],
                      )
                    : const SizedBox(height: 5,)
                  ],
                ),
              );
            },
          );
        }
      );
    },
  );
}



