// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:app_3/data/encrypt_ids.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditProfileScreen extends StatefulWidget {
  final String name;
  final String email;
  final String mobile;

  const EditProfileScreen({
    super.key,
    required this.name,
    required this.email,
    required this.mobile,
  });

  @override
  // ignore: library_private_types_in_public_api
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController nameController;
  // late TextEditingController lastnameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

// initalise the default user to the text field to change
  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    // lastnameController = TextEditingController(text: widget.name);
    emailController = TextEditingController(text: widget.email);
    phoneController = TextEditingController(text: widget.mobile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            // TextField(
            //   controller: lastnameController,
            //   decoration: const InputDecoration(labelText: 'Last Name'),
            // ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Phone'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                sendData();
                // Get the updated values and pop the page
                String newName = nameController.text;
                String newEmail = emailController.text;
                String newMobile = phoneController.text;
                // It send the new edited name to the previous screen
                Navigator.pop(context, {'name': newName, 'email': newEmail, 'mobile': newMobile});
              },
              child: const Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  } 
  void sendData() async {
    Map<String, dynamic> userData ={
      'customer_id': UserId.getUserId(),
      'first_name': nameController.text,
      // 'last_name': lastnameController.text,
      'email': emailController.text,
      'mobile_no': phoneController.text,
    };

    String jsonData = json.encode(userData);
    print('JSON Data: $jsonData');
    String encryptedUserData = encryptAES(jsonData);
    print('Encrypted data: $encryptedUserData');
      String url = 'http://pasumaibhoomi.com/connectapi/updateprofile';

    final response = await http.post(Uri.parse(url), body: {'data': encryptedUserData});
    print('SuccessCode: ${response.statusCode}');
    if (response.statusCode == 200)  {
      print('Success: ${response.body}');
      String decrptedData =  decryptAES(response.body);
      print('Decrypted Data: $decrptedData');
      final responseJson = json.decode(decrptedData);
      print('Response: $responseJson');
    }else{
      print('Error: ${response.body}');
    }

  }

}
