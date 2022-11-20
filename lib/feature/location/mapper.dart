import 'package:radio_r159000/feature/location/model/location_info.dart';
import 'package:radio_r159000/feature/transport/model/event_pocket.dart';

LocationInfo mapLocationEvents(EventPocket pocket) {
  return LocationInfo.fromJson(pocket.payload);
}
