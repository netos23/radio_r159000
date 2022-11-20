import 'package:flutter/material.dart';
import 'package:radio_r159000/presentation/navigation/navigation.dart';
import 'package:radio_r159000/presentation/screen/host/host_screen_widget.dart';
import 'package:radio_r159000/presentation/screen/not_found/not_found_screen.dart';
import 'package:radio_r159000/presentation/screen/startup/startup_screen_widget.dart';

abstract class GenerateRouter {
  static Route<dynamic>? generateRootRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.startup:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const StartupScreenWidget(),
        );
      case Routes.create:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const HostScreenWidget(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => NotFoundScreen(
            route: settings.name ?? 'missing route',
          ),
        );
    }
  }
}
