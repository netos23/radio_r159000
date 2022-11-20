import 'package:elementary/elementary.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:radio_r159000/util/logger.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:http/http.dart' as http;

// TODO: cover with documentation
/// Default Elementary model for ConnectScreen module
class ConnectScreenModel extends ElementaryModel {
  ConnectScreenModel(ErrorHandler errorHandler)
      : super(errorHandler: errorHandler);

  Future<bool> connectWifi(String ssid, String password) async {
    try {
      return await WiFiForIoTPlugin.connect(
        ssid,
        password: password,
        security: NetworkSecurity.WPA,
      );
    } catch (e) {
      handleError(e);
      rethrow;
    }
  }

  Future<String> getIp(String customIp) async {
    try {
      var ip = customIp;

      if (customIp.isEmpty) {
        ip = (await NetworkInfo().getWifiGatewayIP())!;
      }

      return ip;
    } catch (e) {
      handleError(e);
      rethrow;
    }
  }

  Future<bool> pingServer(String targetIp) async {
    try {
      final res = await http.get(Uri.parse('http://$targetIp:3000/ping'));
      return res.body == 'ok';
    } catch (e) {
      handleError(e);
      rethrow;
    }
  }
}
