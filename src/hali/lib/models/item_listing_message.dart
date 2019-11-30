import 'package:hali/models/chat_message.dart';
import 'package:hali/models/user_profile.dart';
import 'package:json_annotation/json_annotation.dart';

part 'item_listing_message.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class ItemListingMessage extends ChatMessage {  
  String itemType; // food, non-food
  String itemId;
  String itemTitle;
  String itemImageUrl; 
  UserProfile from, to;
  bool isSeen;
  DateTime publishedAt;

  ItemListingMessage(
    this.itemType, 
    this.itemId, 
    this.itemTitle, 
    this.itemImageUrl, 
    this.from, 
    this.to, 
    this.isSeen, 
    this.publishedAt
  ) : super(itemTitle, from, to, isSeen, publishedAt, itemType, itemId);

  factory ItemListingMessage.fromJson(Map<String, dynamic> json) =>
      _$ItemListingMessageFromJson(json);

  factory ItemListingMessage.fromNamed(
          {String itemType,
          String itemId,
          String itemTitle,
          String itemImageUrl,
          UserProfile from,
          UserProfile to,
          bool isSeen,
          DateTime publishedAt}) =>
      ItemListingMessage(itemType, itemId, itemTitle, itemImageUrl, from, to, isSeen, publishedAt);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$ChatToJson`.
  Map<String, dynamic> toJson() => _$ItemListingMessageToJson(this);
}
