// ignore_for_file: library_private_types_in_public_api, unused_field, avoid_print

// import 'package:app_2/UI/profile/widgets/orderhistory_page.dart';
import 'dart:async';
import 'dart:convert';

import 'package:app_3/screens/edit_profile.dart';
import 'package:app_3/screens/location_list.dart';
import 'package:app_3/screens/order_history.dart';
import 'package:app_3/screens/active_subscription.dart';
import 'package:app_3/screens/vacation_page.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/encrypt_ids.dart';
import '../widgets/screen_widgets.dart';
class ExpansionPanelItem {
  final String name;
  final IconData icon;
  final int index;
  bool isExpanded;

  ExpansionPanelItem(this.name, this.icon, this.index, {this.isExpanded = false});
}
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  // use gloable key to use this state functions to other pages
  static final GlobalKey<_ProfilePageState> profileKey = GlobalKey<_ProfilePageState>();

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
    // listen to the connectivity changes 
  late StreamSubscription<ConnectivityResult> connectivitySubscription;
  late ConnectivityResult _isConnected;
  // Set session time
  late Timer _sessionTime;
  late DateTime _lastCacheTime = DateTime.now();
  // initial check for connectivity
  bool _isInitialCheckDone = false;
  int selectedTabIndex = 0;

  // edit profile content
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  // default profile name
  String name = 'P Ramanujam';
  String email = 'ramanajuam.infinity@gmail.com';
  String mobile = '9876543210';
  Map<String, dynamic> customerData = {};
  String? invoiceNo;
  DateTime? invoicedate; 
  String? invoiceamount; 
  String? invoicestatus; 

  @override
  void initState() {
    super.initState();
    // initialize the connectivity change to none and session time
    _isConnected = ConnectivityResult.none;
    _sessionTime = Timer(const Duration(microseconds: 10), () { });
    _loadConnectivityFromCache();
    checkConnectivity();
    // listen and change the state based on connectivity change on page load
    connectivitySubscription = Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        _isConnected = result;
        _saveConnectivityToCache();
      });
    });
    _restartSessionTimer();
    sendData();
  }
  
  // load the connectivity changes from the caches
  void _loadConnectivityFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedConnectivity = prefs.getString('profile');
    final lastCacheTimeStr = prefs.getString('lastCacheTime');
    if (cachedConnectivity != null) {
      setState(() {
        _isConnected = ConnectivityResult.values.byName(cachedConnectivity);
        _isInitialCheckDone = true;
        if (lastCacheTimeStr != null) {
          _lastCacheTime = DateTime.parse(lastCacheTimeStr);
        }
      });
    } else {
      checkConnectivity(); // Check if cache is empty
    }
  }

  // Save the connectivity changes to the cache for future use
  void _saveConnectivityToCache() async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('profile', _isConnected.name);
    prefs.setString('lastCacheTime', DateTime.now().toIso8601String());
  }

  // check inital connectivity when page loaded 
  void checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = connectivityResult;
      _isInitialCheckDone = true;
      _saveConnectivityToCache();
    });
  }

  // Restart the session time 
  void _restartSessionTimer(){
    _sessionTime.cancel();
    _sessionTime = Timer(const Duration(minutes: 10), () {
      _clearConnectivityCache();
    });
  }

  // clear all the connectivity changes from cache
  void _clearConnectivityCache() async{
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('profile');
  }

  // remove all the data from the memory to avoid memory leaks
  @override
  void dispose() {
    connectivitySubscription.cancel();
    _sessionTime.cancel();
    super.dispose();
  }
 void sendData() async{
    final prefs = await SharedPreferences.getInstance();
    
    Map<String, dynamic> userData = {
      'customer_id': UserId.getUserId(),
      // or
      'customer_id1': prefs.getString('userid')
    };
    String jsonData = json.encode(userData);
    print('JSON Data: $jsonData');
    String encryptedUserData = encryptAES(jsonData);
    print('Encrypted data: $encryptedUserData');
    String url = 'http://pasumaibhoomi.com/connectapi/userprofile';

    final response = await http.post(Uri.parse(url), body: {'data': encryptedUserData});
    print('SuccessCode: ${response.statusCode}');
    if (response.statusCode == 200)  {
      print('Success: ${response.body}');
      String decrptedData =  decryptAES(response.body);
      print('Decrypted Data: $decrptedData');
      final responseJson = json.decode(decrptedData);
      print('Response: $responseJson');
      setState(() {
        customerData = Map<String, dynamic>.from(responseJson['customer_data']);
      });
      // customerData = responseJson['customer_data'];
      
    }else{
      print('Error: ${response.body}');
    }

  }


    List<String> categoriesName = [
    'Your Orders',
    'Your Addresses',
    'Subscription',
    'Invoice Listing',
    'Vacation'
  ];
  List<bool> isCategoryExpanded = List.generate(5, (index) => false);

  final ScrollController _controller = ScrollController();

  // Update the user name from the profile
  void updateUserInfo(String newName, String newEmail, String newMobile) {
    setState(() {
      name = newName;
      email = newEmail;
      mobile = newMobile;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitialCheckDone ) {
      if(_isConnected == ConnectivityResult.mobile || _isConnected == ConnectivityResult.wifi){
        return Scaffold(
            // app bar
          appBar: profileAppBar(context),
          body: SingleChildScrollView(
            controller: _controller,
            child: Column(
              children: [
                Container(
                  color: Colors.green.shade400,
                  height: 140,
                  child: Row(
                    children: [
                      profileDetails(name, email, mobile) ,
                      const SizedBox(width: 45,),
                      Column(
                        children: [
                          Container(
                            margin:const  EdgeInsets.only(top: 20),
                            child: const Icon(
                              Icons.person,
                              size: 72,
                              // color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Container(
                  margin: const EdgeInsets.only(top: 10),
                  height: 510,
                  child: ListView.builder(
                    controller: _controller,
                    itemCount: categoriesName.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Container(
                            width: 330,
                            height: 50,
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
                                          Text(categoriesName[index], style: const TextStyle(fontWeight: FontWeight.w800),),
                                        ],
                                      ),
                                      trailing: Icon(
                                        isCategoryExpanded[index] 
                                        ? Icons.arrow_circle_down_outlined 
                                        : Icons.arrow_circle_right_outlined, 
                                        size: 26, 
                                        color: const Color(0xFF60B47B),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          isCategoryExpanded[index] = !isCategoryExpanded[index];
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          if(isCategoryExpanded[index])
                            Container(
                              height: 320,
                              decoration:  const BoxDecoration(
                                color: Color(0xFFF3F3F3),
                              ),
                              child: profileContent(index, context),
                            )
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        // error image if internet is down
        return Scaffold(
          appBar: profileAppBar(context),
          body: Center(
            child: Image.asset('assets/category/nointernet.png'),
          ),
        );
      }
    } else {
      return Scaffold(
      appBar: profileAppBar(context),
      body: const LinearProgressIndicator(),
      );
    }
  }
  
  // Profile details section
  Widget profileDetails(String name, String email, String mobile){
    return Container(
      margin: const EdgeInsets.only(left: 24, ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 180,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // user name
                  SizedBox(
                    width: 165,
                    child: Text(
                    //  '${customerData['first_name']} ${customerData['last_name']}',
                      name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                  // const SizedBox(width: 4,),
                  // edit icon profile
                  GestureDetector(
                    onTap: () {
                      // edit screen
                      _showCustomDrawer();
                    },
                    child: const Icon(
                      Icons.edit, 
                      size: 12,
                      color: Colors.blue,
                    ),
                  )
                
                ],
              ),
            ),
            const SizedBox(height: 4,),
            // user email and mobile 
            SizedBox(
              width: 210,
              child: Text(
                // customerData['email']
                email,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w400
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              // customerData['mobile_no']
              mobile,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w400
              ),
            )
          ],
        ),
      ),
    );               
  }
  // edit screen
  _showCustomDrawer() async {
    Map<String, dynamic>? result = await Navigator.push(
      context,
      MaterialPageRoute(
      // edit screen
        builder: (context) => EditProfileScreen(name: name, email: email, mobile: mobile),
      ),
    );

    if (result != null) {
      String newName = result['name'];
      String newEmail = result['email'];
      String newMobile = result['mobile'];

      setState(() {
        name = newName;
        email = newEmail;
        mobile = newMobile;
      });
      // change the state based on the edit screen
      ProfilePage.profileKey.currentState?.updateUserInfo(name, email, mobile);
    }
  }

  
  // Select the screen based on the tabs in the page
  Widget profileContent(int selectedTabIndex, BuildContext context){
    switch(selectedTabIndex){
      case 0:
        return const OrderList();
      case 1:
        return const LocationList(title: 'Locations');
      case 2:
        return const SubScriptionList();
      case 3:
        return invoicelistProduct('Invoices');
      case 4:
        return const VaccationMode();
      default: 
        return Container();
    }
  }
  
  //  invoice API
  void getInvoice() async {
    Map<String, dynamic> userData = {
      'customer_id': UserId.getUserId()
    };
    String jsonData = json.encode(userData);
    print('JSON data: $jsonData');
    final encryptedData = encryptAES(jsonData);
    print('Encrypted data: $encryptedData');
    String url = 'http://pasumaibhoomi.com/api/invoicelist';
    final response = await http.post(Uri.parse(url), body: {'data': encryptedData});
    if (response.statusCode == 200)  {
        print('Success: ${response.body}');
        String decrptedData =  decryptAES(response.body);
        print('Decrypted Data: $decrptedData');
        final responseJson = json.decode(decrptedData);
        print('Response: $responseJson');
        invoiceNo = responseJson['invoice_no'];
        invoicedate = responseJson['invoice_date'];
        invoiceamount = responseJson['amount'];
        invoicestatus = responseJson['status'];
    }else{
      print('Error: ${response.body}');
    }
  }
  // invoice list
  Widget invoicelistProduct(String title){
    final DateTime date = DateTime(2024, 01, 01);
    String formatedDate = DateFormat('d MMM y').format(date);
    // String formatedDate = DateFormat('d MMM y').format(invoicedate!);
    return SingleChildScrollView(
      child: Stack(
        children: [
          // tabTitle(title),
          Container(
            margin: const EdgeInsets.only(top: 30),
            decoration: BoxDecoration(
              color: Colors.transparent.withOpacity(0.0)
            ),
            height: 290,
            child: ListView.builder(
              itemCount: 4,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(left: 12, right: 12, bottom: 10),
                  height: 120,
                  width: 210,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBEBEB),
                    borderRadius: BorderRadius.circular(8)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // invoice id
                      Container(
                        margin: const EdgeInsets.only(top: 8, left: 8),
                        // invoice id
                        child: Row(
                          children: [
                            const Text(
                              'Invoice id: ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '$invoiceNo'
                                'IND_004',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 12),
                                child: const Row(
                                  children: [
                                    Text(
                                      'Download',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF60B47B)
                                      ),
                                    ),
                                    SizedBox(width: 4,),
                                    Icon(
                                      Icons.download,
                                      size: 14,
                                      color: Color(0xFF60B47B),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        )
                      ),
                      const SizedBox(
                        width: double.infinity,
                        child: Divider(
                          thickness: 1,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 6,),
                      Row(
                        children: [
                          SizedBox(
                            width: 231,
                            child: Column(
                              children: [
                                // In voice date
                                Container(
                                  margin: const EdgeInsets.only(left: 8),
                                  // In voice date
                                  child: Row(
                                    children: [
                                    const Text(
                                      'Invoice date: ',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400
                                      ),
                                    ),
                                    Expanded(
                                        child: Text(
                                          // '$formatedDate'
                                          formatedDate,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 6,),
                                // Invoice amount
                                Container(
                                  height: 40,
                                  margin: const EdgeInsets.only(left: 8),
                                  child: Row(
                                    children: [
                                    const Text(
                                      'Invoice Amount: ',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400
                                      ),
                                    ),
                                    Expanded(
                                        child: Text(
                                          '$invoiceamount'
                                          'Rs.400',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '$invoicestatus'
                              'Pending',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue.shade200
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            height: 35,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient:  LinearGradient(
                colors: [
                  Colors.transparent.withOpacity(0.2),
                  Colors.transparent.withOpacity(0.1),
                  Colors.transparent.withOpacity(0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter
              ),
            ),
            child: tabTitle(title),
          ),
        ],
      ),
    );
  }


}


