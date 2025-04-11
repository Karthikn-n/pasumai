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
  static const String twilioAccountSID = "ACfc099d19e4c9753774ebbae5ab1970fe";
  static const String twilioAPIKey = "SKbc551db8999a8c4ca0b498578b166487";
  static const String twilioAPISecret = "7BnapKMZcbXrOzy0im8Ow0Yau9d8QKWn";
}