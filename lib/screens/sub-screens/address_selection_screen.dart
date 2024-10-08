import 'dart:convert';

import 'package:app_3/helper/shared_preference_helper.dart';
import 'package:app_3/model/address_model.dart';
import 'package:app_3/providers/address_provider.dart';
import 'package:app_3/helper/page_transition_helper.dart';
import 'package:app_3/model/region_model.dart';
import 'package:app_3/repository/app_repository.dart';
import 'package:app_3/service/api_service.dart';
import 'package:app_3/widgets/common_widgets.dart/app_bar.dart';
import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:app_3/widgets/sub_screen_widgets/address_selection_widget.dart';
import 'package:app_3/widgets/sub_screen_widgets/new_address_form_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressSelectionScreen extends StatefulWidget {
  const AddressSelectionScreen({super.key});

  @override
  State<AddressSelectionScreen> createState() => _AddressSelectionScreenState();
}

class _AddressSelectionScreenState extends State<AddressSelectionScreen> {
  AppRepository addressRepository = AppRepository(ApiService('https://maduraimarket.in/api'));
  // AppRepository addressRepository = AppRepository(ApiService('http://192.168.1.5/pasumaibhoomi/public/api'));
  SharedPreferences prefs = SharedPreferencesHelper.getSharedPreferences();
  List<RegionModel> regions = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    List<String> regionList = prefs.getStringList('regions') ?? [];
    regions = regionList.map((region) => RegionModel.fromMap(json.decode(region))).toList();
    // isCurrentAddress =  List.filled(AddressProvider.helper.getAddresses().length, false);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWidget(
        title: 'Addresses', 
        onBack: () => Navigator.pop(context),
      ),
      body: Consumer<AddressProvider>(
        builder: (context, addressProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                  child: GestureDetector(
                    onTap: () async {
                      addressProvider.clearMapAddress();
                     Navigator.push(context, downToTop(screen: const NewAddressFormWidget(), args: {'regions': regions}));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade300)
                        )
                      ),
                      child: locationSelectButton(
                        context: context, 
                        size: size, 
                        leading: CupertinoIcons.plus,
                        suffixIcon: CupertinoIcons.chevron_right,
                        title: 'Add new address'
                      ),
                    ),
                  )
                ),
                Expanded(
                  child: Consumer<AddressProvider>(
                    builder: (context, addressProvider, child) {
                      return  CupertinoScrollbar(
                        controller: _scrollController,
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: addressProvider.addresses.length,
                          itemBuilder: (context, index) {
                            List<AddressModel> address =  addressProvider.addresses;
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  addressProvider.setCurrentAddress(address: address[index], addressId: address[index].id);
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  height: size.height * 0.21,
                                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      width: address[index].id == addressProvider.currentAddress!.id ? 2 : 1,
                                      color: address[index].id == addressProvider.currentAddress!.id
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey.shade300 
                                    )
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        // crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: size.width * 0.7,
                                            child: AppTextWidget(
                                              text: address[index].location, 
                                              fontSize: 16, 
                                              maxLines: 2,
                                              textOverflow: TextOverflow.ellipsis,
                                              fontWeight: FontWeight.w500,
                                              fontColor: Colors.black87,
                                            ),
                                          ),
                                          PopupMenuButton(
                                            color: Colors.white,
                                            itemBuilder: (context) {
                                              return [
                                                PopupMenuItem(
                                                  onTap: () {
                                                    // print(prefs.getString("customerId"));
                                                     Navigator.push(context, SideTransistionRoute(
                                                      screen: NewAddressFormWidget(
                                                        needUpdate: true, 
                                                        updateAddress: address[index], 
                                                        updateFormKey: GlobalKey<FormState>() 
                                                      ,)
                                                    ));
                                                  },
                                                  child: const AppTextWidget(text: "Edit", fontSize: 14, fontWeight: FontWeight.w500)
                                                ),
                                                PopupMenuItem(
                                                  onTap: () {
                                                    addressProvider.confirmDelete(context, size, address[index].id, index);
                                                  },
                                                  child: const AppTextWidget(text: "Delete", fontSize: 14, fontWeight: FontWeight.w500)
                                                ),
                                                PopupMenuItem(
                                                  onTap: () {
                                                    addressProvider.setAddressDefault(context, size, address[index].id);
                                                  },
                                                  child: const AppTextWidget(text: "Set as default", fontSize: 14, fontWeight: FontWeight.w500)
                                                ),
                                              ];
                                            },
                                          )
                                        ],
                                      ),
                                      AppTextWidget(
                                        text: """${address[index].floorNo}, ${address[index].flatNo}, ${address[index].address}, ${address[index].landmark}, ${address[index].region}""", 
                                        fontSize: 14, 
                                        fontWeight: FontWeight.w300,
                                        fontColor: Colors.grey,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  )
                )
              ],
            ),
          );
        }
      ),
    );
  }
}

