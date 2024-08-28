
class ActiveSubscriptionModel {
  final int subId;
  final int subRefId;
  final String startDate;
  final String? endDate;
  final String status;
  final String frequency;
  final int productId;
  final String productName;
  final String customerBalacne;
  final int productPrice;
  final String productImage;
  final List<FrequencyData> frequencyData;
  final List<FrequencyDataMob> frequencyMobData;

  ActiveSubscriptionModel({
    required this.subId,
    required this.subRefId,
    required this.startDate,
    this.endDate,
    required this.status,
    required this.frequency,
    required this.productId,
    required this.customerBalacne,
    required this.productName,
    required this.productPrice,
    required this.productImage,
    required this.frequencyData,
    required this.frequencyMobData,
  });

  factory ActiveSubscriptionModel.fromJson(Map<String, dynamic> json) {
     List<dynamic> frequencyDataJson = json['frequency_data'] ?? [];
    List<dynamic> frequencyMobDataJson = json['frequency_mob_data'] ?? [];

    return ActiveSubscriptionModel(
      subId: json['sub_id'] ?? 0,
      subRefId: json['sub_ref_id'] ?? json['sub_id'],
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'],
      status: json['status'] ?? '',
      customerBalacne: json["customer_balance"].toString() ,
      frequency: json['frequency'] ?? '',
      productId: json['product_id'] ?? 0,
      productName: json['product_name'] ?? '',
      productPrice: json['product_price'] ?? '',
      productImage: json['product_image'] ?? '',
      frequencyData: frequencyDataJson.map((data) => FrequencyData.fromJson(data)).toList(),
      frequencyMobData: frequencyMobDataJson.map((data) => FrequencyDataMob.fromJson(data)).toList(),
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

class FrequencyDataMob {
  final String day;
  int mrgQuantity;
  int evgQuantity;

  FrequencyDataMob({
    required this.day,
    required this.mrgQuantity,
    required this.evgQuantity,
  });

  factory FrequencyDataMob.fromJson(Map<String, dynamic> json) {
    return FrequencyDataMob(
      day: json['day'],
      mrgQuantity: json['mrg_quantity'],
      evgQuantity: json['evg_quantity'],
    );
  }
}

