class RouteBundle {
  RouteBundle({
    required this.route,
    this.data,
    this.useRootNavigator,
  });

  final String route;
  final Object? data;
  final bool? useRootNavigator;
}
