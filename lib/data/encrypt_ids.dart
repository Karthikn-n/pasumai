import 'package:encrypt/encrypt.dart' as encrypt;


class UserId {
  static int? _userId;
  static String? _orderId;
  static String? _productId;
  static String? _subId;
  static String? _vacationId;
  static String? _addressId;
  static void setUserId(int userId) {
    _userId = userId;
  }

  static int? getUserId() {
    return _userId;
  }
  static void setVacationId(String vacationId) {
    _vacationId = vacationId;
  }

  static String? getVacationId() {
    return _vacationId;
  }
  static void setAddressId(String addressId) {
    _addressId = addressId;
  }

  static String? getAddressId() {
    return _addressId;
  }
  static void setSubId(String subId) {
    _subId = subId;
  }

  static String? getSubId() {
    return _subId;
  }
   static void setproductId(String productId) {
    _productId = productId;
  }

  static String? getproductId() {
    return _productId;
  }


  static void setOrderId(String orderId){
      _orderId = orderId;
  }
   
  static String? getOrderId(){
    return _orderId;
  }
}

// Key and Iv
String key = '3mtree8u51n33ss501ut10nm33n6v33r';
String iv = 'm33n6v33r6561r6w';

// Encryption method 
String encryptAES(String textToEncrypt){
  final secertKey = encrypt.Key.fromUtf8(key);
  final ivKey = encrypt.IV.fromUtf8(iv);
  final encrypter = encrypt.Encrypter(encrypt.AES(secertKey, mode: encrypt.AESMode.cbc, padding: 'PKCS7'));
  final encrypted = encrypter.encrypt(textToEncrypt, iv: ivKey);
  return encrypted.base64;
}

String decryptAES(String encryptedData,)  {
  try{
  final encrypter = encrypt.Encrypter(encrypt.AES(encrypt.Key.fromUtf8(key), mode: encrypt.AESMode.cbc, padding: null));
  final encryptedBytes = encrypter.decrypt64(encryptedData, iv: encrypt.IV.fromUtf8(iv));
  return encryptedBytes;
  }catch(e){
    return 'null';
  }
}