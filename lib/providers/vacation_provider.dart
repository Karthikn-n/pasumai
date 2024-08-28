import 'package:flutter/material.dart';

class VacationProvider extends ChangeNotifier{
  DateTime? startDate;
  DateTime? endDate;
  DateTime? updatedStartDate;
  DateTime? updatedEndDate;
  bool notSet = false;
  String selectedReason  = "";
  List<String> reasons = [
    'Going family tour',
    'Family function',
    'Shifiting home',
    "Don't want to mention"
  ];

  void setTime({DateTime? pickedDate, required bool isStart}){
    if (isStart) {
      startDate = pickedDate;
    }else{
      endDate = pickedDate;
    }
    notifyListeners();
  }

  void updateTime({DateTime? updatedDate, required bool isStart}){
    if (isStart) {
      updatedStartDate = updatedDate;
    }else{
      updatedEndDate = updatedDate;
    }
    notifyListeners();
  }

  void setSelectedReason(String reason){
    selectedReason = reason;
    notifyListeners();
  }

  void validate(bool isOk){
    notSet = true;
    notifyListeners();
  }

  

  void clearAddDates(){
    startDate = null;
    endDate = null;
    selectedReason = "";
    notSet = false;
    notifyListeners();
  }

  void cleatupdateDates(){
    updatedEndDate = null;
    updatedStartDate = null;
    selectedReason = "";
    notSet = false;
    notifyListeners();
  }
}