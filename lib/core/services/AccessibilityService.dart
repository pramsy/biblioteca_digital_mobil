import 'package:flutter/rendering.dart';

class AccessibilityService {
  static const double minTouchTargetSize = 48.0;

  static SemanticsProperties getSemanticProperties(String label) {
    return SemanticsProperties(
      label: label,
      enabled: true,
    );
  }
}
