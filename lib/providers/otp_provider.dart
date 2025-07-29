import 'dart:convert';
import 'dart:developer';

import 'package:app_3/data/constants.dart';
import 'package:app_3/helper/shared_preference_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:http/http.dart' as http;

class OTPProvider extends ChangeNotifier {
  static const platform = MethodChannel('otp_channel');
  SharedPreferences prefs = SharedPreferencesHelper.getSharedPreferences();

  Future<String?> startListening() async {
    try {
      final String? otp = await platform.invokeMethod('startSmsListener');
      return otp;
    } on PlatformException catch (e) {
      print("Failed to get SMS: '${e.message}'.");
      return null;
    }
  }

  Future<void> sendOTP(String mobile) async {
    try{
      String hash = await apphash();
      int otp = await generateOTP();
      String key ="665724d30f70a94a15edc0c43e8ed559";
      String templateid ="1407175376551411760";
      String message = "$otp is your otp for Madurai market. $hash";
      String url = "http://sms.embarkinteractive.com/api/smsapi?key=$key&route=2&sender=INSTNE&number=$mobile&templateid=$templateid&sms=$message";
      log("OTP link : $url");
      final response = await http.get(Uri.parse(url));
      print("Response code and response: ${response.statusCode} & ${response.body}");
      if (response.statusCode == 200) {
        print("OTP sent successfully to $mobile");
      } else {
        print("Failed to send OTP: ${response.statusCode}");
      }
    } catch(e) {
      print("Error sending OTP: $e");
    }
  }

  Future<String> apphash() async {
    if(prefs.getString("app_hash") == null){
      String? hash = await SmsAutoFill().getAppSignature;
      await prefs.setString("app_hash", hash);
      return hash;
    } else {
      return prefs.getString("app_hash")!;
    }
  }

  Future<int> generateOTP() async {
    int otp = 1000 + (9999 - 1000) * (DateTime.now().millisecondsSinceEpoch % 1000) ~/ 1000;
    await storeOtp(otp.toString());
    return otp;
  }

  Future<void> storeOtp(String otp) async{
   await prefs.setString("lastOTP", otp);
  }

  Future<bool> checkOtp(String otp) async {
    String storedOTP = prefs.getString("lastOTP") ?? "";
    if(storedOTP.isNotEmpty && otp == storedOTP) { 
      await prefs.setBool("${prefs.getString("customerId")}_${prefs.getString("mobile")}_logged", true);
      return true;
    }
    return false;
  }

  Future<void> clearOTP() async{
    await prefs.remove("last_otp");
  }

  Future<String?> getLastOtp() async {
    return prefs.getString("last_otp");
  }

  /// twilio OTP Sender
  Future<void> twilioOTPSender(String mobile) async {
    try {
      await SmsAutoFill().listenForCode();
      int? lastOtp = await generateOTP();
      String url = "https://api.twilio.com/2010-04-01/Accounts/${Constants.twilioAccountSID}/Messages.json";
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Basic ${base64Encode(utf8.encode('${Constants.twilioAPIKey}:${Constants.twilioAPISecret}'))}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'From': Constants.twilioPhone,
          'To': "+91$mobile",
          'Body': '<#> Your OTP is $lastOtp.\n${Constants.appHash}',
        },
      );
      if (response.statusCode == 200) {
        print("OTP sent successfully from ${Constants.twilioPhone}");
      } else {
        print("Failed to send OTP: ${response.statusCode}");
      }
    } catch (e) {
      print("Error sending OTP: $e");
    }
  }
}