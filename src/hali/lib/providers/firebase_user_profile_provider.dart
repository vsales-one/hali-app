import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hali/di/appModule.dart';
import 'package:hali/models/user_profile.dart';
import 'package:hali/providers/app_user_profile_provider.dart';

/// The implementation which store user profile data in firestore
/// This class override the default implementation of AppUserProfileProvider
class FirebaseUserProfileProvider implements IAppUserProfileProvider {
  final Firestore _fireStore;
  static const String USER_COLLECTIONS = "users";

  FirebaseUserProfileProvider({Firestore fireStore})
      : this._fireStore = fireStore ?? Firestore.instance;

  @override
  Future<UserProfile> createAppUser(FirebaseUser fbUser) async {
    final appUser = UserProfile.fromNamed(
        id: fbUser.email,
        userId: fbUser.email,
        displayName: fbUser.displayName,
        phoneNumber: fbUser.phoneNumber,
        email: fbUser.email,
        imageUrl: fbUser.photoUrl,
        address: "",
        district: "",
        city: "",
        isActive: true,
        latitude: 0,
        longitude: 0);
    try {
      final docRef =
          await _fireStore.collection(USER_COLLECTIONS).add(appUser.toJson());
      assert(docRef != null);
      final doc = await docRef.snapshots().first;
      return UserProfile.fromJson(doc.data);
    } catch (e) {
      logger.d(e);
      return null;
    }
  }

  @override
  Future<UserProfile> getAppUserProfileByEmail(String email) async {
    final query = await _fireStore
        .collection(USER_COLLECTIONS)
        .where("userId", isEqualTo: email)
        .limit(1)
        .snapshots()
        .first;

    if(query.documents.isEmpty)
      return null;

    final doc = query.documents.first;
    return doc.exists ? UserProfile.fromJson(doc.data) : null;
  }

  @override
  Future<UserProfile> getAppUserProfileByUserId(String userId) async {
    return getAppUserProfileByEmail(userId);
  }

  @override
  Future<UserProfile> linkFirebaseUserWithAppUser(FirebaseUser fbUser) async {
    final appUser = await getAppUserProfileByUserId(fbUser.email);
    return appUser == null ? await createAppUser(fbUser) : appUser;
  }

  @override
  Future<UserProfile> updateUserProfile(UserProfile userProfile) async {
    assert(userProfile != null);
    assert(userProfile.userId != null && userProfile.userId.isNotEmpty);
    assert(userProfile.email != null && userProfile.email.isNotEmpty);

    final query = await _fireStore
        .collection(USER_COLLECTIONS)
        .where("userId", isEqualTo: userProfile.email)
        .limit(1)
        .snapshots()
        .first;

    assert(query.documents.isNotEmpty);
    final docRef = query.documents.first.reference;
    await docRef.updateData(userProfile.toJson());

    return await getAppUserProfileByEmail(userProfile.email);
  }

  @override
  Future<UserProfile> updateUserProfileByUserId(UserProfile userProfile) async {
    return updateUserProfile(userProfile);
  }
}
