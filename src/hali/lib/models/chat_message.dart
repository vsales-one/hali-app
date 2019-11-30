import 'package:hali/models/user_profile.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_message.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class ChatMessage {
  static const String TEXT = "text";
  String type;
  dynamic content;
  UserProfile from, to;
  bool isSeen;
  DateTime publishedAt;
  String groupId;
  ChatMessage(this.content, this.from, this.to, this.isSeen, this.publishedAt,
      this.type, this.groupId);

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);

  factory ChatMessage.fromNamed(
          {String content,
          UserProfile from,
          UserProfile to,
          bool isSeen,
          DateTime publishedAt,
          String groupId,
          String type = TEXT}) =>
      ChatMessage(content, from, to, isSeen, publishedAt, type, groupId);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$ChatToJson`.
  Map<String, dynamic> toJson() => _$ChatMessageToJson(this);
}
