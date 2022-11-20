import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio_r159000/presentation/navigation/navigation.dart';
import 'package:radio_r159000/presentation/theme/extensions.dart';
import 'package:radio_r159000/presentation/theme/theme.dart';

class RadioApp extends StatelessWidget {
  const RadioApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navigation = context.read<Navigation>();
    return MaterialApp(
      onGenerateRoute: GenerateRouter.generateRootRoute,
      scaffoldMessengerKey: navigation.scaffoldMessengerKey,
      navigatorKey: navigation.rootNavigationKey,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          foregroundColor: Colors.black,

        ),
        colorScheme: colorScheme,
        extensions: const [
          ExtraColors(),
        ],
      ),
    );
  }
}
