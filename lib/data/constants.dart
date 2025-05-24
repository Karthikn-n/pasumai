import 'package:flutter/material.dart';

class Constants extends ChangeNotifier{
  // Scroll Controllers
  final ScrollController _wishlistScrollController = ScrollController();
  final ScrollController _orderHistoryScrollController = ScrollController();
  final ScrollController _subHistoryScrollController = ScrollController();
  final ScrollController _activeSubScrollController = ScrollController();
  final ScrollController _vacationScrollController = ScrollController();
  final ScrollController _addressesScrollController = ScrollController();
  final ScrollController _categoriesScrollController = ScrollController();
  final ScrollController _invoiceScrollController = ScrollController();
  final ScrollController _categoryListScrollController = ScrollController();

  ScrollController get activeSubScrollController => _activeSubScrollController;
  ScrollController get wishlistScrollController => _wishlistScrollController;
  ScrollController get orderHistoryScrollController => _orderHistoryScrollController;
  ScrollController get vacationScrollController => _vacationScrollController;
  ScrollController get subHistoryScrollController => _subHistoryScrollController;
  ScrollController get addressScrollController => _addressesScrollController;
  ScrollController get categoriesController => _categoriesScrollController;
  ScrollController get invoiceController => _invoiceScrollController;
  ScrollController get categoryListController => _categoryListScrollController;

  @override
  void dispose() {
    _activeSubScrollController.dispose();
    _orderHistoryScrollController.dispose();
    _activeSubScrollController.dispose();
    _categoriesScrollController.dispose();
    _vacationScrollController.dispose();
    _addressesScrollController.dispose();
    _subHistoryScrollController.dispose();
    _invoiceScrollController.dispose();
    _categoryListScrollController.dispose();
    super.dispose();
  }

  static const String appHash = "S4HH6GWSpfZ";
  static const String twilioPhone = "+19497750386";
  static const String twilioAccountSID = "VA0e6dd29be8e3db9aa4f291159d37e9d7";
  static const String twilioAPIKey = "SKbc551db8999a8c4ca0b498578b166487";
  static const String twilioAPISecret = "7OkAfjsWHHDSDhyEZKZLLPt3XgIpCQeB";
  static const String twilioAuthToken  = "2b2250bc9a79f2a568681b09dc8d3648";
  static const String twilioRecoverSID = "SKaa8eaea8f217405d7d575033bc437f82";


//   {
//   "status": "approved",
//   "payee": null,
//   "date_updated": "2025-05-10T08:09:19Z",
//   "account_sid": "AC2b21d7f00e9d2b2e3cb8e0f07edad856",
//   "to": "+918838955205",
//   "amount": null,
//   "valid": true,
//   "sid": "VEb32a21b1dabb4d1ff2de9c875d4609e5",
//   "date_created": "2025-05-10T08:08:51Z",
//   "service_sid": "VA0e6dd29be8e3db9aa4f291159d37e9d7",
//   "channel": "sms"
// }
}