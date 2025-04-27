import 'package:flutter/material.dart';
import 'package:nexust/core/font_awesome_flutter/lib/font_awesome_flutter.dart';

enum Method { get, post, put, patch, delete, options, head }

extension MethodExtension on Method {
  String get stringName {
    switch (this) {
      case Method.get:
        return 'GET';
      case Method.post:
        return 'POST';
      case Method.put:
        return 'PUT';
      case Method.patch:
        return 'PATCH';
      case Method.delete:
        return 'DELETE';
      case Method.options:
        return 'OPTIONS';
      case Method.head:
        return 'HEAD';
    }
  }

  IconData get icon {
    switch (this) {
      case Method.get:
        return FontAwesomeIcons.download;
      case Method.post:
        return FontAwesomeIcons.plus;
      case Method.put:
        return FontAwesomeIcons.penToSquare;
      case Method.patch:
        return FontAwesomeIcons.screwdriverWrench;
      case Method.delete:
        return FontAwesomeIcons.trash;
      case Method.options:
        return FontAwesomeIcons.sliders;
      case Method.head:
        return FontAwesomeIcons.circleInfo;
    }
  }

  Color get color {
    switch (this) {
      case Method.get:
        return Color(0xFF4CAF50);
      case Method.post:
        return Color(0xFF2196F3);
      case Method.put:
        return Color(0xFFFF9800);
      case Method.patch:
        return Color(0xFF9C27B0);
      case Method.delete:
        return Color(0xFFF44336);
      case Method.options:
        return Color(0xFF607D8B);
      case Method.head:
        return Color(0xFF795548);
    }
  }
}
