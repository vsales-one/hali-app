import 'package:bloc/bloc.dart';
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
    if(event is UserProfileLoading) {
      yield* _mapUserProfileLoadingToState();
    } else if(event is UserProfileUpdating) {
      yield* _mapUserProfileUpdatingToState(event.userProfile);
    }
  }

  Stream<UserProfileState> _mapUserProfileLoadingToState() async* {
    try {
      yield UserProfileLoadingState();
      final userProfile = await userRepository.getCurrentUserProfileFull();
      yield UserProfileLoadedState(userProfile);
    } catch(e) {
      print(e);
      yield UserProfileNotLoadedState();
    }    
  }

  Stream<UserProfileState> _mapUserProfileUpdatingToState(UserProfile userProfile) async* {
    try {
      print(">>>>>>> updating user profile ");
      print(userProfile.toJson());
      yield UserProfileLoadingState();
      final updatedUserProfile = await userRepository.updateUserProfileByUserId(userProfile);
      print(">>>>>>>>>>>>>>>BEFORE SET TO UDPATED STATE");
      yield UserProfileUpdatedState(updatedUserProfile);
    } catch(_) {
      yield UserProfileNotLoadedState();
    }
  }
  
}