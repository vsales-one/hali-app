// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) {
  return UserProfile(
    json['userId'] as String,
    json['displayName'] as String,
    json['phoneNumber'] as String,
    json['email'] as String,
    json['imageUrl'] as String,
    json['address'] as String,
    json['district'] as String,
    json['city'] as String,
    json['isActive'] as bool,
    (json['latitude'] as num)?.toDouble(),
    (json['longitude'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'displayName': instance.displayName,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'imageUrl': instance.imageUrl,
      'address': instance.address,
      'district': instance.district,
      'city': instance.city,
      'isActive': instance.isActive,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
