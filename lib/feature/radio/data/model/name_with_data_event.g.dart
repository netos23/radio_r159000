// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'name_with_data_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NameWithDataEventDto _$NameWithDataEventDtoFromJson(
        Map<String, dynamic> json) =>
    NameWithDataEventDto(
      json['name'] as String,
      (json['bytes'] as List<dynamic>).map((e) => e as int).toList(),
    );

Map<String, dynamic> _$NameWithDataEventDtoToJson(
        NameWithDataEventDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'bytes': instance.bytes,
    };
