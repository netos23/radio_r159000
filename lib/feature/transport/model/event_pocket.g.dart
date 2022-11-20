// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_pocket.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventPocket _$EventPocketFromJson(Map<String, dynamic> json) => EventPocket(
      json['eventName'] as String,
      json['payload'],
      json['owner'] as String,
    );

Map<String, dynamic> _$EventPocketToJson(EventPocket instance) =>
    <String, dynamic>{
      'eventName': instance.eventName,
      'owner': instance.owner,
      'payload': instance.payload,
    };
