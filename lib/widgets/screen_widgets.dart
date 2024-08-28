import 'package:flutter/material.dart';


Widget headBar() {
  return Center(
    child: Container(
      width: 70,
      margin: const EdgeInsets.only(
        left: 60,
        right: 60,
      ),
      child: const Divider(
        thickness: 2,
        color: Colors.black54,
      ),
    ),
  );
}


Widget subscriptionButton() {
  return Container(
    height: 50,
    width: 240,
    decoration: BoxDecoration(
        // border: Border.all(color: Colors.green.shade300),
        color: const Color(0xFF60B47B),
        borderRadius: BorderRadius.circular(10)),
    child: const Center(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart),
          SizedBox(
            width: 10,
          ),
          Text(
            'Subscribe',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
          )
        ],
      ),
    ),
  );
}

Widget tabTitle(String title) {
  return Container(
      width: 160,
      margin: const EdgeInsets.only(left: 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
      ));
}


void showSnackBar(BuildContext context, String message, double height,
    double left, double right) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Center(
      child: Text(
        message,
        style: const TextStyle(
            fontSize: 13, color: Colors.white, fontWeight: FontWeight.w600),
      ),
    ),
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.only(
        bottom: height * 0.85, left: left * 0.1, right: right * 0.1),
    duration: const Duration(seconds: 1),
    backgroundColor: const Color(0xFF60B47B),
  ));
}
