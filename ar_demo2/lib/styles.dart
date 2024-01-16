import 'package:flutter/material.dart';

class Styles {
  static const _textSizeLarge = 24.0;
  static const _textSizeDefault = 16.0;
  static final Color _textColorStrong = _hexToColor('000000');
  static final Color _textColorDefault = _hexToColor('666666');
  static const String _fontNameDefault = 'Lemon';

  static const headerLarge = TextStyle(
      fontSize: 24.0,
      fontFamily: _fontNameDefault,
      fontWeight: FontWeight.bold,
      color: Colors.blue);

  static final textDefault = TextStyle(
      fontSize: _textSizeDefault,
      fontFamily: _fontNameDefault,
      color: _textColorDefault);
  static Color _hexToColor(String code) {
    return Color(int.parse(code.substring(0, 6), radix: 16) + 0xFF000000);
  }
}
