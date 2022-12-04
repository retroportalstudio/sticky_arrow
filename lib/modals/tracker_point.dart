import 'package:flutter/material.dart';

enum TrackerPointType { start, end  }

class TrackerPoint {
  final String arrowID;
  final TrackerPointType type;

  const TrackerPoint({
    required this.arrowID,
    required this.type,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is TrackerPoint && runtimeType == other.runtimeType && arrowID == other.arrowID && type == other.type;

  @override
  int get hashCode => arrowID.hashCode ^ type.hashCode;
}
