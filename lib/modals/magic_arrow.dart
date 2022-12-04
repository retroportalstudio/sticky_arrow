import 'package:flutter/material.dart';
import 'package:sticky_arrow/modals/custom_rect.dart';
import 'package:sticky_arrow/modals/tracker_point.dart';
import 'package:sticky_arrow/utils/canvas_math.dart';

class MagicArrow {
  static const double width = 5;
  static const double interactionPointSize = 20;

  final String id;
  final Rect start;

  final String? startBoxId, endBoxId;
  final Rect end;
  final CustomRect boundingRect;

  const MagicArrow({required this.id, required this.start, required this.end, this.startBoxId, this.endBoxId, required this.boundingRect});

  factory MagicArrow.basic({required String id, required Offset start}) {
    final Offset defaultEnd = start.translate(0, 100);
    return MagicArrow(
        id: id,
        start: Rect.fromCenter(center: start, width: interactionPointSize, height: interactionPointSize),
        end: Rect.fromCenter(center: defaultEnd, width: interactionPointSize, height: interactionPointSize),
        boundingRect: CustomRect.fromLine(start, defaultEnd, width));
  }

  Offset getPointByType(TrackerPointType type) {
    if (type == TrackerPointType.start) {
      return start.center;
    }
    return end.center;
  }

  MagicArrow setBoxIdForPoint(TrackerPointType type, String id) {
    if (type == TrackerPointType.start) {
      return copyWith(startBoxId: id);
    }
    return copyWith(endBoxId: id);
  }

  Offset? interactionPointWithRect(Rect boxRect, Offset outsidePoint) {
    return CanvasMath.interactionPointWithRect(boxRect, start.center, end.center, outsidePoint);
  }

  MagicArrow translateByPointType(Offset delta, TrackerPointType type) {
    if (type == TrackerPointType.start) {
      return _translateStart(delta);
    }
    return _translateEnd(delta);
  }

  MagicArrow _translateStart(Offset delta) {
    final Offset translatedStart = start.center.translate(delta.dx, delta.dy);

    return copyWith(
        start: Rect.fromCenter(center: translatedStart, width: interactionPointSize, height: interactionPointSize),
        boundingRect: CustomRect.fromLine(translatedStart, end.center, width));
  }

  MagicArrow _translateEnd(Offset delta) {
    final Offset translatedEnd = end.center.translate(delta.dx, delta.dy);

    return copyWith(
        end: Rect.fromCenter(center: translatedEnd, width: interactionPointSize, height: interactionPointSize),
        boundingRect: CustomRect.fromLine(start.center, translatedEnd, width));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MagicArrow &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          start == other.start &&
          startBoxId == other.startBoxId &&
          endBoxId == other.endBoxId &&
          end == other.end;

  @override
  int get hashCode => id.hashCode ^ start.hashCode ^ startBoxId.hashCode ^ endBoxId.hashCode ^ end.hashCode;

  MagicArrow copyWith({
    String? id,
    Rect? start,
    String? startBoxId,
    String? endBoxId,
    Rect? end,
    CustomRect? boundingRect,
  }) {
    return MagicArrow(
      id: id ?? this.id,
      start: start ?? this.start,
      startBoxId: startBoxId ?? this.startBoxId,
      endBoxId: endBoxId ?? this.endBoxId,
      end: end ?? this.end,
      boundingRect: boundingRect ?? this.boundingRect,
    );
  }
}
