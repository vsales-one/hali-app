// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_listing_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemListingMessage _$ItemListingMessageFromJson(Map json) {
  return ItemListingMessage(
    json['itemType'] as String,
    json['itemId'] as String,
    json['itemTitle'] as String,
    json['itemImageUrl'] as String,
    json['from'] == null
        ? null
        : UserProfile.fromJson((json['from'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
    json['to'] == null
        ? null
        : UserProfile.fromJson((json['to'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
    json['isSeen'] as bool,
    json['publishedAt'] == null
        ? null
        : DateTime.parse(json['publishedAt'] as String),
  )
    ..type = json['type'] as String
    ..content = json['content']
    ..groupId = json['groupId'] as String;
}

Map<String, dynamic> _$ItemListingMessageToJson(ItemListingMessage instance) =>
    <String, dynamic>{
      'type': instance.type,
      'content': instance.content,
      'groupId': instance.groupId,
      'itemType': instance.itemType,
      'itemId': instance.itemId,
      'itemTitle': instance.itemTitle,
      'itemImageUrl': instance.itemImageUrl,
      'from': instance.from?.toJson(),
      'to': instance.to?.toJson(),
      'isSeen': instance.isSeen,
      'publishedAt': instance.publishedAt?.toIso8601String(),
    };
