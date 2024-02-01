// ignore_for_file: unused_field, avoid_print

// import 'dart:async';
// import 'dart:convert';

import 'dart:async';
import 'dart:convert';

import 'package:app_3/data/encrypt_ids.dart';
import 'package:app_3/screens/registration_page.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

// import '../../data/encrypt.dart';
// import '../../data/user_id.dart';
import '../widgets/screen_widgets.dart';
import 'otp_page.dart';


class LoginPage extends StatefulWidget{
  const LoginPage({super.key});
  
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
   // It listen to the connectivity changes in this page
  late StreamSubscription<ConnectivityResult> connectivitySubscription;
  // Hold current status
  late ConnectivityResult _isConnected;
  double loginContainerMargin = 0;
  // This hold current state of the text field foucs
  late FocusNode _focusNode;
  TextEditingController mobileController = TextEditingController();
  String mobile = '';
  final _key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // set connectivity as none
    _isConnected = ConnectivityResult.none;
    // listen to the change and set the connection based on result
    checkConnectivity();
      // Initialize the foucsnode
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        // If Keyboard is visible, move login container up
        _animateLoginContainer(-194.0);
      } else {
        //If  Keyboard is not visible, move login container down
        _animateLoginContainer(0.0);    // this.image, 
      }
    });

  }
  Future<void> checkConnectivity() async {
    ConnectivityResult result = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = result;
    });
  }

  @override
  void dispose() {
    // remove them for avoid memory leaks
    connectivitySubscription.cancel();
    _focusNode.dispose();
    super.dispose();
  }

// set the margin of the container based on foucs node
  void _animateLoginContainer(double margin) {
    setState(() {
      loginContainerMargin = margin;
    });
  }

 final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  final RegExp mobileRegex = RegExp(r'^[0-9]{10}$');
  @override
  Widget build(BuildContext context) {
     double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    // if (_isConnected == ConnectivityResult.mobile || _isConnected == ConnectivityResult.wifi) {
      return Scaffold(
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: Stack(
            children: [
              // app bar
            customAppbar('Welcome'),
            //Login content
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.only(top:  screenWidth > 600 
                    ? screenHeight * 0.18 
                    : screenHeight * 0.11
                  ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Heading of the login page
                    Container(
                      margin: EdgeInsets.only(left: screenWidth > 600 ? screenHeight * 0.58 : screenHeight * 0.01),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Welcome back !',
                            style: TextStyle(
                              fontSize: 32, 
                              fontWeight: FontWeight.w600,
                              letterSpacing: - 0.5
                            ),
                          ),
                          Row(
                            children: [
                              const Text(
                                'Sign in to your account',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300,),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(_createSignupRoute());
                                },
                                child: const Text(
                                  ' or Sign up',
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
                    const SizedBox(height: 8,),
                    // phone text field
                    Form(
                      key: _key,
                      child: buildFormField(
                        hintText: 'Enter your mobile number',
                        icon: Icons.phone,
                        textInputAction: TextInputAction.send,
                        controller: mobileController,
                        onChanged: (value) => setState(() => mobile = value),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your mobile name';
                          }
                          if (emailRegex.hasMatch(value)) {
                            return null; 
                          } else if (mobileRegex.hasMatch(value)) {
                            return null; 
                          } else {
                            return 'Invalid email or mobile number';
                          }
                        },
                      ),
                    ),
                    // Move to the other page and remove this page from the memory to avoid revoke
                    GestureDetector(
                      onTap: (){
                        // if (_key.currentState!.validate()) {
                          sendRequest();
                          Navigator.of(context).push(_createRoute());
                        // }
                      },
                      child: Center(
                        child: buttons('Login')
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
    // } else {
    //   return Scaffold(
    //     appBar: cartAppBar(context),
    //     body: Center(
    //       child: Image.asset('assets/category/nointernet.png'),
    //     ),
    //   );
    // }
  }
  
  PageRouteBuilder _createSignupRoute() {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const RegisterationPage(),
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
        arguments: {'mobile': mobileController.text, 'source': 'login'},
      ),
    );
  }
 
  void sendRequest() async{
    Map<String, dynamic> userData = {"login_data": mobileController.text};
    String jsonData = json.encode(userData);
    // print(jsonData);
    String encryptedLoginData = encryptAES(jsonData);
    // print(encryptedLoginData);
    String apiURL = 'http://pasumaibhoomi.com/connect/api/userlogin';
    
    final response = await http.post(Uri.parse(apiURL), body : {'data' : encryptedLoginData});
    print('SuccessCode: ${response.statusCode}');
    if(response.statusCode == 200) {
      print('Success: ${response.body}');
      String decryptedData = decryptAES(response.body);
      // decryptedData = decryptedData.replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '');
      // debugPrint("Decrypted Response: $decryptedData".toString(), wrapWidth: 1024) ;
      print('Decrypted Dat: $decryptedData');
      final responseJson = json.decode(decryptedData);
      print('Response: $responseJson');
      final userId = responseJson["user_id"];

      
      // print(userId);
      UserId.setUserId(userId);

      // print("OTP Sent");
    }
  }

}
