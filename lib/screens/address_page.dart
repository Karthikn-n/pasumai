// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:app_3/screens/bottom_bar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/encrypt_ids.dart';
import '../widgets/screen_widgets.dart';
import 'package:http/http.dart' as http;

class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
    // late FocusNode _focusNode;
  TextEditingController flatController = TextEditingController();
  TextEditingController floorController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController landmarkController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  String? selectedRegion;
  String? selectedTown;
  List<String> chennaiTowns = ['T.Nagar', 'Guindy', 'Perungudi', /* Add more towns as needed */];
  List<String> maduraiTowns = ['Mattudhavani', 'Periyar', 'Alagar Kovil', /* Add more towns as needed */];

  late StreamSubscription<ConnectivityResult> connectivitySubscription;
  late ConnectivityResult _isConnected;
  @override
  void initState() {
    super.initState();
    // initialise the connectivity status and session time
    _isConnected = ConnectivityResult.none;
    _loadConnectivityFromCache();
    checkConnectivity();
    // change connectivity changes according to the internet changes
    connectivitySubscription = Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        _isConnected = result;
        _saveConnectivityToCache();
      });
    });
  }
   void _loadConnectivityFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedConnectivity = prefs.getString('signup');
    if (cachedConnectivity != null) {
      setState(() {
        _isConnected = ConnectivityResult.values.byName(cachedConnectivity);
      
      });
    } else {
      checkConnectivity(); // Check if cache is empty
    }
  }

   void _saveConnectivityToCache() async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('signup', _isConnected.name);
    prefs.setString('lastsignup', DateTime.now().toIso8601String());
  }

  // initial check of the connectivity
  void checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = connectivityResult;
      _saveConnectivityToCache();
    });
  }

  // restart the session time


final _formKey = GlobalKey<FormState>();

  String flatNumber = '';
  String floor = '';
  String address = '';
  String landmark = '';
  String pincode = '';
  @override
 @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    if (_isConnected == ConnectivityResult.mobile || _isConnected == ConnectivityResult.wifi) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          height: screenWidth > 600 ? screenHeight * 1.8 : screenHeight * 1,
          color: Colors.white,
          child: Stack(
            children: [
                // appbar
              customAppbar('Address'),
              Container(
                height: 620,
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.only(top: screenWidth > 600 
                  ? screenHeight * 0.18 
                  : screenHeight * 0.11 ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: screenWidth > 600 ? screenHeight * 0.6 : screenHeight * 0.01),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Give your address',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5
                              ),
                          ),
                          Text(
                            "This'll be your delivery address",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300,),
                          ),
                        
                        ],
                      )
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          buildFormField(
                            hintText: 'Enter Flat Number',
                            icon: Icons.home,
                            controller: flatController,
                            textInputAction: TextInputAction.next,
                            onChanged: (value) => setState(() => flatNumber = value),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter flat number';
                              }
                              return null;
                            },
                          ),
                          buildFormField(
                            hintText: 'Enter the Floor',
                            icon: Icons.layers,
                            controller: floorController,
                            textInputAction: TextInputAction.next,
                            onChanged: (value) => setState(() => floor = value),
                          ),
                          buildFormField(
                            hintText: 'Enter your Address',
                            textInputAction: TextInputAction.next,
                            controller: addressController,
                            icon: Icons.location_on,
                            onChanged: (value) => setState(() => address = value),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your address';
                              }
                              return null;
                            },
                          ),
                          buildFormField(
                            hintText: 'Enter near by landmark',
                            icon: Icons.location_city,
                            controller: landmarkController,
                            textInputAction: TextInputAction.done,
                            onChanged: (value) => setState(() => landmark = value),
                          ),
                          buildFormField(
                            hintText: 'Enter your Pincode',
                            icon: Icons.phone_android_rounded,
                            controller: pincodeController,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            onChanged: (value) => setState(() => pincode = value),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter pincode';
                              } else if (value.length != 6) {
                                return 'Pincode must be 6 digits';
                              }
                              return null;
                            },
                          ),
                          
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          height: 40,
                          width: 130,
                          margin:  EdgeInsets.only(left: screenWidth > 600 ? screenHeight * 0.569 : screenHeight * 0.04 , top: 8, bottom: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300, // Border color for the container
                            borderRadius: BorderRadius.circular(8.0), // Rounded corners
                          ),
                          child: Center(
                            child: DropdownButton<String>(
                              value: selectedRegion,
                              elevation: 0,
                              hint: const Text('Select Region'),
                              style: const TextStyle(color: Colors.black), // Text color
                              underline: Container(),
                              dropdownColor: Colors.grey.shade200,
                              alignment: Alignment.center,
                              onChanged: (value) {
                                setState(() {
                                  selectedRegion = value;
                                  selectedTown = null; // Reset town to null when region changes
                                });
                              },
                              // locations['name'].
                              items: [null, 'Chennai', 'Madurai'].map((region) {
                                return DropdownMenuItem<String>(
                                  value: region,
                                  child: Text(region ?? 'Select Region'), 
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 35,),
                      // Town Dropdown if only display any one of region is selected
                          if (selectedRegion != null && selectedRegion!.isNotEmpty)
                        Container(
                              height: 40,
                              width: 130,
                              padding: const EdgeInsets.only(left: 14, right: 4),
                              margin: const EdgeInsets.only(left: 10, right: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300, // Border color for the container
                                borderRadius: BorderRadius.circular(8.0), // Rounded corners
                              ),
                              child: DropdownButton<String>(
                                value: selectedTown,
                                iconDisabledColor: Colors.transparent.withOpacity(0.0),
                                style: const TextStyle(color: Colors.black),
                                hint: const Text('Select Town'),
                                underline: Container(),
                                dropdownColor: Colors.grey.shade200,
                                alignment: Alignment.center,
                                onChanged: (value) {
                                  setState(() {
                                    selectedTown = value;
                                  });
                                },
                                items: (selectedRegion == 'Chennai' ? chennaiTowns : maduraiTowns)
                                    .map((town) {
                                  return DropdownMenuItem<String>(
                                    value: town,
                                    child: Text(town),
                                  );
                                }).toList(),
                              ),
                            ),
                      
                      ],
                    ),
                    GestureDetector(
                      onTap: (){
                        sendData();
                        Navigator.of(context).push(_createhomeRoute());
                      },
                      child: Center(
                        child: buttons("Let's Shopping")
                      )
                    )
                  ],
                ),
                ),     
              ],
            ),
          )
        )
      );    
    } else {
      return Scaffold(
        appBar: cartAppBar(context),
        body: Center(
          child: Image.asset('assets/category/nointernet.png'),
        ),
      );
    }
  } 
   
  
  PageRouteBuilder _createhomeRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const BottomBar(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOutCirc;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      var offsetAnimation = animation.drive(tween);

      return SlideTransition(position: offsetAnimation, child: child);
    },
    settings: const RouteSettings(
      arguments: {'selectedIndex' : 0}
    )
  );
}

  void saveUserData(Map<String, dynamic> userData) async {
    final pref = await SharedPreferences.getInstance();
    final jsonData = json.encode(userData);
    pref.setString('userData', jsonData);
  }
  void sendData() async {
    Map<String, dynamic> userData = {
      'customer_id' : UserId.getUserId(),
      'flat_no' : flatController.text,
      'address' : addressController.text,
      'floor' : floorController.text,
      'landmark': landmarkController.text,
      'region': selectedRegion,
      'location': selectedTown,
      'pincode': pincodeController.text,
    };
    saveUserData(userData);

    String jsonData = json.encode(userData);
    print('JSON Data: $jsonData');
    String encryptedUserData = encryptAES(jsonData);
    print('Encrypted data: $encryptedUserData');

    String url = 'http://pasumaibhoomi.com/api/addaddress';

    final response = await http.post(Uri.parse(url), body: {'data': encryptedUserData});
    print('SuccessCode: ${response.statusCode}');
    if (response.statusCode == 200)  {
      print('Success: ${response.body}');
    }else{
      print('Error: ${response.body}');
    }

  }
  
}