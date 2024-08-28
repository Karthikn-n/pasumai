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
  final RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

  @override
  void initState() {
    super.initState();
    preLoadAPi();
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
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const AppTextWidget(
                            text: 'Welcome !',
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5
                          ),
                          Row(
                            children: [
                              const AppTextWidget(
                                text: 'Create an account',
                                fontSize: 16, 
                                fontWeight: FontWeight.w300,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(context, SideTransistionRoute(screen: const LoginPage()));
                                },
                                child: const AppTextWidget(
                                  text: ' or Sign in',
                                  fontSize: 16, 
                                  fontWeight: FontWeight.w500,
                                  fontColor: Color(0xFF60B47B)
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFields(
                            hintText: 'Enter your first name', 
                            isObseure: false, 
                            // borderRadius: 8,
                            textInputAction: TextInputAction.next,
                            prefixIcon: const Icon(CupertinoIcons.person_fill),
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
                            prefixIcon: const Icon(CupertinoIcons.person_fill),
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
                            prefixIcon: const Icon(CupertinoIcons.mail_solid),
                            controller: emailController,
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
                          const SizedBox(height: 20,),
                          TextFields(
                            hintText: 'Enter your Mobile number',
                            isObseure: false, 
                            textInputAction: TextInputAction.done,
                            prefixIcon: const Icon(Icons.phone_android_sharp),
                            controller: mobileController,
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your mobile number';
                              }
                              return null;
                            },
                          ),
                          ],
                        ),
                      
                      ),
                    ),
                    
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              Center(
                child: Consumer<ApiProvider>(
                  builder: (context, provider, child) {
                    return ButtonWidget(
                      buttonName: 'Signup', 
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        if (_formKey.currentState!.validate()) {
                          Map<String, dynamic> userData = {
                              'first_name' : firstNameController.text,
                              'last_name' : lastNameController.text,
                              'email' : emailController.text,
                              'mobile_no': mobileController.text
                            };
                          await provider.registerUser(userData, context, size);
                          // await registerUser(context, size);
                        }
                      }
                    );
                  }
                )
              ),
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

