import 'package:app_3/providers/address_provider.dart';
import 'package:app_3/providers/firebase_authenticate_provider.dart';
import 'package:app_3/providers/locale_provider.dart';
import 'package:app_3/screens/main_screens/cubits/cart_cubits.dart';
import 'package:app_3/screens/main_screens/cubits/cart_repository.dart';
import 'package:app_3/screens/on_boarding/splash_screen.dart';
import 'package:app_3/screens/sub-screens/checkout/provider/payment_proivider.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:app_3/helper/shared_preference_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/constants.dart';
import 'providers/api_provider.dart';
import 'providers/cart_items_provider.dart';
import 'providers/profile_provider.dart';
import 'providers/subscription_provider.dart';
import 'providers/vacation_provider.dart';
import 'screens/sub-screens/filter/components/filter_provider.dart';
import 'service/connectivity_helper.dart';


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesHelper.init();
  final SharedPreferences prefs = SharedPreferencesHelper.getSharedPreferences();
  await FirebaseProvider.init();
  FlutterError.onError = (errorDetails) async {
    if (!await FirebaseCrashlytics.instance.didCrashOnPreviousExecution()) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    }else{
      FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
    }
  };
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AddressProvider(),),
          ChangeNotifierProvider(create: (_) => ConnectivityService()),
          ChangeNotifierProvider(create: (_) => CartProvider()),
          ChangeNotifierProvider(create: (_) => SubscriptionProvider()),
          ChangeNotifierProvider(create: (_) => LocaleProvider()),
          ChangeNotifierProvider(create: (_) => ProfileProvider(),),
          ChangeNotifierProvider(create: (_) => VacationProvider()),
          ChangeNotifierProvider(create: (_) => ApiProvider(),),
          ChangeNotifierProvider(create: (_) => Constants(),),
          ChangeNotifierProvider(create: (_) => PaymentProivider(),),
          ChangeNotifierProvider(create:  (_) => FilterProvider(),)
        ],
        child: MyApp(userLogged:  prefs.getBool("${prefs.getString("customerId")}_${prefs.getString("mobile")}_logged") ?? false,)
      )
    );
  });
  
}

class MyApp extends StatelessWidget {
  final bool userLogged;
  const MyApp({super.key, required this.userLogged});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CartCubits(CartRepository()),
      child: Consumer<LocaleProvider>(
        builder: (context, localProvider, child) {
          return  MaterialApp(
            title: 'Flutter Demo',
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            locale: localProvider.locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: ThemeData(
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white
              ),
             
              primaryColorLight: Colors.white,
              colorScheme:  const ColorScheme.light(
                primary: Color(0xFF60B47B),
              ),
              textTheme: Theme.of(context).textTheme.apply(
                fontFamily: 'Poppins',
              ),
              primaryColor: const Color(0xFF60B47B),
              datePickerTheme: const DatePickerThemeData(
                backgroundColor: Colors.white,
                headerBackgroundColor: Color(0xFF60B47B),
                headerForegroundColor: Colors.white,
                dividerColor:  Color(0xFF60B47B),
                rangePickerBackgroundColor: Color(0xFF60B47B),
                cancelButtonStyle: ButtonStyle(
                  textStyle: WidgetStatePropertyAll(
                    TextStyle(color: Color(0xFF60B47B))
                  ),
                  foregroundColor: WidgetStatePropertyAll(Color(0xFF60B47B))
                ),
                yearStyle: TextStyle(color: Colors.white),
                confirmButtonStyle: ButtonStyle(
                  textStyle: WidgetStatePropertyAll(
                    TextStyle(color: Color(0xFF60B47B))
                  ),
                  foregroundColor: WidgetStatePropertyAll(Color(0xFF60B47B))
                ),
              ),
              primaryColorDark: Colors.black,
              scaffoldBackgroundColor: Colors.white,
            ),
            home: SplashScreen(userLogged: userLogged,),
          );
        },
      ),
    );
  }
}
