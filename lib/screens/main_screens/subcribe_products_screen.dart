import 'package:app_3/helper/shared_preference_helper.dart';
import 'package:app_3/providers/subscription_provider.dart';
import 'package:app_3/screens/sub-screens/subscription/subscription_page_widget.dart';
import 'package:app_3/service/connectivity_helper.dart';
import 'package:app_3/widgets/common_widgets.dart/app_bar.dart';
import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SubscriptionList extends StatelessWidget {
  SubscriptionList({super.key});

  final SharedPreferences prefs = SharedPreferencesHelper.getSharedPreferences();

  @override
  Widget build(BuildContext context) {
    final connectivityService = Provider.of<ConnectivityService>(context);
    final subscriptionProductsProvider = Provider.of<SubscriptionProvider>(context);
    if (connectivityService.isConnected) {
      return Scaffold(
        appBar: const AppBarWidget(title: 'Subscription products',),
        body: subscriptionProductsProvider.subscribeProducts.isEmpty
          ? FutureBuilder(
              future: subscriptionProductsProvider.getSubscribProducts(), 
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LinearProgressIndicator(
                    backgroundColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                  );
                }else if(snapshot.hasError){
                  return Center(
                    child: AppTextWidget(
                      text: snapshot.error.toString(), 
                      fontSize: 14, 
                      fontWeight: FontWeight.w500
                    ),
                  );
                } else{
                  return const SubscriptionPageWidget();
                }
              },
            )
          : const SubscriptionPageWidget()
        );
    } else {
      return Scaffold(
        appBar: const AppBarWidget(title: 'Subscription',),
        body: Center(
          child: Image.asset('assets/category/nointernet.png'),
        ),
      );
    }
  }
}


