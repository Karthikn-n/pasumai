import 'dart:async';

import 'package:app_3/helper/page_transition_helper.dart';
import 'package:app_3/model/address_model.dart';
import 'package:app_3/helper/shared_preference_helper.dart';
import 'package:app_3/providers/address_provider.dart';
import 'package:app_3/model/region_model.dart';
import 'package:app_3/providers/api_provider.dart';
import 'package:app_3/screens/main_screens/bottom_bar.dart';
import 'package:app_3/screens/on_boarding/signin_page.dart';
import 'package:app_3/widgets/common_widgets.dart/app_bar.dart';
import 'package:app_3/widgets/common_widgets.dart/button_widget.dart';
import 'package:app_3/widgets/common_widgets.dart/input_field_widget.dart';
import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:app_3/widgets/sub_screen_widgets/map_screen_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
class NewAddressFormWidget extends StatefulWidget {
  final GlobalKey? updateFormKey;
  final bool? needUpdate;
  final bool? fromOnboarding;
  final AddressModel? updateAddress;
  const NewAddressFormWidget({super.key, 
  this.updateFormKey, 
  this.fromOnboarding,
  this.needUpdate, this.updateAddress});

  @override
  State<NewAddressFormWidget> createState() => _NewAddressFormWidgetState();
}

class _NewAddressFormWidgetState extends State<NewAddressFormWidget> {
  final Completer<GoogleMapController> mapController = Completer<GoogleMapController>();
  SharedPreferences prefs = SharedPreferencesHelper.getSharedPreferences();
  TextEditingController flatController = TextEditingController();
  TextEditingController floorContoller = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController landmarkController = TextEditingController();
  TextEditingController mapAddressController = TextEditingController();
  late final formKey;
  Set<Marker> markers = {};
  LatLng? currentLocation;
  String? selectedRegion;
  String? selectedLocation;
  bool isRegionSelected = true;
  bool isLocationSelected = true;
  List<LocationModel> locations = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.fromOnboarding ?? false) {
      preLoadRegion();
    }
    if (widget.updateFormKey != null) {
      formKey = widget.updateFormKey;
    }else{
      formKey = GlobalKey<FormState>();
    }
    if (widget.updateAddress != null && widget.needUpdate != null) {
      flatController.text = widget.updateAddress!.flatNo;
      floorContoller.text = widget.updateAddress!.floorNo;
      addressController.text = widget.updateAddress!.address;
      pincodeController.text = widget.updateAddress!.pincode;
      landmarkController.text = widget.updateAddress!.landmark;
    }
    
  }



  @override
  void dispose() {
    super.dispose();
    flatController.dispose();
    floorContoller.dispose();
    addressController.dispose();
    pincodeController.dispose();
    landmarkController.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Consumer<AddressProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          // resizeToAvoidBottomInset: false,
          appBar: AppBarWidget(
            title: 'New Address',
            needBack:  true,
            onBack: () {
              // addressProvider.disposeController();
              if (widget.fromOnboarding != null) {
                Navigator.pushAndRemoveUntil(context, downToTop(screen: const LoginPage()), (route) => false,);
              }else{
                Navigator.pop(context);
              }
            },
          ),
          body: Container(
            color: Colors.white,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                      await checkLocationService();
                      },
                      child: Hero(
                        tag: "map",
                        child: Container(
                          height: size.height * 0.2,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: GoogleMap(
                                  zoomControlsEnabled: false,
                                  zoomGesturesEnabled: false,
                                  onMapCreated: (controller) => mapController.complete(controller),
                                  initialCameraPosition: const CameraPosition(
                                    target: LatLng(9.9328429, 78.1483366),
                                    zoom: 18,
                                  )
                                ),
                              ),
                              Container(
                                height: size.height * 0.2,
                                decoration: BoxDecoration(
                                  color: Colors.transparent.withOpacity(0.1)
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(CupertinoIcons.map_pin),
                                    AppTextWidget(
                                      text: 'Use Current Location', 
                                      fontSize: 15, 
                                      fontWeight: FontWeight.w500
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 20,),
                          TextFields(
                            hintText: "Enter Flat/house No", 
                            isObseure: false, 
                            textInputAction: TextInputAction.next,
                            controller: flatController,
                            validator: (value) {
                              if (value == null || value.isEmpty ) {
                                return 'Flat No is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20,),
                          TextFields(
                            hintText: "Enter Floor No", 
                            isObseure: false, 
                            textInputAction: TextInputAction.next,
                            controller: floorContoller,
                            validator: (value) {
                              if (value == null || value.isEmpty ) {
                                return 'Floor No is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20,),
                          TextFields(
                            hintText: "Address", 
                            isObseure: false, 
                            textInputAction: TextInputAction.next,
                            controller: provider.mapAddressController.text.isEmpty ? addressController : provider.mapAddressController,
                            validator: (value) {
                              if (value == null || value.isEmpty ) {
                                return 'Address is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20,),
                          TextFields(
                            hintText: "Pincode", 
                            isObseure: false, 
                            textInputAction: TextInputAction.next,
                            controller: pincodeController,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty ) {
                                return 'Pincode is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20,),
                          // Landmark text field
                          TextFields(
                            hintText: "Landmark", 
                            isObseure: false, 
                            textInputAction: TextInputAction.next,
                            controller: landmarkController,
                            validator: (value) {
                              if (value == null || value.isEmpty ) {
                                return 'landmark is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 40,
                                width: size.width * 0.43,
                                decoration: BoxDecoration(
                                  border: widget.updateAddress != null 
                                    ? null
                                    : isRegionSelected ?  null : Border.all(color: Colors.red),
                                  color: Colors.grey.withOpacity(0.2), // Border color for the container
                                  borderRadius: BorderRadius.circular(8.0), // Rounded corners
                                ),
                                child: Center(
                                  child: DropdownButton(
                                    value: selectedRegion,
                                    elevation: 0,
                                    hint: Center(child: Text(widget.updateAddress != null ?  widget.updateAddress!.region : 'Select Region')),
                                    style: TextStyle(color: const Color(0xFF656872).withOpacity(1.0)), // Text color
                                    underline: Container(),
                                    dropdownColor: Colors.white,
                                    alignment: Alignment.center,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedRegion = value!.toString();
                                        isRegionSelected = true;
                                        locations = provider.regionLocationsList.firstWhere((element) => element.regionName == selectedRegion,).locationData;
                                        selectedLocation = null;
                                      });
                                    },
                                    items: provider.regionLocationsList.map((region) {
                                      return DropdownMenuItem<String>(
                                        value: region.regionName,
                                        child: Text(region.regionName),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                              // Select Location 
                              Container(
                                height: 40,
                                width: size.width * 0.43,
                                padding: const EdgeInsets.only(left: 14, right: 4),
                                margin: const EdgeInsets.only(left: 10, right: 10),
                                decoration: BoxDecoration(
                                   border: widget.updateAddress != null 
                                    ? null
                                    : isLocationSelected ?  null : Border.all(color: Colors.red),
                                  color: Colors.grey.withOpacity(0.2), // Border color for the container
                                  borderRadius: BorderRadius.circular(8.0), // Rounded corners
                                ),
                                child: DropdownButton<String>(
                                  value: selectedLocation,
                                  isExpanded: true,
                                  iconDisabledColor: Colors.transparent.withOpacity(0.0),
                                  style: TextStyle(color:  const Color(0xFF656872).withOpacity(1.0)),
                                  hint: Text(widget.updateAddress != null ?  widget.updateAddress!.location : 'Select Town'),
                                  underline: Container(),
                                  dropdownColor: Colors.white,
                                  alignment: Alignment.center,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedLocation = value!;
                                      isLocationSelected = true;
                                    });
                                  },
                                  items: locations.map((location) {
                                    return DropdownMenuItem<String>(
                                      value: location.locationName,
                                      child: Text(location.locationName),
                                    );
                                  }).toList(),
                                ),
                              ),
                          
                            ],
                          ),
                          const SizedBox(height: 20,),
                          // Add address button 
                          ButtonWidget(
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });

                                // List<RegionModel> regions = provider.regionLocationsList;
                                // print("Current Location: ${widget.updateAddress!.location}");
                                // print("Default Updated Location name${regions.firstWhere((element) => widget.updateAddress!.region == element.regionName,).locationData.firstWhere((element) => widget.updateAddress!.location == element.locationName,).locationName}");
                              try {
                                if (widget.needUpdate != null && widget.needUpdate! && widget.updateAddress != null) {
                                  if (formKey.currentState!.validate()) {
                                    List<RegionModel> regions = provider.regionLocationsList;
                                    print("Default Updated Location name${regions.firstWhere((element) => widget.updateAddress!.region == element.regionName,).locationData.firstWhere((element) => widget.updateAddress!.location == element.locationName,).locationName}");
                                    Map<String, dynamic> updateAddressData = {
                                      'customer_id': prefs.getString('customerId'),
                                      'address_id': widget.updateAddress!.id,
                                      'flat_no': flatController.text,
                                      'address': provider.mapAddressController.text.isEmpty ? addressController.text : provider.mapAddressController.text,
                                      'floor': floorContoller.text,
                                      'landmark': landmarkController.text,
                                      'region': selectedRegion == null 
                                        ? regions.firstWhere((element) => widget.updateAddress!.region == element.regionName,).regionId 
                                        : regions.firstWhere((element) => element.regionName == selectedRegion,).regionId,
                                      'location':  selectedLocation == null 
                                        ? regions.firstWhere((element) => widget.updateAddress!.region == element.regionName,).locationData.firstWhere((element) => widget.updateAddress!.location == element.locationName,).locationId
                                        : locations.firstWhere((element) => element.locationName == selectedLocation,).locationId,
                                      'pincode': pincodeController.text,
                                    };
                                    if (selectedLocation == null && selectedLocation == null) {
                                    print("Updated Address Region: ${widget.updateAddress!.region}");
                                    print("Updated Address Location: ${widget.updateAddress!.location}");
                                      print("Default Updated Region name: ${regions.firstWhere((element) => widget.updateAddress!.region == element.regionName,).regionName}");
                                      print("Default Updated Location name: ${regions.firstWhere((element) => widget.updateAddress!.region == element.regionName,).locationData.firstWhere((element) => widget.updateAddress!.location == element.locationName,).locationName}");
                                    }else{

                                      print("Updated Region Name: ${regions.firstWhere((element) => widget.updateAddress!.region == element.regionName,).regionName}");
                                      print("Updated Location Name: ${regions.firstWhere((element) => widget.updateAddress!.region == element.regionName,).locationData.firstWhere((element) => element.locationName == element.locationName,).locationName}");
                                    }
                                    print("Selected Region: $selectedRegion");
                                    print("Selected Location: $selectedLocation");
                                    print("Update Address Data: $updateAddressData");
                                    await  provider.updateAddressAPI(context, size, updateAddressData).then((value) {
                                      provider.clearMapAddress();
                                      Navigator.pop(context);
                                    },);
                                  }
                                  }else{
                                    if (selectedRegion == null) {
                                      if (selectedLocation == null) {
                                        setState(() {
                                          isRegionSelected = false;
                                          isLocationSelected = false;
                                        });
                                      }
                                    }
                                    if (formKey.currentState!.validate() && isRegionSelected && isLocationSelected) {
                                      print("Region Id: ${provider.regionLocationsList.firstWhere((element) => element.regionName == selectedRegion,).regionId}");
                                      print("Location Id: ${locations.firstWhere((element) => element.locationName == selectedLocation,).locationId}");
                                      Map<String, dynamic> addressData = {
                                        'customer_id': prefs.getString('customerId'),
                                        'flat_no': flatController.text,
                                        'address': provider.mapAddressController.text.isEmpty ? addressController.text : provider.mapAddressController.text,
                                        'floor': floorContoller.text,
                                        'landmark': landmarkController.text,
                                        'region': provider.regionLocationsList.firstWhere((element) => element.regionName == selectedRegion,).regionId,
                                        'location': locations.firstWhere((element) => element.locationName == selectedLocation,).locationId,
                                        'pincode': pincodeController.text,
                                      };
                                      print("New Address Data: $addressData");
                                      await  provider.addAddressAPI(context, size, addressData).then((value) async {
                                        if (widget.fromOnboarding ?? false) {
                                          provider.clearMapAddress();
                                          await provider.getAddressesAPI();
                                          prefs.remove("registered");
                                          prefs.remove("newUserVerified");
                                          prefs.remove("phoneNo");
                                          Navigator.push(context, SideTransistionRoute(screen: const BottomBar()));
                                        }else{
                                          Navigator.pop(context);
                                        } 
                                      },);
                                    }
                                }
                              } catch (e) {
                                print("Can't register address: $e");
                              }finally{
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            }, 
                            buttonName: widget.updateAddress != null && widget.needUpdate! ? "Update" : 'Add'
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        );
      }
    );
  }

  void preLoadRegion() async {
    final addressprovider = Provider.of<AddressProvider>(context, listen: false);
    await addressprovider.getRegionLocation();
    final provider = Provider.of<ApiProvider>(context, listen: false);
    await Future.wait([
      provider.getBestSellers(),
      provider.getCatgories(),
      provider.getFeturedProducts(),
      provider.getBanners()
    ]);
  }

  Future<void> checkLocationService() async {
    var status = await Permission.location.status;

    if (status.isDenied) {
      await Permission.location.request();
    } else if(status.isPermanentlyDenied) {
      await openAppSettings();
    } else if(status.isGranted){
      await goToCurrentLocation();
    }
  }
// 
  Future<void> goToCurrentLocation() async {
    // final GoogleMapController controller = await mapController.future;
    // Get current poisition using Geo Locator
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final currentLocationLatLang = LatLng(position.latitude, position.longitude);
    setState(() {
      currentLocation = currentLocationLatLang;
      markers.clear();
      markers.add(
        Marker(
          draggable: true,
          markerId: const MarkerId('currentLocation'),
          position: currentLocation!,
          infoWindow: const  InfoWindow(
            title: "Use this address"
          )
        )
      );
    });
    print('Current Location: $currentLocation');
     Navigator.push(context, MaterialPageRoute(
      builder: (context) => MapScreenWidget(
        currentLocation: currentLocation!,
        mapController: mapController,
        marker: markers,
      ),));
  }

} 




