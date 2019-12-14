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
    _$enumDecodeNullable(_$ItemRequestMessageStatusEnumMap, json['status']),
    json['groupId'] as String,
  )
    ..type = json['type'] as String
    ..content = json['content'];
}

Map<String, dynamic> _$ItemListingMessageToJson(ItemListingMessage instance) =>
    <String, dynamic>{
      'type': instance.type,
      'content': instance.content,
      'itemType': instance.itemType,
      'itemId': instance.itemId,
      'itemTitle': instance.itemTitle,
      'itemImageUrl': instance.itemImageUrl,
      'from': instance.from?.toJson(),
      'to': instance.to?.toJson(),
      'isSeen': instance.isSeen,
      'publishedAt': instance.publishedAt?.toIso8601String(),
      'status': _$ItemRequestMessageStatusEnumMap[instance.status],
      'groupId': instance.groupId,
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$ItemRequestMessageStatusEnumMap = {
  ItemRequestMessageStatus.Open: 'Open',
  ItemRequestMessageStatus.Cancelled: 'Cancelled',
  ItemRequestMessageStatus.Closed: 'Closed',
};
