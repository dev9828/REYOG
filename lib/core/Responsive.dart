import 'dart:math';
import 'package:flutter/widgets.dart';

class Responsive {
  final BuildContext context;
  static const double _baseWidth =
      390.0; // design width (adjust if your design uses different)
  static const double _baseHeight = 844.0; // design height

  Responsive._(this.context);

  factory Responsive.of(BuildContext context) => Responsive._(context);

  double get w => MediaQuery.of(context).size.width;
  double get h => MediaQuery.of(context).size.height;
  double get _scaleW => w / _baseWidth;
  double get _scaleH => h / _baseHeight;
  double get _scale => min(_scaleW, _scaleH);

  /// responsive width from design px
  double rw(double px) => px * _scaleW;

  /// responsive height from design px
  double rh(double px) => px * _scaleH;

  /// responsive font size from design px (scaled using min)
  double sp(double px) => px * _scale;
}

/// Useful extensions to call inline: 16.rw(context) etc.
extension RExt on num {
  double rw(BuildContext c) => Responsive.of(c).rw(toDouble());
  double rh(BuildContext c) => Responsive.of(c).rh(toDouble());
  double sp(BuildContext c) => Responsive.of(c).sp(toDouble());
}

/// A small wrapper to center & constrain very wide screens (web/tablet)
class ResponsiveWrapper extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  const ResponsiveWrapper(
      {super.key, required this.child, this.maxWidth = 520});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
