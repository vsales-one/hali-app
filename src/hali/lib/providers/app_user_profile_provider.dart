import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hali/di/appModule.dart';
import 'package:hali/models/user_profile.dart';
import 'package:hali/providers/rest_client.dart';

class AppUserProfileProvider {
  Future<UserProfile> getAppUserProfileByUserId(String userId) async {
    final params = {"userId": userId};
    final client = RestClient.create();
    try {
      final response =
          await client.get("/api/user-profiles", queryParameters: params);
      final data = (response.data as List<dynamic>)
          .map((json) => UserProfile.fromJson(json))
          .toList();
      return data != null && data.isNotEmpty ? data[0] : null;
    } on DioError {
      return null;
    }
  }

  Future<UserProfile> linkFirebaseUserWithAppUser(FirebaseUser fbUser) async {
    final appUser = await getAppUserProfileByUserId(fbUser.uid);
    return appUser == null ? await createAppUser(fbUser) : appUser;
  }

  Future<UserProfile> createAppUser(FirebaseUser fbUser) async {
    final appUser = UserProfile.fromNamed(
        userId: fbUser.uid,
        displayName: fbUser.displayName,
        phoneNumber: fbUser.phoneNumber,
        email: fbUser.email,
        imageUrl: fbUser.photoUrl);
    try {
      final response = await dio.post<UserProfile>("/api/user-profiles",
          data: appUser.toJson());
      return response.data;
    } on DioError {
      return null;
    }
  }

  Future<UserProfile> updateUserProfile(UserProfile userProfile) async {
    try {
      final response = await dio.put<UserProfile>("/api/user-profiles",
          data: userProfile.toJson());
      return response.data;
    } on DioError {
      return null;
    }
  }
}
