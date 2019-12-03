import 'package:bloc/bloc.dart';
import 'package:hali/models/user_profile.dart';
import 'package:hali/repositories/user_repository.dart';
import 'package:hali/user_profile/bloc/user_profile_event.dart';
import 'package:hali/user_profile/bloc/user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final userProfileRepo = UserRepository();

  @override
  UserProfileState get initialState => UserProfileLoadingState();

  @override
  Stream<UserProfileState> mapEventToState(UserProfileEvent event) async* {    
    if(event is UserProfileLoading) {
      yield* _mapUserProfileLoadingToState();
    } else if(event is UserProfileUpdating) {
      yield* _mapUserProfileUpdatingToState(event.userProfile);
    }
  }

  Stream<UserProfileState> _mapUserProfileLoadingToState() async* {
    try {
      yield UserProfileLoadingState();
      final userProfile = await userProfileRepo.getUserProfileFull();
      yield UserProfileLoadedState(userProfile);
    } catch(_) {
      yield UserProfileNotLoadedState();
    }    
  }

  Stream<UserProfileState> _mapUserProfileUpdatingToState(UserProfile userProfile) async* {
    try {
      yield UserProfileLoadingState();
      final updatedUserProfile = await userProfileRepo.updateUserProfile(userProfile);
      yield UserProfileUpdatedState(updatedUserProfile);
    } catch(_) {
      yield UserProfileNotLoadedState();
    }
  }
  
}