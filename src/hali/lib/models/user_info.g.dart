// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) {
  return UserInfo(
    json['displayName'] as String,
    json['profilePicture'] as String,
    json['id'] as String,
    json['email'] as String,
    json['isActive'] as bool,
  );
}

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
      'displayName': instance.displayName,
      'profilePicture': instance.profilePicture,
      'id': instance.id,
      'email': instance.email,
      'isActive': instance.isActive,
    };
