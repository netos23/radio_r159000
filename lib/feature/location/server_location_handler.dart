import 'package:radio_r159000/feature/location/location_handler.dart';
import 'package:radio_r159000/feature/location/model/location_info.dart';
import 'package:radio_r159000/feature/transport/model/event_pocket.dart';
import 'package:radio_r159000/feature/common/constant.dart' as names;

class ServerLocationHandler extends LocationHandler {
  ServerLocationHandler(
    super.transportBase,
    super.callId,
  );

  @override
  void handleEvent(LocationInfo info) {
    super.handleEvent(info);
    transportBase.notifyListeners(
      EventPocket(
        names.location,
        info,
        callId,
      ),
    );
  }

  @override
  void addLocationInfo(LocationInfo info) {
    super.addLocationInfo(info);
    notifyLocations(info);
  }
}
