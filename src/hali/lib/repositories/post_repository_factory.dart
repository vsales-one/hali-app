import 'package:hali/constants/constants.dart';
import 'package:hali/repositories/firebase_post_repository.dart';
import 'package:hali/repositories/post_repository.dart';

class PostRepositoryFactory {
  static AbstractPostRepository instance() {
    if ("firestore" == kDbProvider) {
      return FirebasePostRepository();
    }
    return PostRepository();
  }
}