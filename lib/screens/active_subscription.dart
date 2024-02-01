// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:app_3/data/response_data.dart';
import 'package:app_3/screens/sub_history.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../data/encrypt_ids.dart';
import '../widgets/screen_widgets.dart';

class SubscriptionDetails{
  final String productName;
  final DateTime date;
  final double amount;
  final String plan;
  final List<String> day;
  List<int> mCount;
  List<int> eCount;

  SubscriptionDetails({
    required this.productName,
    required this.date,
    required this.amount,
    required this.plan,
    required this.day,
    required this.mCount,
    required this.eCount
  });

}
List<SubscriptionDetails> details = [
  SubscriptionDetails(productName: 'Product Name 1', date: DateTime(2024, 01, 31), amount: 340, plan: 'Everyday', day: ['Everyday'], mCount: [2], eCount: [3]),
  SubscriptionDetails(productName: 'Product Name Name 2', date: DateTime(2024, 01, 11), amount: 480, plan: 'Weekdays', day: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'], mCount: [1, 4, 5 ,7 ,7 ], eCount: [1, 2, 3, 4, 4]),
  SubscriptionDetails(productName: 'Product Name 3', date: DateTime(2024, 01, 31), amount: 340, plan: 'Everyday', day: ['Everyday'], mCount: [2], eCount: [3]),
  SubscriptionDetails(productName: 'Product 4', date: DateTime(2024, 01, 15), amount: 590, plan: 'Custom', day: ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'], mCount: [1, 4, 5 ,7 ,7, 4, 5 ], eCount: [1, 2, 3, 4, 4, 5, 6]),
  SubscriptionDetails(productName: 'Product Name Name 5', date: DateTime(2024, 01, 11), amount: 480, plan: 'Weekdays', day: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'], mCount: [1, 4, 5 ,7 ,7 ], eCount: [1, 2, 3, 4, 4]),
  SubscriptionDetails(productName: 'Product 6', date: DateTime(2024, 01, 15), amount: 590, plan: 'Custom', day: ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'], mCount: [1, 4, 5 ,7 ,7, 4, 5 ], eCount: [1, 2, 3, 4, 4, 5, 6]),
];

class SubscriptionResponse {
  String day;
  int morningQuantity;
  int eveningQuantity;

  SubscriptionResponse({
    required this.day,
    required this.morningQuantity,
    required this.eveningQuantity,
  });

  factory SubscriptionResponse.fromJson(Map<String, dynamic> json) {
    return SubscriptionResponse(
      day: json['day'],
      morningQuantity: json['quantity']['mrng'],
      eveningQuantity: json['quantity']['eveng'],
    );
  }
}

class SubscriptionDetailsNotifier extends ChangeNotifier {
  List<SubscriptionDetails> _details;

  SubscriptionDetailsNotifier(List<SubscriptionDetails> details)
      : _details = details;

  List<SubscriptionDetails> get details => _details;

  set details(List<SubscriptionDetails> value) {
    _details = value;
    notifyListeners();
  }
}

SubscriptionDetailsNotifier detailsNotifier =
    SubscriptionDetailsNotifier(details);

class SubScriptionList extends StatefulWidget {
  const SubScriptionList({super.key});

  @override
  State<SubScriptionList> createState() => _SubScriptionListState();
}

class _SubScriptionListState extends State<SubScriptionList> {
  List<SubscriptionResponse> subscriptionResponses = [];
  String frequency ='';
  String subAmount ='';
  String status ='';
  DateTime? startDate;
  DateTime? endDate;
  late SubscriptionHistoryRes activesubscriptions = SubscriptionHistoryRes(results: []);
 
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 30),
            height: 320,
            child: ListView.builder(
              itemCount: details.length,
              // itemCount: activesubscriptions.results.length,
              itemBuilder: (context, index) {
                // SubscriptionHistory active = activesubscriptions.results[index];
                SubscriptionDetails subscriptionDetails = detailsNotifier.details[index];
                return  Container(
                  margin: const EdgeInsets.only(top: 10, left: 12, right: 12, bottom: 12),
                  // height: 158,
                  width: 330,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green.shade300),
                    borderRadius: BorderRadius.circular(12)
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(left: 8, right: 8, top: 10, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Row(
                        children: [
                          const SizedBox(width: 10,),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  subscriptionDetails.productName,
                                  // active.productName,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w400
                                  ),
                                ),
                                const SizedBox(height: 10,),
                                Row(
                                  children: [
                                    const Text(
                                      'Paid Amount: ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        'RS. $subAmount',
                                        // 'RS. ${active.productPrice}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 7,),
                                Row(
                                  children: [
                                    const Text(
                                      'Started on: ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        '$startDate',
                                        //  DateFormat('d MMM y').format(active.startDate),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      'End date: ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        '$endDate',
                                         //  DateFormat('d MMM y').format(active.startDate),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 49, right: 8,),
                            child: Column(
                              children: [
                                Container(
                                  // height: 20,
                                  width: 60,
                                  margin: const EdgeInsets.only(top: 10),
                                  child:  const Center(
                                    child:  Text(
                                      'Plan Name: ',
                                      style: TextStyle(
                                        fontSize: 8,
                                        color: Color(0xFF60B47B),
                                        fontWeight: FontWeight.w500
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                  width: 60,
                                  // margin: const EdgeInsets.only( bottom: 30),
                                  child: Center(
                                    child:  Text(
                                      frequency,
                                      // active.frequency,
                                      style: const TextStyle(
                                        fontSize: 8,
                                        color: Color(0xFF60B47B),
                                        fontWeight: FontWeight.w500
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 20,
                                  margin: const EdgeInsets.only( bottom: 30),
                                  child: Center(
                                    child:  Text(
                                      status,
                                      // active.status,
                                      style: const TextStyle(
                                        fontSize: 8,
                                        color: Color(0xFF60B47B),
                                        fontWeight: FontWeight.w500
                                      ),
                                    ),
                                  ),
                                ),
                                isSubscriptionCanceled
                                  ? GestureDetector(
                                    onTap: () {
                                      resumeSub();
                                    },
                                    child: Container(
                                        height: 30,
                                        width: 70,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: Colors.black87)),
                                        child: const Center(
                                          child: Text(
                                            'Resume',
                                            style: TextStyle(fontWeight: FontWeight.w300),
                                          ),
                                        ),
                                      ),
                                  )
                                  : Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            deletSub();
                                            cancelSub();
                                          },
                                          child: Container(
                                            height: 30,
                                            width: 70,
                                            decoration: BoxDecoration(
                                              // color: Colors.pink.shade100,
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(color: Colors.black87)
                                            ),
                                            child: const Center(
                                              child: Text(
                                                'Cancel',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w300
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 15,),
                                        GestureDetector(
                                          onTap: () {
                                            // if (details.plan == 'Custom') {
                                            //   customChange(context, details);
                                            // }else if (details.plan == 'Weekdays') {
                                            //   weekDayChange(context, details);
                                            // }else if (details.plan == 'Everyday') {
                                            //   everyDayChange(context, details);
                                            // }
                                            // if (active.frequency == 'Custom') {
                                            //   customChange(context, details);
                                            // }else if (active.frequency  == 'Weekdays') {
                                            //   weekDayChange(context, details);
                                            // }else if (active.frequency  == 'Everyday') {
                                            //   everyDayChange(context, details);
                                            // }
                                          },
                                          child: Container(
                                            height: 30,
                                            width: 70,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(color: Colors.black87)
                                            ),
                                            child: const Center(
                                              child: Text(
                                                'Edit',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w300
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                    
                                      ],
                                    )
                              ],
                            ),
                          )
                        ],
                      ),   
                      Container(
                        height: 100,
                        // width: 00,
                        margin: const EdgeInsets.only(top: 8, ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: List.generate(
                              subscriptionResponses.length, (index) => Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 90,
                                    width: 118,
                                    margin: const EdgeInsets.only(left: 10),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF60B47B),
                                      borderRadius: BorderRadius.circular(8)
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(left: 4, top: 4),
                                          child: Text(
                                            // day name
                                            '${subscriptionResponses[index].day} ',
                                             // active.frequencyMobData[index].day,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16
                                            ),
                                          )
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(left: 4, top: 4),
                                          child: Row(
                                            children: [
                                              const Text(
                                                'Morning: ',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 12
                                                ),
                                              ),
                                              Text(
                                                // mrng quantity
                                                '${subscriptionResponses[index].morningQuantity} ',
                                                // '${active.frequencyMobData[index].mrgQuantity}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 14
                                                ),
                                              ),
                                            ],
                                          )
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(left: 4, top: 4),
                                          child: Row(
                                            children: [
                                              const Text(
                                                'Evening: ',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 12
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  // eveng quantity
                                                  '${subscriptionResponses[index].eveningQuantity} ',
                                                //  '${active.frequencyMobData[index].evgQuantity}',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 14
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        )
                                      ],
                                    ),
                                    // if (index < length - 1) SizedBox(width: 16)
                                  )
                                ],
                              )
                            ),
                          ),
                        ),
                      )
                      ],
                    ),
                  ),
                );
  
              },
            ),
          ),
          Container(
            height: 35,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent.withOpacity(0.2),
                  Colors.transparent.withOpacity(0.1),
                  Colors.transparent.withOpacity(0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter
              ),
            ),
            child: Row(
              children: [
                tabTitle('Subscription'),
                const SizedBox(width: 140,),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SubHistory(),));
                  },
                  child: const Icon(Icons.history, color: Colors.black54,),
                )
              ],
            ),
          ),
        
        ],
      ),
    );
  }

  void activeSub() async {
    Map<String, dynamic> userData = {
      'customer_id': UserId.getUserId()
    };
    String jsonData = json.encode(userData);
    String encryptedData = encryptAES(jsonData);
    print('Encrypted: $encryptedData');
    String url = 'http://pasumaibhoomi.com/api/activesubscription';
    final response = await http.post(Uri.parse(url), body: {'data' : encryptedData});
    if(response.statusCode == 200){
      print('Success: ${response.statusCode}');
      print('Success: ${response.body}');
      String decryptedData = decryptAES(response.body);
      print('Decrypted: $decryptedData');
      final responseJson = json.decode(decryptedData);
      setState(() {
        activesubscriptions = SubscriptionHistoryRes.fromJson(responseJson);
      });
    
    }else{
      print('Success: ${response.body}');
    }
  }
  
  // delete sub api
  void deletSub() async {
    Map<String, dynamic> userData = {
      'sub_id': UserId.getSubId()
    };
    String jsonData = json.encode(userData);
    String encryptedData = encryptAES(jsonData);
    print('Encrypted: $encryptedData');
    String url = 'http://pasumaibhoomi.com/api/deletesubscription';
    final response = await http.post(Uri.parse(url), body: {'data' :  encryptedData});

    if(response.statusCode == 200){
      print('Success: ${response.statusCode}');
      print('Success: ${response.body}');
    }else{
      print('Success: ${response.body}');
    }
  }
  
  bool isSubscriptionCanceled = false;

  void cancelSub() {
    // Perform cancellation logic here
    setState(() {
      isSubscriptionCanceled = true;
    });
  }

  void resumeSub() {
    // Perform resumption logic here
    setState(() {
      isSubscriptionCanceled = false;
    });
  }


}


