import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:radio_r159000/presentation/theme/extensions.dart';

class StartupCard extends StatelessWidget {
  const StartupCard({
    Key? key,
    required this.title,
    this.description,
    this.onTap,
    this.icon = Icons.info,
  }) : super(key: key);

  final String title;
  final String? description;
  final VoidCallback? onTap;
  final IconData icon;

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
              child: Visibility(
                visible: description != null,
                child: Tooltip(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    border: const Border.fromBorderSide(BorderSide()),
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                  ),
                  padding: const EdgeInsets.all(33),
                  margin: const EdgeInsets.all(20),
                  message: description ?? '',
                  textAlign: TextAlign.center,
                  textStyle: TextStyle(
                    color: Theme.of(context).extension<ExtraColors>()?.mainText,
                  ),
                  child: AnimatedSwitcher(
                    key: Key(icon.codePoint.toString()),
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      icon,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsCheckbox extends StatelessWidget {
  const SettingsCheckbox({
    Key? key,
    required this.title,
    this.value,
    this.onChanged,
  }) : super(key: key);
  final String title;
  final bool? value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Text(title),
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(
                milliseconds: 300,
              ),
              child: value == null
                  ? const CupertinoActivityIndicator()
                  : CupertinoSwitch(
                      value: value ?? false,
                      onChanged: onChanged,
                    ),
            ),
          ),
        ],
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

