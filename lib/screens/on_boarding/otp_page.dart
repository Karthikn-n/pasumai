import 'dart:async';
// import 'dart:convert';

// import 'package:app_3/data/encrypt_ids.dart';
import 'package:app_3/helper/shared_preference_helper.dart';
import 'package:app_3/providers/address_provider.dart';
import 'package:app_3/helper/page_transition_helper.dart';
import 'package:app_3/providers/api_provider.dart';
import 'package:app_3/providers/subscription_provider.dart';
import 'package:app_3/repository/app_repository.dart';
import 'package:app_3/screens/main_screens/bottom_bar.dart';
import 'package:app_3/service/api_service.dart';
import 'package:app_3/service/connectivity_helper.dart';
import 'package:app_3/widgets/common_widgets.dart/button_widget.dart';
// import 'package:app_3/widgets/common_widgets.dart/snackbar_widget.dart';
import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:app_3/widgets/sub_screen_widgets/new_address_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class OtpPage extends StatefulWidget {
  final bool fromRegister;
  const OtpPage({super.key, required this.fromRegister});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> with WidgetsBindingObserver{
  // OTP box controller it have 4 so list of controllers
  SharedPreferences prefs = SharedPreferencesHelper.getSharedPreferences();
  AppRepository otpRepository = AppRepository(ApiService("https://maduraimarket.in/api"));
  TextEditingController otpController = TextEditingController();
  // cover all the box foucs nodes
  late List<FocusNode> focusNodes;
  late List<TextInputType> keyboardType;
  late Timer _resendTimer;
  late bool showResendButton;
  int _timerSeconds = 30;
  bool isLoading = false;
  int totalAmount = 0;
  int totalProduct = 0;
  double imageHeight = 360;
  bool isKeyboard = false;
  bool isResending = false;

  @override
  void initState() {
    super.initState();
    showResendButton = false;
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
    WidgetsBinding.instance.addObserver(this);
  }


  @override
  void dispose() {
    _resendTimer.cancel();
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }


  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final bottomInsets = View.of(context).viewInsets.bottom;
    bool isKeyboardVisible = bottomInsets > 0.0;
    setState(() {
      isKeyboard = isKeyboardVisible;
      imageHeight = isKeyboardVisible ? 310 : 360; // Shrink the image when keyboard appears
    });
  }

  void preload() async {
    final subscriptionProvider = Provider.of<SubscriptionProvider>(context);
    await subscriptionProvider.getSubscribProducts();
  }

  String formatTime(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    final connectivityService = Provider.of<ConnectivityService>(context);
    final addressProvider = Provider.of<AddressProvider>(context);
    if (connectivityService.isConnected) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Consumer<ApiProvider>(
          builder: (context, otpProvider, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 AnimatedContainer(
                  duration: const Duration(milliseconds: 10),
                  height: imageHeight, // Dynamically change height based on keyboard
                  width: size.width,
                  child: Image.asset(
                    "assets/icons/on-boarding/otp_banner.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // OTP Headings
                      AppTextWidget(
                        text: 'OTP sent to ${prefs.getString("mobile")}',
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.5
                      ),
                      AppTextWidget(
                        text: 'Enter received OTP',
                        fontSize: 14,
                        fontColor: Colors.grey.withOpacity(1.0),
                        fontWeight: FontWeight.w300,
                      ),
                      const SizedBox(height: 16,),
                      // OTP Field
                      Center(
                        child: SizedBox(
                          width: size.width,
                          height: kToolbarHeight,
                          child: Pinput(
                            focusedPinTheme: PinTheme(
                              height: kToolbarHeight,
                              width: kToolbarHeight + 10,
                              decoration: BoxDecoration(
                              border: Border.all(color: Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.circular(5),
                              // color: 
                             )
                            ),
                            defaultPinTheme: PinTheme(
                             height:  kToolbarHeight,
                             width: kToolbarHeight + 10,
                             decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color.fromRGBO(222, 231, 240, .57)
                              ),
                              borderRadius: BorderRadius.circular(5),
                              // color: 
                             )
                            ),
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            controller: otpController,
                            length: 4,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Verify OTP button
                      Center(
                        child: isLoading
                        ? const LoadingButton(width: double.infinity)
                        : ButtonWidget(
                          width: double.infinity,
                          buttonName: 'Verify',
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });
                            try {
                              await addressProvider.getRegionLocation();
                                if(widget.fromRegister){
                                  Navigator.push(context, SideTransistionRoute(screen: const NewAddressFormWidget(fromOnboarding: true,)));
                                }else{
                                  addressProvider.getAddressesAPI();
                                  Navigator.pushAndRemoveUntil(context,  SideTransistionRoute(screen: const BottomBar()), (route) => false);
                                }
                            } catch (e) {
                              print("Error occured: $e");
                            }finally{
                              setState(() {
                                isLoading = false;
                              });
                            }
                          
                            // FocusScope.of(context).unfocus();
                            // String otp = '';
                            // for (var controller in controllers) {
                            //   otp += controller.text;
                            // }
                              
                            // if (otp.isEmpty || otp.length < 4) {
                            //   final emptyOtp = snackBarMessage(
                            //     context: context, 
                            //     message: 'Please Enter a Valid OTP', 
                            //     backgroundColor: Theme.of(context).primaryColor, 
                            //     sidePadding: size.width * 0.1, 
                            //     bottomPadding: size.height * 0.05
                            //   );
                            //   ScaffoldMessenger.of(context).showSnackBar(emptyOtp);
                            // }else if(otp.length == 4){
                              
                            //   Map<String, dynamic> otpData = {'mobile_no': prefs.getString("mobile"), 'otp': otp};
                        
                            //   final response = await otpRepository.verifyotp(otpData);
                            //   String decryptedData = decryptAES(response.body).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '');
                            //   final decodedResponse = json.decode(decryptedData);
                            //   print('Verify OTP Response: $decodedResponse, Status Code: ${response.statusCode}');
                            //   SnackBar otpMessage = snackBarMessage(
                            //     context: context, 
                            //     message: decodedResponse['message'], 
                            //     backgroundColor: const Color(0xFF60B47B), 
                            //     sidePadding: size.width * 0.1, 
                            //     bottomPadding: size.height * 0.05
                            //   );
                            //   if (response.statusCode == 200 && decodedResponse['status'] == 'success') {
                            //     ScaffoldMessenger.of(context).showSnackBar(otpMessage).closed.then(
                            //       (value) async {
                            //         await addressProvider.getRegionLocation();
                            //         if(widget.fromRegister){
                            //           Navigator.pushAndRemoveUntil(context, SideTransistionRoute(screen: const NewAddressFormWidget(fromOnboarding: true,)), (route) => false,);
                            //         }else{
                            //           addressProvider.getAddressesAPI();
                            //           Navigator.pushAndRemoveUntil(context,  SideTransistionRoute(screen: const BottomBar()), (route) => false);
                            //         }
                            //       },
                            //     );
                            //   } else {
                            //     ScaffoldMessenger.of(context).showSnackBar(otpMessage);
                            //     print('Error: ${response.body}');
                            //   }
                            // }else{
                            //   final emptyOtp = snackBarMessage(
                            //     context: context, 
                            //     message: 'Please Enter a OTP', 
                            //     backgroundColor: Theme.of(context).primaryColor, 
                            //     sidePadding: size.width * 0.1, 
                            //     bottomPadding: size.height * 0.85
                            //   );
                            //   ScaffoldMessenger.of(context).showSnackBar(emptyOtp);
                            // }
                          }, 
                        ),
                      ),
                      const SizedBox(height: 16,),
                      // Or Widget
                      if(!isKeyboard)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: size.width * 0.4,
                              child: Divider(
                                color: Colors.black.withOpacity(0.3),
                                thickness: 1,
                              ),
                            ),
                            const SizedBox(width: 10,),
                            const AppTextWidget(
                              text: "or", 
                              fontWeight: FontWeight.w400, 
                              // fontColor: Colors.black.withOpacity(0.5),
                            ),
                            const SizedBox(width: 10,),
                            SizedBox(
                              width: size.width * 0.4,
                              child: Divider(
                                color: Colors.black.withOpacity(0.3),
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),
                        
                      const SizedBox(height: 14,),
                      // OTP Timing
                      if(!isKeyboard)
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppTextWidget(
                                text: _timerSeconds == 0 
                                ? "Didn't receive OTP "
                                : "Didn't receive OTP wait ", 
                                fontWeight: FontWeight.w500, 
                                fontSize: 14,
                              ),
                              Consumer<ApiProvider>(
                                builder: (context, provider, child) {
                                  return isResending
                                  ? const AppTextWidget(
                                      text: 'Resending...',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      fontColor: Color(0xFF60B47B),
                                    )
                                  : Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        splashFactory: InkRipple.splashFactory,
                                        splashColor: Colors.transparent.withOpacity(0.1),
                                        onTap: () async {
                                          setState(() {
                                            isResending = true;
                                          });
                                          try {
                                            await provider.resendOTP(context, size, prefs.getString("mobile") ?? "");
                                            setState(() {
                                              showResendButton = false;
                                            });
                                            _startResendTimer();
                                          } catch (e) {
                                            print("Can't Resend OTP: $e");
                                          } finally {
                                            setState(() {
                                              isResending = false;
                                            });
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 2),
                                          child: AppTextWidget(
                                            text: _timerSeconds == 0 
                                            ? 'Resend'
                                            : formatTime(_timerSeconds),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            fontColor: const Color(0xFF60B47B),
                                          ),
                                        ),
                                      ),
                                    );
                                }
                              ),
                              
                            ],
                          ),
                        ),
                    
                    ],
                  ),
                )
              ],
            );
          }
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

