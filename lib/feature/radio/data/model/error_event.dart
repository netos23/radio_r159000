import 'package:json_annotation/json_annotation.dart';

part 'error_event.g.dart';

@JsonSerializable()
class ErrorEventDto {
  final String name;
  final String reason;

  ErrorEventDto(this.name, this.reason);

  factory ErrorEventDto.fromJson(Map<String, dynamic> json) =>
      _$ErrorEventDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorEventDtoToJson(this);
}
