import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hali/di/appModule.dart';
import 'package:hali/models/user_profile.dart';
import 'package:hali/repositories/user_repository.dart';
import 'package:hali/user_profile/bloc/user_profile_event.dart';
import 'package:hali/user_profile/bloc/user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final UserRepository userRepository;

  UserProfileBloc({this.userRepository});

  @override
  UserProfileState get initialState => UserProfileLoadingState();

  @override
  Stream<UserProfileState> mapEventToState(UserProfileEvent event) async* {
    if (event is UserProfileLoading) {
      yield* _mapUserProfileLoadingToState();
    } else if (event is UserProfileUpdating) {
      yield* _mapUserProfileUpdatingToState(event.userProfile);
    } else if (event is UpdateUserAvatarImageUrlEvent) {
      yield* _mapUpdateUserAvatarImageUrlToState(
          event.userProfile, event.newUserImage);
    }
  }

  Stream<UserProfileState> _mapUserProfileLoadingToState() async* {
    try {
      yield UserProfileLoadingState();
      final userProfile = await userRepository.getCurrentUserProfileFull();
      yield UserProfileLoadedState(userProfile);
    } catch (e) {
      print(e);
      yield UserProfileNotLoadedState();
    }
  }

  Stream<UserProfileState> _mapUserProfileUpdatingToState(
      UserProfile userProfile) async* {
    try {
      print(">>>>>>> updating user profile ");
      print(userProfile.toJson());
      yield UserProfileLoadingState();
      final updatedUserProfile =
          await userRepository.updateUserProfileByUserId(userProfile);
      print(">>>>>>>>>>>>>>>BEFORE SET TO UDPATED STATE");
      yield UserProfileUpdatedState(updatedUserProfile);
    } catch (_) {
      yield UserProfileNotLoadedState();
    }
  }

  Stream<UserProfileState> _mapUpdateUserAvatarImageUrlToState(
      UserProfile userProfile, File newUserImage) async* {
    assert(newUserImage != null);
    assert(userProfile != null);

    yield UserProfileLoadingState();

    try {
      final fileName = "user_avatar_${userProfile.firstName}.jpg";
      final StorageReference ref =
          storage.ref().child("user_avatars").child(fileName);
      // upload task
      final StorageUploadTask uploadTask = ref.putFile(
        newUserImage,
        StorageMetadata(
          contentLanguage: "en",
          contentType: "image/jpg",
          customMetadata: <String, String>{
            "fileName": fileName,
          },
        ),
      );

      final snap = await uploadTask.onComplete;
      final uploadedUrl = await snap.ref.getDownloadURL();
      logger.d(">>>>>>> upload complete: $uploadedUrl");

      userProfile.imageUrl = uploadedUrl;
      final updatedUserProfile =
          await userRepository.updateUserProfileByUserId(userProfile);
      yield UserProfileLoadedState(updatedUserProfile);
    } catch (e) {
      logger.e(e);
      yield UserProfileNotUpdatedState();
    }    
  }
}
