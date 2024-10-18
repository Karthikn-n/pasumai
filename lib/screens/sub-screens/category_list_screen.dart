import 'package:app_3/data/constants.dart';
import 'package:app_3/providers/api_provider.dart';
import 'package:app_3/service/connectivity_helper.dart';
import 'package:app_3/widgets/common_widgets.dart/app_bar.dart';
import 'package:app_3/widgets/main_screen_widgets/category_products_list_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helper/cache_manager_helper.dart';

class CategoryListScreen extends StatelessWidget {
  const CategoryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scrollController = Provider.of<Constants>(context).categoryListController;
    return Consumer2<ConnectivityService, ApiProvider>(
      builder: (context, connectivity, categoryProvider, child) {
        if (!connectivity.isConnected) {
          return Scaffold(
            appBar: AppBarWidget(
              title: 'Categories',
              needBack: true,
              onBack: () => Navigator.pop(context),
            ),
            body: Center(
              child: Image.asset('assets/category/nointernet.png'),
            ),
          ); 
        } else {
          return Scaffold(
            appBar: AppBarWidget(
              title: 'Categories',
              needBack: true,
              onBack: () => Navigator.pop(context),
            ),
            body: CupertinoScrollbar(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: GridView.builder(
                  controller: scrollController,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5
                  ), 
                  itemCount: categoryProvider.categories.length,
                  itemBuilder: (context, index) {
                    String imageUrl = 'https://maduraimarket.in/public/image/category/${categoryProvider.categories[index].categoryImage}';
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CategoryProductsListWidget(categoryName: categoryProvider.categories[index].categoryName, categoryId: categoryProvider.categories[index].categoryId,)
                        ));
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        ),
                        elevation: 3,
                        child: SizedBox(
                          height: 200,
                          width: 200,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: imageUrl,
                              fit: BoxFit.cover,
                              cacheManager: CacheManagerHelper.cacheIt(key: categoryProvider.categories[index].categoryImage),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ); 
        }
      },
    );
  }
}