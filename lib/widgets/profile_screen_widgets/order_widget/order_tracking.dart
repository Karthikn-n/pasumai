import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderTracking extends StatefulWidget {
  final String status; 
  const OrderTracking({super.key, required this.status});

  @override
  State<OrderTracking> createState() => _OrderTrackingState();
}

class _OrderTrackingState extends State<OrderTracking> {
  final List<String> _orders = [
    "Order placed",
    "Order confirmed",
    "Order processed",
    "Ready to ship",
    "Out for delivery",
    "Devliered"
  ];
  final List<String> _descriptions = [
    "We have received your order on ",
    "We has been confirmed on ",
    "We are preparing your order on ",
    "Your order is Ready to shipping on ",
    "Your order is Out for delivery on ",
    "Your order is successfully placed on "
  ];
  @override
  Widget build(BuildContext context) {
    final int statusIndex = _orders.indexOf(widget.status);
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...List.generate(6, (index) {
              final bool isActive = index <= statusIndex;
              return Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    index  < 6 
                    ? Icon(
                      Icons.circle, 
                      color: isActive ?  Theme.of(context).primaryColor :  Colors.grey.shade300, 
                      size: 20,
                    )
                    : Container(),
                    index  == 5
                    ? Container()
                    : SizedBox(
                      height: kToolbarHeight,
                      width: 4,
                      child: VerticalDivider(
                        color: index < statusIndex ?  Theme.of(context).primaryColor :  Colors.grey.shade300,
                      ),
                    )
                  ],
                ),
              );
            },)
          ],
        ),
        SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.8,
          child: Column(
            children: List.generate(6, (index) {
              final bool isActive = index <= statusIndex;
              return ListTile(
                minTileHeight: kToolbarHeight + 18,
                leading: CircleAvatar(
                    backgroundColor: isActive ?  Theme.of(context).primaryColor :  Colors.grey.shade300,
                    child: isActive ? const Icon(CupertinoIcons.check_mark) :  AppTextWidget(
                      text: "${index + 1}", fontWeight: FontWeight.w500,
                      fontColor:  isActive?  Colors.white : Theme.of(context).primaryColorDark ,
                    ),
                  ),
                title: AppTextWidget(
                  text: _orders[index], 
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  fontColor: Theme.of(context).primaryColorDark.withValues(alpha: 0.6),
                ),
                subtitle: AppTextWidget(
                  text: "${_descriptions[index]}31/09/2024", 
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  fontColor: Theme.of(context).primaryColorDark.withValues(alpha: 0.6),
                ),
              );
            },),
          ),
        )
      ],
    );
  }
}