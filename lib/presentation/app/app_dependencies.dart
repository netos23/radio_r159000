import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio_r159000/presentation/app/app.dart';
import 'package:radio_r159000/presentation/navigation/navigation.dart';
import 'package:radio_r159000/util/error_handler.dart';

class AppDependencies extends StatefulWidget {
  const AppDependencies({
    Key? key,
    required this.app,
  }) : super(key: key);

  final RadioApp app;

  @override
  State<AppDependencies> createState() => _AppDependenciesState();
}

class _AppDependenciesState extends State<AppDependencies> {

  @override
  void initState() {
    super.initState();


  }



  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Navigation>(create: (_) => Navigation()),
        Provider<ErrorHandler>(create: (_) => DefaultErrorHandler()),
      ],
      child: widget.app,
    );
  }
}
