import 'package:app_3/providers/api_provider.dart';
import 'package:app_3/providers/locale_provider.dart';
import 'package:app_3/providers/profile_provider.dart';
import 'package:app_3/providers/vacation_provider.dart';
import 'package:app_3/screens/on_boarding/otp_page.dart';
import 'package:app_3/widgets/sub_screen_widgets/new_address_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:app_3/providers/cart_items_provider.dart';
import 'package:app_3/helper/shared_preference_helper.dart';
import 'package:app_3/providers/address_provider.dart';
import 'package:app_3/providers/subscription_provider.dart';
import 'package:app_3/screens/on_boarding/signin_page.dart';
import 'package:app_3/service/connectivity_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesHelper.init();
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
      child: MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  SharedPreferences prefs = SharedPreferencesHelper.getSharedPreferences();
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
            primaryColorDark: Colors.black,
            scaffoldBackgroundColor: Colors.white,
            primaryColor: const Color(0xFF60B47B),
          ),
          home: prefs.getBool("registered")?? false
          ? const OtpPage()
          : prefs.getBool("newUserVerified") ?? false 
            ? const NewAddressFormWidget(fromOnboarding: true,)
            : const LoginPage(),
        );
      },
    );
  }
}
