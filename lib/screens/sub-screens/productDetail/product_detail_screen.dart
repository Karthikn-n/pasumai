import 'package:app_3/helper/page_transition_helper.dart';
import 'package:app_3/model/products_model.dart';
import 'package:app_3/providers/api_provider.dart';
import 'package:app_3/screens/sub-screens/checkout/payment_screen.dart';
import 'package:app_3/screens/sub-screens/productDetail/components/review_counts.dart';
import 'package:app_3/screens/sub-screens/productDetail/components/reviews_dashbaord.dart';
import 'package:app_3/screens/sub-screens/productDetail/components/reviews_listing.dart';
import 'package:app_3/screens/sub-screens/productDetail/provider/product_detail_provider.dart';
import 'package:app_3/widgets/common_widgets.dart/app_bar.dart';
import 'package:app_3/widgets/common_widgets.dart/button_widget.dart';
import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {
  final Products productDetail;
  final String category;
  const ProductDetailScreen({super.key, required this.productDetail, required this.category});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Consumer<ApiProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBarWidget(
            title: productDetail.name,
            needBack: true,
            fontSize: 18,
            centerTitle: false,
            onBack: () {
              Navigator.pop(context);
            },
            actions: [
              IconButton(onPressed: (){}, icon: const Icon(CupertinoIcons.heart))
            ],
          ),
          body: Column(
            children: [
              // Product Detail column
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 15,
                    children: [
                      SizedBox(
                        height: 240,
                        width: double.infinity,
                        child: CachedNetworkImage(
                          imageUrl: 'https://maduraimarket.in/public/image/product/${productDetail.image}',
                          fit: BoxFit.cover,
                        ),
                      ),
                      // Product Detail column
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 15,
                          children: [
                            // product category section
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Theme.of(context).primaryColor.withValues(alpha: 0.3)
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                spacing: 4,
                                children: [
                                  Icon(CupertinoIcons.wand_stars, size: 12, color: Theme.of(context).primaryColor,),
                                  AppTextWidget(
                                    text: category, 
                                    fontColor: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w500, 
                                    fontSize: 12,
                                  ),
                                ],
                              ),
                            ),
                            // Product name and price
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppTextWidget(text: productDetail.name, fontWeight: FontWeight.w600, fontSize: 18,),
                                AppTextWidget(text: '₹${productDetail.finalPrice}', fontWeight: FontWeight.w600, fontSize: 18, fontColor: Theme.of(context).primaryColor,),
                              ],
                            ),
                            // Product offer and rating
                            Row(
                              spacing: 15,
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppTextWidget(
                                  text: '${(((productDetail.price - productDetail.finalPrice) / productDetail.price) * 100).round()}% off', 
                                  fontWeight: FontWeight.w500, 
                                  fontSize: 14,
                                  fontColor: Colors.deepOrangeAccent
                                ),
                                const SizedBox(
                                  height: 14,
                                  width: 1,
                                  child: VerticalDivider(color: Colors.black,),
                                ),
                                const Row(
                                  children: [
                                    Icon(CupertinoIcons.star_fill, color: Colors.yellow, size: 16,),
                                    AppTextWidget(
                                      text: '4.2 (332)', 
                                      fontWeight: FontWeight.w400, fontSize: 14,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            // Product description
                            AppTextWidget(
                              text: productDetail.description.replaceAll("<p>", "").replaceAll("</p>", ""), 
                              fontWeight: FontWeight.w500, 
                              fontSize: 12,
                            ),
                            // Quantity selection
                            AppTextWidget(
                              text: "Quntity", 
                              fontWeight: FontWeight.w600, 
                              fontSize: 16, 
                              fontColor: Theme.of(context).primaryColorDark.withValues(alpha: 0.7),
                            ),
                            // list of quantity
                            Row(
                              spacing: 5,
                              children: List.generate(ProductDetailProvider.quantities.length, (index) {
                                return InkWell(
                                  onTap: () {
                                    ProductDetailProvider.setQuntity(ProductDetailProvider.quantities[index]);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color:  ProductDetailProvider.quantity == ProductDetailProvider.quantities[index] ? Theme.of(context).primaryColor : null,
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(color:  ProductDetailProvider.quantity == ProductDetailProvider.quantities[index] 
                                      ? Colors.transparent :Colors.grey)
                                    ),
                                    child: AppTextWidget(
                                      text: ProductDetailProvider.quantities[index], 
                                      fontColor: ProductDetailProvider.quantity == ProductDetailProvider.quantities[index] 
                                          ? Theme.of(context).primaryColorLight
                                          : Theme.of(context).primaryColorDark,
                                      fontWeight: FontWeight.w500, 
                                      fontSize: 12,
                                    ),
                                  ),
                                );
                              },),
                            ),
                            // Similar products section
                            AppTextWidget(
                              text: "Similar products", 
                              fontWeight: FontWeight.w600, 
                              fontSize: 16, 
                              fontColor: Theme.of(context).primaryColorDark.withValues(alpha: 0.7),
                            ),
                            // Similar product list
                            SizedBox(
                              height: size.height * 0.28,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: provider.quickOrderProductsList.length,
                                itemBuilder: (context, index) {
                                  Products products = provider.quickOrderProductsList[index]; 
                                  return Row(
                                    spacing: 10,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(context, SideTransistionRoute(screen: ProductDetailScreen(productDetail: products, category: category)));
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
                                                    imageUrl: 'https://maduraimarket.in/public/image/product/${products.image}'
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 3, right: 3),
                                                  child: SizedBox(
                                                    // width: size.width / 4,
                                                    child: AppTextWidget(
                                                      text: products.name, 
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
                                                    text: '₹${products.finalPrice}', 
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
                              ),
                            ),
                            // Review heading
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppTextWidget(
                                  text: "Customer reviews", 
                                  fontWeight: FontWeight.w600, 
                                  fontSize: 16, 
                                  fontColor: Theme.of(context).primaryColorDark.withValues(alpha: 0.7),
                                ),
                                InkWell(
                                  onTap: () {
                                   
                                  },
                                  child: AppTextWidget(
                                    text: "Write a review", 
                                    fontWeight: FontWeight.w400, 
                                    fontSize: 13, 
                                    fontColor: Theme.of(context).primaryColor,
                                  ),
                                )
                              ],
                            ),
                            // Review counts and stars
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 5,
                              children: [
                                ReviewCounts(average: (4.5).toInt()),
                                const AppTextWidget(
                                  text: "332 total ratings, 58 with reviews", 
                                  fontWeight: FontWeight.w400, 
                                  fontSize: 14, 
                                ),
                              ],
                            ),
                            // Reviews dash board
                            const ReviewsDashbaord(
                              ratings: [126, 24, 55, 65, 62], // 126 + 24 + 
                              totalRating: 332
                            ),
                            // Reviews listing
                            const ReviewsListing(reviews: 3)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            
              // Product buying button
              SizedBox(
                height: kToolbarHeight + 14,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                  child: Material(
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ButtonWidget(
                          width: size.width * 0.45,
                          buttonName: "Add to Cart", 
                          buttonColor: Colors.white,
                          fontSize: 16,
                          splashColor: Colors.transparent.withValues(alpha: 0.4),
                          fontColor: Theme.of(context).primaryColor,
                          bordercolor: Theme.of(context).primaryColor,
                          onPressed: () {
                            
                          },
                        ),
                        ButtonWidget(
                          width: size.width * 0.45,
                          buttonName: "Buy now", 
                          fontSize: 16,
                          onPressed: () {
                            
                          },
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      }
    );
  }
}