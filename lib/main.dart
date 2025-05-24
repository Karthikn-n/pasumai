import 'dart:developer' as dev;

import 'package:app_3/providers/address_provider.dart';
import 'package:app_3/providers/firebase_provider.dart';
import 'package:app_3/providers/locale_provider.dart';
import 'package:app_3/screens/on_boarding/splash_screen.dart';
import 'package:app_3/screens/sub-screens/checkout/provider/payment_proivider.dart';
import 'package:app_3/service/notification_service.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
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
import 'screens/main_screens/notification/notification_model.dart';
import 'screens/sub-screens/filter/components/filter_provider.dart';
import 'service/connectivity_helper.dart';


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final stopwatch = Stopwatch()..start();
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
  final profileProvider = ProfileProvider();
  final apiProvider = ApiProvider();

  NotificationService.instance.init(
    profileProvider: profileProvider,
    apiProvider: apiProvider,
  );

  // _initializeFirebaseMessaging(navigatorKey.currentState!.context);
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
          ChangeNotifierProvider(create: (_) => profileProvider,),
          ChangeNotifierProvider(create: (_) => VacationProvider()),
          ChangeNotifierProvider(create: (_) => apiProvider,),
          ChangeNotifierProvider(create: (_) => Constants(),),
          ChangeNotifierProvider(create: (_) => PaymentProivider(),),
          ChangeNotifierProvider(create: (_) => FirebaseProvider(),),
          ChangeNotifierProvider(create: (_) => FilterProvider(),)
        ],
        child: MyApp(userLogged:  prefs.getBool("${prefs.getString("customerId")}_${prefs.getString("mobile")}_logged") ?? false, stopwatch: stopwatch,),
      )
    );
  });
  dev.Service.getInfo().then((info) {
    print('VM Service URL: ${info.serverUri}');
  });
}

class MyApp extends StatefulWidget {
  final bool userLogged;
  final Stopwatch stopwatch;
  const MyApp({super.key, required this.userLogged, required this.stopwatch});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    getFirebaseToken();
    // Stop the stopwatch when the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.stopwatch.stop();
      dev.log('Startup time: ${widget.stopwatch.elapsedMilliseconds} ms');
      debugPrint('Startup time: ${widget.stopwatch.elapsedMilliseconds} ms');
    });
  }

  Future<void> getFirebaseToken() async {
    final provider = Provider.of<FirebaseProvider>(context, listen: false);
    await provider.getFCMToken();
  }
  
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
          home: Builder(
            builder: (context) {
              NotificationService().initialize(context);
              return SplashScreen(userLogged: widget.userLogged,);
            }
          ),
        );
      },
    );
  }
}


Future<void> _initializeFirebaseMessaging(BuildContext context) async {

  final provider = Provider.of<FirebaseProvider>(context);
    // Ask the permission from the user for sending notifications
  await provider.getPermission();
  // Get the firebase cloud messaging token for sending personalize messages
  await provider.getFCMToken();
  /// This method helpt to get the notifications when the app is in background,
  /// By default on click notification is the background brought the app to foreground
  /// and we can customize the on click method as well
  FirebaseMessaging.onBackgroundMessage(provider.notificationStorage);
  // Initialize the flutter local notifications for foreground notifications
  await provider.listenForegroundNotification().then((value) {
    // if (value != null) {
      // provider.notificationStorage(value);
    // }
  },);
  await provider.initializeFlutterLocalNotification();
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Initialize Hive if not already initialized
  final storage = await getExternalStorageDirectory();
  if (!Hive.isBoxOpen('notificationsBox')) {
    Hive.init(storage!.path);// Provide the correct path
  }
  Hive.registerAdapter(NotificationModelAdapter());
  // Create a NotificationModel from the message data
  final notification = NotificationModel(
    id: message.data["id"] ?? 1, // Unique ID
    notificationType: message.notification?.title ?? 'Unknown',
    notificationData: message.data,
    notificationTime: DateTime.now(),
    notificationImage: message.notification?.android?.imageUrl ?? '',
  );

  // Use Hive to store the notification
  final box = await Hive.openBox<NotificationModel>('notificationsBox');
  await box.add(notification);
}

