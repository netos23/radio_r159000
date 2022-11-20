import 'package:json_annotation/json_annotation.dart';
part 'location_info.g.dart';

@JsonSerializable()
class LocationInfo {
  final String name;
  final int signal;

  LocationInfo(this.name, this.signal);

  factory LocationInfo.fromJson(Map<String, dynamic> json) =>
      _$LocationInfoFromJson(json);

  Map<String, dynamic> toJson() => _$LocationInfoToJson(this);
}
