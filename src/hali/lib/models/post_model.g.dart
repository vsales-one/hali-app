// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostModel _$PostModelFromJson(Map<String, dynamic> json) {
  return PostModel(
    categoryCategoryName: json['categoryCategoryName'] as String,
    categoryId: json['categoryId'] as int,
    city: json['city'] as String,
    description: json['description'] as String,
    district: json['district'] as String,
    endDate: json['endDate'] == null
        ? null
        : DateTime.parse(json['endDate'] as String),
    id: json['id'] as int,
    imageUrl: json['imageUrl'] as String,
    lastModifiedBy: json['lastModifiedBy'] as String,
    lastModifiedDate: json['lastModifiedDate'] == null
        ? null
        : DateTime.parse(json['lastModifiedDate'] as String),
    latitude: json['latitude'] as int,
    longitude: json['longitude'] as int,
    pickUpTime: json['pickUpTime'] as String,
    pickupAddress: json['pickupAddress'] as String,
    startDate: json['startDate'] == null
        ? null
        : DateTime.parse(json['startDate'] as String),
    title: json['title'] as String,
  );
}

Map<String, dynamic> _$PostModelToJson(PostModel instance) => <String, dynamic>{
      'categoryCategoryName': instance.categoryCategoryName,
      'categoryId': instance.categoryId,
      'city': instance.city,
      'description': instance.description,
      'district': instance.district,
      'endDate': instance.endDate?.toIso8601String(),
      'id': instance.id,
      'imageUrl': instance.imageUrl,
      'lastModifiedBy': instance.lastModifiedBy,
      'lastModifiedDate': instance.lastModifiedDate?.toIso8601String(),
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'pickUpTime': instance.pickUpTime,
      'pickupAddress': instance.pickupAddress,
      'startDate': instance.startDate?.toIso8601String(),
      'title': instance.title,
    };
