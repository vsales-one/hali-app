// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_listing_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemListingMessage _$ItemListingMessageFromJson(Map<String, dynamic> json) {
  return ItemListingMessage(
    json['itemType'] as String,
    json['itemId'] as String,
    json['itemTitle'] as String,
    json['itemImageUrl'] as String,
    json['from'] == null
        ? null
        : UserProfile.fromJson(Map<String, dynamic>.from(json['from'])),
    json['to'] == null
        ? null
        : UserProfile.fromJson(Map<String, dynamic>.from(json['to'])),
    json['isSeen'] as bool,
    json['publishedAt'] == null
        ? null
        : DateTime.parse(json['publishedAt'] as String),
  );
}

Map<String, dynamic> _$ItemListingMessageToJson(ItemListingMessage instance) =>
    <String, dynamic>{
      'itemType': instance.itemType,
      'itemId': instance.itemId,
      'itemTitle': instance.itemTitle,
      'itemImageUrl': instance.itemImageUrl,
      'from': instance.from.toJson(),
      'to': instance.to.toJson(),
      'isSeen': instance.isSeen,
      'publishedAt': instance.publishedAt?.toIso8601String(),
    };
