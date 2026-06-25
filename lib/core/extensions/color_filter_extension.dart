import 'package:flutter/material.dart';

extension ColorFilterExtention on Color {
  ColorFilter toColorFilter({BlendMode mode = BlendMode.srcIn}) {
    return ColorFilter.mode(this, mode);
  }
}
