import 'package:app_3/helper/page_transition_helper.dart';
import 'package:app_3/helper/shared_preference_helper.dart';
import 'package:app_3/providers/address_provider.dart';
import 'package:app_3/providers/api_provider.dart';
import 'package:app_3/providers/cart_items_provider.dart';
// import 'package:app_3/providers/notification_provider.dart';
import 'package:app_3/providers/profile_provider.dart';
import 'package:app_3/screens/sub-screens/address_selection_screen.dart';
import 'package:app_3/service/connectivity_helper.dart';
import 'package:app_3/widgets/common_widgets.dart/app_bar.dart';
import 'package:app_3/widgets/common_widgets.dart/input_field_widget.dart';
import 'package:app_3/widgets/common_widgets.dart/snackbar_widget.dart';
import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckoutScreen extends StatefulWidget {
  final bool? fromCart;
  const CheckoutScreen({super.key, this.fromCart});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  SharedPreferences prefs = SharedPreferencesHelper.getSharedPreferences();
  TextEditingController couponController = TextEditingController();
  // Delivery detail data
  DateTime? expectedDeliverydate;
  String? expectedDeliveryTime;
  List<String> deliveryTimes = ['06:00 - 11:59 AM','12:00 - 06:00 PM','06:00 - 09:00 PM'];
  // Payment Detail
  String? selectedPaymentOption;
  List<String> paymentOptions = ['Cash on delivery','Pay using UPI','Pay using credit/debit card'];

  // check conditions
  bool isdeliveryDateSelected = false;
  bool isDeliveryTimeSelected = false;
  bool isPaymentoptionSelected = false;

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final connectivityService = Provider.of<ConnectivityService>(context);
    Size size = MediaQuery.sizeOf(context);
    if (!connectivityService.isConnected) {
      return Scaffold(
        appBar: AppBarWidget(
          title: 'Quick order',
          needBack: true,
          onBack: () => Navigator.pop(context),
        ),
        body: Center(
          child: Image.asset('assets/category/nointernet.png'),
        ),
      );
    } else {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBarWidget(
          title: 'Checkout',
          needBack: true,
          onBack: () => Navigator.pop(context),
        ),
        body: Consumer3<ApiProvider, AddressProvider, CartProvider>(
          builder: (context, provider, addressProvider, cartProvider, child) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20,),
                    // Product Detail Heading
                    const AppTextWidget(
                      text: 'Product detail',
                      fontSize: 18, 
                      fontWeight: FontWeight.w600
                    ),
                    const SizedBox(height: 20,),
                    // Product Detail
                    Container(
                      height: widget.fromCart ?? true
                      ? provider.selectedProducts.length * 78
                      :  cartProvider.cartItems.length * 75 ,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey.shade300)
                      ),
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.fromCart ?? true 
                        ? provider.selectedProducts.length : cartProvider.cartItems.length,
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 62,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: widget.fromCart ?? true 
                                    ? index == provider.selectedProducts.length - 1 
                                      ? BorderSide.none
                                      : BorderSide(
                                        color:  Colors.grey.shade200,
                                      )
                                    : index == cartProvider.cartItems.length - 1 
                                      ? BorderSide.none
                                      : BorderSide(
                                        color:  Colors.grey.shade200,
                                      )
                                  )
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Product Name and quantity
                                    SizedBox(
                                      // width: size.width * 0.45,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              AppTextWidget(
                                                text: widget.fromCart ?? true 
                                                  ? "${provider.selectedProducts[index].quantity}x "
                                                  : "${cartProvider.cartQuantities[cartProvider.cartItems[index].id]}x ", 
                                                fontSize: 15, 
                                                fontWeight: FontWeight.w500,
                                                fontColor: Theme.of(context).primaryColor,
                                              ),
                                              SizedBox(
                                                width: size.width * 0.5,
                                                child: AppTextWidget(
                                                  text: widget.fromCart ?? true 
                                                  ? provider.selectedProducts[index].productName
                                                  : cartProvider.cartItems[index].name, 
                                                  fontSize: 14, 
                                                  maxLines: 1,
                                                  textOverflow: TextOverflow.ellipsis,
                                                  fontWeight: FontWeight.w600
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 5,),
                                          Row(
                                            children: [
                                              // AppTextWidget(
                                              //   text: "Product price: ", 
                                              //   fontSize: 12, 
                                              //   fontColor: Colors.black54,
                                              //   fontWeight: FontWeight.w500
                                              // ),
                                              AppTextWidget(
                                                text: widget.fromCart ?? true 
                                                ? "${provider.selectedProducts[index].productQuantity} "
                                                : "₹${int.parse(cartProvider.cartItems[index].price)} ", 
                                                fontSize: 13, 
                                                fontColor: Theme.of(context).primaryColor,
                                                fontWeight: FontWeight.w500
                                              ),
                                              AppTextWidget(
                                                text: widget.fromCart ?? true 
                                                ? " - ₹${provider.selectedProducts[index].finalPrice}/ "
                                                : "", 
                                                fontSize: 13, 
                                                fontWeight: FontWeight.w500
                                              ),
                                              Text(
                                                widget.fromCart ?? true 
                                                ? "₹${provider.selectedProducts[index].listPrice}"
                                                : "₹${cartProvider.cartItems[index].listPrice}",
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black54,
                                                  decorationColor: Colors.red,
                                                  decoration: TextDecoration.lineThrough
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Product price
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        AppTextWidget(
                                          text: widget.fromCart ?? true 
                                          ? "₹${provider.selectedProducts[index].finalPrice * provider.selectedProducts[index].quantity}"
                                          : "₹${cartProvider.cartQuantities[cartProvider.cartItems[index].id]! * int.parse(cartProvider.cartItems[index].price)}", 
                                          fontSize: 14, 
                                          fontWeight: FontWeight.w500
                                        ),
                                        const SizedBox(height: 4,),
                                        Text(
                                          widget.fromCart ?? true 
                                          ? "₹${provider.selectedProducts[index].listPrice * provider.selectedProducts[index].quantity}"
                                          : "₹${cartProvider.cartQuantities[cartProvider.cartItems[index].id]! * int.parse(cartProvider.cartItems[index].listPrice)}",
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black54,
                                            decorationColor: Colors.red,
                                            decoration: TextDecoration.lineThrough
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: widget.fromCart ?? true 
                              ?  index == provider.selectedProducts.length - 1 ? 0 :10
                              :  index == cartProvider.cartItems.length - 1 ? 0 : 10 ,)
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20,),
                    // Coupon Detail,
                    const AppTextWidget(
                      text: 'Coupon detail',
                      fontSize: 18, 
                      fontWeight: FontWeight.w600
                    ),
                    const SizedBox(height: 20,),
                    // Coupon field
                    TextFields(
                      isObseure: false, 
                      textInputAction: TextInputAction.done,
                      controller: couponController,
                      borderRadius: 5,
                      readOnly: provider.isCouponApplied ? true : false,
                      hintText: "Have a coupon code?",
                      suffixIcon:  provider.isCouponApplied 
                        ? Icon(CupertinoIcons.check_mark_circled, size: 24, color: Theme.of(context).primaryColor,)
                        : TextButton(
                        onPressed: () async {
                          if (couponController.text.isEmpty) {
                            final appliedMessage = snackBarMessage(
                              context: context, 
                              message: 'Enter a coupon code', 
                              backgroundColor: Theme.of(context).primaryColor, 
                              sidePadding: size.width * 0.1, 
                              bottomPadding: size.height * 0.75
                            );
                            ScaffoldMessenger.of(context).showSnackBar(appliedMessage);
                          }else{
                            if (widget.fromCart ?? true) {
                              await provider.applyCouponQuickOrder(couponController.text, size, provider.totalQuickOrderAmount.toString(), context);
                            }else{
                              await provider.applyCoupon(couponController.text, size, cartProvider.totalCartAmount.toString(), context);
                            }
                          }
                        }, 
                        style: ButtonStyle(
                          overlayColor: WidgetStatePropertyAll(Colors.grey.withOpacity(0.1))
                        ),
                        child: AppTextWidget(
                          text:  'Apply', 
                          fontSize: 13, 
                          fontColor: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500
                        )
                      ),
                    ),
                    const SizedBox(height: 20,),
                    // Schedule Delivery detail
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const AppTextWidget(
                          text: 'Schedule Delivery',
                          fontSize: 18, 
                          fontWeight: FontWeight.w600
                        ),
                        isdeliveryDateSelected
                        ? const AppTextWidget(text: "* delivery date is required", fontSize: 13, fontWeight: FontWeight.w400, fontColor: Colors.red,)
                        : isDeliveryTimeSelected
                          ? const AppTextWidget(text: "* delivery time is required", fontSize: 13, fontWeight: FontWeight.w400, fontColor: Colors.red,)
                          : Container()
                      ],
                    ),
                    const SizedBox(height: 20,),
                    // Expected Delivery date Detail
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey.shade300)
                      ),
                      child: Column(
                        children: [
                          // Expected Delivery date
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const AppTextWidget(text: "Expected Delivery date: ", fontSize: 14, fontWeight: FontWeight.w500),
                              // Date Picker
                              GestureDetector(
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context, 
                                    firstDate: DateTime.now().add(const Duration(days: 1)), 
                                    lastDate: DateTime(2100),
                                    initialDate: expectedDeliverydate ?? DateTime.now().add(const Duration(days: 1)),
                                  );
                                  setState(() {
                                    expectedDeliverydate = pickedDate;
                                    isdeliveryDateSelected = false;
                                  });
                                },
                                child: AppTextWidget(
                                  text: expectedDeliverydate != null
                                    ? DateFormat("dd MMM yyyy").format(expectedDeliverydate!)
                                    : "Pick a date", 
                                  fontSize: 13, 
                                  fontColor:  Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w500
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 8,),
                          // Expected Delivery time
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const AppTextWidget(text: "Expected Delivery time: ", fontSize: 14, fontWeight: FontWeight.w500),
                              // Delivery time drop down
                              SizedBox(
                                height: 30,
                                width: size.width * 0.35,
                                child: DropdownButton(
                                  isExpanded: true,
                                  elevation: 1,
                                  value: expectedDeliveryTime,
                                  underline: Container(),
                                  // icon: Container(),
                                  dropdownColor: Colors.white,
                                  hint: const AppTextWidget(text: "Pick a time", fontSize: 13, fontWeight: FontWeight.w500),
                                  items: deliveryTimes.map((option) {
                                    return DropdownMenuItem(
                                      value: option,
                                      child: AppTextWidget(
                                        text: option, 
                                        fontSize: 12, 
                                        fontWeight: FontWeight.w500
                                      )
                                    );
                                  },).toList(), 
                                  onChanged: (value) {
                                    setState(() {
                                      expectedDeliveryTime = value;
                                      isDeliveryTimeSelected = false;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    ),
                    const SizedBox(height: 20,),
                    // Payment Option heading
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const AppTextWidget(
                          text: 'Payment option',
                          fontSize: 18, 
                          fontWeight: FontWeight.w600
                        ),
                        isPaymentoptionSelected 
                         ? const AppTextWidget(
                          text: "* required", 
                          fontSize: 13, fontWeight: FontWeight.w400, fontColor: Colors.red,)
                         : Container()
                      ],
                    ),
                    const SizedBox(height: 20,),
                    // Payment options
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: Container(
                        height: kToolbarHeight * paymentOptions.length,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Colors.grey.shade300,
                          )
                        ),
                        child: ListView.builder(
                          itemCount: paymentOptions.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return  RadioListTile(
                              contentPadding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: index == 0
                                ? const BorderRadius.only(
                                  topLeft: Radius.circular(10), topRight: Radius.circular(10)
                                )
                                : index == 2
                                  ? const BorderRadius.only(
                                    bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)
                                  )
                                  : BorderRadius.zero
                              ),
                              title: AppTextWidget(
                                text: paymentOptions[index], 
                                fontSize: 14, 
                                fontWeight: FontWeight.w500
                              ),
                              value: paymentOptions[index], 
                              groupValue: selectedPaymentOption, 
                              onChanged: (value) {
                                setState(() {
                                  selectedPaymentOption = value;
                                  isPaymentoptionSelected = false;
                                });
                                print("Selected poption: $selectedPaymentOption");
                              },
                              activeColor: selectedPaymentOption == paymentOptions[index]
                                ? Theme.of(context).primaryColor
                                : null,
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20,),
                    // Bil Details
                    const AppTextWidget(
                      text: 'Bill detail',
                      fontSize: 18, 
                      fontWeight: FontWeight.w600
                    ),
                    const SizedBox(height: 20,),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(5)
                      ),
                      child: Column(
                        children: [
                          // Total Products
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: Image.asset(
                                      "assets/icons/profile/features.png",
                                      filterQuality: FilterQuality.high,
                                    ),
                                  ),
                                  const SizedBox(width: 10,),
                                  const AppTextWidget(text: "Total item", fontSize: 14, fontWeight: FontWeight.w500),
                                ],
                              ),
                              AppTextWidget(
                                text: widget.fromCart ?? true
                                ? provider.totalQuickOrderProduct > 1 
                                  ? "${provider.totalQuickOrderProduct} items"
                                  : "${provider.totalQuickOrderProduct} item"
                                : cartProvider.totalCartProduct > 1
                                  ? "${cartProvider.totalCartProduct} items"
                                  : "${cartProvider.totalCartProduct} item", 
                                fontSize: 15, 
                                fontWeight: FontWeight.w400
                              )
                            ],
                          ),
                          const SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: Image.asset(
                                      filterQuality: FilterQuality.high,
                                      "assets/icons/profile/invoice.png"
                                    ),
                                  ),
                                  const SizedBox(width: 10,),
                                  const AppTextWidget(text: "Total bill", fontSize: 14, fontWeight: FontWeight.w500),
                                ],
                              ),
                              AppTextWidget(text: 
                                widget.fromCart ?? true
                                ? "₹${provider.totalQuickOrderAmount.toString()}"
                                : "₹${cartProvider.totalCartAmount}", 
                                fontSize: 15, 
                                fontWeight: FontWeight.w700
                              ),
                            ],
                          ),
                          provider.isCouponApplied
                          ? Column(
                            children: [
                              const SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: Image.asset(
                                          "assets/icons/checkout/discount.png",
                                          color: const Color.fromARGB(255, 255, 191, 0),
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                      const AppTextWidget(
                                        text: "Discount amount", 
                                        fontColor: Color.fromARGB(255, 255, 191, 0),
                                        fontSize: 14, fontWeight: FontWeight.w500),
                                    ],
                                  ),
                                  AppTextWidget(
                                    text: "- ₹${double.parse(provider.discountAmount).toStringAsFixed(1)}", 
                                    fontColor: const Color.fromARGB(255, 255, 191, 0),
                                    fontSize: 15, fontWeight: FontWeight.w400),
                                ],
                              ),
                              const SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Row(
                                    children: [
                                      Icon(CupertinoIcons.creditcard, size: 20,),
                                      SizedBox(width: 10,),
                                      AppTextWidget(text: "To pay", fontSize: 14, fontWeight: FontWeight.w500),
                                    ],
                                  ),
                                  AppTextWidget(text: "₹${provider.newTotal}", fontSize: 15, fontWeight: FontWeight.w700),
                                ],
                              ),

                            ],
                          )
                          : Container(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20,),
                    // Address Detail
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const AppTextWidget(text: 'Address Detail', fontSize: 17, fontWeight: FontWeight.w500),
                        GestureDetector(
                          onTap: () {
                          Navigator.push(context, downToTop(screen: const AddressSelectionScreen()));
                        },
                        child: AppTextWidget(text: "Change Address", fontSize: 13, fontWeight: FontWeight.w500, fontColor: Theme.of(context).primaryColor,)
                        )
                      ],
                    ), 
                    const SizedBox(height: 20,),
                    // Selected Addredd
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey.shade300)
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: size.width * 0.7,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: Image.asset(
                                              "assets/icons/profile/location.png"
                                            ),
                                          ),
                                          const SizedBox(width: 5,),
                                          AppTextWidget(
                                            text: addressProvider.currentAddress!.location, 
                                            fontSize: 15, 
                                            fontWeight: FontWeight.w500
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ), 
                              ],
                            ),
                            const SizedBox(height: 5,),
                            AppTextWidget(
                              text: '${addressProvider.currentAddress!.flatNo}, ' 
                              '${addressProvider.currentAddress!.floorNo}, ' 
                              '${addressProvider.currentAddress!.address}, '
                              '${addressProvider.currentAddress!.landmark}, '
                              '${addressProvider.currentAddress!.location}, ' 
                              '${addressProvider.currentAddress!.region}, ',
                              fontSize: 14, 
                              maxLines: 5,
                              fontWeight: FontWeight.w400
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.11,),
                  ],
                ),
              ),
            );
          }
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: Consumer4<AddressProvider, ApiProvider, ProfileProvider, CartProvider>(
              builder: (context, addressProvider, provider,  profileProvider, cartProvider, child) {
                return isLoading
                ? FloatingActionButton(
                    onPressed: () {
                      
                    },
                    backgroundColor: Theme.of(context).primaryColor,
                    splashColor: Colors.white24,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColorLight,
                      ),
                    ),
                  )
                : FloatingActionButton(
                  // elevation: 1,
                  onPressed: () async {
                    if (expectedDeliverydate ==  null || expectedDeliveryTime == null || selectedPaymentOption == null) {
                      if (expectedDeliverydate == null) {
                        setState(() {
                          isdeliveryDateSelected = true;
                        });
                      }
                      if(expectedDeliveryTime == null){
                        setState(() {
                          isDeliveryTimeSelected = true;
                        });
                      }
                      if(selectedPaymentOption == null){
                        setState(() {
                          isPaymentoptionSelected = true;
                        });
                      }
                    }else{
                      setState(() {
                        isLoading = true;
                      });
                      try {
                        Map<String, dynamic> checkOutData = {
                          'customer_id': prefs.getString('customerId'),
                          'address_id': addressProvider.currentAddress!.id,
                          'delivery_date': DateFormat('yyyy-MM-dd').format(expectedDeliverydate!),
                          'delivery_time': expectedDeliveryTime ?? '06:00 AM - 12.00 PM',
                          'payment_method': selectedPaymentOption ?? 'Cash on delivery'
                        };
                        print(widget.fromCart);
                        /// Quick order Checkout if user add products from quick order this API gives response
                        if (widget.fromCart ?? true) {
                          await provider.quickOrderCheckOut(context, size, checkOutData).then((value) async {
                            provider.clearCoupon();
                            await profileProvider.orderList();
                            /// Once order placed it will remove coupon from checkout session
                            print("Order Placed from Quick order");
                          });
                        }else{
                        /// Cart Checkout if the user added product from cart this API gives response
                          await cartProvider.cartCheckOut(context, size, checkOutData).then((value) async {
                              provider.clearCoupon();
                              await profileProvider.orderList();
                              // await NotificationProvider().showNotification(
                              //   title: "Order placed successfully", 
                              //   body: "See order detail here", 
                              //   payload: "Open", 
                              //   id: profileProvider.orderInfoData.last.orderId
                              // );
                            },);
                          
                        }
                      } catch (e) {
                        print('Error Happened: $e');
                      } finally {
                        setState(() {
                          isLoading = false;
                        });
                      }
                    }
                  },
                  backgroundColor: Theme.of(context).primaryColor,
                  splashColor: Colors.white24,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: const AppTextWidget(
                    text: "Checkout", 
                    fontSize: 15, 
                    fontColor: Colors.white,
                    fontWeight: FontWeight.w500
                  )
                );
              }
            ),
          ),
        ),
      );
    }
  }
}