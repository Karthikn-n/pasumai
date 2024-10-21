// import 'dart:io';

// import 'package:app_3/firebase_options.dart';
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:intl/intl.dart';

// class FirebaseAnalyticsHelper {
//   static FirebaseAnalytics analytics = FirebaseAnalytics.instance;

//   // initialize Firebase 
//   static Future<void> init() async {
//      await Firebase.initializeApp(
//       options: DefaultFirebaseOptions.currentPlatform
//     );
//   }

//    // Get Analytic report from the User
//   static Future<void> trackFirstLaunch() async {
//     Map<String, dynamic> deviceInfo = await getDeviceModel();
//     await analytics.logEvent(
//       name: "app_install",
//       parameters: {
//         "installed_time": DateFormat("dd/MM/yyyy").format(DateTime.now()),
//         "device_model": deviceInfo["device_model"].toString(),
//         "device_id": deviceInfo["device_id"].toString(),
//         "product_name": deviceInfo["product_name"].toString(),
//         "device_serial_number": deviceInfo["device_serial_number"].toString(),
//         "device_manufacturer": deviceInfo["device_manufacturer"].toString(),
//         "suppoerted_abis": deviceInfo["suppoerted_abis"].toString(),
//         "device_current_version": deviceInfo["device_current_version"].toString(),
//         "device_release_version": deviceInfo["device_release_version"].toString(),
//         "physical_device": deviceInfo["physical_device"].toString(),
//         "installed_types": deviceInfo["installed_types"].toString(),
//         "device_os_version": Platform.operatingSystemVersion.toString()
//       }
//     );
//     print("Device info: $deviceInfo");
//   }

//   static Future<Map<String, dynamic>> getDeviceModel() async {
//     var deviceInfo = DeviceInfoPlugin();
//     if (Platform.isAndroid) {
//       AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
//       return {
//         "operting_system": "Android",
//         "device_id": androidInfo.id,
//         "device_model": androidInfo.model,
//         "product_name": androidInfo.product,
//         "device_serial_number": androidInfo.serialNumber,
//         "device_manufacturer": androidInfo.manufacturer,
//         "suppoerted_abis": androidInfo.supportedAbis.join(", "),
//         "device_current_version": androidInfo.version.sdkInt.toString(),
//         "device_release_version": androidInfo.version.release,
//         "physical_device": androidInfo.isPhysicalDevice,
//         "installed_types": androidInfo.tags,
//       };
//     }
//     return {"device_model": "unknown"};
//   }

// }