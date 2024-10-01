import 'package:app_3/model/invoice_model.dart';
import 'package:app_3/providers/profile_provider.dart';
import 'package:app_3/widgets/common_widgets.dart/shimmer_profile_widget.dart';
import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:app_3/widgets/subscription_widgets/subscription_detail_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InvoiceListWidget extends StatelessWidget {
  InvoiceListWidget({super.key});
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Consumer<ProfileProvider>(
      builder: (context, provider, child) {
        return provider.invoices.isEmpty
          ? FutureBuilder<String?>(
            future: provider.getInvoice(), 
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextWidget(
                        text: "Invoice Listing", 
                        fontSize: 16, 
                        fontWeight: FontWeight.w500
                      ),
                      SizedBox(height: 15,),
                      Expanded(child: ShimmerProfileWidget())
                    ],
                  ),
                );
              }else if(snapshot.hasError || snapshot.data == null){
                return const Center(
                  child: AppTextWidget(
                    text: "No invoices found",
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                );
              } else{
                return Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppTextWidget(
                        text: "Invoice Listing", 
                        fontSize: 16, 
                        fontWeight: FontWeight.w500
                      ),
                      const SizedBox(height: 15,),
                      Expanded(
                        child: invoicesList(size, provider.invoices)
                      )
                    ],
                  ),
                );
              }
            },
          )
          : Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppTextWidget(
                    text: "Invoice Listing", 
                    fontSize: 16, 
                    fontWeight: FontWeight.w500
                  ),
                  const SizedBox(height: 15,),
                  Expanded(
                    child: invoicesList(size, provider.invoices)
                  )
                ],
              ),
            );
      } 
    );
  }

  // Invoice Listing page
  Widget invoicesList(Size size, List<InvoiceModel> invoices){
    return Consumer<ProfileProvider>(
      builder: (context, provider, child) {
        invoices = invoices.reversed.toList();
        return GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
          child: CupertinoScrollbar(
            controller: _scrollController,
            child: ListView.builder(
              controller: _scrollController,
              itemCount: invoices.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade300
                        ),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Column(
                        children: [
                          // Invoice Id and download Button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const AppTextWidget(
                                    text: "Invoice No: ", 
                                    fontSize: 15, 
                                    fontWeight: FontWeight.w500
                                  ),
                                  AppTextWidget(
                                    text: invoices[index].invoiceNo.toString(), 
                                    fontSize: 14, 
                                    fontWeight: FontWeight.w400
                                  )
                                ],
                              ),
                              // Icon(
                              //   CupertinoIcons.down_arrow, 
                              //   size: 20, 
                              //   color: Theme.of(context).primaryColor,
                              // )
                              
                            ],
                          ),
                          // Order ID
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: size.width * 0.65,
                                child: Column(
                                  children: [
                                    SubscriptionDetailWidget(title: 'Order ID: ', value: invoices[index].orderId),
                                    // Invoice Date
                                    SubscriptionDetailWidget(title: 'Invoice Date: ', value: invoices[index].invoiceDate),
                                    // Invoice Status
                                    SubscriptionDetailWidget(
                                      title: 'Invoice Status: ', 
                                      value: invoices[index].status,
                                      valueColor: invoices[index].status == "Pending"
                                      ? Colors.orange
                                      : Theme.of(context).primaryColor,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 40,
                                width: 45,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    overlayColor: Colors.transparent.withOpacity(0.1),
                                  ),
                                  onPressed: () async {
                                    print("FileName: ${invoices[index].invoiceFile}");
                                    await provider.downloadInvoice(invoices[index].invoiceFile, context, size);
                                  },
                                  child: Image.asset(
                                    'assets/category/download.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: invoices.length -1 == index ? 70 : 10,),
                  ],
                );
              },
            ),
          ),
        );
      }
    );
  }

  
}

