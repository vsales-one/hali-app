// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_post_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreatePostCommand _$CreatePostCommandFromJson(Map<String, dynamic> json) {
  return CreatePostCommand(
    categoryId: json['categoryId'] as int,
    city: json['city'] as String,
    description: json['description'] as String,
    district: json['district'] as String,
    endDate: json['endDate'] as String,
    id: json['id'] as int,
    imageUrl: json['imageUrl'] as String,
    lastModifiedBy: json['lastModifiedBy'] as String,
    lastModifiedDate: json['lastModifiedDate'] as String,
    latitude: (json['latitude'] as num)?.toDouble(),
    longitude: (json['longitude'] as num)?.toDouble(),
    pickUpTime: json['pickUpTime'] as String,
    pickupAddress: json['pickupAddress'] as String,
    startDate: json['startDate'] as String,
    title: json['title'] as String,
    userProfileDisplayName: json['userProfileDisplayName'] as String,
    userProfileImageUrl: json['userProfileImageUrl'] as String,
    status: json['status'] as String,
  );
}

Map<String, dynamic> _$CreatePostCommandToJson(CreatePostCommand instance) =>
    <String, dynamic>{
      'categoryId': instance.categoryId,
      'city': instance.city,
      'description': instance.description,
      'district': instance.district,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'id': instance.id,
      'imageUrl': instance.imageUrl,
      'lastModifiedBy': instance.lastModifiedBy,
      'lastModifiedDate': instance.lastModifiedDate,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'pickUpTime': instance.pickUpTime,
      'pickupAddress': instance.pickupAddress,
      'title': instance.title,
      'userProfileDisplayName': instance.userProfileDisplayName,
      'userProfileImageUrl': instance.userProfileImageUrl,
      'status': instance.status,
    };
