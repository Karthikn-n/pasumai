import 'package:app_3/model/products_model.dart';
import 'package:app_3/widgets/productlist/product_list_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  final List<Products> products;
  final bool? fromQuickOrder;
  final bool? fromSubscription;
  const SearchWidget({
    super.key, 
    required this.products,
    this.fromQuickOrder,
    this.fromSubscription
  });

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController _searchController = TextEditingController();
  FocusNode? _initialFocus;
  bool isSearchon = false;
  List<Products> searchedProducts = [];
  @override
  void initState() {
    super.initState();
    _initialFocus = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_initialFocus);
    },);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width 
          ),
          child: SearchBar(
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
            leading: IconButton(
              tooltip: "Back",
              onPressed: (){
                Navigator.pop(context);
              }, 
              icon: const Icon(CupertinoIcons.chevron_back)
            ),
            controller: _searchController,
            focusNode: _initialFocus,
            trailing: [
              IconButton(
                tooltip: "Search",
                onPressed: (){
                  setState(() {
                    searchedProducts = widget.products.where((product) => product.name.toLowerCase().contains(_searchController.text.toLowerCase()) ).toList();
                  });
                }, 
                icon: const Icon(CupertinoIcons.search)
              )
            ],
            hintText: "Search",
            onChanged: (value) {
              setState(() {
                searchedProducts = widget.products.where((product) => product.name.toLowerCase().contains(_searchController.text.toLowerCase()) ).toList();
              });
            },
            onSubmitted: (value) {
              setState(() {
                searchedProducts = widget.products.where((product) => product.name.toLowerCase().contains(_searchController.text.toLowerCase()) ).toList();
              });
            },
            elevation: const WidgetStatePropertyAll(0),
            shape: const WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
          )
        ),
      ),
      body: ProductListWidget(
        fromSubscription: widget.fromSubscription,
        fromQuickOrder: widget.fromQuickOrder,
        products: searchedProducts
      ),
    );
  }
}