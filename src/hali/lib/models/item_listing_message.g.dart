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
    json['from'] == null
        ? null
        : UserProfile.fromJson(json['from'] as Map<String, dynamic>),
    json['to'] == null
        ? null
        : UserProfile.fromJson(json['to'] as Map<String, dynamic>),
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
      'from': instance.from,
      'to': instance.to,
      'isSeen': instance.isSeen,
      'publishedAt': instance.publishedAt?.toIso8601String(),
    };
