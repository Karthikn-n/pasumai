import 'dart:isolate';

import 'package:app_3/helper/page_transition_helper.dart';
import 'package:app_3/providers/address_provider.dart';
import 'package:app_3/providers/api_provider.dart';
import 'package:app_3/screens/main_screens/bottom_bar.dart';
import 'package:app_3/screens/on_boarding/signin_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget{
  final bool userLogged; 
  const SplashScreen({super.key, required this.userLogged});

  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>{

  @override
  void initState(){
    super.initState();
    initializeApp();
  }


  Future<void> initializeApp() async {
    await Future.wait([
      preLoadAPi(),
    ]);
  }

  
  @override
  Widget build(BuildContext context){
    Size size = MediaQuery.sizeOf(context);
    return Container(
      height: size.height,
      width: size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor
      ),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: size.height * 0.45,),
          ClipRRect(
            child: SizedBox(
              width: 80,
              height: 80,
              child: Image.asset(
                "assets/icons/logo.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: size.height * 0.3,),
          const SizedBox(
            height: 30,
            width: 30,
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
  
  Future<void> preLoadAPi() async {
    final provider = Provider.of<ApiProvider>(context, listen: false);
    final addressProvider = Provider.of<AddressProvider>(context, listen: false);
    await Future.wait([
      provider.getBestSellers(),
      provider.getCatgories(),
      provider.getFeturedProducts(),
      provider.getBanners()
    ]);
    //  Difference in parallel API call: 3133 ms
    // Difference in sequential API call: 3519 ms
    // final startTime = DateTime.now();
    // await provider.getBestSellers();
    // await provider.getCatgories();
    // await provider.getFeturedProducts();
    // await provider.getBanners();
    // final endTime = DateTime.now();
    // print("Difference in sequential API call: ${endTime.difference(startTime).inMilliseconds} ms");
    if (widget.userLogged) {
      await addressProvider.getAddressesAPI();
      Navigator.pushAndRemoveUntil(context,  SideTransistionRoute(screen: const BottomBar()), (route) => false);
    } else {
      Navigator.pushAndRemoveUntil(context, downToTop(screen: const LoginPage(fromSplash: true,)), (route) => false);
    }
  }

  void loadAPIBackground(SendPort sendPort) async {
    final provider = Provider.of<ApiProvider>(context, listen: false);
    await Future.wait([
      provider.getBestSellers(),
      provider.getCatgories(),
      provider.getFeturedProducts(),
      provider.getBanners()
    ]);
  }

}