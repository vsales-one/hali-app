// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessage _$ChatMessageFromJson(Map json) {
  return ChatMessage(
    json['content'],
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
    json['type'] as String,
    json['groupId'] as String,
  );
}

Map<String, dynamic> _$ChatMessageToJson(ChatMessage instance) =>
    <String, dynamic>{
      'type': instance.type,
      'content': instance.content,
      'from': instance.from?.toJson(),
      'to': instance.to?.toJson(),
      'isSeen': instance.isSeen,
      'publishedAt': instance.publishedAt?.toIso8601String(),
      'groupId': instance.groupId,
    };
