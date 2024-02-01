// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member, avoid_print, unused_local_variable


import 'dart:convert';

import 'package:app_3/screens/active_subscription.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../data/encrypt_ids.dart';
import '../widgets/screen_widgets.dart';

void editSubscribe(String planName, Map<String, int> quantity ) async {
  Map<String, dynamic> userData = {
    'product_id': UserId.getproductId(),
    'customer_id': UserId.getUserId(),
    'sub_id': UserId.getSubId(),
    'frequency': planName,
    'quantity': quantity
  };
  String jsonData = json.encode(userData);
  String encryptedData = encryptAES(jsonData);
  print('Encrypted: $encryptedData');
  String url = 'http://pasumaibhoomi.com/api/updatesubscription';
  final response = await http.post(Uri.parse(url), body: {'data': encryptedData});
   print('Success: ${response.body}');
  if (response.statusCode == 200) {
    print('Success: ${response.statusCode}');
  }else{
    print('Failure: ${response.body}');
  }
}
void editWeekdaySubscribe( List<String> weekdays, List<int> mrng, List<int> evng, String plan) async {

List<List<int>> quantities = [];
for(int i = 0; i< weekdays.length; i++){
  List<int> quantity = [mrng[i], evng[i]];
  quantities.add(quantity);
}
  Map<String, dynamic> userData = {
    'product_id': UserId.getproductId(),
    'customer_id': UserId.getUserId(),
    'sub_id': UserId.getSubId(),
    'day': weekdays,
    'frequency': plan,
    'quantity': quantities
  };
  String jsonData = json.encode(userData);
  String encryptedData = encryptAES(jsonData);
  print('Encrypted: $encryptedData');
  String url = 'http://pasumaibhoomi.com/api/updatesubscription';
  final response = await http.post(Uri.parse(url), body: {'data': encryptedData});
  print('Success: ${response.body}');
  if (response.statusCode == 200) {
    print('Success: ${response.statusCode}');
  }else{
    print('Error: ${response.body}');
  }
}


void everyDayChange(BuildContext context, SubscriptionDetails subscriptionDetails) {
  int morningQuantity = subscriptionDetails.mCount.isNotEmpty ? subscriptionDetails.mCount[0] : 0;
  int eveningQuantity = subscriptionDetails.eCount.isNotEmpty ? subscriptionDetails.eCount[0] : 0;
  Map<String, int> quantityMap = {
    'mrng': morningQuantity,
    'eveng': eveningQuantity,
  };
  List<String> days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

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
                                  morningQuantity = value! ? subscriptionDetails.mCount[0] : 0;
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
                              value: eveningQuantity > 0,
                              onChanged: (value) {
                                setState(() {
                                  eveningQuantity = value! ? subscriptionDetails.eCount[0] : 0;
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
                  GestureDetector(
                    onTap: () {
                      subscriptionDetails.mCount = [morningQuantity];
                      subscriptionDetails.eCount = [eveningQuantity];
                      detailsNotifier.details = List.from(detailsNotifier.details);
                      editSubscribe('everyday',quantityMap);
                      Navigator.pop(context);
                    },
                    child: changesubscriptionButton()
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
void weekDayChange(BuildContext context, SubscriptionDetails details) {
  List<int> morningQuantities = List<int>.generate(5, (index) {
    if (details.mCount.isNotEmpty && index < details.mCount.length) {
      return details.mCount[index];
    } else {
      return 0;
    }
  });

  List<int> eveningQuantities = List<int>.generate(5, (index) {
    if (details.eCount.isNotEmpty && index < details.eCount.length) {
      return details.eCount[index];
    } else {
      return 0;
    }
  });
  List<String> weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
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
                                        value: morningQuantities[index] > 0,
                                        onChanged: (value) {
                                          setState(() {
                                            morningQuantities[index] = value! ? 1 : 0;
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
                                                if (morningQuantities[index] > 1) {
                                                  setState(() {
                                                    morningQuantities[index]--;
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
                                                child: Text('${morningQuantities[index]}'),
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  morningQuantities[index]++;
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
                                        value: eveningQuantities[index] > 0,
                                        onChanged: (value) {
                                          setState(() {
                                            eveningQuantities[index] = value! ? 1 : 0;
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
                                                if (eveningQuantities[index] > 1) {
                                                  setState(() {
                                                    eveningQuantities[index]--;
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
                                                child: Text('${eveningQuantities[index]}'),
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  eveningQuantities[index]++;
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
                      GestureDetector(
                        onTap: () {
                          details.mCount = morningQuantities;
                          details.eCount = eveningQuantities;

                          // Notify listeners to trigger a rebuild
                          detailsNotifier.notifyListeners();
                          editWeekdaySubscribe(weekdays, morningQuantities, eveningQuantities, 'weekday');


                          // Close the modal sheet
                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 20, bottom: 20),
                          child: changesubscriptionButton(),
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
}

// custom 
void customChange(BuildContext context, SubscriptionDetails details) {
List<int> morningQuantities = List<int>.generate(7, (index) {
    if (details.mCount.isNotEmpty && index < details.mCount.length) {
      return details.mCount[index];
    } else {
      return 0;
    }
  });

  List<int> eveningQuantities = List<int>.generate(7, (index) {
    if (details.eCount.isNotEmpty && index < details.eCount.length) {
      return details.eCount[index];
    } else {
      return 0;
    }
  });
  List<String> weekdays = ['Sunday','Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

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
                          7,
                          (index) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Day name
                              Container(
                                margin: const EdgeInsets.only(top: 13, right: 50),
                                child: Text(
                                  getDayName(index),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              // Checkbox for Morning
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: morningQuantities[index] > 0,
                                        onChanged: (value) {
                                          setState(() {
                                            morningQuantities[index] = value! ? 1 : 0;
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
                                                if (morningQuantities[index] > 1) {
                                                  setState(() {
                                                    morningQuantities[index]--;
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
                                                child: Text('${morningQuantities[index]}'),
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  morningQuantities[index]++;
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
                                        value: eveningQuantities[index] > 0,
                                        onChanged: (value) {
                                          setState(() {
                                            eveningQuantities[index] = value! ? 1 : 0;
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
                                                if (eveningQuantities[index] > 1) {
                                                  setState(() {
                                                    eveningQuantities[index]--;
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
                                                child: Text('${eveningQuantities[index]}'),
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  eveningQuantities[index]++;
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
                      GestureDetector(
                        onTap: () {
                          details.mCount = morningQuantities;
                          details.eCount = eveningQuantities;

                          editWeekdaySubscribe(weekdays, morningQuantities, eveningQuantities, 'weekday');
                          // Notify listeners to trigger a rebuild
                          detailsNotifier.notifyListeners();
                          
                          // Close the modal sheet
                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 20, bottom: 20),
                          child: changesubscriptionButton(),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart
          ),
          SizedBox(width: 10,),
          Text(
            'Confirm',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w300
            ),
          )
        ],
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
