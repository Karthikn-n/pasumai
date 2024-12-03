import 'package:app_3/helper/provider_helper.dart';
import 'package:app_3/providers/locale_provider.dart';
import 'package:app_3/screens/on_boarding/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:app_3/helper/shared_preference_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesHelper.init();
  final SharedPreferences prefs = SharedPreferencesHelper.getSharedPreferences();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(
      MultiProvider(
        providers: ProviderHelper.getProviders(),
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
    return Consumer<LocaleProvider>(
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
      );
  }
}
