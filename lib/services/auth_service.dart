// import 'package:cafe_app/screens/home.dart';
// import 'package:cafe_app/screens/login.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class AuthService{

//   handleAuthState(){
//     return StreamBuilder(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: ((context, snapshot) 
//       {
//                 if (snapshot.hasData) {
//                   return Home();
//                 }
//                 else{
//                   return Login();
//                 }
//       })
//     );
//   }

//   signInWithGoogle() async{

//     final GoogleSignInAccount? googleUser = await GoogleSignIn(
//         scopes: <String>["email"]).signIn();

//     final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

//     final credential = GoogleAuthProvider.credential(
//       accessToken: googleAuth.accessToken,
//       idToken: googleAuth.idToken,
//     );

//     return await FirebaseAuth.instance.signInWithCredential(credential);
//   }
// }