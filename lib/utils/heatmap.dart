import 'package:flutter/material.dart';
import 'dart:math';

Color speedtocolor(double speed) {
  // Custom Gradient
  double percentage = min(speed * 13, 100);
  double r = 0, g = 0, b = 0;
  if (percentage < 30) {
    r = 0;
    g = 138 + 117 * percentage / 30;
    b = 255 - 251 * percentage / 30;
  } else if (percentage < 70) {
    r = 238 * (percentage - 30) / 40;
    g = 255 - 3 * (percentage - 30) / 40;
    b = 4 - 3 * (percentage - 30) / 40;
  } else {
    r = 238 + 17 * (percentage - 70) / 30;
    g = 252 - 252 * (percentage - 70) / 30;
    b = 0;
  }

  return Color.fromRGBO(r.round(), g.round(), b.round(), 1);
}
