// ignore_for_file: avoid_print


import 'package:flutter/material.dart';

import '../widgets/screen_widgets.dart';

class EditLocation extends StatefulWidget {
  final LocationPart location;
  // final LocationAPIList location;
  const EditLocation({super.key, required this.location});

  @override
  // ignore: library_private_types_in_public_api
  _EditLocationState createState() => _EditLocationState();
}

class _EditLocationState extends State<EditLocation> {
  // TextEditingController flatController = TextEditingController();
  // TextEditingController floorController = TextEditingController();
  // TextEditingController addressController = TextEditingController();
  // TextEditingController landmarkController = TextEditingController();
  // TextEditingController pincodeController = TextEditingController();
  // TextEditingController regionController = TextEditingController();
  // TextEditingController locationController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set initial values in controllers
    nameController.text = widget.location.name;
    addressController.text = widget.location.address;
    cityController.text = widget.location.city;
    emailController.text = widget.location.email;
    phoneController.text = widget.location.mobile;
    // flatController.text = widget.location.name;
    // floorController.text = widget.location.address;
    // addressController.text = widget.location.city;
    // landmarkController.text = widget.location.email;
    // pincodeController.text = widget.location.mobile;
    // regionController.text = widget.location.mobile;
    // locationController.text = widget.location.mobile;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Location'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          // Add form fields for editing detailList<LocationAPIList> yourLocations = [];s
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                // controller: flatController,
                // decoration: const InputDecoration(labelText: 'Flat'),
              ),
              TextFormField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Address'),
              ),
              TextFormField(
                controller: cityController,
                decoration: const InputDecoration(labelText: 'City'),
                // controller: floorController,
                // decoration: const InputDecoration(labelText: 'Floor number'),
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                // controller: landmarkController,
                // decoration: const InputDecoration(labelText: 'Landmark'),
              ),
              TextFormField(
                // controller: regionController,
                // decoration: const InputDecoration(labelText: 'Region'),
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
              ),
              // TextFormField(
              //   controller: emailController,
              //   decoration: const InputDecoration(labelText: 'Email'),
                // controller: locationController,
                // decoration: const InputDecoration(labelText: 'Location'),
              // ),
              // TextFormField(
              //   controller: phoneController,
              //   decoration: const InputDecoration(labelText: 'Phone'),
                // controller: pincodeController,
                // decoration: const InputDecoration(labelText: 'Pincode'),
              // ),
              
              ElevatedButton(
                onPressed: () {
                  // Update the details on the previous page
                  final updatedLocation = LocationPart(
                    name: nameController.text,
                    address: addressController.text,
                    city: cityController.text,
                    email: emailController.text,
                    mobile: phoneController.text,
                  );
                  // final updatedLocation = LocationAPIList(
                  //   flatNo: flatController.text,
                  //   address: addressController.text, 
                  //   floor: floorController.text, 
                  //   landMark: landmarkController.text, 
                  //   region: regionController.text, 
                  //   town: locationController.text, 
                  //   pincode: pincodeController.text,
                  // );
                  
                  Navigator.pop(context, updatedLocation);
                },
                child: const Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
  // void sendData() async {
  //   Map<String, dynamic> userData = {
  //     'customer_id' : UserId.getUserId(),
  //     'flat_no' : flatController.text,
  //     'address' : addressController.text,
  //     'floor' : floorController.text,
  //     'landmark': landmarkController.text,
  //     'region': regionController.text,
  //     'location': locationController.text,
  //     'pincode': pincodeController.text,
  //   };

  //   String jsonData = json.encode(userData);
  //   print('JSON Data: $jsonData');
  //   String encryptedUserData = encryptAES(jsonData);
  //   print('Encrypted data: $encryptedUserData');

  //   String url = 'http://pasumaibhoomi.com/api/updateaddress';

  //   final response = await http.post(Uri.parse(url), body: {'data': encryptedUserData});
  //   print('SuccessCode: ${response.statusCode}');
  //   if (response.statusCode == 200)  {
  //     print('Success: ${response.body}');
  //   }else{
  //     print('Error: ${response.body}');
  //   }

  // }
  
}
