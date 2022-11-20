import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:radio_r159000/presentation/components/settings_elements.dart';
import 'host_screen_wm.dart';

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
            child: ListView(
              children: [
                EntityStateNotifierBuilder(
                  listenableEntityState: wm.hotspotState,
                  builder: (context, data) {
                    return SettingsCheckbox(
                      title: 'Точка доступа',
                      value: data,
                      onChanged: wm.switchHotspot,
                    );
                  },
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
                OutlineTextField(
                  controller: wm.nameController,
                  hint: 'Имя',
                  textInputType: TextInputType.name,
                ),
                const SizedBox(height: 20),
                StartupCard(
                  title: 'Создать',
                  onTap: wm.create,
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
                final showText = obscure ?? false;
                final text = showText ? data.password : '********';
                return StartupCard(
                  title: 'password: $text',
                  description: 'Показать пароль',
                  onTap: wm.showPassword,
                  icon: showText ? Icons.visibility_off : Icons.visibility,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
