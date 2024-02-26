class DeliveryAddress{
  String firstName;
  String lastName;
  String flatNo;
  String streetName;
  String pincode;
  String city;
  String state;
  String landmark;
  String email;
  String mobile;

  DeliveryAddress( {
    required this.firstName, 
    required this.lastName, 
    required this.flatNo, 
    required this.streetName, 
    required this.pincode, 
    required this.city, 
    required this.state, 
    required this.landmark, 
    required this.email, 
    required this.mobile,
    });
     // Convert DeliveryAddress object to JSON
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'flatNo': flatNo,
      'streetName': streetName,
      'pincode': pincode,
      'city': city,
      'state': state,
      'landmark': landmark,
      'email': email,
      'mobile': mobile,
    };
  }

  // Create DeliveryAddress object from JSON
  factory DeliveryAddress.fromJson(Map<String, dynamic> json) {
    return DeliveryAddress(
      firstName: json['firstName'],
      lastName: json['lastName'],
      flatNo: json['flatNo'],
      streetName: json['streetName'],
      pincode: json['pincode'],
      city: json['city'],
      state: json['state'],
      landmark: json['landmark'],
      email: json['email'],
      mobile: json['mobile'],
    );
  }
}
    