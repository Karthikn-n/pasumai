// ignore_for_file: avoid_print
import 'dart:convert';

import 'package:app_3/data/response_data.dart';
import 'package:app_3/screens/active_subscription.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


import '../data/encrypt_ids.dart';


class SubHistory extends StatefulWidget {
  const SubHistory({super.key});

  @override
  State<SubHistory> createState() => _SubHistoryState();
}

class _SubHistoryState extends State<SubHistory> {
  List<SubscriptionResponse> subscriptionResponses = [];
  String frequency ='';
  String subAmount ='';
  String status ='';
  DateTime? startDate;
  DateTime? endDate;
  late SubscriptionHistoryRes historyRes = SubscriptionHistoryRes(results: []);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: historyBar(context),
      extendBody: true,
      
      body: SizedBox(
        height: 640,
        child: ListView.builder(
          // itemCount: historyRes.results.length,
          itemCount: details.length,
          itemBuilder: (context, index) {
            // SubscriptionHistory history = historyRes.results[index];
            SubscriptionDetails subscriptionDetails = detailsNotifier.details[index];
            return Container(
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
                              // history.productName
                              subscriptionDetails.productName,
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
                                    // 'RS. ${history.productPrice}',
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
                                    //  DateFormat('d MMM y').format(history.startDate)
                                    // formattedDate,
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
                                    //  DateFormat('d MMM y').format(history.endDate),
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
                              margin: const EdgeInsets.only(top: 2),
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
                                  // history.frequency,
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
                              child: const Center(
                                child:  Text(
                                  // history.status,
                                  'details.plan',
                                  style: TextStyle(
                                    fontSize: 8,
                                    color: Color(0xFF60B47B),
                                    fontWeight: FontWeight.w500
                                  ),
                                ),
                              ),
                            ),
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
                          // history.frequencyMobData.length, (index) => Row(
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
                                        // history.frequencyMobData[index].day,
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
                                            // '${history.frequencyMobData[index].mrgQuantity}',
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
                                              // '${history.frequencyMobData[index].evgQuantity}',
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
    );
  }

  void subHistory() async {
    Map<String, dynamic> userData = {
      'customer_id': UserId.getUserId()
    };
    String jsonData = json.encode(userData);
    String encryptedData = encryptAES(jsonData);
    print('Encrypted: $encryptedData');
    String url = 'http://pasumaibhoomi.com/api/subscriptionhistory';
    final response = await http.post(Uri.parse(url), body: {'data' : encryptedData});
    if(response.statusCode == 200){
      print('Success: ${response.statusCode}');
      print('Success: ${response.body}');
      String decryptedData = decryptAES(response.body);
      print('Decrypted: $decryptedData');
      final responseJson = json.decode(decryptedData);
      setState(() {
        historyRes = SubscriptionHistoryRes.fromJson(responseJson);
      });
      // frequency = responseJson['frequency'];
      // subAmount = responseJson['amount'];
      // status = responseJson['status'];
      // startDate = responseJson['start_date'];
      // endDate = responseJson['end_date'];
      // List<dynamic> quantitiesResponse = responseJson['quantity'];
      // subscriptionResponses = quantitiesResponse.map((json) {
      //  return SubscriptionResponse.fromJson(json);
      // }).toList();
    }else{
      print('Success: ${response.body}');
    }
  }
  


}
  // app bar widget
  PreferredSizeWidget historyBar(BuildContext context){
    return AppBar(
      title: const Text(
        'History',
        style: TextStyle(
          fontSize: 16
        ),
      ),
      centerTitle: true,
      surfaceTintColor: Colors.transparent,
      // backgroundColor: Colors.white
      elevation: 0,
    );     
  }
