import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityService with ChangeNotifier{
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  ConnectivityResult _isConnected = ConnectivityResult.none;

  ConnectivityService(){
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((event) {
      _isConnected = event;
      notifyListeners();
    },);
  }
  

  ConnectivityResult get connectivityStatus => _isConnected;

  // check is internet connected or not
  bool get isConnected 
    => _isConnected == ConnectivityResult.mobile 
      || _isConnected == ConnectivityResult.wifi 
      || _isConnected == ConnectivityResult.ethernet;

  // Future<void> checkConnectivity() async {
  //   final connectivityResult = await Connectivity().checkConnectivity();
  //   _isConnected = connectivityResult;
  //   notifyListeners();
  // }

  @override
  void dispose(){
    _connectivitySubscription.cancel();
    super.dispose();
  }
} 