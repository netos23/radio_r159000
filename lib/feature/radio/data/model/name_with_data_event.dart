import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';

part 'name_with_data_event.g.dart';

@JsonSerializable()
class NameWithDataEventDto {
  final String name;
  final List<int> bytes;

  NameWithDataEventDto(this.name, this.bytes);

  factory NameWithDataEventDto.fromJson(Map<String, dynamic> json) =>
      _$NameWithDataEventDtoFromJson(json);

  Map<String, dynamic> toJson() => _$NameWithDataEventDtoToJson(this);
}
