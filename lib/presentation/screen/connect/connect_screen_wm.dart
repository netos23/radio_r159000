import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio_r159000/presentation/navigation/navigation.dart';
import 'package:radio_r159000/presentation/screen/connect/model/client_configuration.dart';
import 'package:uuid/uuid.dart';
import 'connect_screen_model.dart';
import 'connect_screen_widget.dart';

abstract class IConnectScreenWidgetModel extends IWidgetModel {
  EntityStateNotifier<bool> get connectWifiState;

  EntityStateNotifier<bool> get customServerState;

  EntityStateNotifier<bool> get enableConnectionState;

  TextEditingController get ssidController;

  TextEditingController get passwordController;

  TextEditingController get ipController;

  TextEditingController get nameController;

  void connect();

  void openCamera();

  void switchConnectWifi(bool value);

  void switchCustomServer(bool value);
}

ConnectScreenWidgetModel defaultConnectScreenWidgetModelFactory(
    BuildContext context) {
  return ConnectScreenWidgetModel(
    ConnectScreenModel(
      context.read(),
    ),
    context.read(),
  );
}

// TODO: cover with documentation
/// Default widget model for ConnectScreenWidget
class ConnectScreenWidgetModel
    extends WidgetModel<ConnectScreenWidget, ConnectScreenModel>
    implements IConnectScreenWidgetModel {
  ConnectScreenWidgetModel(
    ConnectScreenModel model,
    this.navigation,
  ) : super(model);

  final Navigation navigation;

  @override
  void initWidgetModel() {
    super.initWidgetModel();
    connectWifiState.content(false);
    customServerState.content(false);
    enableConnectionState.content(true);
  }

  @override
  Future<void> connect() async {
    final ssid = ssidController.text;
    final password = passwordController.text;
    final ip = ipController.text;
    enableConnectionState.loading();

    if (ssid.isNotEmpty && password.isNotEmpty) {
      try {
        final res = await model.connectWifi(ssid, password);

        if (!res) {
          navigation.displayErrorSnackBar(
            'Не удалось подключиться к сети wifi. '
            'Проверьте данные или попробуйте позже',
          );
          enableConnectionState.content(true);
        }
      } catch (_) {
        navigation.displayErrorSnackBar(
          'Не удалось подключиться к сети wifi. '
          'Проверьте данные или попробуйте позже',
        );
        enableConnectionState.content(true);
        return;
      }
    }

    final String targetIp;
    try {
      targetIp = await model.getIp(ip);
    } catch (_) {
      navigation.displayErrorSnackBar(
        'Не удалось получить или проверить IP'
        'Проверьте данные или попробуйте позже',
      );
      enableConnectionState.content(true);
      return;
    }

    try {
      final res = await model.pingServer(targetIp);
      if (!res) {
        navigation.displayErrorSnackBar(
          'Возникла ошибка'
          'Проверьте данные или попробуйте позже',
        );
        enableConnectionState.content(true);
      }
    } catch (_) {
      navigation.displayErrorSnackBar(
        'Сервер не отвечает'
        'Проверьте данные или попробуйте позже',
      );
      enableConnectionState.content(true);
      return;
    }

    var name = nameController.text;

    if (name.isEmpty) {
      name = const Uuid().v4();
    }

    enableConnectionState.content(true);
    navigation.routeReplacementTo(
      RouteBundle(
        route: Routes.radioClient,
        data: ClientConfiguration(
          name: name,
          ip: targetIp,
        ),
      ),
    );
  }

  @override
  Future<void> openCamera() async {
    navigation.displayErrorSnackBar(
      'Будет позже (:',
    );
  }

  @override
  final EntityStateNotifier<bool> connectWifiState = EntityStateNotifier();

  @override
  final EntityStateNotifier<bool> customServerState = EntityStateNotifier();

  @override
  void switchConnectWifi(bool value) {
    if (!value) {
      ssidController.clear();
      passwordController.clear();
    }
    connectWifiState.content(value);
  }

  @override
  void switchCustomServer(bool value) {
    if (!value) {
      ipController.clear();
    }
    customServerState.content(value);
  }

  @override
  final TextEditingController ipController = TextEditingController();

  @override
  final TextEditingController passwordController = TextEditingController();

  @override
  final TextEditingController ssidController = TextEditingController();

  @override
  final TextEditingController nameController = TextEditingController();

  @override
  final EntityStateNotifier<bool> enableConnectionState = EntityStateNotifier();

  @override
  void dispose() {
    connectWifiState.dispose();
    customServerState.dispose();
    enableConnectionState.dispose();
    ssidController.dispose();
    passwordController.dispose();
    ipController.dispose();
    nameController.dispose();
    super.dispose();
  }
}
