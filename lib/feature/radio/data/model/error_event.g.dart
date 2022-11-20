// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorEventDto _$ErrorEventDtoFromJson(Map<String, dynamic> json) =>
    ErrorEventDto(
      json['name'] as String,
      json['reason'] as String,
    );

Map<String, dynamic> _$ErrorEventDtoToJson(ErrorEventDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'reason': instance.reason,
    };
