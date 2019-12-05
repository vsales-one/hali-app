
import 'dart:ffi';

import 'package:hali/models/user_profile.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_model.g.dart';

@JsonSerializable()
class PostModel {
  String categoryCategoryName;
  int categoryId;
  String city;
  String description;
  String district;
  String endDate;
  int id;
  String imageUrl;
  String lastModifiedBy;
  String lastModifiedDate;
  double latitude;
  double longitude;
  String pickUpTime;
  String pickupAddress;
  String startDate;
  String title;
  UserProfile userProfile;
  int numberLike;
  Float distance;

  PostModel({
    this.categoryCategoryName,
    this.categoryId,
    this.city,
    this.description,
    this.district,
    this.endDate,
    this.id,
    this.imageUrl,
    this.lastModifiedBy,
    this.lastModifiedDate,
    this.latitude,
    this.longitude,
    this.pickUpTime,
    this.pickupAddress,
    this.startDate,
    this.title,
    this.userProfile,
    this.numberLike,
    this.distance
  });

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostModelToJson(this);
}