import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';
class ToastMessage {
  static void success(String title, message) {
    try {
      Size size = MediaQuery.of(Get.context!).size;
      double width = size.width;
      toastification.show(
        icon: const Icon(
          Icons.check_circle,
          color: Colors.green,
        ),
        alignment: width > 450 ? Alignment.topRight : Alignment.bottomCenter,
        context: Get.context!,
        title: Text(title),
        type: ToastificationType.success,
        style: ToastificationStyle.flatColored,
        autoCloseDuration: const Duration(seconds: 3),
        showProgressBar: false,
        description: Text(message),
      );
    } catch (e) {
      print(e);
    }
  }

  static void error(String title, message) {
    try {
      Size size = MediaQuery.of(Get.context!).size;
      double width = size.width;
      toastification.show(
        icon: const Icon(
          Icons.error,
          color: Colors.red,
        ),
        alignment: width > 450 ? Alignment.topRight : Alignment.bottomCenter,
        context: Get.context!,
        title: width > 450 ? Text(title) : Text(title),
        type: ToastificationType.error,
        style: width > 450 ?ToastificationStyle.flatColored: ToastificationStyle.flatColored,
        autoCloseDuration: const Duration(seconds: 3),
        showProgressBar: false,
        description: Text(message),
      );
    } catch (e) {
      print(e);
    }
  }

  static void info(String title, message) {
    try {
      Size size = MediaQuery.of(Get.context!).size;
      double width = size.width;
      toastification.show(
        alignment: width > 450 ? Alignment.topRight : Alignment.bottomCenter,
        context: Get.context!,
        title: width > 450 ? Text(title) : Text(title),
        type: ToastificationType.info,
        style: width > 450 ?ToastificationStyle.flatColored: ToastificationStyle.flatColored,
        autoCloseDuration: const Duration(seconds: 3),
        showProgressBar: false,
        description: Text(message),
      );
    } catch (e) {
      print(e);
    }
  }

  static void warning(String title, message) {
    try {
      Size size = MediaQuery.of(Get.context!).size;
      double width = size.width;
      toastification.show(
        alignment: width > 450 ? Alignment.topRight : Alignment.bottomCenter,
        context: Get.context!,
        title: width > 450 ? Text(title) : Text(title),
        type: ToastificationType.warning,
        style: width > 450 ?ToastificationStyle.flatColored: ToastificationStyle.flatColored,
        autoCloseDuration: const Duration(seconds: 3),
        showProgressBar: false,
        description: Text(message),
      );
    } catch (e) {
      print(e);
    }
  }
}