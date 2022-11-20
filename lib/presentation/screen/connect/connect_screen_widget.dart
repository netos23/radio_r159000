import 'package:elementary/elementary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:radio_r159000/presentation/components/settings_elements.dart';
import 'connect_screen_wm.dart';

// TODO: cover with documentation
/// Main widget for ConnectScreen module
class ConnectScreenWidget extends ElementaryWidget<IConnectScreenWidgetModel> {
  const ConnectScreenWidget({
    Key? key,
    WidgetModelFactory wmFactory = defaultConnectScreenWidgetModelFactory,
  }) : super(wmFactory, key: key);

  @override
  Widget build(IConnectScreenWidgetModel wm) {
    return Scaffold(
      appBar: AppBar(
        title: const FittedBox(
          child: Text('Подключение рации'),
        ),
        actions: [
          IconButton(
            onPressed: wm.openCamera,
            icon: const Icon(Icons.photo_camera),
          ),
        ],
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
                  listenableEntityState: wm.connectWifiState,
                  builder: (context, data) {
                    return SettingsCheckbox(
                      title: 'Подключиться к точке доступа',
                      value: data,
                      onChanged: wm.switchConnectWifi,
                    );
                  },
                ),
                EntityStateNotifierBuilder(
                  listenableEntityState: wm.connectWifiState,
                  builder: (context, data) {
                    return Visibility(
                      visible: data ?? false,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxHeight: 150,
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            Flexible(
                              child: OutlineTextField(
                                controller: wm.ssidController,
                                hint: 'SSID',
                                textInputType: TextInputType.name,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Flexible(
                              child: OutlineTextField(
                                controller: wm.passwordController,
                                hint: 'password',
                                textInputType: TextInputType.visiblePassword,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                EntityStateNotifierBuilder(
                  listenableEntityState: wm.customServerState,
                  builder: (context, data) {
                    return SettingsCheckbox(
                      title: 'Указать пользовательский сервер',
                      value: data,
                      onChanged: wm.switchCustomServer,
                    );
                  },
                ),
                EntityStateNotifierBuilder(
                  listenableEntityState: wm.customServerState,
                  builder: (context, data) {
                    return Visibility(
                      visible: data ?? false,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 20.0,
                        ),
                        child: OutlineTextField(
                          controller: wm.ipController,
                          hint: 'IP',
                          textInputType: TextInputType.name,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                EntityStateNotifierBuilder(
                  listenableEntityState: wm.enableConnectionState,
                  builder: (context, data) {
                    final hasData = data ?? false;
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: hasData
                          ? StartupCard(
                              title: 'Подключить',
                              onTap: wm.connect,
                            )
                          : const CupertinoActivityIndicator(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OutlineTextField extends StatelessWidget {
  const OutlineTextField({
    Key? key,
    required this.controller,
    required this.hint,
    required this.textInputType,
  }) : super(key: key);

  final TextEditingController controller;
  final String hint;
  final TextInputType textInputType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: textInputType,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(15),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        hintText: hint,
      ),
    );
  }
}
