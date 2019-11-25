import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:hali/models/user_profile.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FacebookLogin _facebookLogin;
  final Firestore _fireStore;  
  static UserProfile currentUser;

  UserRepository({FirebaseAuth firebaseAuth, GoogleSignIn googleSignin, FacebookLogin facebookLogin, Firestore fireStore})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignin ?? GoogleSignIn(),
        _facebookLogin = facebookLogin ?? FacebookLogin(),
        _fireStore = fireStore ?? Firestore.instance;
  
  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await _firebaseAuth.signInWithCredential(credential);    
    return _firebaseAuth.currentUser();
  }

  Future<FirebaseUser> signInWithFacebook() async {
    final fbLoginResult = await _facebookLogin.logIn(['email']);
    switch (fbLoginResult.status) {
    case FacebookLoginStatus.loggedIn:        
      final token = fbLoginResult.accessToken.token;
      final AuthCredential credential = FacebookAuthProvider.getCredential(accessToken: token);
      await _firebaseAuth.signInWithCredential(credential);
      return _firebaseAuth.currentUser();   
      break;
    case FacebookLoginStatus.cancelledByUser:
    case FacebookLoginStatus.error:
      return null;
      break;
    }
    return null;
  }

  Future<void> signInWithCredentials(String email, String password) async {
    AuthResult authResult = await  _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );


    var user = await FirebaseAuth.instance.currentUser();

    IdTokenResult idTokenResult
    = await user.getIdToken();
    return idTokenResult;
  }

  Future<void> signUp({String email, String password}) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    return Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }

  Future<UserProfile> getUserProfile() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();    
    if (user == null) {
      return null;
    }
    return UserProfile(user.displayName, user.photoUrl, user.email ?? user.uid,
        user.email, true);
  }

  Future<List<UserProfile>> getActiveUsers() async {
    print("Active Users");
    var val = await _fireStore
        .collection("users")
        .where("isActive", isEqualTo: true)
        .getDocuments();
    var documents = val.documents;
    print("Documents ${documents.length}");
    if (documents.length > 0) {
      try {
        print("Active ${documents.length}");
        return documents.map((document) {
          UserProfile user =
              UserProfile.fromJson(Map<String, dynamic>.from(document.data));
          print("User ${user.displayName}");
          return user;
        }).toList();
      } catch (e) {
        print("Exception $e");
        return [];
      }
    }
    return [];
  }
}
