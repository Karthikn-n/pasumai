import 'package:app_3/screens/bottom_bar.dart';
import 'package:app_3/screens/category/qucik_order.dart';
import 'package:app_3/screens/otp_page.dart';
import 'package:app_3/screens/products_list.dart';
import 'package:app_3/screens/registration_page.dart';
import 'package:app_3/screens/signin_page.dart';
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
      initialRoute: '/login',
      home: const RegisterationPage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const RegisterationPage(),
        '/otp': (context) => const OtpPage(),
        '/bottom': (context) =>  BottomBar(selectedIndex: 0,),
        '/productList': (context) => const ProductListPage(),
        '/quickOrder': (context) => const QuickOrderPage(),
        // '/otp': (context) => const OtpPage(),
        // '/address':(context) => const AddressPage(),
        // '/home': (context) => BottomBar(),
      },
    );
  }
}


