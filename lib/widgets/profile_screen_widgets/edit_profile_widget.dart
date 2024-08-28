import 'package:app_3/helper/shared_preference_helper.dart';
import 'package:app_3/providers/profile_provider.dart';
import 'package:app_3/service/connectivity_helper.dart';
import 'package:app_3/widgets/common_widgets.dart/app_bar.dart';
import 'package:app_3/widgets/common_widgets.dart/button_widget.dart';
import 'package:app_3/widgets/common_widgets.dart/input_field_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileWidget extends StatefulWidget {
  const EditProfileWidget({super.key});

  @override
  State<EditProfileWidget> createState() => _EditProfileWidgetState();
}

class _EditProfileWidgetState extends State<EditProfileWidget> {
  SharedPreferences prefs = SharedPreferencesHelper.getSharedPreferences();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    firstNameController.text = prefs.getString('firstname') ?? "";
    lastNameController.text = prefs.getString("lastname") ?? "";
    emailController.text = prefs.getString("mail") ?? "";
    mobileController.text = prefs.getString("mobile") ?? "";
  }

  @override
  void dispose() {
    super.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    mobileController.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Consumer2<ConnectivityService, ProfileProvider>(
      builder: (context, connection, profile, child) {
        return connection.isConnected 
        ? Scaffold(
            appBar: AppBarWidget(
              title: "Edit Profile",
              onBack: () => Navigator.pop(context),
              needBack: true,
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SingleChildScrollView(
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
                      const SizedBox(height: 20,),
                      SizedBox(
                        width: double.infinity,
                        child: ButtonWidget(
                          buttonName: "Update", 
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              print("${prefs.getString("mobile") == mobileController.text}");
                              if (mobileController.text != prefs.getString("mobile")) {
                                profile.confirmEditProfile({
                                  'customer_id': prefs.getString("customerId"),
                                    'first_name': firstNameController.text,
                                    'last_name': lastNameController.text,
                                    'email': emailController.text,
                                    'mobile_no': mobileController.text
                                }, size, context, true);
                               
                              }else{
                                 profile.confirmEditProfile({
                                  'customer_id': prefs.getString("customerId"),
                                    'first_name': firstNameController.text,
                                    'last_name': lastNameController.text,
                                    'email': emailController.text,
                                    'mobile_no': mobileController.text
                                }, size, context, false);
                              }
                            }
                          }
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        : Scaffold(
          appBar: AppBarWidget(
            title: 'Edit Profile',
            needBack: true,
            onBack: () => Navigator.pop,
          ),
          body: Center(
            child: Image.asset('assets/category/nointernet.png'),
          ),
        );
      },
    );
  }
}