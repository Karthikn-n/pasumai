// import 'package:firebase_auth/firebase_auth.dart';

// class FirebaseAuthHelper{

//   String verify = "";
//   static FirebaseAuth auth = FirebaseAuth.instance;
//   // Signin using mobile number
//   static var receivedID = "";

//   static void verifyUserPhoneNumber(String userNumber) {
//     auth.verifyPhoneNumber(
//       phoneNumber: userNumber,
//       verificationCompleted: (PhoneAuthCredential credential) async {
//         await auth.signInWithCredential(credential).then(
//           (value) => print('Logged In Successfully'),
//         );
//       },
//       verificationFailed: (FirebaseAuthException e) {
//         print(e.message);
//       },
//       codeSent: (String verificationId, int? resendToken) {
//         receivedID = verificationId;
//         verifyOTPCode("234677");
//       },
//       codeAutoRetrievalTimeout: (String verificationId) {},
//     );
//   }

//   static Future<void> verifyOTPCode(String otp) async {
//     PhoneAuthCredential credential = PhoneAuthProvider.credential(
//       verificationId: receivedID,
//       smsCode: "234677",
//     );
//     await auth
//         .signInWithCredential(credential)
//         .then((value) => print('User Login In Successful'));
//   }

// }