import 'package:flutter/material.dart';
import 'package:sticky_arrow/modals/tracker_point.dart';

class MagicBox {
  final String id;
  final TrackerPoint? trackerPoint;
  final Size boxSize;
  final Offset position;
  final double borderRadius;
  final Widget child;
  late final Rect boundingRect;

  MagicBox(
      {Key? key,
      required this.id,
      this.borderRadius = 0,
      required this.child,
      required this.position,
      this.boxSize = const Size(200, 200),
      this.trackerPoint}) {
    boundingRect = Rect.fromCenter(center: position, width: boxSize.width, height: boxSize.height);
  }

  MagicBox clearTracker() {
    return MagicBox(id: id, child: child, position: position, borderRadius: borderRadius, trackerPoint: null, boxSize: boxSize);
  }

  double get positionY => position.dy - boxSize.height / 2;

  double get positionX => position.dx - boxSize.width / 2;

  MagicBox translate(Offset delta) {
    return copyWith(position: position.translate(delta.dx, delta.dy));
  }

  Widget preview() {
    if (borderRadius > 0) {
      return SizedBox(width: boxSize.width, height: boxSize.height, child: Center(child: child));
    }
    return SizedBox(width: boxSize.width, height: boxSize.height, child: Center(child: child));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MagicBox &&
          runtimeType == other.runtimeType &&
          trackerPoint == other.trackerPoint &&
          boxSize == other.boxSize &&
          position == other.position &&
          borderRadius == other.borderRadius &&
          child == other.child &&
          boundingRect == other.boundingRect;

  @override
  int get hashCode => trackerPoint.hashCode ^ boxSize.hashCode ^ position.hashCode ^ borderRadius.hashCode ^ child.hashCode ^ boundingRect.hashCode;

  MagicBox copyWith({
    TrackerPoint? trackerPoint,
    Size? boxSize,
    Offset? position,
    double? borderRadius,
    Widget? child,
  }) {
    return MagicBox(
      trackerPoint: trackerPoint ?? this.trackerPoint,
      boxSize: boxSize ?? this.boxSize,
      position: position ?? this.position,
      borderRadius: borderRadius ?? this.borderRadius,
      child: child ?? this.child,
      id: id,
    );
  }
}
