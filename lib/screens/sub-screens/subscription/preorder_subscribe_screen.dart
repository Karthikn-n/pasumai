import 'package:app_3/model/pre_order_model.dart';
import 'package:app_3/providers/address_provider.dart';
import 'package:app_3/providers/subscription_provider.dart';
import 'package:app_3/widgets/common_widgets.dart/app_bar.dart';
import 'package:app_3/widgets/common_widgets.dart/button_widget.dart';
import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:app_3/widgets/subscription_widgets/subscription_detail_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


class PreOrderProductsScreen extends StatefulWidget{
 const PreOrderProductsScreen({super.key});

 @override
  State<PreOrderProductsScreen> createState() => _PreOrderProductScreen();
}

class _PreOrderProductScreen extends State<PreOrderProductsScreen>{

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    Map args = ModalRoute.of(context)!.settings.arguments as Map;
    PreOrderModel preOrderData = args['preOrderData'] as PreOrderModel;
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Subscribe Product',
        needBack: true,
        onBack: () => Navigator.pop(context),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Delivery Address Heading
            const AppTextWidget(
              text: 'Delivery Address', 
              fontSize: 16,
              fontWeight: FontWeight.w600
              ),
            const SizedBox(height: 20,),
            // Delivery Address
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10)
              ),
              child: Consumer<AddressProvider>(
                  builder: (context, provider, child) {
                  return AppTextWidget(
                    text: '${preOrderData.customerAddress.flatNo}, ' 
                    '${preOrderData.customerAddress.floor}, ' 
                    '${preOrderData.customerAddress.address}, '
                    '${preOrderData.customerAddress.landmark}, '
                    '${provider.regionLocationsList.firstWhere((element) => element.regionId == int.parse(preOrderData.customerAddress.region),).regionName}, ' 
                    '${provider.regionLocationsList.firstWhere((element) => element.regionId == int.parse(preOrderData.customerAddress.region),).locationData.firstWhere((element) => element.locationId == int.parse(preOrderData.customerAddress.location),).locationName}, '
                    '${preOrderData.customerAddress.pincode}, ', 
                    fontSize: 14, 
                    fontWeight: FontWeight.w400
                  );
                }
              ),
            ),
            const SizedBox(height: 20,),
            // Subscription Detail
            const AppTextWidget(
              text: 'Subscription Detail', 
              fontSize: 16,
              fontWeight: FontWeight.w600
            ),
            const SizedBox(height: 20,),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey.shade300,
                )
              ),
              child: Column(
                children: [
                  // Subscribed Product Name
                  SubscriptionDetailWidget(title: "Product Name: ", value: preOrderData.productName),
                  const SizedBox(height: 6,),
                  // Subscribed Method
                  SubscriptionDetailWidget(title: "Subscribed Method: ", value: preOrderData.frequency),
                  const SizedBox(height: 6,),
                  // Product Price
                  SubscriptionDetailWidget(title: "Product Price: ", value: "₹${preOrderData.amount.toString()}"),
                  const SizedBox(height: 6,),
                  // Subscription Status
                  SubscriptionDetailWidget(
                    title: "Subscription status: ", 
                    value: preOrderData.status,
                    valueColor: preOrderData.status == "Active"
                      ? Theme.of(context).primaryColor
                      : Colors.red,
                  ),
                  const SizedBox(height: 6,),
                  // subscription Start Date
                  SubscriptionDetailWidget(title: "Start date: ", value: DateFormat("dd MMM yyyy").format(DateTime.parse(preOrderData.startDate))),
                  const SizedBox(height: 6,),
                  // Subscription End Date
                  SubscriptionDetailWidget(title: "End date: ", value: DateFormat("dd MMM yyyy").format(DateTime.parse(preOrderData.endDate))),
                  const SizedBox(height: 6,),
                  // Subscription Grace Date
                  SubscriptionDetailWidget(
                    title: "Grace date: ", 
                    valueColor: Colors.orange,
                    value: DateFormat("dd MMM yyyy").format(DateTime.parse(preOrderData.graceDate))),
                  const SizedBox(height: 6,),
                  // total Subscription amount
                  SubscriptionDetailWidget(title: "Total Amount: ", value: "₹${preOrderData.total}"),
                  const SizedBox(height: 6,),
                  // Subscription Days
                  SubscriptionDetailWidget(title: "Total days: ", value: preOrderData.totDays == 1 ? "${preOrderData.totDays} day" : "${preOrderData.totDays} days"),
                  const SizedBox(height: 6,),
                  // Total Quanity for entire month
                  SubscriptionDetailWidget(title: "Total quantity: ", value: "${preOrderData.totalQuantity}"),
                  const SizedBox(height: 6,),
                  // Payment Status
                  SubscriptionDetailWidget(
                    title: "Payment Status: ", 
                    value: preOrderData.paymentStatus, 
                    valueColor: preOrderData.paymentStatus == "Pending"
                    ? Colors.red
                    : Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20,),
            Center(
              child: Consumer<SubscriptionProvider>(
                builder: (context, payProvider, child) {
                  return ButtonWidget(
                    width: double.infinity,
                    buttonName: 'Pay Now', 
                    fontSize: 15,
                    onPressed: () async {
                      // await payProvider.rePreorder({"subscription_id": 67}, context, size);
                      await payProvider.preorderAPi(context, size);
                    },
                  );
                }
              ),
            )
          ],
        ),
      )
        
    );
  }

}
