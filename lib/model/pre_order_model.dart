
class PreOrderModel {
  final String frequency;
  final String customerId;
  final String paymentStatus;
  final String status;
  final String productName;
  final int totalQuantity;
  final CustomerAddress customerAddress;
  final String startDate;
  final String endDate;
  final String graceDate;
  final int amount;
  final String email;
  final int total;
  final int totDays;
  final String name;

  PreOrderModel({
    required this.frequency,
    required this.customerId,
    required this.paymentStatus,
    required this.status,
    required this.productName,
    required this.totalQuantity,
    required this.customerAddress,
    required this.startDate,
    required this.endDate,
    required this.graceDate,
    required this.amount,
    required this.email,
    required this.total,
    required this.totDays,
    required this.name,
  });

  factory PreOrderModel.fromJson(Map<String, dynamic> json) {
    return PreOrderModel(
      frequency: json['frequency'] ?? "",
      customerId: json['customer_id'] ?? "",
      paymentStatus: json['payment_status'] ?? "",
      status: json['status'] ?? "",
      productName: json['product_name'] ?? "",
      totalQuantity: json['total_quantity'] ?? "",
      customerAddress: CustomerAddress.fromJson(json['customer_address'] ?? {}),
      startDate: json['start_date'] ?? "",
      endDate: json['end_date'] ?? "",
      graceDate: json['grace_date'] ?? "",
      amount: json['amount'] ?? 0,
      email: json['email'] ?? "",
      total: json['total'] ?? 0,
      totDays: json['totDays'] ?? 0,
      name: json['name'] ?? "",
    );
  }
}


class CustomerAddress {
  final int id;
  final int customerId;
  final String pincode;
  final String flatNo;
  final String address;
  final String floor;
  final String landmark;
  final String region;
  final String location;
  final dynamic latitude; // Assuming it can be null
  final dynamic longitude; // Assuming it can be null
  final String isDefault;
  final String delInd;
  final String createdAt;
  final String updatedAt;

  CustomerAddress({
    required this.id,
    required this.customerId,
    required this.pincode,
    required this.flatNo,
    required this.address,
    required this.floor,
    required this.landmark,
    required this.region,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.isDefault,
    required this.delInd,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CustomerAddress.fromJson(Map<String, dynamic> json) {
    return CustomerAddress(
      id: json['id'] ?? 0,
      customerId: int.tryParse(json['customer_id']?.toString() ?? '0' )?? 0,
      pincode: json['pincode'] ?? "",
      flatNo: json['flat_no'] ?? "",
      address: json['address'] ?? "",
      floor: json['floor'] ?? "",
      landmark: json['landmark'] ?? "",
      region: json['region'] ?? "",
      location: json['location'] ?? "",
      latitude: json['latitude'] ?? "",
      longitude: json['longitude'] ?? "",
      isDefault: json['default'] ?? "",
      delInd: json['del_ind'] ?? "",
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
    );
  }
}

