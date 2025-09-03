import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// A helper class for displaying toast messages in the app.
abstract class AppToast {
  /// Shows a toast message with the given [message] at the bottom of the screen.
  ///
  /// If a [child] widget is provided, it will be displayed instead of the default
  /// container.
  static void show(BuildContext context, String message, {Widget? child}) {
    final fToast = FToast()..init(context);

    // Defines the appearance of the toast widget.
    final toastWidget = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Color(0xFF656565),
      ),
      child: Text(
        message,
        maxLines: 2,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
    );

    // Shows the toast.
    fToast.showToast(child: child ?? toastWidget, gravity: ToastGravity.BOTTOM);
  }
}
