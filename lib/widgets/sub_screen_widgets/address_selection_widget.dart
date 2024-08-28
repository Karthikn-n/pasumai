import 'package:app_3/model/address_model.dart';
import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget locationSelectButton({
  required BuildContext context,
  required Size size,
  required IconData leading,
  required IconData suffixIcon,
  required String title
}){
  return SizedBox(
    height: size.height * 0.08,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              leading,
              color: Theme.of(context).primaryColor,
              size: 18,
            ),
            const SizedBox(width: 5,),
            AppTextWidget(
              text: title, 
              fontSize: 16, 
              fontWeight: FontWeight.w600,
              fontColor: Theme.of(context).primaryColor,
            )
          ],
        ),
        Text(String.fromCharCode(suffixIcon.codePoint),
          style: TextStyle(
            inherit: false,
            fontSize: 17,
            fontWeight: FontWeight.w800,
            fontFamily: suffixIcon.fontFamily,
            package: suffixIcon.fontPackage,
            color:  Theme.of(context).primaryColor,
          ),
        )
      ],
    ),
  );     
}



// Address List
Widget addressList({
  required BuildContext context,
  required AddressModel address,
  required bool isCurrentAddress,
  required Size size
}){
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                CupertinoIcons.bag_fill, 
                size: 15, 
                color: Colors.grey.shade500,
              ),
              const SizedBox(width: 5,),
              SizedBox(
                width: size.width * 0.5,
                child: AppTextWidget(
                  text: address.location, 
                  fontSize: 16, 
                  maxLines: 2,
                  textOverflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w500,
                  fontColor: Colors.black87,
                ),
              ),
              const SizedBox(width: 5,),
              address.defaultAddress == "1" || isCurrentAddress
              ? Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(5)
                  ),
                  child: const AppTextWidget(
                    text: 'Currently Selected', 
                    fontSize: 10, 
                    fontWeight: FontWeight.w500,
                    fontColor: Colors.white,
                  ),
                )
              : Container()
            ],
          ),
          AppTextWidget(
            text: """${address.floorNo}, ${address.flatNo}, ${address.address}, ${address.landmark}, ${address.region}""", 
            fontSize: 14, 
            fontWeight: FontWeight.w400,
            fontColor: Colors.black54,
          )
        ],
      ),
    ),
  );
                
}





