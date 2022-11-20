import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio_r159000/presentation/navigation/navigation.dart';
import 'package:radio_r159000/presentation/theme/extensions.dart';
import 'startup_screen_model.dart';
import 'startup_screen_widget.dart';

abstract class IStartupScreenWidgetModel extends IWidgetModel {
  TextStyle? get headlineStyle;

  void onCreate();

  void onConnect();
}

StartupScreenWidgetModel defaultStartupScreenWidgetModelFactory(
    BuildContext context) {
  return StartupScreenWidgetModel(
    StartupScreenModel(context.read()),
    context.read(),
  );
}

// TODO: cover with documentation
/// Default widget model for StartupScreenWidget
class StartupScreenWidgetModel
    extends WidgetModel<StartupScreenWidget, StartupScreenModel>
    implements IStartupScreenWidgetModel {
  final Navigation navigation;

  StartupScreenWidgetModel(
    StartupScreenModel model,
    this.navigation,
  ) : super(model);

  @override
  TextStyle? get headlineStyle => _textTheme.headline4?.copyWith(
        color: _theme.extension<ExtraColors>()?.mainText,
      );

  TextTheme get _textTheme => _theme.textTheme;

  ThemeData get _theme => Theme.of(context);

  @override
  void onConnect() {
    navigation.routeTo(
      RouteBundle(route: Routes.connect),
    );
  }

  @override
  void onCreate() {
    navigation.routeTo(
      RouteBundle(route: Routes.create),
    );
  }
}
