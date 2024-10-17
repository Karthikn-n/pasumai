import 'package:app_3/model/orders_model.dart';
import 'package:app_3/providers/profile_provider.dart';
import 'package:app_3/widgets/common_widgets.dart/app_bar.dart';
import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderDetailWidget extends StatelessWidget {
  const OrderDetailWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    Map args = ModalRoute.of(context)!.settings.arguments as Map;
    OrderInfo orderDetail = args['orderDetail'] as OrderInfo;
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Order detail',
        needBack: true,
        onBack: () => Navigator.pop(context),
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, provider, child) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppTextWidget(
                    text: "Order detail", 
                    fontSize: 18 , 
                    fontWeight: FontWeight.w500
                  ),
                  const SizedBox(height: 12,),
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
                        Row(
                        children: [
                          SizedBox(
                            width: size.width * 0.33,
                            child: const AppTextWidget(
                              text: "Ordered ID", 
                              fontSize: 14, 
                              fontWeight: FontWeight.w500,
                              // maxLines: 1,
                              textOverflow: TextOverflow.ellipsis,
                            ),
                          ),
                          AppTextWidget(
                            text: orderDetail.orderId.toString(), 
                            fontSize: 12, 
                            fontWeight: FontWeight.w400,
                          )
                        ],
                        ),
                        const SizedBox(height: 5,),
                        Row(
                          children: [
                            SizedBox(
                              width: size.width *0.33,
                              child: const AppTextWidget(text: 'Products', fontSize: 14, fontWeight: FontWeight.w500)
                            ),
                            AppTextWidget(text: '${orderDetail.quantity}', fontSize: 12, fontWeight: FontWeight.w400),
                          ],
                        ),
                        const SizedBox(height: 5,),
                        Row(
                          children: [
                            SizedBox(
                              width: size.width * 0.32,
                              child: const AppTextWidget(text: 'Ordered on', fontSize: 14, fontWeight: FontWeight.w500)
                            ),
                            AppTextWidget(text: orderDetail.orderOn, fontSize: 12, fontWeight: FontWeight.w400),
                          ],
                        ),
                        const SizedBox(height: 5,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: size.width *0.33,
                              child: const AppTextWidget(text: 'Address', fontSize: 14, fontWeight: FontWeight.w500)
                            ),
                            Expanded(child: AppTextWidget(text: orderDetail.address, fontSize: 12, fontWeight: FontWeight.w400)),
                          ],
                        ),
                        // Discount Amount
                        const SizedBox(height: 5,),
                        provider.discountAmount == 0.0
                        ? Container()
                        : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: size.width *0.33,
                              child: const AppTextWidget(text: 'Discount', fontSize: 14, fontWeight: FontWeight.w500)
                            ),
                            Expanded(child: AppTextWidget(text: "₹${provider.discountAmount}", fontSize: 12, fontWeight: FontWeight.w400)),
                          ],
                        ),
                        provider.discountAmount == 0.0 ? Container() : const SizedBox(height: 5,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: size.width *0.33,
                              child: const AppTextWidget(text: 'Total', fontSize: 14, fontWeight: FontWeight.w500)
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  AppTextWidget(text: provider.discountAmount == 0.0 
                                    ? '₹${double.parse(orderDetail.total)}'
                                    : '₹${double.parse(orderDetail.total)} / ', 
                                    fontSize: 12, fontWeight: FontWeight.w500,
                                    fontColor: Theme.of(context).primaryColor,
                                  ),
                                  Text(
                                    provider.discountAmount == 0.0
                                    ? ""
                                    : "₹${(double.parse(orderDetail.total) + provider.discountAmount)}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.lineThrough,
                                      decorationColor: Colors.grey,
                                      decorationThickness: 2,
                                      color: Colors.grey
                                    ),
                                  )
                                ],
                              )
                            ),
                          ],
                        ),
                        const SizedBox(height: 5,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: size.width *0.33,
                              child: const AppTextWidget(
                                text: 'Status', 
                                fontSize: 14, 
                                fontWeight: FontWeight.w500
                              )
                            ),
                            Expanded(
                                child: AppTextWidget(
                                text: orderDetail.status, 
                                fontSize: 12, 
                                fontWeight: FontWeight.w500,
                                fontColor: orderDetail.status == "Pending"
                                  ? Colors.red
                                  : Theme.of(context).primaryColor,
                              )
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16,),
                  const AppTextWidget(
                    text: "Ordered products", 
                    fontSize: 18 , 
                    fontWeight: FontWeight.w500
                  ),
                  const SizedBox(height: 12,),
                  // Ordered Product List
                  Consumer<ProfileProvider>(
                    builder: (context, orderedProvider, child) {
                      return SizedBox(
                        height: size.height * 0.18 * orderedProvider.orderedProducts.length,
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: orderedProvider.orderedProducts.length,
                          itemBuilder: (context, index) {
                            final product = orderedProvider.orderedProducts[index];
                            return Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.black26)
                                  ),
                                  // height: size.height * 0.16,
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      AppTextWidget(
                                        text: product.productName,
                                        fontSize: 14, 
                                        fontWeight: FontWeight.w600,
                                      ),
                                      // total count
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: size.width * 0.4,
                                            child: const AppTextWidget(
                                              text: 'Item count',
                                              fontSize: 14, 
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          AppTextWidget(
                                            text: '${product.quantity} item',
                                            fontSize: 12, 
                                            fontWeight: FontWeight.w400,
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 4,),
                                      // total amount
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: size.width * 0.4,
                                            child: const AppTextWidget(
                                              text: 'Product price',
                                              fontSize: 14, 
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          AppTextWidget(
                                            text: '₹${provider.orderedProducts[index].price}',
                                            fontSize: 12, 
                                            fontColor: Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.w500,
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 4,),
                                      // total amount
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: size.width * 0.4,
                                            child: const AppTextWidget(
                                              text: 'Total for product',
                                              fontSize: 14, 
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          AppTextWidget(
                                            text: '₹${provider.orderedProducts[index].total}',
                                            fontSize: 12, 
                                            fontWeight: FontWeight.w400,
                                          )
                                        ],
                                      ),
                                      // const SizedBox(height: 4,),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 15,)
                              ],
                            );
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20,)
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}