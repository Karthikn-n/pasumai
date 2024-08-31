import 'package:app_3/providers/api_provider.dart';
import 'package:app_3/providers/locale_provider.dart';
import 'package:app_3/providers/profile_provider.dart';
import 'package:app_3/providers/vacation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:app_3/providers/cart_items_provider.dart';
import 'package:app_3/helper/shared_preference_helper.dart';
import 'package:app_3/providers/address_provider.dart';
import 'package:app_3/providers/subscription_provider.dart';
import 'package:app_3/screens/on_boarding/signin_page.dart';
import 'package:app_3/service/connectivity_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesHelper.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AddressProvider.helper,),
          ChangeNotifierProvider(create: (_) => ConnectivityService()),
          ChangeNotifierProvider(create: (_) => CartProvider()),
          ChangeNotifierProvider(create:  (_) => SubscriptionProvider()),
          ChangeNotifierProvider(create: (_) => LocaleProvider()),
          ChangeNotifierProvider(create: (_) => ProfileProvider(),),
          ChangeNotifierProvider(create: (_) => VacationProvider()),
          ChangeNotifierProvider(create: (_) => ApiProvider(),)
        ],
        child: const MyApp()
      )
    );
  });
  
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localProvider, child) {
        return  MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          locale: localProvider.locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData(
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white
            ),
            colorScheme:  const ColorScheme.light(
              primary: Color(0xFF60B47B),
            ),
            datePickerTheme: const DatePickerThemeData(
              backgroundColor: Colors.white,
              headerBackgroundColor: Color(0xFF60B47B),
              headerForegroundColor: Colors.white,
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
            primaryColor: const Color(0xFF60B47B),
            
          ),
          
          home: const LoginPage(),
        );
      },
    );
  }
}
