import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

typedef CustomGestureCallback = void Function(Offset offset);

class CustomGestureRecognizer extends OneSequenceGestureRecognizer {
  final CustomGestureCallback onPanStart;
  final CustomGestureCallback onPanUpdate;
  final CustomGestureCallback onPanEnd;
  final CustomGestureCallback onTap;

  bool _isPan = false;

  CustomGestureRecognizer({
    this.onPanStart,
    this.onPanUpdate,
    this.onPanEnd,
    this.onTap,
  });

  @override
  void addPointer(PointerEvent event) {
    if (onPanStart != null || onPanUpdate != null || onPanEnd != null || onTap != null) {
      startTrackingPointer(event.pointer);
      resolve(GestureDisposition.accepted);
    } else {
      stopTrackingPointer(event.pointer);
    }
  }

  @override
  void handleEvent(PointerEvent event) {
    if (event is PointerDownEvent) {
      if (onPanStart != null) {
        onPanStart(event.localPosition);
      }
    } else if (event is PointerMoveEvent) {
      if (!_isPan) {
        _isPan = true;
      }
      if (onPanUpdate != null) {
        onPanUpdate(event.localPosition);
      }
    } else if (event is PointerUpEvent) {
      if (!_isPan && onTap != null) {
        onTap(event.localPosition);
      }
      if (onPanEnd != null) {
        onPanEnd(event.localPosition);
      }
      _isPan = false;
      stopTrackingPointer(event.pointer);
    }
  }

  @override
  String get debugDescription => 'custom-gesture';

  @override
  void didStopTrackingLastPointer(int pointer) {}
}
