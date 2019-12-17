import 'package:json_annotation/json_annotation.dart';

part 'user_profile.g.dart';

@JsonSerializable()
class UserProfile {  
  String userId;
  String displayName;  
  String phoneNumber;
  String email;
  String imageUrl;
  String address;
  String district;
  String city;  
  bool isActive;
  double latitude;
  double longitude;

  UserProfile(this.userId, this.displayName, this.phoneNumber, this.email, this.imageUrl,
    this.address, this.district, this.city, this.isActive, this.latitude, this.longitude);

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  factory UserProfile.fromNamed(
          {String id,
          String userId,
          String displayName,          
          String phoneNumber,
          String email,
          String imageUrl,
          String address,
          String district,
          String city,
          bool isActive,
          double latitude,
          double longitude}) =>
      UserProfile(userId, displayName, phoneNumber, email, imageUrl, address, district, city, isActive, latitude, longitude);

  Map<String, dynamic> toJson() => _$UserProfileToJson(this);

  String get firstName => displayName != null && displayName.isNotEmpty ? displayName.split(" ")[0] : email;

  String get id => userId;

  String get fullAddress => "$address, $district, $city".trim();

  @override
  String toString() {
    return "($userId-$email-$displayName-$imageUrl)";
  }
}
