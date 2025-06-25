// lib/utils/brightness_detector.dart
import 'package:flutter/material.dart';
import 'package:light/light.dart';

class BrightnessDetector extends StatefulWidget {
  final Widget Function(bool isDark) builder;

  const BrightnessDetector({super.key, required this.builder});

  @override
  State<BrightnessDetector> createState() => _BrightnessDetectorState();
}

class _BrightnessDetectorState extends State<BrightnessDetector> {
  late Light _light;
  late Stream<int> _lightStream;
  bool _isDark = false;

  @override
  void initState() {
    super.initState();
    _light = Light();
    _lightStream = _light.lightSensorStream;
    _lightStream.listen((luxValue) {
      setState(() {
        _isDark = luxValue < 10; // You can tweak this threshold
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(_isDark);
  }
}
