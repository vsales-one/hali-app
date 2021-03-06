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
import 'package:hali/providers/user_profile_provider_factory.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FacebookLogin _facebookLogin;
  final Firestore _fireStore;
  final IAppUserProfileProvider _appUserProfileProvider;
  static UserProfile currentUser;

  UserRepository({
    FirebaseAuth firebaseAuth,
    GoogleSignIn googleSignin,
    FacebookLogin facebookLogin,
    Firestore fireStore,
    IAppUserProfileProvider appUserProfileProvider,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignin ?? GoogleSignIn(),
        _facebookLogin = facebookLogin ?? FacebookLogin(),
        _fireStore = fireStore ?? Firestore.instance,
        _appUserProfileProvider =
            appUserProfileProvider ?? UserProfileProviderFactory.instance();

  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final signinMethods =
        await _firebaseAuth.fetchSignInMethodsForEmail(email: googleUser.email);

    if (signinMethods.isNotEmpty && signinMethods.indexOf("google.com") < 0) {
      throw AppError(
        statusCode: 200,
        message:
            "${googleUser.email} đã tồn tại với phương thức đăng nhập ${signinMethods.join(",")}",
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
    final graphResponse = await dioClient.get(
        "https://graph.facebook.com/v2.12/me?fields=email&access_token=$token");
    if (graphResponse.statusCode != 200) {
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
        if (fbProfile == null) return null;
        final userEmail = fbProfile["email"];
        final signinMethods =
            await _firebaseAuth.fetchSignInMethodsForEmail(email: userEmail);

        if (signinMethods.isNotEmpty &&
            signinMethods.indexOf("facebook.com") < 0) {
          throw AppError(
            statusCode: 200,
            message:
                "$userEmail đã tồn tại với phương thức đăng nhập ${signinMethods.join(",")}",
          );
        }

        final AuthCredential credential =
            FacebookAuthProvider.getCredential(accessToken: token);
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

  Future<FirebaseUser> signInWithCredentials(
      String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final signinMethods =
        await _firebaseAuth.fetchSignInMethodsForEmail(email: email);
    if (signinMethods.isNotEmpty && signinMethods.indexOf("password") < 0) {
      throw AppError(
          statusCode: 200,
          message:
              "Email đã tồn tại với phương thức đăng nhập ${signinMethods.join(",")}");
    }
    final user = await FirebaseAuth.instance.currentUser();
    await storeFirebaseAuthToken(user);
    await linkFirebaseUserWithAppUser(user);
    return user;
  }

  Future<AuthResult> signUp(
      {String email, String password, String fullName}) async {
    final authRes = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = await _firebaseAuth.currentUser();
    assert(user != null);    
    final updateInfo = UserUpdateInfo();
    updateInfo.displayName = fullName;
    await user.updateProfile(updateInfo);
    await linkFirebaseUserWithAppUser(user);
    return authRes;
  }

  Future<void> signOut() async {
    return Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
      _facebookLogin.logOut()
    ]);
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
    return true;
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

  Future<void> storeFirebaseUserLogged(UserProfile userProfile) async {
    spUtil.saveObject(kFirebaseUser, userProfile);
  }

  Future<UserProfile> retrieveFirebaseUserLogged() async {
    return UserProfile.fromJson(await spUtil.readObject(kFirebaseUser));
  }

  Future<UserProfile> linkFirebaseUserWithAppUser(FirebaseUser user) async {
    print(
        '>>>>>>> Link firebase user with app user: ${user.uid}-${user.email}');
    final profile =
        await _appUserProfileProvider.linkFirebaseUserWithAppUser(user);
    return profile;
  }

  Future<UserProfile> getCurrentUserProfileFull() async {
    final user = await _firebaseAuth.currentUser();
    assert(user != null);

    final appUserProfile =
        await _appUserProfileProvider.getAppUserProfileByUserId(user.email);
    assert(appUserProfile != null);
    final userPhotoUrl =
        appUserProfile.imageUrl ?? user.photoUrl ?? kDefaultUserPhotoUrl;
    return UserProfile(
      user.email,
      appUserProfile.displayName,
      appUserProfile.phoneNumber,
      user.email,
      userPhotoUrl,
      appUserProfile?.address,
      appUserProfile?.district,
      appUserProfile?.city,
      appUserProfile.isActive,
      appUserProfile.latitude,
      appUserProfile.longitude,
    );
  }

  Future<UserProfile> updateUserProfile(UserProfile userProfile) async {
    await _appUserProfileProvider.updateUserProfile(userProfile);
    return await getCurrentUserProfileFull();
  }

  Future<UserProfile> updateUserProfileByUserId(UserProfile userProfile) async {
    await _appUserProfileProvider.updateUserProfileByUserId(userProfile);
    return await getCurrentUserProfileFull();
  }

  Future<UserProfile> getUserProfileByEmail(String email) async {
    return await _appUserProfileProvider.getAppUserProfileByUserId(email);
  }

  Future<List<UserProfile>> getActiveUsers() async {
    print("Active Users");
    var val = await _fireStore
        .collection("users")
        .where("isActive", isEqualTo: true)
        .getDocuments();
    var documents = val.documents;
    if (documents.length > 0) {
      try {
        return documents.map((document) {
          UserProfile user =
              UserProfile.fromJson(Map<String, dynamic>.from(document.data));
          return user;
        }).toList();
      } catch (e) {
        logger.e("Exception $e");
        return [];
      }
    }
    return [];
  }
}
