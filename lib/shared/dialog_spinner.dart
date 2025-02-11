import 'package:flutter/material.dart';

class DialogSpinner extends StatelessWidget {
  const DialogSpinner({
    Key? key,
    this.textStyle,
    required this.text,
  }) : super(key: key);

  final TextStyle? textStyle;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              backgroundColor: Theme.of(context).primaryColorLight,
              strokeWidth: 5.0,
              valueColor:
                  AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            ),
            Container(
              margin: const EdgeInsets.only(left: 30.0),
              child: Text(
                text,
                style: textStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
