import 'package:json_annotation/json_annotation.dart';

part 'name_event.g.dart';

@JsonSerializable()
class NameEventDto {
  final String name;

  NameEventDto(this.name);

  factory NameEventDto.fromJson(Map<String, dynamic> json) =>
      _$NameEventDtoFromJson(json);

  Map<String, dynamic> toJson() => _$NameEventDtoToJson(this);
}
