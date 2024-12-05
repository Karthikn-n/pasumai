import 'package:app_3/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseProvider {
  static final FirebaseAuth _firebaseAuthInstance = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// initialize the firebase in the [main.dart] file
  static Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
    );
  }
  
  // google login
  static Future<void> signinWithGoogle() async {
    if(await GoogleSignIn().isSignedIn()) await GoogleSignIn().signOut();
    final googleUser = await GoogleSignIn().signIn();
    // final GoogleAuthProvider authProvider = GoogleAuthProvider();
    // Obtain auth details from the request
    final googleAuth = await googleUser?.authentication;

    if (googleAuth != null) {
      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken
      );

      // Once signed in return the User Credential
      UserCredential user = await _firebaseAuthInstance.signInWithCredential(credential);
      Map<String, dynamic> userData = {
        "user_name": user.user!.displayName,
        "user_email": user.user!.email,
        "user_phone": user.user!.phoneNumber,
        "user_photo": user.user!.photoURL,
        "user_uuid": user.user!.uid
      };
      print("Google user: $userData");
      storeUsers(userDetail: userData, fromGoogle: true);
    }
  }
  
  static Future<void> signInWithMicrosoft() async {
    final microsoftProvider = MicrosoftAuthProvider();
    final  UserCredential? user;
    if (kIsWeb) {
      user = await FirebaseAuth.instance.signInWithPopup(microsoftProvider);
    } else {
      user = await FirebaseAuth.instance.signInWithProvider(microsoftProvider);
    }
     Map<String, dynamic> userData = {
      "user_name": user.user!.displayName,
      "user_email": user.user!.email,
      "user_phone": user.user!.phoneNumber,
      "user_photo": user.user!.photoURL,
      "user_uuid": user.user!.uid
    };
    print("Google user: $userData");
    storeUsers(userDetail: userData, fromGithub: true);
  }

  // Github login
  static Future<void> siginWithGithub() async {
    // Need SHA finger print to use github social login
     final GithubAuthProvider githubAuthProvider = GithubAuthProvider();

    // Sign in with the GitHub credential
     final  UserCredential? user;
    if (kIsWeb) {
      user = await FirebaseAuth.instance.signInWithPopup(githubAuthProvider);
    } else {
      user = await FirebaseAuth.instance.signInWithProvider(githubAuthProvider);
    }
    Map<String, dynamic> userData = {
      "user_name": user.user!.displayName,
      "user_email": user.user!.email,
      "user_phone": user.user!.phoneNumber,
      "user_photo": user.user!.photoURL,
      "user_uuid": user.user!.uid
    };
    print("Google user: $userData");
    storeUsers(userDetail: userData, fromGithub: true);
  }


  // Using facebook authentication
  Future<void> signInWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();
    final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(result.accessToken!.tokenString);

    UserCredential user = await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
     Map<String, dynamic> userData = {
      "user_name": user.user!.displayName,
      "user_email": user.user!.email,
      "user_phone": user.user!.phoneNumber,
      "user_photo": user.user!.photoURL,
      "user_uuid": user.user!.uid
    };
    print("Google user: $userData");
    storeUsers(userDetail: userData, fromGithub: true);
  }

  // Store the user to the firestore function from based on social login
  static Future<void> storeUsers({
    required Map<String, dynamic> userDetail, 
    bool? fromGoogle, 
    bool? fromGithub,
    bool? fromFacebook, 
    bool? fromMicrosoft}) async {
      String collectionName = fromGoogle != null 
            ? "google_user" 
            : fromGithub != null 
              ? "github_user" 
              : fromFacebook  != null
                ? "fb_user"
                : fromMicrosoft != null
                  ? "ms_user"
                  : "users";
      // Create a collection for every social logins
      final collection = _firestore.collection(collectionName);

      // Generate document ID using user email
      await collection.doc(userDetail["user_email"]).set(userDetail);

      
    }

  static Future<void> storeUserContancts(List<Map<String, Map<String,String>>> contacts, String user) async {
    // create a collection using user number 
    final DocumentReference doc =  _firestore.collection("contacts").doc(user);
    await doc.set(contacts);
  }
}