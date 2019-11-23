// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) {
  return UserProfile(
    json['displayName'] as String,
    json['profilePicture'] as String,
    json['id'] as String,
    json['email'] as String,
    json['isActive'] as bool,
  );
}

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'displayName': instance.displayName,
      'profilePicture': instance.profilePicture,
      'id': instance.id,
      'email': instance.email,
      'isActive': instance.isActive,
    };
