import 'package:json_annotation/json_annotation.dart';

part 'create_post_command.g.dart';

@JsonSerializable()
class CreatePostCommand {  
  int categoryId;
  String city;
  String description;
  String district;
  String startDate;
  String endDate;  
  String imageUrl;
  String lastModifiedBy;
  String lastModifiedDate;
  double latitude;
  double longitude;
  String pickUpTime;
  String pickupAddress;  
  String title;
  String userProfileDisplayName;
  String userProfileImageUrl;
  String status;

  CreatePostCommand({    
    this.categoryId,
    this.city,
    this.description,
    this.district,
    this.endDate,    
    this.imageUrl,
    this.lastModifiedBy,
    this.lastModifiedDate,
    this.latitude,
    this.longitude,
    this.pickUpTime,
    this.pickupAddress,
    this.startDate,
    this.title,
    this.userProfileDisplayName,
    this.userProfileImageUrl,
    this.status,
  });

  factory CreatePostCommand.fromJson(Map<String, dynamic> json) =>
      _$CreatePostCommandFromJson(json);

  Map<String, dynamic> toJson() => _$CreatePostCommandToJson(this);
}