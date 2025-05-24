import 'package:app_3/helper/page_transition_helper.dart';
import 'package:app_3/providers/address_provider.dart';
import 'package:app_3/providers/profile_provider.dart';
import 'package:app_3/screens/sub-screens/wishlist_products.dart';
import 'package:app_3/service/connectivity_helper.dart';
import 'package:app_3/widgets/common_widgets.dart/app_bar.dart';
import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:app_3/widgets/profile_screen_widgets/active_subscription_widget.dart';
import 'package:app_3/widgets/profile_screen_widgets/invoice_list_widget.dart';
import 'package:app_3/widgets/profile_screen_widgets/orders_history_widget.dart';
import 'package:app_3/widgets/profile_screen_widgets/raise_a_query_widget.dart';
import 'package:app_3/widgets/profile_screen_widgets/subscription_history_widget.dart';
import 'package:app_3/widgets/profile_screen_widgets/user_profile_widget.dart';
import 'package:app_3/widgets/profile_screen_widgets/vacation_list_widget.dart';
import 'package:app_3/widgets/profile_screen_widgets/your_address_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewProfileScreen extends StatefulWidget {
  const NewProfileScreen({super.key});

  @override
  State<NewProfileScreen> createState() => _NewProfileScreenState();
}

class _NewProfileScreenState extends State<NewProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldStateKey = GlobalKey<ScaffoldState>();
 
  @override
  void initState() {
    super.initState();
    _loadSelectedOption();
  }
  
    void _loadSelectedOption() {
      final provider = Provider.of<ProfileProvider>(context, listen: false);
      provider.loadSelectedOption();
    }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    final connectivityCheck = Provider.of<ConnectivityService>(context);
    if (!connectivityCheck.isConnected) {
      return Scaffold(
        // resizeToAvoidBottomInset: false,
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
            resizeToAvoidBottomInset: true,
            appBar: AppBarWidget(
              title: 'Profile',
              needBack: true,
              onBack: () {
                _scaffoldStateKey.currentState?.openDrawer();
              },
              toolTip: "Menu",
              leading: CupertinoIcons.bars,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: IconButton(
                    tooltip: "Logout",
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
                    provider.options.length, 
                    (index) {
                      return Consumer2<ProfileProvider, AddressProvider>(
                        builder: (context, profileProvider, addressProvider, child) {
                          return ListTile(
                            leading: SizedBox(
                              height: 20,
                              width: 20,
                              child: Image.asset(
                                provider.images[index],
                                color: provider.isOptionSelected[index] ? Colors.white : null,
                              ),
                            ),
                            tileColor: provider.isOptionSelected[index]
                            ? Theme.of(context).primaryColor
                            : null,
                            onTap: () async {
                              if (provider.options[index] == "Raise a query") {
                                _scaffoldStateKey.currentState?.closeDrawer();
                               await Future.delayed(const Duration(milliseconds: 200));
                                Navigator.push(context, SideTransistionRoute(screen: const RaiseAQueryWidget()));
                              } 
                              else if(provider.options[index] == "Wishlist Products") {
                                _scaffoldStateKey.currentState?.closeDrawer();
                               await Future.delayed(const Duration(milliseconds: 200));
                                Navigator.push(context, SideTransistionRoute(screen: const WishlistProducts()));
                              }else {
                                  provider.changeBody(index);
                                _scaffoldStateKey.currentState?.closeDrawer();
                              }
                            },
                            title: AppTextWidget(
                              text: provider.options[index], 
                              fontSize: 14, 
                              fontWeight: FontWeight.w400,
                              fontColor: provider.isOptionSelected[index] ? Theme.of(context).scaffoldBackgroundColor : null,
                            ),
                          );
                        }
                      );
                    },
                  )
                ],
              ),
            ),
            body: Column(
              children: [
                UserProfileWidget(prefs: provider.prefs),
                const SizedBox(height: 16,),
                optionsBody[provider.prefs.getInt('selectedOptionIndex') ?? provider.selectedbody],
              ],
            ),
          );
        }
      );
    }
  }

  List<Widget> optionsBody = [
    const OrdersHistoryWidget(),
    const ActiveSubscriptionWidget(),
    const SubscriptionHistoryWidget(),
    const YourAddressWidget(),
    const InvoiceListWidget(),
    const VacationListWidget(),
  ];

}
