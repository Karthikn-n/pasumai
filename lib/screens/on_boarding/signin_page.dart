import 'dart:async';
import 'package:app_3/helper/page_transition_helper.dart';
import 'package:app_3/providers/api_provider.dart';
import 'package:app_3/screens/on_boarding/registration_page.dart';
import 'package:app_3/service/connectivity_helper.dart';
import 'package:app_3/widgets/common_widgets.dart/app_bar.dart';
import 'package:app_3/widgets/common_widgets.dart/button_widget.dart';
import 'package:app_3/widgets/common_widgets.dart/input_field_widget.dart';
import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key,});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _key = GlobalKey<FormState>();
  final TextEditingController mobileController = TextEditingController();
  FocusNode mobileNoFocus = FocusNode();
  final RegExp mobileRegex = RegExp(r'^[0-9]{10}$');
  // bool _isInitialized = false;
  
  @override
  void initState() {
    super.initState();
    preLoadAPi();
  }

  @override
  void dispose() {
    mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final connectivityService = Provider.of<ConnectivityService>(context);
    Size size = MediaQuery.sizeOf(context);
    if (connectivityService.isConnected) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: const AppBarWidget(title: "Login"),
        body: Container(
          height: size.height,
          color: Colors.white,
          child: Column(
            // alignment: Alignment.topCenter,
            children: [
              //Login content
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppTextWidget(
                      text: 'Welcome back !',
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.5
                    ),
                    Row(
                      children: [
                        const AppTextWidget(
                          text: 'Login to your account',
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(context, SideTransistionRoute(screen: const RegisterationPage(), ));
                          },
                          child: const AppTextWidget(
                            text: ' or Sign up',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            fontColor: Color(0xFF60B47B)
                          ),
                        ),
                      ],
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
                          prefixIcon: const Icon(CupertinoIcons.phone),
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
                  ],
                ),
              ),
              const SizedBox(height: 20,),
              // Button
              Consumer<ApiProvider>(
                builder: (context, provider, child) {
                  return ButtonWidget(
                    buttonName: 'Login',
                    onPressed: () async {
                      if (_key.currentState!.validate()) {
                        mobileNoFocus.unfocus();
                        await provider.userLogin(mobileController.text, size, context);
                      }
                    }, 
                  );
                }
              )
            ],
          ),
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


}
