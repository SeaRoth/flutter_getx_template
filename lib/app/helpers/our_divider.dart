import 'package:flutter/material.dart';

Widget returnOurDivider({required BuildContext context, Color? color}) {
  color ??= Theme.of(context).colorScheme.onPrimary;
  return Divider(
    height: 30,
    thickness: 1,
    indent: 20,
    endIndent: 20,
    color: color,
  );
}