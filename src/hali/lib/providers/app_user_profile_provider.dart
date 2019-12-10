import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hali/constants/constants.dart';
import 'package:hali/di/appModule.dart';
import 'package:hali/models/user_profile.dart';
import 'package:hali/providers/rest_client.dart';

class AppUserProfileProvider {
  Future<UserProfile> getAppUserProfileByUserId(String userId) async {
    final params = {"userId.equals": userId};
    return _getAppUserProfileByParams(params);
  }

  Future<UserProfile> getAppUserProfileByEmail(String email) async {
    final params = {"email.equals": email};
    return _getAppUserProfileByParams(params);
  }

  Future<UserProfile> _getAppUserProfileByParams(Map<String, dynamic> params) async {
    final client = RestClient.create();
    try {
      final response =
          await client.get("/api/user-profiles", queryParameters: params);
      final data = (response.data as List<dynamic>)
          .map((json) => UserProfile.fromJson(json))
          .toList();
      final profile = data != null && data.isNotEmpty ? data[0] : null;
      if(profile != null && (profile.imageUrl == null || profile.imageUrl.isEmpty)) {
        profile.imageUrl = kDefaultUserPhotoUrl;
      }
      return profile;
    } on DioError {
      return null;
    }
  }

  Future<UserProfile> linkFirebaseUserWithAppUser(FirebaseUser fbUser) async {
    final appUser = await getAppUserProfileByUserId(fbUser.email);
    return appUser == null ? await createAppUser(fbUser) : appUser;
  }

  Future<UserProfile> createAppUser(FirebaseUser fbUser) async {
    final appUser = UserProfile.fromNamed(
        userId: fbUser.email,
        displayName: fbUser.displayName,
        phoneNumber: fbUser.phoneNumber,
        email: fbUser.email,
        imageUrl: fbUser.photoUrl);
    try {
      final response = await dio.post("/api/user-profiles",
          data: appUser.toJson());
      return UserProfile.fromJson(response.data);
    } on DioError catch(e) {
      print(e);
      return null;
    }
  }

  Future<UserProfile> updateUserProfile(UserProfile userProfile) async {
    try {
      final response = await dio.put("/api/user-profiles/",
          data: userProfile.toJson());
      return UserProfile.fromJson(response.data);
    } on DioError catch(e) {
      print(e);
      return null;
    }
  }

  Future<UserProfile> updateUserProfileByUserId(UserProfile userProfile) async {
    try {
      print(">>>>>>>>>user id ${userProfile.userId}");
      final response = await dio.post("/api/user-profiles/" + userProfile.email +"/update-by-user-id",
          data: userProfile.toJson());
      return UserProfile.fromJson(response.data);
    } on DioError catch(e) {
      print(e);
      return null;
    }    
  }
}
