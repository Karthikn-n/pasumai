// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:app_3/data/encrypt_ids.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class VacationEntry {
  int? vacationId; 
  final DateTime startsOn;
  final DateTime? endsOn;

  VacationEntry({required this.vacationId ,required this.startsOn, this.endsOn});
}

class VaccationMode extends StatefulWidget {
  // ignore: use_super_parameters
  const VaccationMode({Key? key}) : super(key: key);

  @override
  State<VaccationMode> createState() => _VaccationModeState();
}

class _VaccationModeState extends State<VaccationMode> {
  List<VacationEntry> vacationEntries = [];
  int? userId = UserId.getUserId();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 320,
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 40),
              child: buildVaccationList(context)
            ),
            // Container(
            //   height: 109,
            // ),
            GestureDetector(
              onTap: () async {
                DateTime startsOn = DateTime.now();
                DateTime? endsOn;
                int? vacationId;
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  builder: (context) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      height: 300,
                      width: double.infinity,
                      child: Column(
                        children: [
                          Container(
                            width: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            margin: const EdgeInsets.only(top: 20),
                            child: const Divider(
                              thickness: 3,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 50),
                          Row(
                            children: [
                              const SizedBox(width: 40),
                              buildDatePicker(
                                context,
                                'Starts On',
                                startsOn,
                                (DateTime? date) {
                                  setState(() {
                                    startsOn = date!;
                                  });
                                },
                              ),
                              const SizedBox(width: 100),
                              buildDatePicker(
                                context,
                                'Ends On',
                                endsOn,
                                (DateTime? date) {
                                  setState(() {
                                    endsOn = date;
                                  });
                                },
                              ),
                              const SizedBox(height: 20),
                              if (endsOn != null)
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      endsOn = null;
                                    });
                                  },
                                  child: const Icon(
                                    Icons.cancel,
                                    color: Colors.red,
                                    size: 30,
                                  ),
                                ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () async{
                              // ignore: unnecessary_null_comparison
                              if(startsOn != null){
                                Map<String, dynamic> userData = {
                                  "customer_id" : userId,
                                  "start_date" : startsOn.toIso8601String(),
                                  "end_date" : endsOn?.toIso8601String() ?? '',
                                  };
                                  final jsonData = json.encode(userData);
                                  final encryptData = encryptAES(jsonData);
                                  String url = 'http://pasumaibhoomi.com/api/addvacation';
                                  final response = await http.post(Uri.parse(url), body: {"data" : encryptData});
                                  print('SuccessCode: ${response.statusCode}');
                                  if(response.statusCode == 200) {
                                    print('Success: ${response.body}');
                                  } else {
                                    print('Failed: ${response.body}');
                                  }
                                vacationEntries.add(
                                  VacationEntry(startsOn: startsOn, endsOn: endsOn, vacationId: vacationId)
                                );
                                // ignore: use_build_context_synchronously
                                Navigator.of(context).pop();
                                setState(() {});
                              }
                            },
                            child: Container(
                              height: 40,
                              width: 240,
                              margin: const EdgeInsets.only(top: 48),
                              // alignment: Alignment.bottomCenter,
                              decoration: BoxDecoration(
                                color: const Color(0xFF60B47B),
                                borderRadius: BorderRadius.circular(8)
                              ),
                              child: const Center(
                                child: Text(
                                  'Add vacation',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );    
              },
              child: Container(
                height: 40,
                width: 350,
                margin: const EdgeInsets.only(left: 5),
                // alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                  color: const Color(0xFF60B47B),
                  borderRadius: BorderRadius.circular(8)
                ),
                child: const Center(
                  child: Text(
                    'Add vacation +',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white
                    ),
                  ),
                ),
              ),
            ),
          
          ],
        ),
      );

  }

  // date picker
  Widget buildDatePicker(
    BuildContext context,
    String labelText,
    DateTime? selectedDate,
    Function(DateTime?) onDateSelected,
  ) {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            final DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: selectedDate ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            if (pickedDate != null && pickedDate != selectedDate) {
              onDateSelected(pickedDate);
            }
          },
          child: Column(
            children: [
              Text(
                labelText,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600
                ),
              ),
              const SizedBox(height: 20,),
              Text(
                selectedDate != null
                    ? "${selectedDate.toLocal()}".split(' ')[0]
                    : 'Optional',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  // vaction list api
  void vacationList() async {
    Map<String, dynamic> userData = {"customer_id" : userId};
    String jsonData = json.encode(userData);
    String encryptedData = encryptAES(jsonData);

    String apiURL = 'http://pasumaibhoomi.com/api/vacationlist';

    final response = await http.post(Uri.parse(apiURL), body : {'data' : encryptedData});
    print('SuccessCode: ${response.statusCode}');
    if(response.statusCode == 200) {
      print('Success: ${response.body}');
      String decryptedData = decryptAES(response.body);
      // decryptedData = decryptedData.replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '');
      // debugPrint("Decrypted Response: $decryptedData".toString(), wrapWidth: 1024) ;
      print('Decrypted Dat: $decryptedData');
      final responseJson = json.decode(decryptedData);
      print('Response: $responseJson');
      final results = responseJson["results"];
      vacationEntries.clear();
      print(results);
      for (var result in results) {
        int vacationId = result["vacation_id"];
        DateTime startsOn = DateTime.parse(result["start_date"]);
        DateTime? endsOn = result["end_date"] != null
            ? DateTime.parse(result["end_date"])
            : null;

        vacationEntries.add(VacationEntry(vacationId: vacationId, startsOn: startsOn, endsOn: endsOn));
      }
      setState(() {});
      // print("OTP Sent");
    }
  }
  // vaction list
  Widget buildVaccationList(BuildContext context){
    return ListView.builder(
      itemCount: vacationEntries.length,
      itemBuilder: (context, index) {
        VacationEntry entry = vacationEntries[index];
        String formattedStartsOn = DateFormat.yMMMd().format(entry.startsOn);
        String formattedEndsOn = entry.endsOn != null ? DateFormat.yMMMd().format(entry.endsOn!) : '';
        return Container(
            height: 110,
            width: 320,
            margin: const EdgeInsets.only(left: 10, right: 10, top: 15),
            decoration: BoxDecoration(
              color: const Color(0xFFEBEBEB),
              borderRadius: BorderRadius.circular(8)
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 35, top: 25, bottom: 5),
                      child: const Text('Starts on'),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 35, top: 10),
                      child: Text(formattedStartsOn),
                    )
                  ],
                ),
                // Text('='),
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 30, top: 25, bottom: 5),
                      child: const Text('Ends on'),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 30, top: 10),
                      child: Text(formattedEndsOn),
                    )
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  height: 80,
                  child: const VerticalDivider(
                    color: Colors.black54,
                    thickness: 2,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20, left: 15),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          int? vactionId = vacationEntries[index].vacationId;
                          DateTime startsOn = vacationEntries[index].startsOn;
                          DateTime? endsOn = vacationEntries[index].endsOn;
                          showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                            builder: (context) {
                              return SizedBox(
                                height: 300,
                                width: double.infinity,
                                child: Column(
                                  children: [
                                    Container(
                                      width: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      margin: const EdgeInsets.only(top: 20),
                                      child: const Divider(
                                        thickness: 3,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    const SizedBox(height: 50),
                                    Row(
                                      children: [
                                        const SizedBox(width: 40),
                                        buildDatePicker(
                                          context,
                                          'Starts On',
                                          startsOn,
                                          (DateTime? date) {
                                            setState(() {
                                              startsOn = date!;
                                            });
                                          },
                                        ),
                                        const SizedBox(width: 100),
                                        buildDatePicker(
                                          context,
                                          'Ends On',
                                          endsOn,
                                          (DateTime? date) {
                                            setState(() {
                                              endsOn = date;
                                            });
                                          },
                                        ),
                                        const SizedBox(height: 20),
                                        if (endsOn != null)
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                endsOn = null;
                                              });
                                            },
                                            child: const Icon(
                                              Icons.cancel,
                                              color: Colors.red,
                                              size: 30,
                                            ),
                                          ),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        // ignore: unnecessary_null_comparison
                                        if (startsOn != null) {
                                          Map<String, dynamic> userData = {
                                            "customer_id" : userId,
                                            "vacation_id" : vactionId,
                                            "start_date" : startsOn.toIso8601String(),
                                            "end_date" : endsOn?.toIso8601String() ?? '',
                                            };
                                            final jsonData = json.encode(userData);
                                            final encryptData = encryptAES(jsonData);
                                            String url = 'http://pasumaibhoomi.com/api/updatevacation';
                                            final response = await http.post(Uri.parse(url), body: {"data" : encryptData});
                                            print('SuccessCode: ${response.statusCode}');
                                            if(response.statusCode == 200) {
                                              print('Success: ${response.body}');
                                            } else {
                                              print('Failed: ${response.body}');
                                            }
                                          vacationEntries[index] =
                                              VacationEntry(startsOn: startsOn, endsOn: endsOn, vacationId: vactionId);
                                          // ignore: use_build_context_synchronously
                                          Navigator.of(context).pop();
                                          setState(() {});
                                        }
                                      },
                                      child: Container(
                                        height: 40,
                                        width: 240,
                                        margin: const EdgeInsets.only(top: 48),
                                        decoration: BoxDecoration(
                                            color: const Color(0xFF60B47B),
                                            borderRadius: BorderRadius.circular(8)),
                                        child: const Center(
                                          child: Text(
                                            'Update vacation',
                                            style: TextStyle(
                                                fontSize: 14, color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );

                            },
                          );
                        },
                      child: const Icon(
                        Icons.edit,
                        color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 15,),
                      GestureDetector(
                        onTap: () async {
                          Map<String, dynamic> userData = {
                            "vacation_id" : vacationEntries[index].vacationId,
                            };
                            final jsonData = json.encode(userData);
                            final encryptData = encryptAES(jsonData);
                            String url = 'http://pasumaibhoomi.com/api/deletevacation';
                            final response = await http.post(Uri.parse(url), body: {"data" : encryptData});
                            print('SuccessCode: ${response.statusCode}');
                            if(response.statusCode == 200) {
                              print('Success: ${response.body}');
                            } else {
                              print('Failed: ${response.body}');
                          }
                          deleteVacation(index);
                        },
                      child: const Icon(
                        Icons.delete,
                        color: Colors.black54,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
      },
    );
  }
  
  // delete vacation
  void deleteVacation(int index) {
    // Implement the logic for deleting a vacation entry
    setState(() {
      vacationEntries.removeAt(index);
    });
  }
  // edit vacation

}

