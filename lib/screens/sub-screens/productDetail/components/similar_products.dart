import 'package:app_3/model/products_model.dart';
import 'package:app_3/screens/sub-screens/productDetail/product_detail_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../helper/page_transition_helper.dart';
import '../../../../widgets/common_widgets.dart/text_widget.dart';

class SimilarProducts extends StatelessWidget {
  final List<Products> similarProducts;
  const SimilarProducts({super.key,required this.similarProducts});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: similarProducts.length,
      itemBuilder: (context, index) {
        return Row(
          spacing: 10,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(context, SideTransistionRoute(screen: ProductDetailScreen(productDetail: similarProducts[index], category: "Best seller")));
              },
              child: Card(
                elevation: 2,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5)
                  ),
                  height: size.height * 0.28,
                  width: size.width / 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                        child: CachedNetworkImage(
                          height: size.height * 0.2,
                            width: size.width / 3,
                            fit: BoxFit.cover,
                          imageUrl: 'https://maduraimarket.in/public/image/product/${similarProducts[index].image}'
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 3, right: 3),
                        child: SizedBox(
                          // width: size.width / 4,
                          child: AppTextWidget(
                            text: similarProducts[index].name, 
                            fontWeight: FontWeight.w400,
                            maxLines: 2,
                            fontSize: 12,
                            textOverflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 3, right: 3),
                        child: AppTextWidget(
                          text: '₹${similarProducts[index].finalPrice}', 
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          maxLines: 2,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Container()
          ],
        );
      },
    );
  }
}