import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:hali/commons/app_error.dart';
import 'package:hali/constants/constants.dart';
import 'package:hali/di/appModule.dart';
import 'package:hali/models/user_profile.dart';
import 'package:hali/providers/app_user_profile_provider.dart';

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
    final signinMethods = await _firebaseAuth.fetchSignInMethodsForEmail(email: googleUser.email);

    if(signinMethods.isNotEmpty && signinMethods.indexOf("google.com") < 0) {
        throw AppError(
          statusCode: 200, 
          message: "Email đã tồn tại với phương thức đăng nhập ${signinMethods.join(",")}"
        );
      }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await _firebaseAuth.signInWithCredential(credential);    
    final user = await _firebaseAuth.currentUser();
    await storeFirebaseAuthToken(user);    
    await linkFirebaseUserWithAppUser(user);
    return user;
  }

  Future<dynamic> _getUserEmailFromFacebookToken(String token) async { 
    final dioClient = Dio();
    final graphResponse = await dioClient.get("https://graph.facebook.com/v2.12/me?fields=email&access_token=$token");
    if(graphResponse.statusCode != 200) {
      return null;
    }    
    return jsonDecode(graphResponse.data);
  }

  Future<FirebaseUser> signInWithFacebook() async {
    final fbLoginResult = await _facebookLogin.logIn(['email']);
    switch (fbLoginResult.status) {
    case FacebookLoginStatus.loggedIn:
      final token = fbLoginResult.accessToken.token;
      final fbProfile = await _getUserEmailFromFacebookToken(token);
      if(fbProfile == null)
        return null;
      final signinMethods = await _firebaseAuth.fetchSignInMethodsForEmail(email: fbProfile["email"]);

      if(signinMethods.isNotEmpty && signinMethods.indexOf("facebook.com") < 0) {        
        throw AppError(
          statusCode: 200, 
          message: "Email đã tồn tại với phương thức đăng nhập ${signinMethods.join(",")}"
        );
      }

      final AuthCredential credential = FacebookAuthProvider.getCredential(accessToken: token);
      await _firebaseAuth.signInWithCredential(credential);
      final user = await _firebaseAuth.currentUser();
      await storeFirebaseAuthToken(user);
      await linkFirebaseUserWithAppUser(user);
      return user;
      break;
    case FacebookLoginStatus.cancelledByUser:
    case FacebookLoginStatus.error:
      return null;
      break;
    }
    return null;
  }

  Future<FirebaseUser> signInWithCredentials(String email, String password) async {
    await  _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final signinMethods = await _firebaseAuth.fetchSignInMethodsForEmail(email: email);
    if(signinMethods.isNotEmpty && signinMethods.indexOf("password") < 0) {
        throw AppError(
          statusCode: 200, 
          message: "Email đã tồn tại với phương thức đăng nhập ${signinMethods.join(",")}"
        );
      }
    final user = await FirebaseAuth.instance.currentUser();    
    await storeFirebaseAuthToken(user);
    await linkFirebaseUserWithAppUser(user);
    return user;
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
      _facebookLogin.logOut()
    ]);
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }

  Future<void> storeFirebaseAuthToken(FirebaseUser user) async {
    final idTokenResult = await user.getIdToken();
    print('>>>>>>> Storing the user auth token: ${idTokenResult.token}');
    spUtil.putString(kFirebaseAuthToken, idTokenResult.token);
  }

  Future<void> linkFirebaseUserWithAppUser(FirebaseUser user) async {
    print('>>>>>>> Link firebase user with app user: ${user.uid}');
    final appUserProvider = AppUserProfileProvider();
    await appUserProvider.linkFirebaseUserWithAppUser(user);
  }

  Future<UserProfile> getUserProfile() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();    
    if (user == null) {
      return null;
    }
    return UserProfile(user.uid, user.displayName, user.phoneNumber, user.email, user.photoUrl, 
      "", "", "", true);
  }

  Future<UserProfile> getUserProfileFull() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();    
    if (user == null) {
      return null;
    }
    final appUserProfileProvider = AppUserProfileProvider();
    final appUserProfile = await appUserProfileProvider.getAppUserProfileByUserId(user.uid);    
    return UserProfile(user.uid, user.displayName, user.phoneNumber, user.email, user.photoUrl, 
      appUserProfile?.address, appUserProfile?.district, appUserProfile?.city, true);
  }

  Future<UserProfile> updateUserProfile(UserProfile userProfile) async {
    final appUserProfileProvider = AppUserProfileProvider();
    await appUserProfileProvider.updateUserProfile(userProfile);
    return await getUserProfileFull();
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
