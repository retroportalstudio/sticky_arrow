import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sticky_arrow/modals/custom_rect.dart';

class CanvasMath {
  static double distanceBetweenPoints(Offset point1, Offset point2) {
    return sqrt((pow(point2.dx - point1.dx, 2) + pow(point2.dy - point1.dy, 2)).toDouble());
  }


  static CustomRect getCustomRectFromLine(Offset start, Offset end, double height) {
    double halfHeight = height / 2;
    double slope = -(end.dx - start.dx) / (end.dy - start.dy);
    double topT = -halfHeight / sqrt(1 + pow(slope, 2));
    double bottomT = halfHeight / sqrt(1 + pow(slope, 2));
    return CustomRect(
        topLeft: Offset(start.dx + topT, start.dy + (slope * topT)),
        topRight: Offset(end.dx + topT, end.dy + (slope * topT)),
        bottomLeft: Offset(start.dx + bottomT, start.dy + (slope * bottomT)),
        bottomRight: Offset(end.dx + bottomT, end.dy + (slope * bottomT)));
  }

  static Offset? interactionPointWithRect(Rect rect, Offset lineStart, Offset lineEnd, Offset outsidePoint) {
    final double distance = distanceBetweenPoints(lineStart, lineEnd);
    List<List<Offset>> sides = [
      [rect.topLeft, rect.topRight],
      [rect.topRight, rect.bottomRight],
      [rect.bottomRight, rect.bottomLeft],
      [rect.bottomLeft, rect.topLeft]
    ];
    for (List<Offset> lineOne in sides) {
      Offset lineOneStart = lineOne[0];
      Offset lineOneEnd = lineOne[1];

      double a1 = lineOneEnd.dy - lineOneStart.dy;
      double b1 = lineOneStart.dx - lineOneEnd.dx;
      double c1 = a1 * (lineOneStart.dx) + b1 * (lineOneStart.dy);

      double a2 = lineEnd.dy - lineStart.dy;
      double b2 = lineStart.dx - lineEnd.dx;
      double c2 = a2 * (lineStart.dx) + b2 * (lineStart.dy);

      double determinant = a1 * b2 - a2 * b1;
      if (determinant != 0) {
        double x = (b2 * c1 - b1 * c2) / determinant;
        double y = (a1 * c2 - a2 * c1) / determinant;
        Offset interactionPoint = Offset(x, y);
        final double distanceNew = distanceBetweenPoints(outsidePoint, interactionPoint);
        if (rect.inflate(2.0).contains(interactionPoint) && distanceNew < distance) {
          return interactionPoint;
        }
      }
    }
    return null;
  }

  static bool pointInRectangle(Offset m, CustomRect r) {
    Offset ab = vector(r.bottomLeft, r.topLeft);
    Offset ad = vector(r.bottomLeft, r.bottomRight);
    Offset am = vector(r.bottomLeft, m);
    var dotAMAB = dot(am, ab);
    var dotABAB = dot(ab, ab);
    var dotAMAD = dot(am, ad);
    var dotADAD = dot(ad, ad);

    return 0 <= dotAMAB && dotAMAB <= dotABAB && 0 <= dotAMAD && dotAMAD <= dotADAD;
  }

  static Offset vector(Offset p1, Offset p2) {
    return Offset((p2.dx - p1.dx), (p2.dy - p1.dy));
  }

  static double dot(Offset u, Offset v) {
    return u.dx * v.dx + u.dy * v.dy;
  }
}
