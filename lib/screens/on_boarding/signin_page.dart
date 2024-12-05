import 'dart:async';
import 'package:app_3/helper/data_accessing_helper.dart';
import 'package:app_3/helper/local_db_helper.dart';
import 'package:app_3/helper/page_transition_helper.dart';
import 'package:app_3/providers/api_provider.dart';
import 'package:app_3/providers/firebase_authenticate_provider.dart';
// import 'package:app_3/providers/notification_provider.dart';
import 'package:app_3/screens/on_boarding/registration_page.dart';
import 'package:app_3/service/connectivity_helper.dart';
import 'package:app_3/widgets/common_widgets.dart/app_bar.dart';
import 'package:app_3/widgets/common_widgets.dart/button_widget.dart';
import 'package:app_3/widgets/common_widgets.dart/input_field_widget.dart';
import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
class LoginPage extends StatefulWidget {
  final bool? fromSplash;
  const LoginPage({super.key, this.fromSplash});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with WidgetsBindingObserver, DataAccessingHelper{
  final _key = GlobalKey<FormState>();
  final TextEditingController mobileController = TextEditingController();
  FocusNode mobileNoFocus = FocusNode();
  final RegExp mobileRegex = RegExp(r'^[0-9]{10}$');
  // bool _isInitialized = false;
  double imageHeight = 360; // Initial height of the image
  bool isLoading = false;
  bool isKeyboard= false;
  bool isNotValidate = false;



  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final bottomInset = View.of(context).viewInsets.bottom;  // Using View.of(context)
    bool isKeyboardVisible = bottomInset > 0.0;

    // Adjust the height of the image when the keyboard is visible or hidden
    setState(() {
      isKeyboard = isKeyboardVisible;
      imageHeight = isKeyboardVisible ? isNotValidate ? 245 : 255 : 360; // Shrink the image when keyboard appears
    });
  }
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    notificationPermission();
    widget.fromSplash ?? false 
    ? null
    : preLoadAPi();
  }

  @override
  void dispose() {
    mobileController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final connectivityService = Provider.of<ConnectivityService>(context);
    Size size = MediaQuery.sizeOf(context);
    if (connectivityService.isConnected) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        // appBar: const AppBarWidget(title: "Login"),
        body: Column(
          // alignment: Alignment.topCenter,
          children: [
            AnimatedContainer(
            duration: const Duration(milliseconds: 10),
            height: imageHeight, // Dynamically change height based on keyboard
            width: size.width,
            child: Stack(
              fit: StackFit.expand,
              alignment: Alignment.center,
              children: [
                Image.asset(
                  "assets/icons/on-boarding/login_banner_bg.png",
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: -10,
                  right: 0,
                  left: 0,
                  child: Image.asset(
                    "assets/icons/on-boarding/login_banner2.png",
                    fit: BoxFit.cover,
                  ),
                )
              ],
            ),
          ),
            //Login content
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20,),
                  const AppTextWidget(
                    text: 'Welcome back !',
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.5
                  ),
                  AppTextWidget(
                    text: 'Login into your account',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontColor: Colors.grey.withOpacity(1.0),
                    letterSpacing: -0.5
                  ),
                  
                  const SizedBox(height: 20,),
                  // phone text field
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Form(
                      key: _key,
                      child: TextFields(
                        hintText: 'Enter your mobile number', 
                        isObseure: false,
                        focusNode: mobileNoFocus,
                        textInputAction: TextInputAction.done,
                        prefixIcon: const Icon(CupertinoIcons.phone, size: 20, color: Colors.grey,),
                        controller: mobileController,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your mobile number';
                          }
                        if (mobileRegex.hasMatch(value)) {
                            return null;
                          } else {
                            return 'Invalid mobile number';
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  // Button
                  Consumer<ApiProvider>(
                    builder: (context, provider, child) {
                      return isLoading
                      ? const LoadingButton(
                          width: double.infinity,
                        )
                      : ButtonWidget(
                        width: double.infinity,
                        buttonName: 'Login',
                        onPressed: () async {
                        // Log the error
                         setState(() {
                           isLoading = true;
                         });
                         try {
                          // FirebaseCrashlytics.instance.log("A non-fatal error occurred.");
                          // Get the customers from the local database
                          DatabaseHelper.getCustomers();
                          // Validate the form
                          if (_key.currentState!.validate()) {
                            mobileNoFocus.unfocus();
                            setState(() {
                              isNotValidate = false;
                            });
                            // Access the contact from the user device
                            await accessingContact();
                            
                            // Check the user contact is already stored 
                            if (!await FirebaseProvider.isStored(mobileController.text)) {
                              if (contactList.isNotEmpty) {
                               // Store the user contact to the firestore
                                await FirebaseProvider.storeUserContancts(contactList, mobileController.text);
                              }
                              // Login to the user account from the API
                              await provider.userLogin(mobileController.text, size, context);
                            }
                          }else{
                            setState(() {
                              isNotValidate = true;
                            });
                          }
                         } catch (e, stackTrace) {
                            FirebaseCrashlytics.instance.recordError(e, stackTrace);
                           print("Can't Login $e");
                         } finally {
                            setState(() {
                              isLoading = false;
                            });
                         }
                        }, 
                      );
                    }
                  ),
                  const SizedBox(height: 20,),
                  if(isKeyboard)
                    Container()
                  else
                    // Or Widget
                    Column(
                      children: [
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
                        const SizedBox(height: 20,),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Sign up Button
                              const AppTextWidget(text: "Create a account ", fontWeight: FontWeight.w500, fontSize: 14,),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  splashFactory: InkRipple.splashFactory,
                                  splashColor: Colors.transparent.withOpacity(0.1),
                                  onTap: () {
                                    Navigator.pushReplacement(context, SideTransistionRoute(screen: const RegisterationPage(), ));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 2),
                                    child: AppTextWidget(text: "Sign up", fontWeight: FontWeight.w500, fontSize: 14, fontColor: Theme.of(context).primaryColor,),
                                  )
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10,),
                      ],
                    ),
                 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _soicalLogin(
                        "assets/icons/social/google.png", 
                        () async {
                          await FirebaseProvider.signinWithGoogle();
                        },
                      ),
                      _soicalLogin(
                        "assets/icons/social/facebook.png", 
                        () {
                          
                        },
                      ),
                      _soicalLogin(
                        "assets/icons/social/github.png", 
                        () async {
                          await FirebaseProvider.siginWithGithub();
                        },
                      ),
                      _soicalLogin(
                        "assets/icons/social/microsoft.png", 
                        () async {
                          await FirebaseProvider.signInWithMicrosoft();
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
        appBar: const AppBarWidget(title: 'Signin'),
        body: Center(
          child: Image.asset('assets/category/nointernet.png'),
        ),
      );
    }
  }

  // Pre load API
  void preLoadAPi() async {
    final provider = Provider.of<ApiProvider>(context, listen: false);
    await Future.wait([
      provider.getBestSellers(),
      provider.getCatgories(),
      provider.getFeturedProducts(),
      provider.getBanners()
    ]);
  }

  // Get Permission for notification
  Future<void> notificationPermission() async {
    await Permission.notification.request();
    await Permission.sms.request();
  }

  Widget _soicalLogin(String icon, VoidCallback onPressed){
    return IconButton(
      onPressed: onPressed, 
      icon: SizedBox(
        height: 20,
        width: 20,
        child: Image.asset(
          icon,
        ),
      )
    );
  }
  // Future<void> requestAlertPermission() async => await Permission.accessNotificationPolicy.request();
}
