import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

class SnackBarHelper {
  static void showSuccess({
    required BuildContext context,
    required String title,
    required String message,
  }) {
    _showSnackBar(
      context: context,
      title: title,
      message: message,
      contentType: ContentType.success,
    );
  }

  static void showWarning({
    required BuildContext context,
    required String title,
    required String message,
  }) {
    _showSnackBar(
      context: context,
      title: title,
      message: message,
      contentType: ContentType.warning,
    );
  }

  static void showHelp({
    required BuildContext context,
    required String title,
    required String message,
  }) {
    _showSnackBar(
      context: context,
      title: title,
      message: message,
      contentType: ContentType.help,
    );
  }

  static void showError({
    required BuildContext context,
    required String title,
    required String message,
  }) {
    _showSnackBar(
      context: context,
      title: title,
      message: message,
      contentType: ContentType.failure,
    );
  }

  static void _showSnackBar({
    required BuildContext context,
    required String title,
    required String message,
    required ContentType contentType,
  }) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: contentType,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
