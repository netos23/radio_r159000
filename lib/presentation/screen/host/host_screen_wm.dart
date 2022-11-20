import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio_r159000/presentation/navigation/navigation.dart';
import 'package:radio_r159000/presentation/screen/host/models/wifi_info.dart';
import 'host_screen_model.dart';
import 'host_screen_widget.dart';

abstract class IHostScreenWidgetModel extends IWidgetModel {
  EntityStateNotifier<bool> get hotspotState;

  EntityStateNotifier<WifiInfo> get wifiState;

  EntityStateNotifier<bool> get showPasswordState;

  EntityStateNotifier<String> get ipState;

  void switchHotspot(bool value);

  void create();

  void showPassword();
}

HostScreenWidgetModel defaultHostScreenWidgetModelFactory(
    BuildContext context) {
  return HostScreenWidgetModel(
    HostScreenModel(
      context.read(),
    ),
    context.read(),
  );
}

// TODO: cover with documentation
/// Default widget model for HostScreenWidget
class HostScreenWidgetModel
    extends WidgetModel<HostScreenWidget, HostScreenModel>
    implements IHostScreenWidgetModel {
  final Navigation navigation;

  HostScreenWidgetModel(
    HostScreenModel model,
    this.navigation,
  ) : super(model);

  @override
  void initWidgetModel() {
    super.initWidgetModel();
    _initHotspotState();
    _initHotspotInfoState();
    _getIp();
  }

  @override
  final EntityStateNotifier<bool> hotspotState = EntityStateNotifier();

  @override
  final EntityStateNotifier<String> ipState = EntityStateNotifier();

  @override
  final EntityStateNotifier<bool> showPasswordState = EntityStateNotifier();

  @override
  final EntityStateNotifier<WifiInfo> wifiState = EntityStateNotifier();

  @override
  void dispose() {
    hotspotState.dispose();
    wifiState.dispose();
    ipState.dispose();
    showPasswordState.dispose();
    super.dispose();
  }

  Future<void> _initHotspotState() async {
    final enabled = await model.isHotspotEnabled();
    hotspotState.content(enabled);
  }

  Future<void> _getIp() async {
    try {
      final ip = await model.getIp();
      ipState.content(ip);
    } catch (_) {
      navigation.displayErrorSnackBar(
        'Неудалось определить wifi ip дальнейшая работа невозможна',
      );
      navigation.routeBack();
    }
  }

  Future<void> _initHotspotInfoState() async {
    final info = await model.getWifiInfo();
    if (info != null) {
      wifiState.content(info);
    } else {
      wifiState.loading();
    }
  }

  @override
  Future<void> switchHotspot(bool value) async {
    var enabled = await model.isHotspotEnabled();
    hotspotState.loading();

    try {
      await model.switchHotspot(!enabled);
      _initHotspotInfoState();
      _getIp();
    } catch (_) {
      navigation.displayErrorSnackBar(
        enabled ? 'Неудалось выключить wifi' : 'Неудалось создать сеть wifi',
      );
    }

    enabled = await model.isHotspotEnabled();
    hotspotState.content(enabled);
  }

  @override
  void create() {
    navigation.routeReplacementTo(
      RouteBundle(
        route: Routes.radio,
      ),
    );
  }

  @override
  void showPassword() {
    final state = showPasswordState.value?.data ?? false;
    showPasswordState.content(!state);
  }
}
