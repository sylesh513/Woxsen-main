import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Future<dynamic> loadingOnScreen(BuildContext context) {
  return showDialog(
    barrierColor: Colors.black.withOpacity(0.5),
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return SizedBox(
        height: 100,
        width: 100,
        child: Center(
          child: SpinKitSpinningLines(
            color: Colors.red.shade800,
            size: 70.0,
          ),
        ),
      );
    },
  );
}
