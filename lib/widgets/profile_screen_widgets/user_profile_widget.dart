import 'package:app_3/helper/page_transition_helper.dart';
import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:app_3/widgets/profile_screen_widgets/edit_profile_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileWidget extends StatelessWidget {
  final SharedPreferences prefs;
  const UserProfileWidget({super.key, required this.prefs});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      // height: size.height * 0.1,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            CupertinoIcons.person_circle,
            size: 100,
            color: Theme.of(context).appBarTheme.backgroundColor,
          ),
          const SizedBox(width: 5,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextWidget(
                    text: '${prefs.getString('firstname') ?? ''} ${prefs.getString('lastname') ?? ''}', 
                    fontSize: 16, 
                    maxLines: 2,
    
                    fontWeight: FontWeight.w500,
                    fontColor: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  const SizedBox(width: 7,),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, SideTransistionRoute(screen: const EditProfileWidget()));
                    },
                    child: const Icon(
                      CupertinoIcons.pencil,
                      size: 20,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 5,),
              AppTextWidget(
                text: prefs.getString('mail') ?? '', 
                fontSize: 12, 
                fontWeight: FontWeight.w500,
                fontColor: Theme.of(context).scaffoldBackgroundColor,
              ),
              const SizedBox(height: 5,),
              AppTextWidget(
                text: prefs.getString('mobile') ?? '', 
                fontSize: 12, 
                fontWeight: FontWeight.w500,
                fontColor: Theme.of(context).scaffoldBackgroundColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}