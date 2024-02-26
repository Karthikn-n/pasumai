import 'package:app_3/data/address_repo.dart';
import 'package:app_3/widgets/screen_widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentPage extends StatefulWidget {
  final DeliveryAddress address;
  const PaymentPage({super.key, required this.address});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  DateTime? selectedDate;
  bool selectDate = false;
  late String selectedMethod;
  List<String> deliveryTimes = [
    '06:00 AM - 12:00 PM',
    '12:00 PM - 06:00 PM',
    '06:00 PM - 09:00 PM'
  ];
  List<String> deliveryMethods = [
    'Cash on delivery',
    'Pay using UPI',
    'Pay using credit/debit card'
  ];
  String? selectedDeliveryTime;
  int totalAmount = 0;
  int totalProduct =0;
   Future<void> _getTotalAmount() async {
    final prefs = await SharedPreferences.getInstance();
    final storedTotalAmount = prefs.getInt('totalQuickOrder');
    final products = prefs.getInt('totalProducts');
    if (storedTotalAmount != null && products != null ) {
      setState(() {
        totalAmount = storedTotalAmount;
        totalProduct = products;
      });
    }
  }
  @override
  void initState() {
    super.initState();
    DateTime currentDate = DateTime.now();
    selectedDate = currentDate.add(const Duration(days: 1));
    selectedMethod = deliveryMethods.first;
    _getTotalAmount();
  }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate!,
      firstDate:DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime(2101), // Adjust as needed
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }
  
  String _getDaySuffix(int day) {
  if (day >= 11 && day <= 13) {
    return 'th';
  }
  switch (day % 10) {
    case 1:
      return 'st';
    case 2:
      return 'nd';
    case 3:
      return 'rd';
    default:
      return 'th';
  }
}
  @override
  Widget build(BuildContext context) {
    // DateTime date = DateTime(2024, 01, 01);
    // String formatedDate = DateFormat('d MMM y').format(date);
    String formattedDate = DateFormat('E, MMM, dd').format(selectedDate!);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    String daySuffix = _getDaySuffix(selectedDate!.day);
    return Scaffold(
      appBar: homeAppBar('Payment'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: screenWidth > 600 ? screenHeight * 1.0 : screenHeight * 0.65,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: screenWidth > 600 ? 10 :30, left: 20, right: 10),
                      child: const Text(
                        'Schedule Delivery',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: screenWidth > 600 ? 5 : 10, left: 20, right: 10),
                      child: SizedBox(
                        width: screenWidth > 600 ? screenHeight * 2 : screenHeight * 0.6,
                        child: const Divider(
                          color: Colors.black38,
                          thickness: 1,
                        ),
                      ),
                    ),
                    Container(
                      margin:const EdgeInsets.only(left: 10, right: 10),
                      height: screenWidth > 600 ? screenHeight * 0.5 : screenHeight * 0.2,
                      child: Container(
                        alignment: Alignment.center,
                        margin:const EdgeInsets.only(left: 10, right: 10, top: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                    'Expected delivery date',
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectDate = true;
                                      });
                                      if(selectDate){
                                        _selectDate(context);
                                      }
                                    },
                                    child: Text(
                                      selectDate ? '$formattedDate$daySuffix' : 'Select Date',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF60B47B)
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 40,),
                            Row(
                              children: [
                                const Text(
                                    'Expected delivery time',
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                  const Spacer(),
                                    SizedBox(
                                    child: DropdownButton<String>(
                                    value: selectedDeliveryTime,
                                    iconEnabledColor: Colors.black54,
                                    focusColor: const Color(0xFF60B47B),
                                    dropdownColor: Colors.grey.shade200,
                                    style: const TextStyle(color: Color(0xFF60B47B), fontSize: 12),
                                    underline: Container(),
                                    hint: const Text('Select Town'),
                                    alignment: Alignment.center,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedDeliveryTime = newValue!;
                                      });
                                    },
                                    items: deliveryTimes.map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    ),
                                  ),
                                ],
                              )
                            
                            ],
                          ),
                        ),
                      ),
                    Padding(
                      padding: EdgeInsets.only(top: screenWidth > 600 ? 10 :30, left: 20, right: 10),
                      child: const Text(
                        'Payment Option',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: screenWidth > 600 ? 5 : 10, left: 20, right: 10),
                      child: SizedBox(
                        width: screenWidth > 600 ? screenHeight * 2 : screenHeight * 0.6,
                        child: const Divider(
                          color: Colors.black38,
                          thickness: 1,
                        ),
                      ),
                    ),
                    Container(
                      margin:const EdgeInsets.only(left: 10, right: 10),
                      height: screenWidth > 600 ? screenHeight * 0.5 : screenHeight * 0.2,
                      child: Column(
                        children: [
                          paymentOptions(deliveryMethods[0], 0),
                          paymentOptions(deliveryMethods[1], 1),
                          paymentOptions(deliveryMethods[2], 2),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: screenWidth > 600 ? 10 :30, left: 20, right: 10),
                      child: const Text(
                        'Delivered address',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: screenWidth > 600 ? 5 : 10, left: 20, right: 10),
                      child: SizedBox(
                        width: screenWidth > 600 ? screenHeight * 2 : screenHeight * 0.6,
                        child: const Divider(
                          color: Colors.black38,
                          thickness: 1,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10, right: 10), 
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '* Order will be delivered to this address',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF60B47B)
                            ),
                          ),
                          Row(
                            children: [
                              Radio(
                                value: null, 
                                groupValue: null, 
                                activeColor: const Color(0xFF60B47B),
                                onChanged: (value) {},
                              ),
                              Center(
                                child: Text(
                                  '${widget.address.firstName} ${widget.address.lastName}\n'
                                  '${widget.address.flatNo}, ${widget.address.streetName}, ${widget.address.city},\n'
                                  '${widget.address.state}, ${widget.address.pincode},\n'
                                  '${widget.address.email}, ${widget.address.mobile}',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        'Order summary',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      const Spacer(),
                      Text(
                        totalProduct > 1 ?'($totalProduct items)' : '($totalProduct item)',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 8,),
                  Row(
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      const Spacer(),
                      Text('₹$totalAmount',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600
                        ),
                      )
                    ],
                  ),
                   Row(
                    children: [
                      const Text(
                        'Includes GST*',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '₹${totalAmount + 20}',
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          fontSize: 12,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      const SizedBox(width: 4,),
                      const Text(
                        'Save ₹20',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                    ],
                  ),
                  // const SizedBox(height: 20,),
                  Center(
                    child: Row(
                      crossAxisAlignment: screenWidth > 600 ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            height: screenWidth > 600 ? screenHeight * 0.08 : screenHeight * 0.05,
                            width: screenWidth > 600 ? screenHeight * 0.3 : screenHeight * 0.2 ,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.black54)
                            ),
                            margin: const EdgeInsets.only(top: 30, bottom: 10),
                            child: const Center(
                              child: Text(
                                'Back',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          // onTap: () => Navigator.of(context).push(_paymentPage()),
                          child: Container(
                            height: screenWidth > 600 ? screenHeight * 0.08 : screenHeight * 0.05,
                            width: screenWidth > 600 ? screenHeight * 0.3 : screenHeight * 0.2 ,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: const Color(0xFF60B47B)
                            ),
                            margin: const EdgeInsets.only(top: 30, left: 10, bottom: 10),
                            child: const Center(
                              child: Text(
                                'Next',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                
                ],
              ),
            ),
            
          ],
        ),
      ),
    );
  }

  Widget paymentOptions(String name, int index){
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMethod = deliveryMethods[index];
        });
      },
      child: Row(
        children: [
          Radio(
            value: deliveryMethods[index], 
            groupValue: selectedMethod, 
            activeColor: const Color(0xFF60B47B),
            onChanged: (value) {
              setState(() {
                selectedMethod = value!;
              });
            },
          ),
          Text(
            name,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600
            ),
          )
        ],
      ),
    );
  }
}

