// import 'package:flutter_contacts/flutter_contacts.dart';
// import 'package:permission_handler/permission_handler.dart';

// mixin DataAccessingHelper {

//   final List<Map<String, String>> contactList = [];

//   // Get the permission for contact first
//   Future<void> accessingContact() async {
//     final permissionStatus = await Permission.contacts.status;
//     if (permissionStatus == PermissionStatus.denied 
//     || permissionStatus == PermissionStatus.permanentlyDenied) {
//       await Permission.contacts.request();
//     }
//     List<Contact> contacts = await FlutterContacts.getContacts(withProperties: true,);
//     for (Contact contact in contacts) {
//         contactList.add({
//         "name": contact.displayName,
//         "phone_no": contact.phones.isNotEmpty ? contact.phones.first.normalizedNumber : "No number"
//       });
//     }
//     print(contactList);
//   }
  
// }