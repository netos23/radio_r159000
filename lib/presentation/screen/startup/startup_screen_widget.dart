import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:radio_r159000/presentation/components/startup_card.dart';
import 'package:radio_r159000/presentation/theme/resourses.dart';
import 'startup_screen_wm.dart';
import 'package:flutter_svg/flutter_svg.dart';

// TODO: cover with documentation
/// Main widget for StartupScreen module
class StartupScreenWidget extends ElementaryWidget<IStartupScreenWidgetModel> {
  const StartupScreenWidget({
    Key? key,
    WidgetModelFactory wmFactory = defaultStartupScreenWidgetModelFactory,
  }) : super(wmFactory, key: key);

  @override
  Widget build(IStartupScreenWidgetModel wm) {
    return Scaffold(
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
                  child: SvgPicture.asset(
                    ImageResources.logo,
                  ),
                ),
                const SizedBox(height: 20),
                Flexible(
                  child: Text(
                    'Radio R159000',
                    style: wm.headlineStyle,
                  ),
                ),
                const Spacer(),
                Flexible(
                  child: StartupCard(
                    title: 'Создать радиосеть',
                    description:
                        'Создает точки доступа или сервер, для подключения '
                        'остальных раций.\n\n'
                        'Отключение главной радиостанции приводит '
                        'к отключению побочных',
                    onTap: wm.onCreate,
                  ),
                ),
                const SizedBox(height: 20),
                Flexible(
                  child: StartupCard(
                    title: 'Подключить радиосеть',
                    description: 'Подключение к радиосети с помощью wifi '
                        'или адреса сервера.\n\n'
                        'Отключение подключенной радиостанции не влияет '
                        'на другие радиостанции',
                    onTap: wm.onConnect,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
