import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

mixin DataAccessingHelper {

  final List<Map<String, Map<String,String>>> contactList = [];

  // Get the permission for contact first
  Future<void> accessingContact() async {
    final permissionStatus = await Permission.contacts.status;
    if (permissionStatus == PermissionStatus.denied 
    || permissionStatus == PermissionStatus.permanentlyDenied) {
      await Permission.contacts.request();
    }
    List<Contact> contacts = await FlutterContacts.getContacts();

    for (var contact in contacts) {
      if (contact.phones.isNotEmpty) {
        contactList.add({
          contact.displayName : {
          "name": contact.displayName,
          "phone_no": contact.phones.first.number
        }
        });
      }
    }
  }
  
}