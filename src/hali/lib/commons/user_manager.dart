
import 'package:hali/commons/shared_preferences.dart';
import 'package:hali/constants/constants.dart';
import 'package:hali/di/appModule.dart';
import 'package:hali/models/user_profile.dart';
import 'package:rxdart/subjects.dart';

class UserManager {

  final BehaviorSubject<UserProfile> _userProfileStream = BehaviorSubject<UserProfile>();

  static UserManager _instance;

  BehaviorSubject<UserProfile> get userProfile => _userProfileStream;

  static Future<UserManager> get instance async {
    return await getInstance();
  }

  Future bind() async {
    final _userProfile = UserProfile.fromJson(await spUtil.readObject(kFirebaseUser));
    _userProfileStream.sink.add(_userProfile);
  }
  
  static Future<UserManager> getInstance() async  {
    if (_instance == null) {
      _instance = new UserManager();
    }
    return _instance;
  }

}