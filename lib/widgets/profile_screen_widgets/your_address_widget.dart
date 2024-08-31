import 'package:app_3/helper/page_transition_helper.dart';
import 'package:app_3/model/address_model.dart';
import 'package:app_3/providers/address_provider.dart';
import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:app_3/widgets/sub_screen_widgets/new_address_form_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class YourAddressWidget extends StatelessWidget {
  const YourAddressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Consumer<AddressProvider>(
      builder: (context, provider, child) {
        return provider.addresses.isEmpty
          ? FutureBuilder(
            future: provider.getAddressesAPI(), 
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Column(
                  children: [
                    const AppTextWidget(
                      text: "My Addresses", 
                      fontSize: 16, 
                      fontWeight: FontWeight.w500
                    ),
                    const SizedBox(height: 15,),
                    LinearProgressIndicator(
                      // minHeight: 1,
                      color: Theme.of(context).primaryColor,
                      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ],
                );
              }else if(!snapshot.hasData){
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const AppTextWidget(
                          text: "My Addresses", 
                          fontSize: 16, 
                          fontWeight: FontWeight.w500
                        ),
                         IconButton(
                          onPressed: (){
                            Navigator.push(context, downToTop(screen: const NewAddressFormWidget()));
                          },
                            icon: Icon(CupertinoIcons.plus, 
                            size: 20, 
                            color: Theme.of(context).primaryColor,
                          )
                        )
                      ],
                    ),
                    const SizedBox(height: 50,),
                    const Center(
                      child: AppTextWidget(
                        text: "No Address found",
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                );
              } else{
                return Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const AppTextWidget(
                            text: "My Addresses", 
                            fontSize: 16, 
                            fontWeight: FontWeight.w500
                          ),
                          IconButton(
                            style: IconButton.styleFrom(
                              padding: const EdgeInsets.all(0)
                            ),
                            onPressed: (){
                              Navigator.push(context, downToTop(screen: const NewAddressFormWidget()));
                            },
                              icon: Icon(CupertinoIcons.plus, 
                              size: 20, 
                              color: Theme.of(context).primaryColor,
                            )
                          )
                        ],
                      ),
                      // const SizedBox(height: 15,),
                      Expanded(
                        child: addressList(size, provider.addresses, provider.currentAddress!.id)
                      )
                    ],
                  ),
                );
              }
            },
          )
          : Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const AppTextWidget(
                        text: "My Addresses", 
                        fontSize: 16, 
                        fontWeight: FontWeight.w500
                      ),
                       IconButton(
                        style: IconButton.styleFrom(
                              padding: const EdgeInsets.all(0)
                            ),
                        onPressed: (){
                          Navigator.push(context, downToTop(screen: const NewAddressFormWidget()));
                        },
                          icon: Icon(CupertinoIcons.plus, 
                          size: 20, 
                          color: Theme.of(context).primaryColor,
                        )
                      )
                    ],
                  ),
                  // const SizedBox(height: 15,),
                  Expanded(
                    child: addressList(size, provider.addresses, provider.currentAddress!.id)
                  )
                ],
              ),
            );
      } 
    );
  }

  Widget addressList(Size size, List<AddressModel> addressList, int currentAddressId){
    return Consumer<AddressProvider>(
      builder: (context, provider, child) {
        return ListView.builder(
          itemCount: addressList.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    provider.setCurrentAddress(address: provider.addresses[index]);
                  },
                  child: Container(
                    // height: size.height * 0.22,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        width: provider.addresses[index].id == provider.currentAddress!.id ? 2 : 1,
                        color: provider.addresses[index].id == provider.currentAddress!.id
                        ? Theme.of(context).primaryColor
                        : Colors.grey.shade300 
                      )
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: size.width * 0.7,
                                child: AppTextWidget(
                                  text: addressList[index].location, 
                                  fontSize: 15, 
                                  fontWeight: FontWeight.w500
                                ),
                              ),
                              PopupMenuButton(
                                color: Colors.white,
                                itemBuilder: (context) {
                                  return [
                                    PopupMenuItem(
                                      onTap: () {
                                          Navigator.push(context, SideTransistionRoute(
                                          screen: NewAddressFormWidget(
                                            needUpdate: true, 
                                            updateAddress: provider.addresses[index], 
                                            updateFormKey: GlobalKey<FormState>() 
                                          ,)
                                        ));
                                      },
                                      child: const AppTextWidget(text: "Edit", fontSize: 14, fontWeight: FontWeight.w500)
                                    ),
                                    PopupMenuItem(
                                      onTap: () {
                                        provider.confirmDelete(context, size, provider.addresses[index].id, index);
                                      },
                                      child: const AppTextWidget(text: "Delete", fontSize: 14, fontWeight: FontWeight.w500)
                                    ),
                                    PopupMenuItem(
                                      onTap: () {
                                        provider.setAddressDefault(context, size, provider.addresses[index].id);
                                      },
                                      child: const AppTextWidget(text: "Set as default", fontSize: 14, fontWeight: FontWeight.w500)
                                    ),
                                  ];
                                },
                              )
                            
                            ],
                          ),
                          const SizedBox(height: 5,),
                          AppTextWidget(
                            text: '${addressList[index].flatNo}, ' 
                            '${addressList[index].floorNo}, ' 
                            '${addressList[index].address}, '
                            '${addressList[index].landmark}, '
                            '${addressList[index].location}, ' 
                            '${addressList[index].region}, '
                            '${addressList[index].pincode}, ',
                            fontSize: 14, 
                            maxLines: 5,
                            fontWeight: FontWeight.w400
                          ),
                          const SizedBox(height: 5,),
                        ],
                      ),
                    ),
                  
                  ),
                ),
                SizedBox(height: addressList.length -1 == index ? 70 : 10,)
              ],
            );
          },
        );
      }
    );
  }
}