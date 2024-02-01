// import 'dart:convert';

class SubscriptionHistoryRes {
  final List<SubscriptionHistory> results;

  SubscriptionHistoryRes({
    required this.results,
  });

  factory SubscriptionHistoryRes.fromJson(Map<String, dynamic> json) {
    final resultsList = json['results'] as List<dynamic>;
    final List<SubscriptionHistory> results = resultsList
        .map((result) => SubscriptionHistory.fromJson(result))
        .toList();

    return SubscriptionHistoryRes(results: results);
  }
}

class SubscriptionHistory {
  final int subId;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final String frequency;
  final int productId;
  final String productName;
  final String productPrice;
  final String productImage;
  final List<FrequencyData> frequencyData;
  final List<FrequencyMobData> frequencyMobData;

  SubscriptionHistory({
    required this.subId,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.frequency,
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.productImage,
    required this.frequencyData,
    required this.frequencyMobData,
  });

  factory SubscriptionHistory.fromJson(Map<String, dynamic> json) {
    final frequencyDataList = json['frequency_data'] as List<dynamic>;
    final List<FrequencyData> frequencyData = frequencyDataList
        .map((data) => FrequencyData.fromJson(data))
        .toList();

    final frequencyMobDataList = json['frequency_mob_data'] as List<dynamic>;
    final List<FrequencyMobData> frequencyMobData = frequencyMobDataList
        .map((data) => FrequencyMobData.fromJson(data))
        .toList();

    return SubscriptionHistory(
      subId: json['sub_id'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      status: json['status'],
      frequency: json['frequency'],
      productId: json['product_id'],
      productName: json['product_name'],
      productPrice: json['product_price'],
      productImage: json['product_image'],
      frequencyData: frequencyData,
      frequencyMobData: frequencyMobData,
    );
  }
}

class FrequencyData {
  final String day;
  final int quantity;

  FrequencyData({
    required this.day,
    required this.quantity,
  });

  factory FrequencyData.fromJson(Map<String, dynamic> json) {
    return FrequencyData(
      day: json['day'],
      quantity: json['quantity'],
    );
  }
}

class FrequencyMobData {
  final String day;
  final int mrgQuantity;
  final int evgQuantity;

  FrequencyMobData({
    required this.day,
    required this.mrgQuantity,
    required this.evgQuantity,
  });

  factory FrequencyMobData.fromJson(Map<String, dynamic> json) {
    return FrequencyMobData(
      day: json['day'],
      mrgQuantity: json['mrg_quantity'],
      evgQuantity: json['evg_quantity'],
    );
  }
}
