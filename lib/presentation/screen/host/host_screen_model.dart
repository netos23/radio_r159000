import 'package:elementary/elementary.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:radio_r159000/presentation/screen/host/models/wifi_info.dart';
import 'package:wifi_iot/wifi_iot.dart';

// TODO: cover with documentation
/// Default Elementary model for HostScreen module
class HostScreenModel extends ElementaryModel {
  HostScreenModel(ErrorHandler errorHandler)
      : super(errorHandler: errorHandler);

  Future<bool> isHotspotEnabled() => WiFiForIoTPlugin.isWiFiAPEnabled();

  Future<WifiInfo?> getWifiInfo() async {
    final enabled = await isHotspotEnabled();
    if (enabled) {
      final ssid = await WiFiForIoTPlugin.getWiFiAPSSID();
      final password = await WiFiForIoTPlugin.getWiFiAPPreSharedKey();

      if (ssid != null && password != null) {
        return WifiInfo(
          ssid: ssid,
          password: password,
          qrPacked: 'WIFI:S:$ssid;T:WPA;P:$password;;',
        );
      }
    }

    return null;
  }

  Future<bool> switchHotspot(bool state) async {
    try {
      return await WiFiForIoTPlugin.setWiFiAPEnabled(state);
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  Future<String> getIp() async{
    return (await NetworkInfo().getWifiIP())!;
  }
}
