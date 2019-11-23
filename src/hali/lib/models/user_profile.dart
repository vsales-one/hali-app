import 'package:json_annotation/json_annotation.dart';

part 'user_profile.g.dart';

@JsonSerializable()
class UserProfile {
  String displayName;
  String profilePicture;
  String id;
  String email;
  bool isActive;

  UserProfile(this.displayName, this.profilePicture, this.id, this.email,
      this.isActive);

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  factory UserProfile.fromNamed(
          {String displayName,
          String profilePicture,
          String id,
          String email,
          bool isActive}) =>
      UserProfile(displayName, profilePicture, id, email, isActive);

  Map<String, dynamic> toJson() => _$UserProfileToJson(this);

  String get firstName => displayName.split(" ")[0];

  @override
  String toString() {
    return "($id-$email-$displayName)";
  }
}
