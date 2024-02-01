// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:app_3/screens/location_selection.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../data/encrypt_ids.dart';
import '../widgets/screen_widgets.dart';





class LocationList extends StatefulWidget {
  // title
  final String title;
  const LocationList({required this.title, super.key});

  @override
  State<LocationList> createState() => _LocationListState();
}

class _LocationListState extends State<LocationList> {
  int? selectedValue;
  Map<String, dynamic> customerData = {};
  String? address;

  Future<bool?> _confirmDismiss(int index) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete'),
          content: const Text('Are you sure you want to delete this location?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Return false when canceled
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Map<String, dynamic> userData = {"address_id" : UserId.getAddressId()};
                final jsonData = json.encode(userData);
                final encryptedData = encryptAES(jsonData);
                String url = 'http://pasumaibhoomi.com/api/deleteaddress';
                final response = await http.post(Uri.parse(url), body: {'data' : encryptedData});
                if (response.statusCode == 200) {
                  print('Success: ${response.body}');
                } else {
                  print('Failed: ${response.body}');
                }
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop(true); // Return true when deleted
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
// swipe to delete the location
  void removeLocation(int index) {
    setState(() {
      locations.removeAt(index);
      // Update selectedValue to null if the removed item was selected
      if (selectedValue == index) {
        selectedValue = null;
      }
      if (selectedValue != null && selectedValue! > index) {
        selectedValue = selectedValue! - 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 30, ),
            height: 290,
            child: ListView.builder(
              itemCount: locations.length,
              itemBuilder: (context, index) {
                // this widget help to delete the location part
                return Dismissible(
                  key: Key(locations[index].name),
                  onDismissed: (direction) {
                    removeLocation(index);
                  },
                  confirmDismiss: (direction) =>  _confirmDismiss(index),
                  background: Container(
                    color: Colors.red,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 36.0,
                        ),
                        // SizedBox(width: 16.0),
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      // default location
                      LocationDetails(
                        city: locations[index], 
                        index: index, 
                        selectedValue: selectedValue, 
                        onChanged: (int? value) {
                          setState(() {
                            selectedValue = value;
                          });
                        },
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          // app bar in the location section
          Container(
            height: 40,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                Colors.transparent.withOpacity(0.5),
                Colors.transparent.withOpacity(0.3),
                Colors.transparent.withOpacity(0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter
              ),
            ),
            child: Row(
              children: [
                // title
                tabTitle(widget.title),
                const SizedBox(width: 150,),
                GestureDetector(
                  onTap: (){
                    // address form
                    _addAddress();
                  },
                  child: Icon(Icons.add_rounded, color: Colors.green.shade400,)
                )  
              ],
            ),
          ),
        
        ],
      ),
    );
  }
  
  // Add address manually via form
  void _addAddress(){
    showDialog(
      context: context, 
      builder: (context) {
        TextEditingController nameController = TextEditingController();
        TextEditingController addressController = TextEditingController();
        TextEditingController cityController = TextEditingController();
        TextEditingController emailController = TextEditingController();
        TextEditingController phoneController = TextEditingController();

        return AlertDialog(
          title: const Text('Add Address'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextFormField(
                  controller: addressController,
                  decoration: const InputDecoration(labelText: 'Address'),
                ),
                TextFormField(
                  controller: cityController,
                  decoration: const InputDecoration(labelText: 'City'),
                ),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'Phone'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: (){
                 if (nameController.text.isNotEmpty &&
                    addressController.text.isNotEmpty &&
                    cityController.text.isNotEmpty &&
                    emailController.text.isNotEmpty &&
                    phoneController.text.isNotEmpty){
                      setState(() {
                    locations.insert(
                      0,
                      LocationPart(
                        name: nameController.text, 
                        address: addressController.text,
                        city: cityController.text,
                        email: emailController.text,
                        mobile: phoneController.text, 
                      ),
                    );
                  });
                  Navigator.pop(context);
                    }
              }, 
              child: const Text('Add')
            )
          ],
        );
      },
    );
  }
}




