// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';

// import 'package:app_2/data/auth_appbar.dart';
import 'package:app_3/screens/address_page.dart';
import 'package:app_3/screens/bottom_bar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../data/encrypt_ids.dart';
import '../widgets/screen_widgets.dart';
import 'package:http/http.dart' as http;

// import '../../data/encrypt.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  // OTP box controller it have 4 so list of controllers
  late List<TextEditingController> controllers;
  // cover all the box foucs nodes
  late List<FocusNode> focusNodes;
    // listen to the conncectivity changes
  late StreamSubscription<ConnectivityResult> connectivitySubscription;
  //hold the connectivity result
  late ConnectivityResult _isConnected;
  late List<Color> otpFieldBorderColors = List.generate(controllers.length, (index) => Colors.black);

  late Timer _resendTimer;
  late bool _showResendButton;
   late String mobileNo;
   late String next;

 
  int _timerSeconds = 30;
  double otpContainerMargin = 0;

  @override
  void initState() {
    super.initState();
    _showResendButton = false;
    _isConnected = ConnectivityResult.none;
    checkConnectivity();
    // Listen to the connectivity changes and set the result
    connectivitySubscription = Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        _isConnected = result;
      });
    });
    // initialise the controllers and foucs nodes
    controllers = List.generate(4, (index) => TextEditingController());
    focusNodes = List.generate(4, (index) => FocusNode());
    otpFieldBorderColors = List.generate(controllers.length, (index) => Colors.black);
  

    for (int i = 0; i < controllers.length; i++) {
      controllers[i].addListener(() {
        if (controllers[i].text.isNotEmpty && i < controllers.length - 1) {
          // Move focus to the next text field
          FocusScope.of(context).requestFocus(focusNodes[i + 1]);
        }
      });
      focusNodes[i].addListener(() {
        if (focusNodes[i].hasFocus) {
          // Keyboard is visible, move OTP container up
          _animateOtpContainer(-187.0);
        } else {
          // Keyboard is not visible, move OTP container down
          _animateOtpContainer(0.0);
        }
      });
    }
    // _addKeyboardVisibilityListener();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
       if(_timerSeconds > 0){
        _timerSeconds --;
       } else {
        timer.cancel();
        _showResendButton = true;
       }
      });
    });
  }

   // check the connectivity and set to the result
  void checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = connectivityResult;
    });
  }
  
  // set the otp fields margin based on focus node
  void _animateOtpContainer(double margin) {
    setState(() {
      otpContainerMargin = margin;
    });
  }
  
  @override
  void dispose() {
    connectivitySubscription.cancel();
    _resendTimer.cancel();
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }
   @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Retrieve the mobile number from the previous screen
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    mobileNo = args['mobile'] ?? '';
    next = args['source'] ?? '';

  }
  // Define the correct OTP

    String correctOTP = '3493';
    // Add a list to store the border colors of each text field
  
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;


    if (_isConnected == ConnectivityResult.wifi || _isConnected == ConnectivityResult.mobile) {
      return Scaffold(
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            height: screenHeight,
            decoration: const BoxDecoration(color: Colors.white, ),
            child: Stack(
              children: [
                customAppbar('Verify'),
                // OTP Content
                Container(
                  alignment: Alignment.bottomCenter,
                  margin: EdgeInsets.only(top: screenWidth > 600 ? screenHeight * 0.18 : screenHeight * 0.11  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: screenWidth > 600 ? screenHeight * 0.55 : screenHeight * 0.01),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Verify with OTP sent to $mobileNo',
                              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w600, letterSpacing: -0.5),
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Verify to login',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300,),
                                ),
                                GestureDetector(
                                  onTap: (){
                                    resednOTP();
                                    setState(() {
                                      _showResendButton = false;
                                    });
                                    _startResendTimer();
                                    print('Resent');
                                  },
                                  child: Visibility(
                                    visible: _showResendButton,
                                    child: const Text(
                                      ' or Resend',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF60B47B)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 14,left: 0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:  List.generate(
                                  controllers.length,
                                  (index) => buildOtpTextField(index),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14,),
                      GestureDetector(
                        onTap: () async {
                          // String enteredOTP = controllers.map((controller) => controller.text).join('');

                          sendOTP();
                          // if (enteredOTP == correctOTP) {
                            if (next == 'login') {
                              Navigator.of(context).push(_createhomeRoute());
                            } else if (next == 'register') {
                              // Navigate to Location Selection Page
                              Navigator.of(context).push(_createAddressRoute());
                            }
                          // } else {
                          //    setState(() {
                          //     otpFieldBorderColors = List.generate(controllers.length, (index) => Colors.red.shade300);
                          //   });
                          //   await Future.delayed(const Duration(milliseconds: 800));
                          //    setState(() {
                          //     otpFieldBorderColors = List.generate(controllers.length, (index) => Colors.black);
                          //   });
                          // }
                        },
                        child: Center(child: buttons('Verify'))
                      ),
                      Center(
                        child: Visibility(
                          visible: _timerSeconds > 0,
                          child: Container(
                            margin: const EdgeInsets.only(top: 14,),
                            child: Text(
                              'Resend OTP in $_timerSeconds seconds',
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                            ),
                          )
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        body: Center(
          child: Image.asset('assets/category/nointernet.png'),
        ),
      );
    }
  }
   
   // OTP APi
  void sendOTP() async {
    String otp = '';
    for (int i = 0; i < controllers.length; i++) {
      otp += controllers[i].text;
    }

    Map<String, dynamic> userData = {
      'mobile_no' : mobileNo,
      'otp' : otp
    };
    String jsonData = json.encode(userData);
    print('JSON Data: $jsonData');
    String encryptedUserData = encryptAES(jsonData);
    print('Encrypted data: $encryptedUserData');

    String url = 'http://pasumaibhoomi.com/connectapi/verifyotp';
    final response = await http.post(Uri.parse(url), body: {'data': encryptedUserData});
    print('SuccessCode: ${response.statusCode}');
    print('Response: $response');
    if (response.statusCode == 200)  {
      print('Success: ${response.body}');
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushNamed('/location');
    }else{
      print('Error: ${response.body}');
    }

  }
  // Resend OTP api
  void resednOTP() async {

    Map<String, dynamic> userData = {
      'mobile_no' : mobileNo,
    };
    String jsonData = json.encode(userData);
    print('JSON Data: $jsonData');
    String encryptedUserData = encryptAES(jsonData);
    print('Encrypted data: $encryptedUserData');

    String url = 'http://pasumaibhoomi.com/connectapi/resendotp';
    final response = await http.post(Uri.parse(url), body: {'data': encryptedUserData});
    print('SuccessCode: ${response.statusCode}');
    print('Response: $response');
    if (response.statusCode == 200)  {
      print('Success: ${response.body}');
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushNamed('/location');
    }else{
      print('Error: ${response.body}');
    }

  }

  void _startResendTimer() {
    setState(() {
      _timerSeconds = 30;
    });
    _resendTimer.cancel(); // Cancel any existing timers
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (_timerSeconds > 0) {
          _timerSeconds--;
        } else {
          // Timer expired, enable the resend button
          timer.cancel();
        }
      });
    });
  }
  Widget buildOtpTextField(int index) {
    return Container(
      width: 50.0,
      height: 50.0,
      margin:  const EdgeInsets.only(left: 16, right: 16),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border:Border.all(color: otpFieldBorderColors[index]),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextField(
        controller: controllers[index],
        autofocus: true,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        onChanged: (value) {
          if (value.isEmpty && index > 0) {
            // Move focus to the previous text field when backspace is pressed
            FocusScope.of(context).requestFocus(focusNodes[index - 1]);
          }
        },
        focusNode: focusNodes[index],
        decoration: const InputDecoration(
          counter: Offstage(),
          border: InputBorder.none,
        ),
      ),
    );
  }

  PageRouteBuilder _createAddressRoute() {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const AddressPage(),
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

  
}
