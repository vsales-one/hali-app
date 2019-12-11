import 'package:hali/constants/constants.dart';
import 'package:hali/providers/app_user_profile_provider.dart';
import 'package:hali/providers/firebase_user_profile_provider.dart';

class UserProfileProviderFactory {
  static IAppUserProfileProvider instance() {
    if ("firestore" == kDbProvider) {
      return FirebaseUserProfileProvider();
    }
    return AppUserProfileProvider();
  }
}
