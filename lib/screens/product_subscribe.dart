// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../data/encrypt_ids.dart';
import '../widgets/screen_widgets.dart';

class ProductSubScription extends StatefulWidget {
  final String name;
  final String image;
  const ProductSubScription(
    {
      required this.name ,
      required this.image,
      super.key
    }
  );

  @override
  State<ProductSubScription> createState() => _ProductSubScriptionState();
}

class _ProductSubScriptionState extends State<ProductSubScription> {
  

  List<String> buttonNames = ['Everyday', 'Weekdays', 'Custom'];
  int selectedIndex = -1;
  int dailyQuantity = 1; 

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: homeAppBar('Subscription'),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
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
                    imageUrl: widget.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // Product details
            Container(
              margin: EdgeInsets.only(left: screenWidth > 600 ? screenHeight * 0.55 : screenHeight * 0.015, right: screenWidth > 600 ? screenHeight * 0.55 : screenHeight * 0.015),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // product price and name and offer
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              child: Text(
                                widget.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600
                                ),
                              ),
                            ),
                            const SizedBox(width: 5,),
                            Icon(
                              Icons.star,
                              size: 14,
                              color: Colors.yellow.shade800,
                            ),
                            const Text(
                              '4.3',
                              style:  TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14
                              ),
                            )
                          ],
                        ),
                        const Row(
                          children: [
                            Stack(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.currency_rupee,
                                      size: 14,
                                    ),
                                    Text(
                                      '100',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        // decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  top: 1, // Adjust this value based on your text size and desired position
                                  left: 3,
                                  right: 0,
                                  child: Divider(
                                    color: Colors.black, // Set the color of the strikethrough line
                                    thickness: 1, // Set the thickness of the strikethrough line
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 5,),
                            Text(
                              '7% off',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.red
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  // Subscribe button
                  // const SizedBox(width: 5,),
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.currency_rupee,
                          size: 20,
                        ),
                        Text(
                          '3555/kg',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            // Subscription buttons
            Container(
              margin: EdgeInsets.only(top: 60, left:screenWidth > 600 ? screenHeight * 0.5 :screenHeight * 0.001, right: screenWidth > 600 ? screenHeight * 0.5 :1),
              height: 50,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8)
                ),
                border: Border(
                  top: BorderSide(color: Colors.grey.shade300),
                  bottom: BorderSide(color: Colors.grey.shade300)
                ),
                color: Colors.grey.shade200
              ),
              child: Container(
                margin: EdgeInsets.only(left: screenWidth > 600 ? screenHeight * 0.001 : screenHeight * 0.001),
                child: Row(
                  children: List.generate(
                    buttonNames.length, 
                    (index) => buttons(buttonNames[index], index, context)
                  )
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buttons(String name, int currentindex, BuildContext context){
    bool isSelected = currentindex == selectedIndex;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = currentindex;
        });
        if (selectedIndex == 0) {
          everyDay(context, dailyQuantity);
        } else if (selectedIndex == 1) {
          weekDay(context);
        } else if (selectedIndex == 2) {
          custom(context);
        }
      },
      child: Container(
        height: 40,
        width: 105,
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
  void everyDay(BuildContext context, int dailyQuantity) {
    int morningQuantity = dailyQuantity;
    int eveningQuantity = dailyQuantity;
    // List<String> days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    Map<String, int> quantityMap = {
      'mrng': morningQuantity,
      'eveng': eveningQuantity,
    };
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
                    GestureDetector(
                      onTap: () async {
                        Map<String, dynamic> userData = {
                          'product_id': UserId.getproductId(),
                          'customer_id': UserId.getUserId(),
                          'freqency': 'everyday',
                          'quantity': quantityMap
                        };
                        String jsonData = json.encode(userData);
                        String encryptedData = encryptAES(jsonData);
                        print('Encrypted Date: $encryptedData');
                        String url = 'http://pasumaibhoomi.com/api/subscribe';
                        final response = await http.post(Uri.parse(url), body: {'data': encryptedData});
                        print('Success: ${response.body}');
                        if (response.statusCode == 200) {
                          print('Success: ${response.statusCode}');
                        }
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pop();
                      },
                      child: subscriptionButton()
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

  // weekday subscribe api
  void weekdaysubscribe( List<String> weekdays, List<List<int>> quantities, String plan) async {
  List<Map<String, dynamic>> quantityList = [];

  for (int i = 0; i < weekdays.length; i++) {
    Map<String, dynamic> dayQuantity = {
      'day': weekdays[i],
      'quantity': {
        'mrng': quantities[i][0],
        'eveng': quantities[i][1],
      },
    };
    quantityList.add(dayQuantity);
  }

  Map<String, dynamic> userData = {
      'product_id': UserId.getproductId(),
      'customer_id': UserId.getUserId(),
      'day': weekdays,
      'frequency': plan,
      'quantity': quantityList,
    };
    String jsonData = json.encode(userData);
    String encryptedData = encryptAES(jsonData);
    print('Encrypted: $encryptedData');
    String url = 'http://pasumaibhoomi.com/api/subscribe';
    final response = await http.post(Uri.parse(url), body: {'data': encryptedData});
    print('Success: ${response.body}');
    if (response.statusCode == 200) {
      print('Success: ${response.statusCode}');
    }else{
      print('Error: ${response.body}');
    }
  }

  // week day subscription
  void weekDay(BuildContext context) {
    // List<int> morningQuantities = List<int>.generate(5, (index) => 1);
    // List<int> eveningQuantities = List<int>.generate(5, (index) => 1);
    List<String> weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
    List<List<int>> quantities = List<List<int>>.generate(5, (index) => [1, 1]);

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
                                                  // setState(() {
                                                  //   morningQuantities[index]++;
                                                  // });
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
                        GestureDetector(
                          onTap: () {
                            weekdaysubscribe(weekdays, quantities, 'weekday');
                          },
                          child: Container(
                            margin: const EdgeInsets.only(top: 20, bottom: 20),
                            child: subscriptionButton(),
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

  // custom subscribe 
  void custom(BuildContext context) {
    // List<int> morningQuantities = List<int>.generate(7, (index) => 0);
    // List<int> eveningQuantities = List<int>.generate(7, (index) => 0);
     List<String> weekdays = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    List<List<int>> quantities = List<List<int>>.generate(7, (index) => [1, 1]);


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
                                                  // if (morningQuantities[index] > 1) {
                                                  //   setState(() {
                                                  //     morningQuantities[index]--;
                                                  //   });
                                                  // }
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
                                                  // child: Text('${morningQuantities[index]}'),
                                                  child: Text('${quantities[index][0]}'),
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    // morningQuantities[index]++;
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
                        GestureDetector(
                          onTap: () {
                            weekdaysubscribe(weekdays, quantities,'custom');
                          },
                          child: Container(
                            margin: const EdgeInsets.only(top: 20, bottom: 20),
                            child: subscriptionButton(),
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


}
