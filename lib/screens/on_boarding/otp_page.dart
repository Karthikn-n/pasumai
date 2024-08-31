import 'dart:async';
import 'dart:convert';

import 'package:app_3/data/encrypt_ids.dart';
import 'package:app_3/helper/shared_preference_helper.dart';
import 'package:app_3/providers/address_provider.dart';
import 'package:app_3/helper/page_transition_helper.dart';
import 'package:app_3/providers/api_provider.dart';
import 'package:app_3/providers/subscription_provider.dart';
import 'package:app_3/repository/app_repository.dart';
import 'package:app_3/screens/main_screens/bottom_bar.dart';
import 'package:app_3/service/api_service.dart';
import 'package:app_3/service/connectivity_helper.dart';
import 'package:app_3/widgets/common_widgets.dart/app_bar.dart';
import 'package:app_3/widgets/common_widgets.dart/button_widget.dart';
import 'package:app_3/widgets/common_widgets.dart/snackbar_widget.dart';
import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:app_3/widgets/sub_screen_widgets/new_address_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class OtpPage extends StatefulWidget {
  final bool fromRegister;
  const OtpPage({super.key, required this.fromRegister});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  // OTP box controller it have 4 so list of controllers
  SharedPreferences prefs = SharedPreferencesHelper.getSharedPreferences();
  AppRepository otpRepository = AppRepository(ApiService("https://maduraimarket.in/api"));
  late List<TextEditingController> controllers;
  // cover all the box foucs nodes
  late List<FocusNode> focusNodes;
  late List<TextInputType> keyboardType;
  late Timer _resendTimer;
  late bool showResendButton;
  int _timerSeconds = 30;

  int totalAmount = 0;
  int totalProduct = 0;

  @override
  void initState() {
    super.initState();
    showResendButton = false;
    
    // initialise the controllers and foucs nodes
    controllers = List.generate(4, (index) => TextEditingController());
    focusNodes = List.generate(4, (index) => FocusNode());
    keyboardType = List.generate(4, (index) => TextInputType.number,);
    // preload();
    for (int i = 0; i < controllers.length; i++) {
      controllers[i].addListener(() {
        if (controllers[i].text.isNotEmpty && i < controllers.length - 1) {
          // Move focus to the next text field
          FocusScope.of(context).requestFocus(focusNodes[i + 1]);
        }
      });
    }
    // _addKeyboardVisibilityListener();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timerSeconds > 0) {
          _timerSeconds--;
        } else {
          timer.cancel();
          showResendButton = true;
        }
      });
    });
  }


  @override
  void dispose() {
    _resendTimer.cancel();
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }


  void preload() async {
    final subscriptionProvider = Provider.of<SubscriptionProvider>(context);
    await subscriptionProvider.getSubscribProducts();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    final connectivityService = Provider.of<ConnectivityService>(context);
    final addressProvider = Provider.of<AddressProvider>(context);
    if (connectivityService.isConnected) {
      return Scaffold(
        appBar: AppBarWidget(
          title: "OTP",
          needBack: true,
          onBack: () {
              Navigator.pop(context);
          },
        ),
        body: Container(
          height: size.height,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Consumer<ApiProvider>(
            builder: (context, otpProvider, child) {
              return Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AppTextWidget(
                          text: 'Verify with OTP sent to\n${prefs.getString("mobile")}',
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.5
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, bottom: 5),
                        child: Row(
                          children: [
                            const AppTextWidget(
                              text: 'Verify to login',
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                            ),
                            Consumer<ApiProvider>(
                              builder: (context, provider, child) {
                                return GestureDetector(
                                  onTap: () async {
                                    await provider.resendOTP(context, size, prefs.getString("mobile") ?? "");
                                    setState(() {
                                      showResendButton = false;
                                    });
                                    _startResendTimer();
                                  },
                                  child: Visibility(
                                    visible: _timerSeconds == 0,
                                    child: const AppTextWidget(
                                      text: ' or Resend',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      fontColor: Color(0xFF60B47B),
                                    ),
                                  ),
                                );
                              }
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Container(
                          margin: const EdgeInsets.only(top: 14, left: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                              controllers.length,
                              (index) => buildOtpTextField(index),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: ButtonWidget(
                          buttonName: 'Verify',
                          onPressed: () async {
                            // await addressProvider.getRegionLocation();
                            // if(widget.fromRegister){
                            //   Navigator.pushReplacement(context, SideTransistionRoute(screen: const NewAddressFormWidget(fromOnboarding: true,)));
                            // }else{
                            //   addressProvider.getAddressesAPI();
                            //   Navigator.pushReplacement(context, SideTransistionRoute(screen: const BottomBar()),).then((value) {
                            //     // prefs.remove("phoneNo");
                            //   },);
                            // }
                            //  Navigator.pushReplacement(context, SideTransistionRoute(screen: const NewAddressFormWidget(fromOnboarding: true,)));
                            FocusScope.of(context).unfocus();
                            String otp = '';
                            for (var controller in controllers) {
                              otp += controller.text;
                            }
                              
                            if (otp.isEmpty || otp.length < 4) {
                              final emptyOtp = snackBarMessage(
                                context: context, 
                                message: 'Please Enter a Valid OTP', 
                                backgroundColor: Theme.of(context).primaryColor, 
                                sidePadding: size.width * 0.1, 
                                bottomPadding: size.height * 0.05
                              );
                              ScaffoldMessenger.of(context).showSnackBar(emptyOtp);
                            }else if(otp.length == 4){
                              
                              Map<String, dynamic> otpData = {'mobile_no': prefs.getString("mobile"), 'otp': otp};
                        
                              final response = await otpRepository.verifyotp(otpData);
                              String decryptedData = decryptAES(response.body).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '');
                              final decodedResponse = json.decode(decryptedData);
                              print('Verify OTP Response: $decodedResponse, Status Code: ${response.statusCode}');
                              SnackBar otpMessage = snackBarMessage(
                                context: context, 
                                message: decodedResponse['message'], 
                                backgroundColor: const Color(0xFF60B47B), 
                                sidePadding: size.width * 0.1, 
                                bottomPadding: size.height * 0.05
                              );
                              if (response.statusCode == 200 && decodedResponse['status'] == 'success') {
                                ScaffoldMessenger.of(context).showSnackBar(otpMessage).closed.then(
                                  (value) async {
                                    await addressProvider.getRegionLocation();
                                    if(widget.fromRegister){
                                      Navigator.pushAndRemoveUntil(context, SideTransistionRoute(screen: const NewAddressFormWidget(fromOnboarding: true,)), (route) => false,);
                                    }else{
                                      addressProvider.getAddressesAPI();
                                      Navigator.pushAndRemoveUntil(context,  SideTransistionRoute(screen: const BottomBar()), (route) => false);
                                    }
                                  },
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(otpMessage);
                                print('Error: ${response.body}');
                              }
                            }else{
                              final emptyOtp = snackBarMessage(
                                context: context, 
                                message: 'Please Enter a OTP', 
                                backgroundColor: Theme.of(context).primaryColor, 
                                sidePadding: size.width * 0.1, 
                                bottomPadding: size.height * 0.85
                              );
                              ScaffoldMessenger.of(context).showSnackBar(emptyOtp);
                            }
                          }, 
                        ),
                      ),
                      Center(
                        child: Visibility(
                          visible: _timerSeconds > 0,
                          child: Container(
                            margin: const EdgeInsets.only(
                              top: 14,
                            ),
                            child: Text(
                              'Resend OTP in $_timerSeconds seconds',
                              style: const TextStyle(
                                fontSize: 14, 
                                fontWeight: FontWeight.w300
                              ),
                            ),
                          )
                        ),
                      )
                    ],
                  ),
                ],
              );
            }
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

  

  Widget buildOtpTextField(int index) {
    return Container(
      width: 50.0,
      height: 50.0,
      margin: const EdgeInsets.only(left: 16, right: 16),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextFormField(
        controller: controllers[index],
        autofocus: index == 0, // Autofocus only the first field
        keyboardType: keyboardType[index],
        textAlign: TextAlign.center,
        maxLength: 1,
        textInputAction: index < controllers.length - 1 
          ? TextInputAction.next // Move to the next field
          : TextInputAction.done,
        onFieldSubmitted: (value) {
          if (value.isEmpty && index > 0) {
            // Move focus to the previous text field when backspace is pressed
            FocusScope.of(context).requestFocus(focusNodes[index - 1]);
          } else if (value.isNotEmpty && index < controllers.length - 1) {
            // Move to the next field if the current field is not the last one
            FocusScope.of(context).requestFocus(focusNodes[index + 1]);
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
          timer.cancel();
        }
      });
    });
  }


}

