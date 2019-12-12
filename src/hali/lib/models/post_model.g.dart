// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostModel _$PostModelFromJson(Map json) {
  return PostModel(
    categoryCategoryName: json['categoryCategoryName'] as String,
    categoryId: json['categoryId'] as int,
    city: json['city'] as String,
    description: json['description'] as String,
    district: json['district'] as String,
    endDate: json['endDate'] as String,
    id: intToString(json['id'] as int),
    imageUrl: json['imageUrl'] as String,
    lastModifiedBy: json['lastModifiedBy'] as String,
    lastModifiedDate: json['lastModifiedDate'] as String,
    latitude: (json['latitude'] as num)?.toDouble(),
    longitude: (json['longitude'] as num)?.toDouble(),
    pickUpTime: json['pickUpTime'] as String,
    pickupAddress: json['pickupAddress'] as String,
    startDate: json['startDate'] as String,
    title: json['title'] as String,
    userProfile: json['userProfile'] == null
        ? null
        : UserProfile.fromJson((json['userProfile'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
    numberLike: json['numberLike'] as int,
    distance: (json['distance'] as num)?.toDouble(),
    userProfileDisplayName: json['userProfileDisplayName'] as String,
    userProfileImageUrl: json['userProfileImageUrl'] as String,
    status: json['status'] as String,
  );
}

Map<String, dynamic> _$PostModelToJson(PostModel instance) => <String, dynamic>{
      'categoryCategoryName': instance.categoryCategoryName,
      'categoryId': instance.categoryId,
      'city': instance.city,
      'description': instance.description,
      'district': instance.district,
      'endDate': instance.endDate,
      'id': stringToJsonString(instance.id),
      'imageUrl': instance.imageUrl,
      'lastModifiedBy': instance.lastModifiedBy,
      'lastModifiedDate': instance.lastModifiedDate,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'pickUpTime': instance.pickUpTime,
      'pickupAddress': instance.pickupAddress,
      'startDate': instance.startDate,
      'title': instance.title,
      'userProfile': instance.userProfile?.toJson(),
      'numberLike': instance.numberLike,
      'distance': instance.distance,
      'userProfileDisplayName': instance.userProfileDisplayName,
      'userProfileImageUrl': instance.userProfileImageUrl,
      'status': instance.status,
    };
