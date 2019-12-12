
import 'package:hali/models/user_profile.dart';
import 'package:hali/utils/date_utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_model.g.dart';

String intToString(int i) => i.toString();

String stringToJsonString(String i) => i;

@JsonSerializable(anyMap: true, explicitToJson: true)
class PostModel {
  String categoryCategoryName;
  int categoryId;
  String city;
  String description;
  String district;
  String endDate;
  @JsonKey(fromJson: intToString, toJson: stringToJsonString)
  String id;  
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
  double distance;
  String userProfileDisplayName;
  String userProfileImageUrl;
  String status;

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
    this.distance,
    this.userProfileDisplayName,
    this.userProfileImageUrl,
    this.status,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostModelToJson(this);

  DateTime getPickupTime() {
    return DateUtils.dateFromString(this.pickUpTime);
  }

  String pickupTimeDisplay() {
    return DateUtils.formatDateAsString(getPickupTime());
  }

  double displayDistance() {
    return this.distance ?? 0.0;
  }

}