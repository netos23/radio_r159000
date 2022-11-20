import 'package:elementary/elementary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:radio_r159000/presentation/components/startup_card.dart';
import 'host_screen_wm.dart';
import 'package:radio_r159000/presentation/screen/host/models/wifi_info.dart';

// TODO: cover with documentation
/// Main widget for HostScreen module
class HostScreenWidget extends ElementaryWidget<IHostScreenWidgetModel> {
  const HostScreenWidget({
    Key? key,
    WidgetModelFactory wmFactory = defaultHostScreenWidgetModelFactory,
  }) : super(wmFactory, key: key);

  @override
  Widget build(IHostScreenWidgetModel wm) {
    return Scaffold(
      appBar: AppBar(
        title: const FittedBox(
          child: Text('Создание главной рации'),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 15,
            ),
            child: Column(
              children: [
                Flexible(
                  child: EntityStateNotifierBuilder(
                    listenableEntityState: wm.hotspotState,
                    builder: (context, data) {
                      return SettingsCheckbox(
                        title: 'Точка доступа',
                        value: data,
                        onChanged: wm.switchHotspot,
                      );
                    },
                  ),
                ),
                _buildWifiInfo(wm),
                const SizedBox(height: 20),
                EntityStateNotifierBuilder(
                  listenableEntityState: wm.ipState,
                  builder: (context, data) {
                    return StartupCard(
                      title: 'IP: $data',
                    );
                  },
                ),
                const SizedBox(height: 20),
                Flexible(
                  child: StartupCard(
                    title: 'Создать',
                    onTap: wm.create,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWifiInfo(IHostScreenWidgetModel wm) {
    return EntityStateNotifierBuilder(
      listenableEntityState: wm.wifiState,
      loadingBuilder: (_, __) => const SizedBox.shrink(),
      builder: (context, data) {
        if (data == null) {
          return const SizedBox.shrink();
        }
        return Column(
          children: [
            const SizedBox(height: 20),
            QrImage(
              data: data.qrPacked ?? '',
              version: QrVersions.auto,
              size: 200,
            ),
            const SizedBox(height: 20),
            StartupCard(
              title: 'SSID: ${data.ssid}',
            ),
            const SizedBox(height: 20),
            EntityStateNotifierBuilder(
              listenableEntityState: wm.showPasswordState,
              builder: (context, obscure) {
                final text = (obscure ?? false) ? data.password : '********';
                return StartupCard(
                  title: 'password: $text',
                  description: 'Показать пароль',
                  onTap: wm.showPassword,
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class SettingsCheckbox extends StatelessWidget {
  const SettingsCheckbox({
    Key? key,
    required this.title,
    this.value,
    this.onChanged,
  }) : super(key: key);
  final String title;
  final bool? value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Text(title),
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(
                milliseconds: 300,
              ),
              child: value == null
                  ? const CupertinoActivityIndicator()
                  : CupertinoSwitch(
                      value: value ?? false,
                      onChanged: onChanged,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsInfo extends StatelessWidget {
  const SettingsInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
