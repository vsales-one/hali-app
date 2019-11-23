import 'package:json_annotation/json_annotation.dart';

part 'user_info.g.dart';

@JsonSerializable()
class UserInfo {
  String displayName;
  String profilePicture;
  String id;
  String email;
  bool isActive;

  UserInfo(this.displayName, this.profilePicture, this.id, this.email,
      this.isActive);

  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      _$UserInfoFromJson(json);

  factory UserInfo.fromNamed(
          {String displayName,
          String profilePicture,
          String id,
          String email,
          bool isActive}) =>
      UserInfo(displayName, profilePicture, id, email, isActive);

  Map<String, dynamic> toJson() => _$UserInfoToJson(this);

  String get firstName => displayName.split(" ")[0];
}
