import 'dart:async';
import 'package:app_3/helper/page_transition_helper.dart';
import 'package:app_3/providers/api_provider.dart';
import 'package:app_3/screens/on_boarding/signin_page.dart';
import 'package:app_3/service/connectivity_helper.dart';
import 'package:app_3/widgets/common_widgets.dart/app_bar.dart';
import 'package:app_3/widgets/common_widgets.dart/button_widget.dart';
import 'package:app_3/widgets/common_widgets.dart/input_field_widget.dart';
import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class RegisterationPage extends StatefulWidget {
  const RegisterationPage({super.key});

  @override
  State<RegisterationPage> createState() => _RegisterationPageState();
}

class _RegisterationPageState extends State<RegisterationPage> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final RegExp nameRegex = RegExp(r'^[a-zA-Z]+$');
  // final RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  bool isLoading = false;
  bool isFormValid = false;


  @override
  void initState() {
    super.initState();
    preLoadAPi();
    firstNameController.addListener(_validateForm);
    lastNameController.addListener(_validateForm);
    emailController.addListener(_validateForm);
    mobileController.addListener(_validateForm);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    final connectivityService = Provider.of<ConnectivityService>(context);
    if (connectivityService.isConnected) {
      return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppBarWidget(title: "Register"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Text
              const AppTextWidget(
                text: 'Welcome !',
                fontSize: 18,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.5
              ),
              // Or Sigin button
              const AppTextWidget(
                text: 'Join now for exclusive deals & benifits',
                fontSize: 14, 
                fontColor: Colors.grey,
                fontWeight: FontWeight.w300,
              ),
              
              const SizedBox(height: 20,),
              // Form 
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFields(
                    hintText: 'Enter your first name', 
                    isObseure: false, 
                    // borderRadius: 8,
                    textInputAction: TextInputAction.next,
                    prefixIcon: const Icon(CupertinoIcons.person, color: Colors.grey),
                    controller: firstNameController,
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
                  const SizedBox(height: 20,),
                  TextFields(
                    hintText: 'Enter your last name',
                    isObseure: false, 
                    textInputAction: TextInputAction.next,
                    prefixIcon: const Icon(CupertinoIcons.person, color: Colors.grey),
                    controller: lastNameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your last name';
                        }
                        if (!nameRegex.hasMatch(value)) {
                          return 'Last name can only contain letters';
                        }
                        return null;
                      },
                  ),
                  const SizedBox(height: 20,),
                  TextFields(
                    hintText: 'Enter your email address',
                    isObseure: false, 
                    textInputAction: TextInputAction.next,
                    prefixIcon: const Icon(CupertinoIcons.mail, color: Colors.grey,),
                    controller: emailController,
                    validator: (value) {
                      if (value == null && value!.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!emailRegex.hasMatch(value)) {
                        return  'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20,),
                  TextFields(
                    hintText: 'Enter your Mobile number',
                    isObseure: false, 
                    textInputAction: TextInputAction.done,
                    prefixIcon: const Icon(Icons.phone_android_sharp, color: Colors.grey),
                    controller: mobileController,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      final RegExp mobileRegex = RegExp(r'^[0-9]{10}$');
                      if (value!.isEmpty) {
                        return 'Please enter your mobile number';
                      }
                      if (mobileController.text.length != 10) {
                        return "Please Enter a valid mobile number";
                      }
                      if (mobileRegex.hasMatch(value)) {
                        return null;
                      } else {
                        return 'Invalid mobile number';
                      }
                      // return null;
                    },
                  ),
                  ],
                ),
              
              ),
              const SizedBox(height: 20,),
              Consumer<ApiProvider>(
                builder: (context, provider, child) {
                  return isLoading
                  ? const LoadingButton(
                    width: double.infinity,
                  )
                  : ButtonWidget(
                    width: double.infinity,
                    buttonName: 'Signup', 
                    buttonColor: isFormValid
                        ? Theme.of(context).primaryColor
                        : Colors.grey.withValues(alpha: 0.4),
                    // textColor: isFormValid ? Colors.white : Colors.black38,
                    onPressed: () async {
                      if(isFormValid && !isLoading) {
                        FocusScope.of(context).unfocus();
                        setState(() {
                          isLoading = true;
                        });
                        try {
                          if (_formKey.currentState!.validate()) {
                            if(firstNameController.text.isNotEmpty 
                              && lastNameController.text.isNotEmpty 
                              && emailController.text.isNotEmpty 
                              && mobileController.text.isNotEmpty) {

                            }
                            Map<String, dynamic> userData = {
                                'first_name' : firstNameController.text,
                                'last_name' : lastNameController.text,
                                'email' : emailController.text,
                                'mobile_no': mobileController.text
                              };
                              print(userData);
                            // await DatabaseHelper.storeUsers(userData);
                            await provider.registerUser(userData, context, size);
                          }
                        } catch (e) {
                          print("Can't Signup $e");
                        } finally{
                          setState(() {
                            isLoading = false;
                          });
                        }
                      }
                    }
                  );
                }
              ),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: size.width * 0.4,
                    child: Divider(
                      color: Colors.black.withValues(alpha: 0.3),
                      thickness: 1,
                    ),
                  ),
                  const SizedBox(width: 10,),
                  const AppTextWidget(
                    text: "or", 
                    fontWeight: FontWeight.w400, 
                    // fontColor: Colors.black.withValues(alpha: 0.5),
                  ),
                  const SizedBox(width: 10,),
                  SizedBox(
                    width: size.width * 0.4,
                    child: Divider(
                      color: Colors.black.withValues(alpha: 0.3),
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
                  const AppTextWidget(text: "Already have an account ", fontWeight: FontWeight.w500, fontSize: 14,),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      splashFactory: InkRipple.splashFactory,
                      splashColor: Colors.transparent.withValues(alpha: 0.1),
                      onTap: () {
                        Navigator.pushReplacement(context, SideTransistionRoute(screen: const LoginPage(), ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: AppTextWidget(text: "Sign in", fontWeight: FontWeight.w500, fontSize: 14, fontColor: Theme.of(context).primaryColor,),
                      )
                    ),
                  ),
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
        appBar: AppBar(
          title: const Text(
            'Signup',
            style: TextStyle(fontSize: 16),
          ),
          centerTitle: true,
          surfaceTintColor: Colors.transparent,
        ),
        body: Center(
          child: Image.asset('assets/category/nointernet.png'),
        ),
      );
    }
  } 
  
  void _validateForm() {
    final isValid = nameRegex.hasMatch(firstNameController.text) &&
                    nameRegex.hasMatch(lastNameController.text) &&
                    emailRegex.hasMatch(emailController.text) &&
                    RegExp(r'^[0-9]{10}$').hasMatch(mobileController.text);

    if (isValid != isFormValid) {
      setState(() {
        isFormValid = isValid;
      });
    }
  }

 
  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    super.dispose();
  }
 
 // Pre load API
  void preLoadAPi() async {
    final provider = Provider.of<ApiProvider>(context, listen: false);
    await Future.wait([
      provider.getBestSellers(),
      provider.getCatgories(),
      provider.getFeturedProducts()
    ]);
  }
}

