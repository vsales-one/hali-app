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

  UserProfile(this.userId, this.displayName, this.phoneNumber, this.email, this.imageUrl,
    this.address, this.district, this.city, this.isActive);

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
          bool isActive}) =>
      UserProfile(userId, displayName, phoneNumber, email, imageUrl, address, district, city, isActive);

  Map<String, dynamic> toJson() => _$UserProfileToJson(this);

  String get firstName => displayName.split(" ")[0];

  String get id => userId;

  @override
  String toString() {
    return "($userId-$email-$displayName)";
  }
}
