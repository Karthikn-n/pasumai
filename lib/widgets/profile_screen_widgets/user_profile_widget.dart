import 'package:app_3/helper/page_transition_helper.dart';
import 'package:app_3/providers/api_provider.dart';
import 'package:app_3/providers/profile_provider.dart';
import 'package:app_3/providers/subscription_provider.dart';
import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:app_3/widgets/profile_screen_widgets/edit_profile_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileWidget extends StatelessWidget {
  final SharedPreferences prefs;
  const UserProfileWidget({super.key, required this.prefs});
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              SizedBox(
                height: 72,
                width: 72,
                child: Image.asset(
                  "assets/icons/profile/man.png",
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 5,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Name
                  SizedBox(
                    width: size.width * 0.575,
                    child: AppTextWidget(
                      text: '${prefs.getString('firstname') ?? ''} ${prefs.getString('lastname') ?? ''}', 
                      fontSize: 16, 
                      maxLines: 1,
                      fontWeight: FontWeight.w500,
                      textOverflow: TextOverflow.ellipsis,
                      fontColor: Theme.of(context).primaryColor,
                    ),
                  ),
                  // User Email
                  // const SizedBox(height: 5,),
                  // AppTextWidget(
                  //   text: prefs.getString('mail') ?? '', 
                  //   fontSize: 12, 
                  //   fontWeight: FontWeight.w500,
                  //   fontColor: Theme.of(context).scaffoldBackgroundColor,
                  // ),
                  // User Number
                  // const SizedBox(height: 5,),
                  AppTextWidget(
                    text: prefs.getString('mobile') ?? '', 
                    fontSize: 12, 
                    fontWeight: FontWeight.w500,
                    fontColor: Theme.of(context).primaryColorDark,
                  ),
                ],
              ),
               IconButton(
                onPressed: () {
                  Navigator.push(context, SideTransistionRoute(screen: const EditProfileWidget()));
                },
                icon: Icon(
                  CupertinoIcons.pencil,
                  size: 20,
                  color: Theme.of(context).primaryColor,
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 12,),
        // Profile Boxes
        Consumer3<ProfileProvider, SubscriptionProvider, ApiProvider>(
          builder: (context, orders, subscriptions, wishlist, child) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ProfileCardsWidget(name: "Subscriptions", count: subscriptions.activeSubscriptions.length),
                  ProfileCardsWidget(name: "Orders", count: orders.orderInfoData.length),
                  ProfileCardsWidget(name: "Wishlist", count: wishlist.wishlistProducts.length),
                ],
              ),
            );
          }
        )
      ],
    );
  }
}

class ProfileCardsWidget extends StatelessWidget {
  final String name;
  final int count;
  const ProfileCardsWidget({super.key, required this.name, required this.count});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Row(
      children: [
        Container(
          height: size.height * 0.1,
          width: size.width * 0.25,
          decoration: BoxDecoration(
            // color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(8)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // count
              AppTextWidget(text: "$count", fontWeight: FontWeight.w600, fontSize: 20, fontColor: Colors.white,),
              const SizedBox(height: 4,),
              // Name of the card
              AppTextWidget(
                textAlign: TextAlign.center,
                text: name, 
                fontColor: Colors.white,
                fontWeight: FontWeight.w300,
                fontSize: 12,
              ),
            ],
          ),
        ),
        // Divider
       
      ],
    );
  }
}