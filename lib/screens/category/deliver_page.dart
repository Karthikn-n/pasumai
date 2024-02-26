import 'dart:convert';

import 'package:app_3/data/address_repo.dart';
import 'package:app_3/screens/category/payment_page.dart';
import 'package:app_3/widgets/screen_widgets.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeliverPage extends StatefulWidget {
  const DeliverPage({super.key});

  @override
  State<DeliverPage> createState() => _DeliverPageState();
}

class _DeliverPageState extends State<DeliverPage> {
   late DeliveryAddress selectedAddress;
   int totalAmount = 0;
   int totalProduct =0;
   bool isNewAddress = false;
   bool isEditAddress = false;
   bool isEditing = false;
   late int editAddressIndex;
   TextEditingController firstNameController = TextEditingController();
   TextEditingController lastNameController = TextEditingController();
   TextEditingController flatController = TextEditingController();
   TextEditingController streetController = TextEditingController();
   TextEditingController pincodeController = TextEditingController();
   TextEditingController cityController = TextEditingController();
   TextEditingController stateController = TextEditingController();
   TextEditingController landmarkController = TextEditingController();
   TextEditingController emailController = TextEditingController();
   TextEditingController mobileController = TextEditingController();

   List<DeliveryAddress> addresses = [
      DeliveryAddress(
        firstName: 'John',
        lastName: 'Doe',
        flatNo: 'A-1',
        streetName: 'Gandhi Road',
        pincode: '625001',
        city: 'Madurai',
        state: 'Tamil Nadu',
        landmark: 'Near Meenakshi Temple',
        email: 'john.doe@example.com',
        mobile: '9876543210',
      ),
      DeliveryAddress(
        firstName: 'Jane',
        lastName: 'Smith',
        flatNo: 'B-2',
        streetName: 'Anna Nagar',
        pincode: '625020',
        city: 'Madurai',
        state: 'Tamil Nadu',
        landmark: 'Opposite to Periyar Bus Stand',
        email: 'jane.smith@example.com',
        mobile: '8765432109',
      ),
      DeliveryAddress(
        firstName: 'David',
        lastName: 'Johnson',
        flatNo: 'C-3',
        streetName: 'KK Nagar',
        pincode: '625107',
        city: 'Madurai',
        state: 'Tamil Nadu',
        landmark: 'Near Rajaji Park',
        email: 'david.johnson@example.com',
        mobile: '7654321098',
      ),
    ];

  Future<void> saveAddressesToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> addressesJson =
        addresses.map((address) => address.toJson()).toList();
    await prefs.setStringList('addresses', addressesJson.map((json) => json.toString()).toList());
  }

  // Method to retrieve addresses from shared preferences
  Future<void> loadAddressesFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? addressesJson = prefs.getStringList('addresses');
    if (addressesJson != null) {
      setState(() {
        addresses = addressesJson
            .map((json) => DeliveryAddress.fromJson(jsonDecode(json)))
            .toList();
      });
    }
  }
  @override
  void initState() {
    super.initState();
    _getTotalAmount();
    selectedAddress = addresses.first;
    loadAddressesFromPrefs();
  }

  Future<void> _getTotalAmount() async {
    final prefs = await SharedPreferences.getInstance();
    final storedTotalAmount = prefs.getInt('totalQuickOrder');
    final products = prefs.getInt('totalProducts');
    if (storedTotalAmount != null ) {
      setState(() {
        totalAmount = storedTotalAmount;
      });
    }
    if (products != null ) {
      setState(() {
        totalProduct = products;
      });
    }

  }
  void showSnackBar(){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 1,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        backgroundColor:  const Color(0xFF60B47B),
        content: const Text('Are you sure?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),
        duration: const Duration(days: 10),
        action: SnackBarAction(
          label: 'Yes', 
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
          },
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: homeAppBar('Address'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: screenWidth > 600 ? 10 :30, left: 20, right: 10),
                  child: const Text(
                    'Shippping Address',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: screenWidth > 600 ? 5 : 10, left: 20, right: 10),
                  child: SizedBox(
                    width: screenWidth > 600 ? screenHeight * 2 : screenHeight * 0.6,
                    child: const Divider(
                      color: Colors.black38,
                      thickness: 1,
                    ),
                  ),
                ),
                Container(
                  margin:const EdgeInsets.only(left: 10, right: 10),
                  height: screenWidth > 600 ? screenHeight * 0.5 : screenHeight * 0.55,
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.black38))
                  ),
                  child: ListView.builder(
                    itemCount: addresses.length,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: screenWidth > 600 ? screenHeight * 0.2 : screenHeight * 0.15,
                            margin: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedAddress = addresses[index];
                                    });
                                    showSnackBar();
                                  },
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        child: Radio(
                                          value: addresses[index], 
                                          groupValue: selectedAddress, 
                                          activeColor: const Color(0xFF60B47B),
                                          onChanged: (value) {
                                              setState(() {
                                              selectedAddress = value!;
                                            });
                                            showSnackBar();
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: screenWidth > 600 ? screenHeight * 1.7 : screenHeight * 0.34,
                                        child: screenWidth > 600 
                                          ? Text(
                                          '${addresses[index].firstName} '
                                          '${addresses[index].lastName}, '
                                          '${addresses[index].flatNo}, ${addresses[index].streetName} ,'
                                          '${addresses[index].city}, ${addresses[index].state} ,'
                                          '${addresses[index].pincode},'
                                          '${addresses[index].email}, \n${addresses[index].mobile} ',
                                          style: const TextStyle(
                                            fontSize: 13, 
                                            fontWeight: FontWeight.w500
                                          ),
                                        )
                                        : Text(
                                          '${addresses[index].firstName} '
                                          '${addresses[index].lastName}, '
                                          '${addresses[index].flatNo}, ${addresses[index].streetName} ,'
                                          '${addresses[index].city}, ${addresses[index].state} ,'
                                          '${addresses[index].pincode},'
                                          '\n${addresses[index].email}, ${addresses[index].mobile} ',
                                          style: const TextStyle(
                                            fontSize: 13, 
                                            fontWeight: FontWeight.w500
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: screenWidth > 600 ? 30 : 50),
                                  child: Column(
                                    // mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: (){
                                          setState(() {
                                            addresses.removeAt(index);
                                          });
                                        },
                                        child: const Icon(
                                          Icons.delete_outline,
                                          size: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 10,),
                                      GestureDetector(
                                        onTap: (){
                                          setState(() {
                                            isEditAddress = true;
                                            editAddressIndex = index;
                                            isEditing = !isEditing;
                                             DeliveryAddress selectedAddress = addresses[index];
                                            firstNameController.text = selectedAddress.firstName;
                                            lastNameController.text = selectedAddress.lastName;
                                            flatController.text = selectedAddress.flatNo;
                                            streetController.text = selectedAddress.streetName;
                                            pincodeController.text = selectedAddress.pincode;
                                            cityController.text = selectedAddress.city;
                                            stateController.text = selectedAddress.state;
                                            landmarkController.text = selectedAddress.landmark;
                                            emailController.text = selectedAddress.email;
                                            mobileController.text = selectedAddress.mobile;                    
                                          });
                                        },
                                        child: const Icon(
                                          Icons.edit,
                                          size: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          if(isEditAddress && index == editAddressIndex)
                            editAddressForm(addresses[index]),
                          if(addresses[index] == addresses.last && !isNewAddress  || addresses.isEmpty )
                              if(!isEditing)
                          // add new address button
                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isNewAddress = !isNewAddress;
                                      });
                                    },
                                    child: Container(
                                      height: screenWidth > 600 ? screenHeight * 0.1 : screenHeight * 0.05,
                                      width: screenWidth > 600 ? screenHeight * 1.5 : screenHeight * 0.4,
                                      margin: const EdgeInsets.only(bottom: 10),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF60B47B),
                                        borderRadius: BorderRadius.circular(8)
                                      ),
                                      child: Center(
                                        child: Row(
                                          // crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              'Add new address', 
                                              style: TextStyle(
                                                color: Colors.white, 
                                                fontWeight: FontWeight.w600
                                              ),
                                            ),
                                            const SizedBox(width: 5,),
                                            Container(
                                              margin: EdgeInsets.only(top: screenWidth > 600 ? 1 :2),
                                              child: const Icon(
                                                Icons.add,
                                                weight: 2,
                                                size: 14,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                          else if(addresses[index] == addresses.last && isNewAddress) 
                            newAddressForm()
                        ],
                      );
                    },
                  )
                ),
              ],
            ),
            // Order Summary
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        'Order summary',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      const Spacer(),
                      Text(
                        totalProduct > 1 ?'($totalProduct items)' : '($totalProduct item)',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 8,),
                  Row(
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '₹$totalAmount',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        'Includes GST*',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '₹${totalAmount + 20}',
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          fontSize: 12,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      const SizedBox(width: 4,),
                      const Text(
                        'Save ₹20',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                    ],
                  ),
                  // const SizedBox(height: 20,),
                  // Next and cacel button
                  Center(
                    child: Row(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            height: screenWidth > 600 ? screenHeight * 0.08 : screenHeight * 0.05,
                            width: screenWidth > 600 ? screenHeight * 0.3 : screenHeight * 0.2 ,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.black54)
                            ),
                            margin: const EdgeInsets.only(top: 30, bottom: 10),
                            child: const Center(
                              child: Text(
                                'Back',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(context).push(_paymentPage()),
                          child: Container(
                            height: screenWidth > 600 ? screenHeight * 0.08 : screenHeight * 0.05,
                            width: screenWidth > 600 ? screenHeight * 0.3 : screenHeight * 0.2 ,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: const Color(0xFF60B47B)
                            ),
                            margin: const EdgeInsets.only(top: 30, left: 10, bottom: 10),
                            child: const Center(
                              child: Text(
                                'Next',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                
                ],
              ),
            )
          
          ],
        ),
      ),
    );
  }
  // New Address Form 
  Widget newAddressForm(){
    return Column(
      children: [
        textfields('Enter your first name', firstNameController),
        textfields('Enter your second name', lastNameController),
        textfields('Flat/house No', flatController),
        textfields('Street/Locality', streetController),
        textfields('Pincode', pincodeController),
        Row(
          children: [
            SizedBox(
              width: 160,
              child: textfields('City', cityController),
            ),
            const Spacer(),
            SizedBox(
              width: 160,
              child: textfields('State', stateController),
            ),
          ],
        ),
        textfields('Landmark', landmarkController),
        textfields('Email', emailController),
        textfields('Mobile number', mobileController),
        Row(
          children: [
            const Spacer(),
            GestureDetector(
              onTap: (){
                setState(() {
                  isNewAddress = false;
                });
              },
              child: Container(
                height: 35,
                width: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black54)
                ),
                child: const Center(
                  child: Text(
                    'Cancel',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20,),
            GestureDetector(
              onTap: () async {
                setState(() {
                  addresses.add(
                    DeliveryAddress(
                      firstName: firstNameController.text, 
                      lastName: lastNameController.text, 
                      flatNo: flatController.text, 
                      streetName: streetController.text, 
                      pincode: pincodeController.text, 
                      city: cityController.text, 
                      state: stateController.text,
                      landmark: landmarkController.text, 
                      email: emailController.text, 
                      mobile: mobileController.text
                    )
                  );
                  isNewAddress = false;
                });
                await saveAddressesToPrefs();
              },
              child: Container(
                height: 35,
                width: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color(0xFF60B47B)
                ),
                child: const Center(
                  child: Text(
                    'Save',
                    style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10,)
      ],
    );
  }
  // Edit Address From
  Widget editAddressForm(DeliveryAddress address){
    return Column(
      children: [
        textfields('Enter your first name', firstNameController),
        textfields('Enter your second name', lastNameController),
        textfields('Flat/house No', flatController),
        textfields('Street/Locality', streetController),
        textfields('Pincode', pincodeController),
        Row(
          children: [
            SizedBox(
              width: 160,
              child: textfields('City', cityController),
            ),
            const Spacer(),
            SizedBox(
              width: 160,
              child: textfields('State', stateController),
            ),
          ],
        ),
        textfields('Landmark', landmarkController),
        textfields('Email', emailController),
        textfields('Mobile number', mobileController),
        Row(
          children: [
            const Spacer(),
            GestureDetector(
              onTap: (){
                setState(() {
                  isEditAddress = false;
                  isEditing = !isEditing;
                   firstNameController.clear();
                  lastNameController.clear();
                  flatController.clear();
                  streetController.clear();
                  pincodeController.clear();
                  cityController.clear();
                  stateController.clear();
                  landmarkController.clear();
                  emailController.clear();
                  mobileController.clear();
                });
              },
              child: Container(
                height: 35,
                width: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black54)
                ),
                child: const Center(
                  child: Text(
                    'Cancel',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20,),
            GestureDetector(
              onTap: () async {
                setState(() {
                  isEditing = !isEditing;
                   DeliveryAddress updatedAddress = addresses[editAddressIndex];
                  updatedAddress.firstName = firstNameController.text;
                  updatedAddress.lastName = lastNameController.text;
                  updatedAddress.flatNo = flatController.text;
                  updatedAddress.streetName = streetController.text;
                  updatedAddress.pincode = pincodeController.text;
                  updatedAddress.city = cityController.text;
                  updatedAddress.state = stateController.text;
                  updatedAddress.landmark = landmarkController.text;
                  updatedAddress.email = emailController.text;
                  updatedAddress.mobile = mobileController.text;
                  // Reset form state
                  firstNameController.clear();
                  lastNameController.clear();
                  flatController.clear();
                  streetController.clear();
                  pincodeController.clear();
                  cityController.clear();
                  stateController.clear();
                  landmarkController.clear();
                  emailController.clear();
                  mobileController.clear();
                  isEditAddress = false;
                });
                await saveAddressesToPrefs();
              },
              child: Container(
                height: 35,
                width: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color(0xFF60B47B)
                ),
                child: const Center(
                  child: Text(
                    'Save',
                    style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10,)
      ],
    );
  }

  // Text Fields for form
  Widget textfields(String hintText, TextEditingController controller){
    return Container(
      height: 40,
      margin: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 12, color: Colors.grey.withOpacity(0.4)),
          focusColor: Colors.blue
        ),
      ),
    );
  }
  PageRouteBuilder _paymentPage(){
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>  PaymentPage(address: selectedAddress,),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCirc;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child,);

      },
    );
  }
}


