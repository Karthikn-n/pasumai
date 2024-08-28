import 'package:app_3/helper/shared_preference_helper.dart';
import 'package:app_3/providers/address_provider.dart';
import 'package:app_3/providers/profile_provider.dart';
import 'package:app_3/service/connectivity_helper.dart';
import 'package:app_3/widgets/common_widgets.dart/app_bar.dart';
import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:app_3/widgets/profile_screen_widgets/active_subscription_widget.dart';
import 'package:app_3/widgets/profile_screen_widgets/invoice_list_widget.dart';
import 'package:app_3/widgets/profile_screen_widgets/orders_history_widget.dart';
import 'package:app_3/widgets/profile_screen_widgets/subscription_history_widget.dart';
import 'package:app_3/widgets/profile_screen_widgets/user_profile_widget.dart';
import 'package:app_3/widgets/profile_screen_widgets/vacation_list_widget.dart';
import 'package:app_3/widgets/profile_screen_widgets/your_address_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewProfileScreen extends StatefulWidget {
  const NewProfileScreen({super.key});

  @override
  State<NewProfileScreen> createState() => _NewProfileScreenState();
}

class _NewProfileScreenState extends State<NewProfileScreen> {
  SharedPreferences prefs = SharedPreferencesHelper.getSharedPreferences();
  List<bool> isOptionSelected = [];
  bool isOrdersSelected = true;
  int selectedbody = 0;
  final GlobalKey<ScaffoldState> _scaffoldStateKey = GlobalKey<ScaffoldState>();
  List<String> options = [
    'Order History',
    'Active Subscriptions',
    'Subscription History',
    'My Addresses',
    'Invoice Listing',
    'Vacation Mode'
  ];
  @override
  void initState() {
    super.initState();
    isOptionSelected = List.generate(options.length, (index) {
      return index == 0 ? true : false;
    },);
  }
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    final connectivityCheck = Provider.of<ConnectivityService>(context);
    if (!connectivityCheck.isConnected) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: const AppBarWidget(
          title: 'Profile',
        ),
        body: Center(
          child: Image.asset('assets/category/nointernet.png'),
        ),
      );
    }else{
      return Consumer<ProfileProvider>(
        builder: (context, provider, child,) {
          return Scaffold(
            key: _scaffoldStateKey,
            resizeToAvoidBottomInset: false,
            appBar: AppBarWidget(
              title: 'Profile',
              needBack: true,
              onBack: () {
                _scaffoldStateKey.currentState?.openDrawer();
              },
              leading: CupertinoIcons.bars,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: IconButton(
                    onPressed: () async {
                     provider.confirmLogout(context, size);
                    }, 
                    icon: SizedBox(
                      height: 20,
                      width: 20,
                      child: Image.asset(
                        "assets/category/out.png",
                        fit: BoxFit.cover,
                      ),
                    )
                  ),
                )
              ],
            ),
            // Drawer for selection
            drawer: Drawer(
              width: size.width * 0.8,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero
              ),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              child: ListView(
                children: [
                  // Drwaer Header
                  SizedBox(
                    height: size.height * 0.1,
                    child: DrawerHeader(
                      child: SizedBox(
                        height: size.height * 0.1,
                        child: const AppTextWidget(
                          text: "App Settings", 
                          fontSize: 16, 
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                  ),
                  // Your orders
                  ...List.generate(
                    options.length, 
                    (index) {
                      return Consumer2<ProfileProvider, AddressProvider>(
                        builder: (context, profileProvider, addressProvider, child) {
                          return ListTile(
                            leading: SizedBox(
                              height: 20,
                              width: 20,
                              child: Image.asset(
                                images[index],
                                color: isOptionSelected[index] ? Colors.white : null,
                              ),
                            ),
                            tileColor: isOptionSelected[index]
                            ? Theme.of(context).primaryColor
                            : null,
                            onTap: () async {
                              setState(() {
                                for (var i = 0; i < options.length; i++) {
                                  isOptionSelected[i] = false;
                                }
                                selectedbody = index;
                                isOptionSelected[index] = true;
                              });
                              _scaffoldStateKey.currentState?.closeDrawer();
                            },
                            title: AppTextWidget(
                              text: options[index], 
                              fontSize: 14, 
                              fontWeight: FontWeight.w400,
                              fontColor: isOptionSelected[index] ? Theme.of(context).scaffoldBackgroundColor : null,
                            ),
                          );
                        }
                      );
                    },
                  )
                ],
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  UserProfileWidget(prefs: prefs),
                  const SizedBox(height: 20,),
                  optionsBody[selectedbody],
                ],
              ),
            ),
          );
        }
      );
    }
  }

  List<Widget> optionsBody = [
    const OrdersHistoryWidget(),
    ActiveSubscriptionWidget(),
    const SubscriptionHistoryWidget(),
    const YourAddressWidget(),
    const InvoiceListWidget(),
    VacationListWidget()
  ];

  List<String> images = [
    "assets/icons/profile/shopping-bag.png",
    "assets/icons/profile/surprise-box.png",
    "assets/icons/profile/time.png",
    "assets/icons/profile/location.png",
    "assets/icons/profile/invoice.png",
    "assets/icons/profile/sunset.png",
  ];
  
}
