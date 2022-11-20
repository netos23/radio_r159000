import 'package:flutter/material.dart';
import 'package:radio_r159000/presentation/theme/extensions.dart';

class StartupCard extends StatelessWidget {
  const StartupCard({
    Key? key,
    required this.title,
    required this.description,
    this.onTap,
  }) : super(key: key);

  final String title;
  final String description;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(15)),
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(
          border: Border.fromBorderSide(BorderSide()),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        padding: const EdgeInsets.all(24),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 5,
              child: Text(
                title,
              ),
            ),
            Expanded(
              child: Tooltip(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  border: const Border.fromBorderSide(BorderSide()),
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                ),
                padding: const EdgeInsets.all(33),
                margin: const EdgeInsets.all(20),
                message: description,
                textAlign: TextAlign.center,
                textStyle: TextStyle(
                  color: Theme.of(context).extension<ExtraColors>()?.mainText,
                ),
                child: const Icon(
                  Icons.info,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
