

import 'dart:async';
import 'dart:convert';

import 'package:app_3/helper/shared_preference_helper.dart';
import 'package:app_3/model/active_subscription_model.dart';
import 'package:app_3/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/encrypt_ids.dart';
import '../../../widgets/screen_widgets.dart';

Future<void> editSubscribe(String planName, List<int> quantity,  ActiveSubscriptionModel edit, double screenHeight, double screenWidth, BuildContext context ) async {
   SharedPreferences prefs = SharedPreferencesHelper.getSharedPreferences();
   for(int i =0 ; i < quantity.length; i++){

   }
  Map<String, dynamic> userData = {
    'sub_id': edit.subId,
    'subscription_id': edit.subRefId,
    'product_id': edit.productId,
    'customer_id': prefs.getString('customerId'),
    'day': 'everyday',
    'frequency': edit.frequency,
    'payment_status': 'Pending',
    'status': 'Active',
    "product_price": edit.productPrice,
    'quantity':  quantity,
    'amount':  (quantity[0] + quantity[1]) * edit.productPrice,
  };
  String jsonData = json.encode(userData);
  print('JsonData: $jsonData');
  String encryptedData = encryptAES(jsonData);
  encryptedData = encryptedData.replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '');
  print('Encrypted: $encryptedData');
  String url = 'https://maduraimarket.in/api/updatesubscription';
  final response = await http.post(Uri.parse(url), body: {'data': encryptedData.replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '')});
   print('Success: ${response.body}');
  if (response.statusCode == 200) {
    print('Success: ${response.statusCode}');
    print('Success: ${response.statusCode}');
          print('Success: ${response.body}');
          String decryptedData = decryptAES(response.body);
          decryptedData = decryptedData.replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '');
          // debugPrint("Decrypted Response: $decryptedData".toString(), wrapWidth: 1024) ;
          print('Decrypted Dat: $decryptedData');
          final responseJson = json.decode(decryptedData);
          print('Response: $responseJson');
          switch (responseJson['status']) {
            case 'success':
              // showSnackBar(context, responseJson['message'], screenHeight , screenWidth , screenWidth);
              break;
            case 'failure':
              // showSnackBar(context, responseJson['message'], screenHeight , screenWidth , screenWidth);
              break;
            default:
          }
  }else{
    print('Failure: ${response.body}');
    
  }
}


void everyDayChange(BuildContext context, ActiveSubscriptionModel edit, double screenHeight, double screenWidth) {
  int morningQuantity = edit.frequencyMobData[0].mrgQuantity;
    int eveningQuantity = edit.frequencyMobData[0].evgQuantity;
    List<int> quantityMap = [morningQuantity, eveningQuantity];
  showModalBottomSheet(
    context: context,
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
                              value: morningQuantity > 0,
                              onChanged: (value) {
                                setState(() {
                                  morningQuantity = value! ? edit.frequencyMobData[0].mrgQuantity : 0;
                                });
                              },
                            ),
                            const Text('Morning'),
                            const SizedBox(width: 10,),
                            // Quantity counter for Morning
                            GestureDetector(
                              onTap: () {
                                print(morningQuantity);
                                print(eveningQuantity);
                                if (morningQuantity > 0) {
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
                              value: eveningQuantity > 0,
                              onChanged: (value) {
                                setState(() {
                                  eveningQuantity = value! ? edit.frequencyMobData[0].evgQuantity : 0;
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
                  Consumer<ProfileProvider>(
                      builder: (context, provider, child) {
                      return GestureDetector(
                        onTap: () async {
                          quantityMap[0] = morningQuantity;
                          quantityMap[1] = eveningQuantity;
                          await  editSubscribe('everyday',quantityMap, edit, screenHeight, screenWidth, context).then((value) async {
                            await provider.activeSubscription().then((value) {
                              Navigator.pop(context);
                            },);
                          });
                        },
                        child: changesubscriptionButton()
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

// week day
void weekDayChange(BuildContext context, ActiveSubscriptionModel edit, double screenHeight, double screenWidth) {
  List<String> weekdays = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday'];
    List<List<int>> quantities = List<List<int>>.generate(edit.frequencyMobData.length, (index) => [edit.frequencyMobData[index].mrgQuantity, edit.frequencyMobData[index].evgQuantity]);
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            height: 450,
            child: SingleChildScrollView(
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
                          edit.frequencyMobData.length,
                          (index) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Day name
                              Container(
                                margin: const EdgeInsets.only(top: 13, right: 50),
                                child: Text(
                                  edit.frequencyMobData[index].day,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              // Checkbox for Morning
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: quantities[index][0] > 0,
                                        onChanged: (value) {
                                          // setState(() {
                                          //   quantities[index][0] = value! ? quantities[index][0] : 0;
                                          // });
                                           setState(() {
                                          if (value!) {
                                            quantities[index][0] = 1; // Default to 1 when checked
                                          } else {
                                            quantities[index][0] = 0; // Set to 0 when unchecked
                                          }
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
                                        value:quantities[index][1] > 0,
                                        onChanged: (value) {
                                          // setState(() {
                                          //   quantities[index][1] = value! ? quantities[index][1] : 0;
                                          // });
                                           setState(() {
                                          if (value!) {
                                            quantities[index][1] = 1; // Default to 1 when checked
                                          } else {
                                            quantities[index][1] = 0; // Set to 0 when unchecked
                                          }
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
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
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
                      Consumer<ProfileProvider>(
                        builder: (context, provider, child) {
                          return GestureDetector(
                            onTap: () async {
                              await editWeekdaySubscribe(weekdays, quantities, edit, screenHeight, screenWidth, context).then((value) async{
                                await provider.activeSubscription().then((value) {
                                  Navigator.pop(context);
                                },);
                              },);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(top: 20, bottom: 20),
                              child: changesubscriptionButton(),
                            ),
                          );
                        }
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

}

// custom 
void customChange(BuildContext context, ActiveSubscriptionModel edit, double screenHeight, double screenWidth) {
  List<List<int>> quantities = List<List<int>>.generate(edit.frequencyMobData.length, (index) => [edit.frequencyMobData[index].mrgQuantity, edit.frequencyMobData[index].evgQuantity]);
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            height: 450,
            child: SingleChildScrollView(
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
                          edit.frequencyMobData.length,
                          (index) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Day name
                              Container(
                                margin: const EdgeInsets.only(top: 13, right: 50),
                                child: Text(
                                  edit.frequencyMobData[index].day,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              // Checkbox for Morning
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: quantities[index][0]  > 0,
                                        onChanged: (value) {
                                          // setState(() {
                                          //   quantities[index][0] = value! ? quantities[index][0] : 1;
                                          // });
                                           setState(() {
                                          if (value!) {
                                            quantities[index][0] = 1; // Default to 1 when checked
                                          } else {
                                            quantities[index][0] = 0; // Set to 0 when unchecked
                                          }
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
                                        value: quantities[index][1] > 0,
                                        onChanged: (value) {
                                          // setState(() {
                                          //   quantities[index][1] = value! ? quantities[index][1] : 0;
                                          // });
                                           setState(() {
                                          if (value!) {
                                            quantities[index][1] = 1; // Default to 1 when checked
                                          } else {
                                            quantities[index][1] = 0; // Set to 0 when unchecked
                                          }
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
                                                if (quantities[index][1]> 1) {
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
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
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
                        Consumer<ProfileProvider>(
                        builder: (context, provider, child) {
                          return GestureDetector(
                            onTap: () async {
                              List<String> weekdaysUpdate = ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday'];
                              // details.mCount = morningQuantities;
                              // details.eCount = eveningQuantities;
                             await editWeekdaySubscribe(weekdaysUpdate, quantities, edit, screenHeight, screenWidth, context).then((value) async{
                                await provider.activeSubscription();
                              },);
                              // editWeekdaySubscribe(weekdays, morningQuantities, eveningQuantities, 'weekday');
                              // Notify listeners to trigger a rebuild
                              // Close the modal sheet
                              Navigator.pop(context);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(top: 20, bottom: 20),
                              child: changesubscriptionButton(),
                            ),
                          );
                        }
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
}

// changebutton
Widget changesubscriptionButton(){
  return  Container(
    height: 50,
    width: 240,
    decoration: BoxDecoration(
      // border: Border.all(color: Colors.green.shade300),
      color: const Color(0xFF60B47B),
      borderRadius: BorderRadius.circular(10)
    ),
    child: const Center(
      child: Text(
        'Update',
        style: TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.w300
        ),
      ),
    ),
  );             
}

  String getDayName(int index) {
    // Implement a function to get the day name based on the index
    // You can customize this based on your requirements
    switch (index) {
      case 0:
        return 'Sunday:';
      case 1:
        return 'Monday:';
      case 2:
        return 'Tuesday:';
      case 3:
        return 'Wednesday:';
      case 4:
        return 'Thursday:';
      case 5:
        return 'Friday:';
      case 6:
        return 'Saturday:';
      default:
        return '';
    }
  }

 Future<void> editWeekdaySubscribe( List<String> weekdays, List<List<int>> quantities, ActiveSubscriptionModel edit, double screenHeight, double screenWidth, BuildContext context) async {
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
      if (selectedWeekdays.isNotEmpty) {
        Map<String, dynamic> userData = {
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
        String jsonData = json.encode(userData);
        print('Subscription: $jsonData');
        String encryptedData = encryptAES(jsonData);
        print('Encrypted: $encryptedData');
        String url = 'https://maduraimarket.in/api/updatesubscription';
        final response = await http.post(Uri.parse(url), body: {'data': encryptedData.replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '')});
        print('Success: ${response.body}');
        if (response.statusCode == 200) {
          print('Success: ${response.statusCode}');
          print('Success: ${response.body}');
          String decryptedData = decryptAES(response.body);
          decryptedData = decryptedData.replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '');
          // debugPrint("Decrypted Response: $decryptedData".toString(), wrapWidth: 1024) ;
          print('Decrypted Dat: $decryptedData');
          final responseJson = json.decode(decryptedData);
          print('Response: $responseJson');
          switch (responseJson['status']) {
            case 'success':
              // scaffoldMessenger.showSnackBar(
              //   SnackBar(
              //     content:  responseJson['message'],
              //     padding: EdgeInsets.only(left: screenWidth * 0.1, right: screenWidth * 0.1, top: screenHeight * 0.8),
              //   )
              // );
              // showSnackBar(context,, screenHeight , screenWidth , screenWidth);
              showSnackBar(context, responseJson['message'], screenHeight , screenWidth , screenWidth);
              break;
            case 'failure':
              showSnackBar(context, responseJson['message'], screenHeight , screenWidth , screenWidth);
              break;
            default:
          }
      // ignore: use_build_context_synchronously
      // Navigator.of(context).pop();
        }else{
          print('Error: ${response.body}');
        }
    }
  }

