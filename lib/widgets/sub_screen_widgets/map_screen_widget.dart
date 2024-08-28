import 'dart:async';
import 'dart:convert';

import 'package:app_3/providers/address_provider.dart';
import 'package:app_3/widgets/common_widgets.dart/button_widget.dart';
import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class MapScreenWidget extends StatefulWidget {
  LatLng currentLocation;
  Set<Marker> marker;
  final Completer<GoogleMapController> mapController;
  MapScreenWidget({
    super.key, 
    required this.currentLocation, 
    required this.mapController,
    required this.marker
  });

  @override
  State<MapScreenWidget> createState() => _MapScreenWidgetState();
}

class _MapScreenWidgetState extends State<MapScreenWidget> {
  // final Completer<GoogleMapController> mapController = Completer<GoogleMapController>();
  String? address;
  String? addressCode;
  @override
  void initState() {
    super.initState();
    getCurrentAddress(widget.currentLocation);
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return FutureBuilder(
      future: widget.mapController.future, 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Hero(
            tag: "map",
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                GoogleMap(
                  onTap: (argument) async {
                    await getCurrentLocation(argument);
                    print("Tapped");
                  },
                  compassEnabled: false,
                  markers: widget.marker,
                  // myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  initialCameraPosition: CameraPosition(
                    target: widget.currentLocation,
                    zoom: 15.0
                  )
                ),
                Container(
                  height: size.height * 0.25,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: const  BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)
                    )
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 20,),
                      AppTextWidget(
                        text: address ?? addressCode ?? "Not Found", 
                        fontSize: 15, 
                        fontWeight: FontWeight.w500,
                        fontColor: Colors.black,
                      ),
                      const SizedBox(height: 20,),
                      Consumer<AddressProvider>(
                        builder: (context, provider, child) {
                          return ButtonWidget(
                            width: double.infinity,
                            fontSize: 18,
                            buttonName: 'Confirm Location', 
                            onPressed: () {
                              provider.setAddressFromMap(address ?? addressCode ?? "Not found");
                              Navigator.pop(context, {"mapaddress": address ?? addressCode ?? "Not found"});
                            },
                          );
                        }
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        }
      } ,
    );
  }

  // // Get Current Location
  Future<void> getCurrentLocation(LatLng position) async {
    // Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      widget.currentLocation = position;
      widget.marker.clear();
      widget.marker.add(Marker(
        markerId: const MarkerId('New address'),
        position: widget.currentLocation,
        infoWindow: const InfoWindow(
          snippet: 'Use this addres',
          title: "User this address"
        )
      ));
    print("New Location ${LatLng(position.latitude, position.longitude)}");
    });
    await getCurrentAddress(LatLng(position.latitude, position.longitude));
  }

  // Get current Address
  Future<void> getCurrentAddress(LatLng position) async {
    // String newLocationurl = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${currentLocation!.latitude},${currentLocation!.longitude}&key=AIzaSyDbZcQiUQy-YyCN08yz8OQxQd4z4eRmMqA";
    print('New Positions: $position');
    String url = 
      "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=AIzaSyDbZcQiUQy-YyCN08yz8OQxQd4z4eRmMqA";
    final response = await http.get(Uri.parse(url));
    final decodedResponse = json.decode(response.body);
    if (response.statusCode == 200 && decodedResponse["status"] == "OK") {
      print('Decoded Response: $decodedResponse');
      setState(() {
        address = decodedResponse["results"][0]["formatted_address"];
        if (address == "" || address == null) {
          address = decodedResponse["plus_code"]["compound_code"];
        } 
      });
    }else{
      print('Error: $decodedResponse');
    }
  }
}

