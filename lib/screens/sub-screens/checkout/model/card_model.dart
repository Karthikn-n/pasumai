import 'dart:convert';

class CardModel {
  final int id;
  final String cardNumber;
  final String expireDate;
  final int cvv;
  final String cardholderName;
  CardModel({
    required this.id,
    required this.cardNumber,
    required this.expireDate,
    required this.cvv,
    required this.cardholderName,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'id': id});
    result.addAll({'cardNumber': cardNumber});
    result.addAll({'expireDate': expireDate});
    result.addAll({'cvv': cvv});
    result.addAll({'cardholderName': cardholderName});
  
    return result;
  }

  factory CardModel.fromMap(Map<String, dynamic> map) {
    return CardModel(
      id: map['id']?.toInt() ?? 0,
      cardNumber: map['cardNumber'] ?? '',
      expireDate: map['expireDate'] ?? '',
      cvv: map['cvv']?.toInt() ?? 0,
      cardholderName: map['cardholderName'] ?? '',
    );
  }

}
