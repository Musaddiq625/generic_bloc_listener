import 'package:flutter/material.dart';

/// Class to handle showing and hiding the application loader.
///
/// This class provides two methods:
/// - [show] to display the loader dialog.
/// - [hide] to hide the loader dialog.
abstract class AppLoader {
  /// Shows the loader dialog.
  ///
  /// The loader dialog is displayed as a centered [CircularProgressIndicator].
  /// The dialog is not dismissible and is displayed on top of other dialogs.
  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
  }

  /// Hides the loader dialog.
  ///
  /// The loader dialog is hidden by popping the top dialog from the navigator.
  static void hide(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
