// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:app_3/screens/otp_page.dart';
import 'package:app_3/screens/signin_page.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/encrypt_ids.dart';
import '../widgets/screen_widgets.dart';
import 'package:http/http.dart' as http;

class RegisterationPage extends StatefulWidget {
  const RegisterationPage({super.key});

  @override
  State<RegisterationPage> createState() => _RegisterationPageState();
}

class _RegisterationPageState extends State<RegisterationPage> {
    // late FocusNode _focusNode;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String firstName = '';
  String lastName = '';
  String email = '';
  String mobile = '';

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

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final RegExp nameRegex = RegExp(r'^[a-zA-Z]+$');
    final RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

    if (_isConnected == ConnectivityResult.mobile || _isConnected == ConnectivityResult.wifi) {
      return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          color: Colors.white,
          child: Stack(
            children: [
              // appbar
              customAppbar('Register'),
              Container(
                height: screenWidth > 600 ? screenHeight * 1.3 : screenHeight * 0.8,
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.only(top:  screenWidth > 600 
                  ? screenHeight * 0.18 
                  : screenHeight * 0.11),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: screenWidth > 600 ? screenHeight * 0.6 : screenHeight * 0.01),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Welcome !',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5
                              ),
                          ),
                          Row(
                            children: [
                              const Text(
                                'Crate an account',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300,),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(_createSigninRoute());
                                },
                                child: const Text(
                                  ' or Sign in',
                                  style: TextStyle(
                                    fontSize: 16, 
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF60B47B)
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          buildFormField(
                            hintText: 'Enter your first name',
                            icon: Icons.person_2_rounded,
                            textInputAction: TextInputAction.next,
                            controller: firstNameController,
                            onChanged: (value) => setState(() => firstName = value),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your first name';
                              }
                              if (!nameRegex.hasMatch(value)) {
                                return 'First name can only contain letters';
                              }
                              return null;
                            },
                          ),
                          buildFormField(
                            hintText: 'Enter your last name',
                            icon: Icons.person_2_rounded,
                            controller: lastNameController,
                            textInputAction: TextInputAction.next,
                            onChanged: (value) => setState(() => lastName = value),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter last name';
                              }
                              if (!nameRegex.hasMatch(value)) {
                                return 'Last name can only contain letters';
                              }
                              return null;
                            },
                          ),
                          buildFormField(
                            hintText: 'Enter your email',
                            textInputAction: TextInputAction.next,
                            controller: emailController,
                            icon: Icons.email_rounded,
                            onChanged: (value) => setState(() => email = value),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!emailRegex.hasMatch(value)) {
                                return  'Please enter a valid email address';
                              }
                              return null;
                            },
                          ),
                          buildFormField(
                            hintText: 'Enter your Mobile number',
                            icon: Icons.phone_android_rounded,
                            controller: mobileController,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.phone,
                            onChanged: (value) => setState(() => mobile = value),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter mobile number';
                              }
                              return null;
                            },
                          ),
                          
                        ],
                      ),
                    ),
                
                    // signup button
                    GestureDetector(
                      onTap: (){
                        // if (_formKey.currentState!.validate()) {
                        sendData();
                        Navigator.of(context).push(_createRoute());
                        // }
                      },
                      child: Center(
                        child: buttons('Signup')
                      )
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
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
  
  PageRouteBuilder _createSigninRoute() {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const LoginPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCirc;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          var offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
      );
    }
 
   
  PageRouteBuilder _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const OtpPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOutCirc;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      var offsetAnimation = animation.drive(tween);

      return SlideTransition(position: offsetAnimation, child: child);
    },
    // Pass the arguments to the OTP page
    settings: RouteSettings(
      arguments: {'mobile': mobileController.text, 'source': 'register'},
    ),
  );
}
 
  void saveUserData(Map<String, dynamic> userData) async {
    final pref = await SharedPreferences.getInstance();
    final jsonData = json.encode(userData);
    pref.setString('userData', jsonData);
  }
  void sendData() async {
    Map<String, dynamic> userData = {
      'first_name' : firstNameController.text,
      'last_name' : lastNameController.text,
      'email' : emailController.text,
      'phone_no': mobileController.text
    };
    saveUserData(userData);

    String jsonData = json.encode(userData);
    print('JSON Data: $jsonData');
    String encryptedUserData = encryptAES(jsonData);
    print('Encrypted data: $encryptedUserData');

    String url = 'http://pasumaibhoomi.com/api/userregister';

    final response = await http.post(Uri.parse(url), body: {'data': encryptedUserData});
    print('SuccessCode: ${response.statusCode}');
    if (response.statusCode == 200)  {
      print('Success: ${response.body}');
      String decrptedData =  decryptAES(response.body);
      print('Decrypted Data: $decrptedData');
      final responseJson = json.decode(decrptedData);
      print('Response: $responseJson');
      int userId = responseJson['user_id'];
      print('User Id: $userId');
      // Save user Id in two ways
      final prfs = await SharedPreferences.getInstance();
      prfs.setInt('userid', userId);
      UserId.setUserId(userId);
    }else{
      print('Error: ${response.body}');
    }

  }
  
}

