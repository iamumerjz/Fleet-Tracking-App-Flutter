import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

SnackBar FailureSnackbar(String e) {
  return SnackBar(
    elevation: 50,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: 'Oh Snap!',
      message: e.toString(),
      contentType: ContentType.failure,
      color: Colors.pink,
    ),
  );
}

SnackBar SuccessSnackbar(String msg, Color color) {
  return SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: 'Success',
      message: 'Yolo!',
      contentType: ContentType.success,
      color: Colors.cyan,
    ),
  );
}