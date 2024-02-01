// ignore_for_file: avoid_print


import 'dart:convert';

import 'package:app_3/data/encrypt_ids.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../widgets/screen_widgets.dart';
import 'edit_location.dart';


// ignore: must_be_immutable
class LocationDetails extends StatefulWidget {
  LocationPart city;
  final int index;
  final int? selectedValue;
  final ValueChanged<int?> onChanged;

  LocationDetails({
    super.key,
    required this.city,
    required this.index,
    required this.selectedValue,
    required this.onChanged, 
  });
  @override
  State<LocationDetails> createState() => _LocationDetailsState();
}

class _LocationDetailsState extends State<LocationDetails> {
  
  late final String addressSharedPreferencesKey = 'selectedAddress_${widget.index}';
  late final String citySharedPreferencesKey = 'selectedCity_${widget.index}';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
   // edit profile content
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  // default profile name



  void locationList() async {
    Map<String, dynamic> userData = {
      "customer_id" : UserId.getUserId()
    };
    final jsonData = json.encode(userData);
    final encryptedData = encryptAES(jsonData);
    String url = 'http://pasumaibhoomi.com/api/addresslist';
    final response = await http.post(Uri.parse(url), body: {'data' : encryptedData});
    print('SuccessCode: ${response.statusCode}');
    if (response.statusCode == 200) {
      print('Success: ${response.body}');
      String decryptedData = decryptAES(response.body);
      print('Decrypted Data: $decryptedData');
      final responseJson = json.decode(decryptedData);
      print("Response: $responseJson");
      final results = responseJson["results"];
      for(var result in results){
        String flatNo = result["flat_no"];
        String address = result["address"];
        String floor = result["floor"];
        String landMark = result["landmark"];
        String region = result["region"];
        String town = result["location"];
        String pincode = result["pincode"];

        yourLocations.add(
          LocationAPIList(
            flatNo: flatNo,
            address: address, 
            floor: floor, 
            landMark: landMark, 
            region: region, 
            town: town, 
            pincode: pincode
          )
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Container(
      // height: 165,
      width: 340,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.greenAccent.shade100),
        borderRadius: BorderRadius.circular(12)
      ),
      margin: const EdgeInsets.only(top: 10, left: 12, right: 12, bottom: 25),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //  location details
          Container(
            width: 270,
            margin: const EdgeInsets.only(left: 8, top: 10, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      // '255/4,',
                      widget.city.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditLocation(location: widget.city),
                          ),
                        );
                      } ,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10, left: 4),
                        child: const Icon(
                          Icons.edit,
                          size: 14,
                          color: Colors.lightBlue,
                        ),
                      ),
                    )
                      ],
                    ),
                    Text(
                      // '255/4, Eswaran 2nd Street pagalavan nagar colony',
                      // '${yourLocations[widget.index].flatNo},${yourLocations[widget.index].address}',
                      widget.city.address,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                    
                        fontWeight: FontWeight.w400
                      ),
                    ),
                    Text(
                      widget.city.city,
                      // 'Anuppandi,higher secondary school',
                      // '${yourLocations[widget.index].floor},${yourLocations[widget.index].landMark}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400
                      ),
                    ),
                    Text(
                      // 'Avaniyapuram,Madurai',
                      // '${yourLocations[widget.index].town}, ${yourLocations[widget.index].region}'
                      widget.city.email,
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                    Text(
                      // '600075',
                      // yourLocations[widget.index].pincode
                      widget.city.mobile,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400
                      ),
                    )   // user name
              ],
            ),
          ),
          // radio button for selected address
          Container(
            margin: const EdgeInsets.only(top: 45),
            child: Radio<int>(
              value: widget.index,
              groupValue: widget.selectedValue,
              onChanged: widget.onChanged,
            ),
          ),
        ],
      ),
    );
  
  }




   


 


  // store the selected address in the map to cache 

}

