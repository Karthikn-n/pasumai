import 'package:app_3/screens/registration_page.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true),

      home: const RegisterationPage(),
      // routes: {
      //   '/login': (context) => const LoginPage(),
      //   '/otp': (context) => const OtpPage(),
      //   '/address':(context) => const AddressPage(),
      //   '/home': (context) => BottomBar(),
      // },
    );
  }
}


