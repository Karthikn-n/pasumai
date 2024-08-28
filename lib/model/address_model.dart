class AddressModel{
  int id;
  String flatNo;
  String floorNo;
  String address;
  String pincode;
  String location;
  String region;
  String landmark;
  String? defaultAddress;


  AddressModel( {
    required this.id,
    required this.flatNo, 
    required this.floorNo,
    required this.address, 
    required this.pincode, 
    required this.location, 
    required this.region, 
    required this.landmark, 
    this.defaultAddress
    });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'floor': floorNo,
      'flatNo': flatNo,
      'streetName': address,
      'pincode': pincode,
      'location': location,
      'region': region,
      'landmark': landmark,
      'defaultAddress': defaultAddress
    };
  }

  // Create DeliveryAddress object from JSON
  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['address_id']?? '',
      flatNo: json['flat_no']?? '',
      floorNo: json['floor']?? '',
      address: json['address'] ?? '',
      pincode: json['pincode'] ?? "",
      location: json['location'] ?? '' ,
      region: json['region'] ?? '',
      landmark: json['landmark']?? '',
      // region: json['region'],
      // location: json['location'],
      defaultAddress: json['default']
      // email: json['email'],
      // mobile: json['mobile'],
    );
  }
}

class AddressListmodel{
  int? id;
  String flatNo;
  String floorNo;
  String address;
  String pincode;
  int location;
  int region;
  String landmark;
  String? defaultAddress;


  AddressListmodel( {
    this.id,
    required this.flatNo, 
    required this.floorNo,
    required this.address, 
    required this.pincode, 
    required this.location, 
    required this.region, 
    required this.landmark, 
    this.defaultAddress
    });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'floor': floorNo,
      'flatNo': flatNo,
      'streetName': address,
      'pincode': pincode,
      'location': location,
      'region': region,
      'landmark': landmark,
      'defaultAddress': defaultAddress
    };
  }

  // Create DeliveryAddress object from JSON
  factory AddressListmodel.fromJson(Map<String, dynamic> json) {
    return AddressListmodel(
      id: json['address_id']?? '',
      flatNo: json['flat_no']?? '',
      floorNo: json['floor']?? '',
      address: json['address'] ?? '',
      pincode: json['pincode'] ?? "",
      location: json['location'] ?? '' ,
      region: json['region'] ?? '',
      landmark: json['landmark']?? '',
      // region: json['region'],
      // location: json['location'],
      defaultAddress: json['default']
      // email: json['email'],
      // mobile: json['mobile'],
    );
  }
}
    