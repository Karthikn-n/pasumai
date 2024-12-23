import 'dart:convert';

import 'package:app_3/firebase_options.dart';
import 'package:app_3/helper/shared_preference_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/main_screens/notification/notification_model.dart';

class FirebaseProvider extends ChangeNotifier{
  final FirebaseAuth _firebaseAuthInstance = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<NotificationModel> notifications = [];
  final SharedPreferences prefs = SharedPreferencesHelper.getSharedPreferences();

  /// initialize the firebase in the [main.dart] file
  static Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
    );
  }

  void removeNotification(int index, bool fromHive) async {
    if (fromHive) {
      final box = await Hive.openBox<NotificationModel>('notificationsBox');
      box.deleteAt(index);
    }else{
      notifications.removeAt(index);
    }
    notifyListeners();
  }
  // google login
  Future<void> signinWithGoogle() async {
    if(await GoogleSignIn().isSignedIn()) await GoogleSignIn().signOut();
    final googleUser = await GoogleSignIn().signIn();
    // final GoogleAuthProvider authProvider = GoogleAuthProvider();
    // Obtain auth details from the request
    final googleAuth = await googleUser?.authentication;

    if (googleAuth != null) {
      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken
      );

      // Once signed in return the User Credential
      UserCredential user = await _firebaseAuthInstance.signInWithCredential(credential);
      Map<String, dynamic> userData = {
        "user_name": user.user!.displayName,
        "user_email": user.user!.email,
        "user_phone": user.user!.phoneNumber,
        "user_photo": user.user!.photoURL,
        "user_uuid": user.user!.uid
      };
      print("Google user: $userData");
      storeUsers(userDetail: userData, fromGoogle: true);
    }
  }
  
  Future<void> signInWithMicrosoft() async {
    final microsoftProvider = MicrosoftAuthProvider();
    final  UserCredential? user;
    if (kIsWeb) {
      user = await FirebaseAuth.instance.signInWithPopup(microsoftProvider);
    } else {
      user = await FirebaseAuth.instance.signInWithProvider(microsoftProvider);
    }
     Map<String, dynamic> userData = {
      "user_name": user.user!.displayName,
      "user_email": user.user!.email,
      "user_phone": user.user!.phoneNumber,
      "user_photo": user.user!.photoURL,
      "user_uuid": user.user!.uid
    };
    print("Google user: $userData");
    storeUsers(userDetail: userData, fromGithub: true);
  }

  // Github login
  Future<void> siginWithGithub() async {
    await _firebaseAuthInstance.signOut();
    // Need SHA finger print to use github social login
     final GithubAuthProvider githubAuthProvider = GithubAuthProvider();

    // Sign in with the GitHub credential
     final  UserCredential? user;
    if (kIsWeb) {
      user = await _firebaseAuthInstance.signInWithPopup(githubAuthProvider);
    } else {
      user = await _firebaseAuthInstance.signInWithProvider(githubAuthProvider);
    }
    Map<String, dynamic> userData = {
      "user_name": user.user!.displayName,
      "user_email": user.user!.email,
      "user_phone": user.user!.phoneNumber,
      "user_photo": user.user!.photoURL,
      "user_uuid": user.user!.uid
    };
    print("Google user: $userData");
    storeUsers(userDetail: userData, fromGithub: true);
  }


  // Using facebook authentication
  Future<void> signInWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();
    final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(result.accessToken!.tokenString);

    UserCredential user = await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
     Map<String, dynamic> userData = {
      "user_name": user.user!.displayName,
      "user_email": user.user!.email,
      "user_phone": user.user!.phoneNumber,
      "user_photo": user.user!.photoURL,
      "user_uuid": user.user!.uid
    };
    print("Google user: $userData");
    storeUsers(userDetail: userData, fromGithub: true);
  }

  // Store the user to the firestore function from based on social login
  Future<void> storeUsers({
    required Map<String, dynamic> userDetail, 
    bool? fromGoogle, 
    bool? fromGithub,
    bool? fromFacebook, 
    bool? fromMicrosoft}) async {
      String collectionName = fromGoogle != null 
            ? "google_user" 
            : fromGithub != null 
              ? "github_user" 
              : fromFacebook  != null
                ? "fb_user"
                : fromMicrosoft != null
                  ? "ms_user"
                  : "users";
      // Create a collection for every social logins
      final collection = _firestore.collection(collectionName);

      // Generate document ID using user email
      await collection.doc(userDetail["user_email"]).set(userDetail);

      
    }

  // Store the user contact in the database
  Future<void> storeUserContancts(List<Map<String, String>> contacts, String user) async {
    // create a collection using user number 
    try {
      print("Called");
      final collection =  _firestore.collection("contacts");
      await collection.doc(user).set({"contacts": json.encode(contacts)});
    } catch (e) {
      FirebaseCrashlytics.instance.log("Can't store contact: $e");
    }
  }

  // Check already user contact is stored
  Future<bool> isStored(String user) async {
    final doc = FirebaseFirestore.instance.collection("contacts").doc(user);

    try {
      final snapshot = await doc.get();
      return snapshot.exists; // Returns true if the document exists, false otherwise.
    } catch (e) {
      print("Error checking document existence: $e");
      return false;
    }
  }


  // Firebase Notification settings
  //  https://www.freecodecamp.org/news/set-up-firebase-cloud-messaging-in-flutter/
  //  https://firebase.google.com/docs/cloud-messaging/flutter/client?hl=en&authuser=0
  Future<void> listenForegroundNotification() async {
    
    
      // Listen to foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      /// Send the message to the flutter local notification [showForegroundNotification] method
      if (message.notification != null) {
        debugPrint("Message: ${message.notification!.title}");
        showForegroundNotification(message);
        notificationStorage(message);
      }
      // final notification = NotificationModel(
      //   id: notifications.length + 1, // Generate ID
      //   notificationType: message.notification?.title ?? 'Unknown',
      //   notificationData: message.data,
      //   notificationTime: DateTime.now(),
      //   notificationImage: message.notification?.android?.imageUrl ?? '',
      // );

      // // Add to in-memory list
      // notifications.add(notification);
      // print('Foreground Notification Added: ${notification.toMap()}');
    });
    // try {
    //   final storage = await getExternalStorageDirectory();
    // if (!Hive.isBoxOpen('notificationsBox')) {
    //   Hive.init(storage!.path);// Provide the correct path
    // Hive.registerAdapter(NotificationModelAdapter());
    // }
    // // Load stored notifications from Hive
    // final box = await Hive.openBox<NotificationModel>('notificationsBox');
    // notifications.addAll(box.values);
    // final notification = box.values.toList();
    // print("Notificatino on storage: ${notification.length}");
    // } catch (e) {
    //   print("error: $e");
    // }
  }

  // Get permissions for notification before intializing the firebase messaging
  Future<void> getPermission() async {
    // This provides the permission for the background and foreground notifications
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      provisional: true,
      sound: true, 
      criticalAlert: true,
    );
    // If all the permissions are false notification will not be shown in the foreground
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true
    );
    notifyListeners();
  }

  // Get the notification token on the refersh method if the token is changed
  Future<void> getFCMToken() async {
    // Initialize the firebase messaging automatically once the app is opened
    FirebaseMessaging.instance.setAutoInitEnabled(true);
    // This will access the token even if changes and store it in the preferences
    // for android devices
    FirebaseMessaging.instance.onTokenRefresh.listen((token) {
      prefs.setString("fcm_token", token);
      debugPrint("FCM Token: ${prefs.getString("fcm_token")}");
    },).onError((error, stackTrace){
      print("error: $error");
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
    });
    
    // Get the token for the first time
    await FirebaseMessaging.instance.getToken().then((token) {
      if (token != null) {
        prefs.setString("fcm_token", token);
        debugPrint("FCM Token: ${prefs.getString("fcm_token")}");
      }
    },);
    // For iOS devices we need to get the APN token and set things up in the iOS developer console
    // https://firebase.google.com/docs/cloud-messaging/flutter/client?hl=en&authuser=0#ios
    notifyListeners();
  }
  
  // In android and iOS the notifications are not shown in the foreground because
  // the firebase is gives customize options to handle the foreground notification
  // So we can use the message packages like flutter_local_notifications to show the notification in the foreground
  // https://pub.dev/packages/flutter_local_notifications
  //
  // intializet the flutter local notification for android and ios
  Future<void> initializeFlutterLocalNotification() async {
    // Initialize the flutter local notification
    final FlutterLocalNotificationsPlugin flutterLocalNotification = FlutterLocalNotificationsPlugin();
    // initalize the flutter local notification  for android and ios
    AndroidInitializationSettings initializatinoSettingsAndroid = const AndroidInitializationSettings('@mipmap/ic_launcher');
    DarwinInitializationSettings iOSInitializationSetting = const DarwinInitializationSettings(
      defaultPresentAlert: true,
    );
    // Initialize the device notifications in the setting
    InitializationSettings initializationSettings = InitializationSettings(
      android: initializatinoSettingsAndroid,
      iOS: iOSInitializationSetting
    );
    await flutterLocalNotification.initialize(initializationSettings);
    notifyListeners();
  }

  // This method is shows the notifications if the app is in foreground
  Future<void> showForegroundNotification(RemoteMessage message) async {
    // Load the notification detail for Android and iOS
    AndroidNotificationDetails androidNotificationDetails = const AndroidNotificationDetails(
      "Message", "Firebase", importance: Importance.max, priority: Priority.high,
    );

    const DarwinNotificationDetails iOSNotificationDetails = DarwinNotificationDetails(
      presentAlert: true, presentBadge: true, presentSound: true, presentBanner: true, presentList: true
    );

    // Flutter notification details for the application
    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails, iOS: iOSNotificationDetails
    );

    // Show the notification in the foreground
    // Initialize the flutter local notification
    final FlutterLocalNotificationsPlugin flutterLocalNotification = FlutterLocalNotificationsPlugin();

    await flutterLocalNotification.show(1, message.notification!.title, message.notification!.body, notificationDetails);
    notifyListeners();
  }

  /// Store the notification in the local storage to show the notification in the app
  Future<void> notificationStorage(RemoteMessage message) async {
    try {
      // Get the common storage for the app to store the notification file
      // This will used for store the data if they are not generated by the user
      final storge = await getExternalStorageDirectory();
      if (!Hive.isBoxOpen("notificationsBox")){
        Hive.init(storge!.path);
      }
      // Register the adapter for the notification model in hive box so it can be identitified the model
      Hive.registerAdapter(NotificationModelAdapter());
      // Open the box for notifications
      final box = await Hive.openBox<NotificationModel>('notificationBox');

      // Create a notification model for the notification
      NotificationModel notification = NotificationModel(
        id: box.values.toList().length + 1 , // Generate ID
        notificationType: message.notification?.title ?? 'Unknown',
        notificationData: message.data,
        notificationTime: DateTime.now(),
        notificationImage: message.notification?.android?.imageUrl ?? '',
      );

      // Store the notifications to the notificationBox
      await box.add(notification);
      debugPrint("Notifications length: ${box.values.toList().length}}");
    } catch (e) {
      debugPrint("Error on hive storage: $e");
    }
    notifyListeners();
  }
}

