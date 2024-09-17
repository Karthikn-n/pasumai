// import 'package:app_3/widgets/common_widgets.dart/app_bar.dart';
// import 'package:app_3/widgets/common_widgets.dart/button_widget.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:otp_autofill/otp_autofill.dart';
// import 'package:sms_autofill/sms_autofill.dart';

// class NewOtpScreen extends StatefulWidget {
//   final String verfiyId;
//   const NewOtpScreen({super.key, required this.verfiyId});

//   @override
//   State<NewOtpScreen> createState() => _NewOtpScreenState();
// }

// class _NewOtpScreenState extends State<NewOtpScreen> {
//   late OTPTextEditController otpController;
//   String _smsCode = '';
//   String otpCode = "";
//   String otp = "";
//   final FirebaseAuth auth = FirebaseAuth.instance;

//   @override
//   void initState() {
//     super.initState();
//     otpController = OTPTextEditController(
//       codeLength: 6,
//       onCodeReceive: (code) {
//         setState(() {
//           _smsCode = code;
//         });
//       },
//     )..startListenUserConsent((code) {
//         return code ?? "";
//       });
//   }
// void signInWithOTP() async {
//     PhoneAuthCredential credential = PhoneAuthProvider.credential(
//       verificationId: widget.verfiyId,
//       smsCode: _smsCode,
//     );

//     // Sign the user in (or link) with the credential
//     await FirebaseAuth.instance.signInWithCredential(credential);
//     print("User signed in");
//   }
//   @override
//   void dispose() {
//     super.dispose();
//     SmsAutoFill().unregisterListener();
//     print("Unregistered successfully");
//   }

//   void listenCode() async {
//     await SmsAutoFill().listenForCode();
//     print("OTP listen is called");
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const AppBarWidget(title: "OTP"),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 8),
//           child: Column(
//             children: [
//               PinFieldAutoFill(
//                 currentCode:  otpCode,
//                 onCodeChanged: (code) {
//                   print("OnCodeChanged : $code");
//                   otpCode = code.toString();
//                 },
//                 onCodeSubmitted: (val) {
//                   print("OnCodeSubmitted : $val");
//                 },
//                 decoration:  BoxLooseDecoration(
//                   radius: const Radius.circular(10),
//                   strokeColorBuilder: const FixedColorBuilder(
//                     Colors.black
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20,),
//               ButtonWidget(
//                 buttonName: "Verify", 
//                 onPressed: () async {
                 
              
//                 },
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }