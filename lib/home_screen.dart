import 'package:flutter/material.dart';
import 'package:sticky_arrow/constants.dart';
import 'package:sticky_arrow/modals/custom_rect.dart';
import 'package:sticky_arrow/modals/tracker_point.dart';

import 'modals/magic_arrow.dart';
import 'modals/magic_box.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, MagicBox> magicBoxes = SAConstants.defaultMagicBoxes;
  Map<String, MagicArrow> magicArrows = {"first_arrow": MagicArrow.basic(id: "first_arrow", start: const Offset(500, 200))};
  String? selectedBoxIndex;
  TrackerPoint? selectedTracker;
  String? selectedArrow;

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  onPointerDown(PointerDownEvent pointerDownEvent) {
    if (selectedArrow == null) {
      for (String key in magicBoxes.keys) {
        final MagicBox box = magicBoxes[key]!;
        if (box.boundingRect.contains(pointerDownEvent.localPosition)) {
          selectedBoxIndex = key;
          break;
        }
      }
    }
    if (selectedBoxIndex == null) {
      for (MagicArrow arrow in magicArrows.values) {
        if (arrow.start.contains(pointerDownEvent.localPosition) && (arrow.startBoxId == null || arrow.id == selectedArrow)) {
          selectedTracker = TrackerPoint(arrowID: arrow.id, type: TrackerPointType.start);
        } else if (arrow.end.contains(pointerDownEvent.localPosition) && (arrow.endBoxId == null || arrow.id == selectedArrow)) {
          selectedTracker = TrackerPoint(arrowID: arrow.id, type: TrackerPointType.end);
        }
        if (selectedTracker != null) {
          for (String key in magicBoxes.keys) {
            final MagicBox box = magicBoxes[key]!;
            if (box.trackerPoint?.arrowID == selectedTracker?.arrowID && box.trackerPoint?.type == selectedTracker?.type) {
              magicBoxes[key] = box.clearTracker();
            }
          }
        }
      }
    }
    if (selectedTracker == null && selectedArrow == null) {
      for (String key in magicArrows.keys) {
        final MagicArrow arrow = magicArrows[key]!;
        if (arrow.boundingRect.contains(pointerDownEvent.localPosition)) {
          selectedArrow = key;
          break;
        }
      }
    }
    setState(() {});
  }

  onPointerUp(PointerUpEvent pointerUpEvent) {
    if (selectedTracker != null) {
      if (magicArrows.containsKey(selectedTracker!.arrowID)) {
        for (String key in magicBoxes.keys) {
          final MagicBox box = magicBoxes[key]!;
          if (box.boundingRect.contains(pointerUpEvent.localPosition)) {
            magicBoxes[key] = box.copyWith(trackerPoint: TrackerPoint(arrowID: selectedTracker!.arrowID, type: selectedTracker!.type));
            magicArrows[selectedTracker!.arrowID] = magicArrows[selectedTracker!.arrowID]!.setBoxIdForPoint(selectedTracker!.type, key);
          }
        }
      }
    }
    setState(() {
      selectedArrow = selectedTracker?.arrowID == selectedArrow ? null : selectedArrow;
      selectedTracker = null;
      selectedBoxIndex = null;
    });
  }

  onPointerMove(PointerMoveEvent pointerMoveEvent) {
    if (selectedBoxIndex != null && magicBoxes.containsKey(selectedBoxIndex) && selectedArrow == null) {
      magicBoxes[selectedBoxIndex!] = magicBoxes[selectedBoxIndex]!.translate(pointerMoveEvent.delta);
      TrackerPoint? attachedTracker;

      if ((attachedTracker = magicBoxes[selectedBoxIndex]?.trackerPoint) != null) {
        if (magicArrows.containsKey(attachedTracker!.arrowID)) {
          magicArrows[attachedTracker.arrowID] =
              magicArrows[attachedTracker.arrowID]!.translateByPointType(pointerMoveEvent.delta, attachedTracker.type);
        }
      }
    }

    if (selectedTracker != null && magicArrows.containsKey(selectedTracker?.arrowID)) {
      if (selectedTracker!.type == TrackerPointType.start) {
        magicArrows[selectedTracker!.arrowID] =
            magicArrows[selectedTracker!.arrowID]!.translateByPointType(pointerMoveEvent.delta, TrackerPointType.start);
      } else {
        magicArrows[selectedTracker!.arrowID] =
            magicArrows[selectedTracker!.arrowID]!.translateByPointType(pointerMoveEvent.delta, TrackerPointType.end);
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Listener(
        onPointerDown: onPointerDown,
        onPointerMove: onPointerMove,
        onPointerUp: onPointerUp,
        child: Container(
          width: screenSize.width,
          height: screenSize.height,
          decoration: const BoxDecoration(gradient: SAConstants.gradient),
          child: Center(
            child: Stack(
              children: [
                ...magicBoxes.values.map((e) => Positioned(top: e.positionY, left: e.positionX, child: e.preview())).toList(),
                Positioned(
                  top: 0,
                  left: 0,
                  child: CustomPaint(
                    isComplex: true,
                    painter: _MagicCustomPainter(magicArrows: magicArrows, magicBoxes: magicBoxes, selectedArrow: selectedArrow),
                  ),
                ),
                const Positioned(
                    top: 20,
                    right: 20,
                    child: Text("Click on line to adjust reference points",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),)),
                const Positioned(
                    bottom: 20,
                    right: 20,
                    child: Text("@retroportalstudio",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final Paint interactionPaint = Paint()
  ..color = Colors.white
  ..style = PaintingStyle.fill;

class _MagicCustomPainter extends CustomPainter {
  final Map<String, MagicBox> magicBoxes;
  final Map<String, MagicArrow> magicArrows;
  final String? selectedArrow;

  _MagicCustomPainter({required this.magicBoxes, required this.magicArrows, required this.selectedArrow});

  @override
  void paint(Canvas canvas, Size size) {
    for (MagicArrow arrow in magicArrows.values) {
      final Path path = Path();
      Offset arrowStatPoint = arrow.start.center;
      Offset arrowEndPoint = arrow.end.center;
      if (arrow.startBoxId != null && selectedArrow != arrow.id) {
        MagicBox? startBox;
        if ((startBox = magicBoxes[arrow.startBoxId]) != null) {
          Offset? interactionPoint = arrow.interactionPointWithRect(startBox!.boundingRect, arrow.end.center);
          if (interactionPoint != null) {
            arrowStatPoint = interactionPoint;
            canvas.drawCircle(interactionPoint, arrow.start.width / 2, interactionPaint);
          }
        }
      }
      if (arrow.endBoxId != null && selectedArrow != arrow.id) {
        MagicBox? startBox;
        if ((startBox = magicBoxes[arrow.endBoxId]) != null) {
          Offset? interactionPoint = arrow.interactionPointWithRect(startBox!.boundingRect, arrow.start.center);
          if (interactionPoint != null) {
            arrowEndPoint = interactionPoint;
            canvas.drawCircle(interactionPoint, arrow.end.width / 2, interactionPaint);
          }
        }
      }

      CustomRect rect = (arrow.startBoxId == null && arrow.endBoxId == null)
          ? arrow.boundingRect
          : CustomRect.fromLine(arrowStatPoint, arrowEndPoint, MagicArrow.width);
      path.moveTo(rect.topLeft.dx, rect.topLeft.dy);
      path.lineTo(rect.topRight.dx, rect.topRight.dy);
      path.lineTo(rect.bottomRight.dx, rect.bottomRight.dy);
      path.lineTo(rect.bottomLeft.dx, rect.bottomLeft.dy);
      path.close();
      canvas.drawPath(
          path,
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.fill);

      canvas.drawCircle(arrowStatPoint, arrow.start.width / 2, interactionPaint);

      canvas.drawCircle(arrowEndPoint, arrow.start.width / 2, interactionPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
