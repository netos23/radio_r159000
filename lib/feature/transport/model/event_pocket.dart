import 'package:json_annotation/json_annotation.dart';

part 'event_pocket.g.dart';

@JsonSerializable(createToJson: true)
class EventPocket {
  final String eventName;
  final String owner;
  final dynamic payload;

  EventPocket(
    this.eventName,
    this.payload,
    this.owner,
  );

  factory EventPocket.fromJson(Map<String, dynamic> json) =>
      _$EventPocketFromJson(json);

  Map<String, dynamic> toJson() => _$EventPocketToJson(this);
}
