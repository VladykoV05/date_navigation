import 'package:flutter/material.dart';

class UiSpace {
  const UiSpace._();

  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 30;
}

class UiRadius {
  const UiRadius._();

  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
}

class UiElevation {
  const UiElevation._();

  static const double card = 3;
  static const double blur = 10;
  static const double spread = 2;
  static const double shadowAlpha = 0.12;
}

class UiInsets {
  const UiInsets._();

  static const pageHorizontal = EdgeInsets.symmetric(horizontal: UiSpace.lg);
  static const panelPadding = EdgeInsets.all(UiSpace.sm);
}
