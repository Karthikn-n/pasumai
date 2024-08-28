class Subscription {
  final int id;
  final dynamic subRefId; // Assuming it can be null
  final int customerId;
  final int addressId;
  final int productId;
  final String frequency;
  final String amount;
  final String paymentStatus;
  final String status;
  final dynamic startDate;
  final dynamic endDate;
  final dynamic graceDate;
  final dynamic total;
  final String createdAt;
  final String updatedAt;

  Subscription({
    required this.id,
    required this.subRefId,
    required this.customerId,
    required this.addressId,
    required this.productId,
    required this.frequency,
    required this.amount,
    required this.paymentStatus,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.graceDate,
    required this.total,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'],
      subRefId: json['sub_ref_id'],
      customerId: json['customer_id'],
      addressId: json['address_id'],
      productId: json['product_id'],
      frequency: json['frequency'],
      amount: json['amount'],
      paymentStatus: json['payment_status'],
      status: json['status'],
      startDate: json['start_date'] ?? "null",
      endDate: json['end_date'] ?? "null",
      graceDate: json['grace_date'] ?? "null",
      total: json['total'] ?? "null",
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class ProductDetail {
  final int id;
  final dynamic productPosition; // Assuming it can be null
  final String title;
  final String description;
  final String image;
  final String quantity;
  final int price;
  final int finalPrice;
  final int catCount;
  final String createdAt;
  final String updatedAt;
  final String delInd;

  ProductDetail({
    required this.id,
    required this.productPosition,
    required this.title,
    required this.description,
    required this.image,
    required this.quantity,
    required this.price,
    required this.finalPrice,
    required this.catCount,
    required this.createdAt,
    required this.updatedAt,
    required this.delInd,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json) {
    return ProductDetail(
      id: json['id'],
      productPosition: json['product_position'],
      title: json['title'],
      description: json['description'],
      image: json['image'],
      quantity: json['quantity'],
      price: json['price'],
      finalPrice: json['final_price'],
      catCount: json['cat_count'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      delInd: json['del_ind'],
    );
  }
}

class SubscriptionDetail {
  final int id;
  final int subscriptionId;
  final String frequency;
  final String day;
  final int mrgQuantity;
  final int evgQuantity;
  final String createdAt;
  final String updatedAt;

  SubscriptionDetail({
    required this.id,
    required this.subscriptionId,
    required this.frequency,
    required this.day,
    required this.mrgQuantity,
    required this.evgQuantity,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SubscriptionDetail.fromJson(Map<String, dynamic> json) {
    return SubscriptionDetail(
      id: json['id'],
      subscriptionId: json['subscription_id'],
      frequency: json['frequency'],
      day: json['day'],
      mrgQuantity: json['mrg_quantity'],
      evgQuantity: json['evg_quantity'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class DefaultAddress {
  final int id;
  final int customerId;
  final String address;
  final dynamic floor; // Assuming it can be null
  final dynamic landmark; // Assuming it can be null
  final String region;
  final String location;
  final String? latitude;
  final String? longitude;
  final String isDefault;
  final String delInd;
  final String createdAt;
  final String updatedAt;

  DefaultAddress({
    required this.id,
    required this.customerId,
    required this.address,
    required this.floor,
    required this.landmark,
    required this.region,
    required this.location,
    this.latitude,
    this.longitude,
    required this.isDefault,
    required this.delInd,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DefaultAddress.fromJson(Map<String, dynamic> json) {
    return DefaultAddress(
      id: json['id'],
      customerId: json['customer_id'],
      address: json['address'],
      floor: json['floor'],
      landmark: json['landmark'],
      region: json['region'],
      location: json['location'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      isDefault: json['default'],
      delInd: json['del_ind'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class CustomerBalance {
  final int balance;

  CustomerBalance({
    required this.balance,
  });

  factory CustomerBalance.fromJson(Map<String, dynamic> json) {
    return CustomerBalance(
      balance: json['customer_balance'],
    );
  }
}


class RenewSubscriptionResponse {
  final Subscription subscription;
  final ProductDetail productDetail;
  final List<SubscriptionDetail> subscriptionDetail;
  final DefaultAddress defaultAddress;
  final String customerBalance;

  RenewSubscriptionResponse({
    required this.subscription,
    required this.productDetail,
    required this.subscriptionDetail,
    required this.defaultAddress,
    required this.customerBalance,
  });

  factory RenewSubscriptionResponse.fromJson(Map<String, dynamic> json) {
    return RenewSubscriptionResponse(
      subscription: Subscription.fromJson(json['subscription']),
      productDetail: ProductDetail.fromJson(json['product_detail']),
      subscriptionDetail: List<SubscriptionDetail>.from(
        json['subscription_detail'].map((item) => SubscriptionDetail.fromJson(item))
      ),
      defaultAddress: DefaultAddress.fromJson(json['default_address']),
      customerBalance: json['customer_balance'],
    );
  }
}



class RenewSubscriptionModel {
  final String totalQty;
  final String totalDays;
  final String totalAmount;
  final String endDate;
  final String graceDate;
  final String finalTotal;

  RenewSubscriptionModel({
    required this.totalQty,
    required this.totalDays,
    required this.totalAmount,
    required this.endDate,
    required this.graceDate,
    required this.finalTotal,
  });

  factory RenewSubscriptionModel.fromMap(Map<String, dynamic> map) {
    return RenewSubscriptionModel(
      totalQty: map['totalQty'] ?? '',
      totalDays: map['totalDays'] ?? '',
      totalAmount: map['totalAmount'] ?? '',
      endDate: map['endDate'] ?? '',
      graceDate: map['graceDate'] ?? '',
      finalTotal: map['finalTotal'] ?? '',
    );
  }
}


