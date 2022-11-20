import 'package:flutter/material.dart';
import 'route_bundle.dart';

export 'generate_router.dart';
export 'route_bundle.dart';
export 'routes.dart';

class Navigation {
  final GlobalKey<NavigatorState> rootNavigationKey =
      GlobalKey<NavigatorState>();

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  NavigatorState? get _navigatorState => rootNavigationKey.currentState;

  Future<T?> routeTo<T extends Object?>(RouteBundle bundle) async {
    return await _navigatorState?.pushNamed<T>(
      bundle.route,
      arguments: bundle.data,
    );
  }

  Future<T?> routeReplacementTo<T extends Object?>(RouteBundle bundle) async {
    return await _navigatorState?.pushReplacementNamed(bundle.route,
        arguments: bundle.data);
  }

  Future<T?> routeToAndRemoveUntil<T extends Object?>(
      RouteBundle bundle) async {
    return await _navigatorState?.pushNamedAndRemoveUntil(
        bundle.route, (route) => route.isFirst,
        arguments: bundle.data);
  }

  Future<bool?> routeBack({
    Object? data,
    bool? useRootNavigator = false,
  }) async {
    return await _navigatorState?.maybePop(data);
  }

  void routeBackTo(RouteBundle bundle) {
    _navigatorState?.popUntil(ModalRoute.withName(bundle.route));
  }

  void routeBackToFirst({
    bool? useRootNavigator = false,
  }) {
    _navigatorState?.popUntil((route) => route.isFirst);
  }

  Future<T?> routeBackThenTo<T extends Object?>(RouteBundle bundle) async {
    return await _navigatorState?.popAndPushNamed(
      bundle.route,
      arguments: bundle.data,
    );
  }

  bool? canPop({
    bool? useRootNavigator = false,
  }) {
    return _navigatorState?.canPop();
  }

  void displayErrorSnackBar(String message) {
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void displayMaterialBanner(MaterialBanner materialBanner) {
    scaffoldMessengerKey.currentState?.showMaterialBanner(materialBanner);
  }
}
