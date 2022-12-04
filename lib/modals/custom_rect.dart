import 'package:flutter/material.dart';
import 'package:sticky_arrow/utils/canvas_math.dart';

class CustomRect {
  final Offset topLeft, topRight, bottomLeft, bottomRight;

  const CustomRect({
    required this.topLeft,
    required this.topRight,
    required this.bottomLeft,
    required this.bottomRight,
  });

  factory CustomRect.fromLine(Offset start, Offset end, double width) {
    return CanvasMath.getCustomRectFromLine(start, end, width);
  }

  bool contains(Offset point) {
    return CanvasMath.pointInRectangle(point, this);
  }


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomRect &&
          runtimeType == other.runtimeType &&
          topLeft == other.topLeft &&
          topRight == other.topRight &&
          bottomLeft == other.bottomLeft &&
          bottomRight == other.bottomRight;

  @override
  int get hashCode => topLeft.hashCode ^ topRight.hashCode ^ bottomLeft.hashCode ^ bottomRight.hashCode;

  CustomRect copyWith({
    Offset? topLeft,
    Offset? topRight,
    Offset? bottomLeft,
    Offset? bottomRight,
  }) {
    return CustomRect(
      topLeft: topLeft ?? this.topLeft,
      topRight: topRight ?? this.topRight,
      bottomLeft: bottomLeft ?? this.bottomLeft,
      bottomRight: bottomRight ?? this.bottomRight,
    );
  }
}
