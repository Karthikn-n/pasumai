import 'dart:convert';

class UpiModel {
  final int id;
  final String upiProvider;
  final String upiId;
  UpiModel({
    required this.id,
    required this.upiProvider,
    required this.upiId,
  });
  

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'id': id});
    result.addAll({'upiProvider': upiProvider});
    result.addAll({'upiId': upiId});
  
    return result;
  }

  factory UpiModel.fromMap(Map<String, dynamic> map) {
    return UpiModel(
      id: map['id']?.toInt() ?? 0,
      upiProvider: map['provider_name'] ?? '',
      upiId: map['upi_id'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UpiModel.fromJson(String source) => UpiModel.fromMap(json.decode(source));
}
