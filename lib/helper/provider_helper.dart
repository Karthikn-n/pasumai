import 'package:app_3/providers/address_provider.dart';
import 'package:app_3/providers/cart_items_provider.dart';
import 'package:app_3/providers/locale_provider.dart';
import 'package:app_3/providers/profile_provider.dart';
import 'package:app_3/providers/subscription_provider.dart';
import 'package:app_3/service/connectivity_helper.dart';
import 'package:provider/provider.dart';

import '../data/constants.dart';
import '../providers/api_provider.dart';
import '../providers/firebase_provider.dart';
import '../providers/vacation_provider.dart';
import '../screens/sub-screens/checkout/provider/payment_proivider.dart';
import '../screens/sub-screens/filter/components/filter_provider.dart';

class ProviderHelper {

  static List<ChangeNotifierProvider> getProviders(){
    return [
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
      ChangeNotifierProvider(create: (_) => FirebaseProvider(),),
      ChangeNotifierProvider(create: (_) => FilterProvider(),)
    ];
  }
}