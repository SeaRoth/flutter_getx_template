import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

Widget returnButtonCenter({required BuildContext context, required String buttonText, required Function onClick, Color? tintColor, Color? textColor}) {
  textColor ??= Theme.of(context).colorScheme.onSecondary;
  tintColor ??= Theme.of(context).colorScheme.onSurface;
  return Builder(
    builder: (context) {
      return GestureDetector(
        onTap: () {
          onClick();
        },
        child: ElevatedButton(
          key: Key('${UniqueKey()}'),
          style: ElevatedButton.styleFrom(
            backgroundColor: tintColor,
          ),

          child: Text(
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: textColor, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
            buttonText,
          ),
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.all(Radius.circular(8.0)),
          // ),
          onPressed: () {
            onClick();
          },
        ),
      );
    }
  );
}
