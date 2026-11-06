import 'package:flutter/material.dart';

class Policy {
  static Widget can(
    bool access, {
    required Widget child,
    Widget noAccess = const SizedBox.shrink(),
  }) {
    return access ? child : noAccess;
  }

  static List<Widget> canMany(
    bool access, {
    required List<Widget> children,
    Widget noAccess = const SizedBox.shrink(),
  }) {
    return access ? children : [noAccess];
  }

  static Widget canAny(
    List<bool> accessList, {
    required Widget child,
    Widget noAccess = const SizedBox.shrink(),
  }) {
    return accessList.any((item) => item) ? child : noAccess;
  }
}
