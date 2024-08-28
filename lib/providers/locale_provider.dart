import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocaleProvider extends ChangeNotifier{
  Locale locale = const Locale("en");
  bool tnChanged = false;

  void changeLocaleToTamil(){
    locale = const Locale("ta");
    tnChanged = true;
    notifyListeners();
  }
  void changeLocaleToEnglish(){
    locale = const Locale("en");
    notifyListeners();
  }

  AppLocalizations of(BuildContext context){
    return AppLocalizations.of(context)!;
  }
}