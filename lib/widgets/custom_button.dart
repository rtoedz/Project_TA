// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:project_ta/core/theme/app_colors.dart';

class CustomButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final bool enabled, isOutline;
  final Color color;
  final double height;
  final double width;
  final ShadowDegree shadowDegree;
  final int duration;
  final BoxShape shape;
  final bool isLoading;
  final double? radius;
  final bool isFlatButton;
  final double topOffset;
  final double? horizontalPadding;

  const CustomButton(
      {super.key,
      required this.onPressed,
      required this.child,
      this.enabled = true,
      this.color = AppColors.tealPrimary,
      this.isOutline = false,
      this.isLoading = false,
      this.isFlatButton = false,
      this.topOffset = 5,
      this.height = 56,
      this.shadowDegree = ShadowDegree.light,
      this.width = 200,
      this.duration = 70,
      this.shape = BoxShape.rectangle,
      this.radius,
      this.horizontalPadding});

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  static const Curve _curve = Curves.easeIn;
  static const double _shadowHeight = 5;
  double _position = 5;
  static const int _animationDuration = 150;

  @override
  void initState() {
    super.initState();
    _position = widget.topOffset;
  }

  @override
  Widget build(BuildContext context) {
    _position = widget.isFlatButton ? 0 : _position;
    final double _height = widget.height - _shadowHeight;

    return AnimatedContainer(
      duration: Duration(milliseconds: _animationDuration),
      padding: widget.horizontalPadding != null
          ? EdgeInsets.symmetric(horizontal: widget.horizontalPadding ?? 0)
          : null,
      child: GestureDetector(
        onTapDown: widget.isLoading
            ? null
            : widget.enabled
                ? _pressed
                : null,
        onTapUp: widget.isLoading
            ? null
            : widget.enabled
                ? _unPressedOnTapUp
                : null,
        onTapCancel: widget.isLoading
            ? null
            : widget.enabled
                ? _unPressed
                : null,
        child: AnimatedContainer(
          duration: Duration(milliseconds: _animationDuration),
          width: widget.horizontalPadding != null
              ? widget.width - ((widget.horizontalPadding ?? 0) * 2)
              : widget.width,
          height: _height + _shadowHeight,
          child: AnimatedOpacity(
            opacity: widget.color != Colors.white
                ? widget.enabled
                    ? 1
                    : .4
                : 1,
            duration: Duration(milliseconds: _animationDuration),
            child: Stack(
              children: [
                Positioned(
                  bottom: 0,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: _animationDuration),
                    height: _height,
                    width: widget.horizontalPadding != null
                        ? widget.width - ((widget.horizontalPadding ?? 0) * 2)
                        : widget.width,
                    decoration: BoxDecoration(
                        color: widget.enabled
                            ? darken(widget.color, widget.shadowDegree)
                            : widget.color == Colors.white
                                ? Colors.grey[50]!
                                : darken(widget.color, widget.shadowDegree),
                        borderRadius: widget.shape != BoxShape.circle
                            ? BorderRadius.all(
                                Radius.circular(widget.radius ?? 16),
                              )
                            : null,
                        shape: widget.shape),
                  ),
                ),
                AnimatedPositioned(
                  curve: _curve,
                  duration: Duration(milliseconds: widget.duration),
                  bottom: _position,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: _animationDuration),
                    height: _height,
                    width: widget.horizontalPadding != null
                        ? widget.width - ((widget.horizontalPadding ?? 0) * 2)
                        : widget.width,
                    decoration: BoxDecoration(
                        color: widget.isOutline
                            ? Colors.white
                            : widget.enabled
                                ? widget.color
                                : widget.color == Colors.white
                                    ? widget.color
                                    : widget.color,
                        borderRadius: widget.shape != BoxShape.circle
                            ? BorderRadius.all(
                                Radius.circular(widget.radius ?? 16),
                              )
                            : null,
                        shape: widget.shape,
                        border: widget.isOutline
                            ? Border.all(color: widget.color, width: 2)
                            : widget.color == Colors.white
                                ? Border.all(
                                    color: widget.color == Colors.white
                                        ? Colors.grey[100]!
                                        : darken(
                                            Colors.white, widget.shadowDegree))
                                : null),
                    child: Center(
                      child: widget.isLoading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: widget.color == Colors.white
                                    ? Colors.grey
                                    : widget.isOutline
                                        ? widget.color
                                        : Colors.white,
                              ),
                            )
                          : widget.child,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _pressed(_) {
    setState(() {
      _position = 0;
    });
  }

  void _unPressedOnTapUp(_) => _unPressed();

  void _unPressed() {
    setState(() {
      _position = widget.topOffset;
    });
    widget.onPressed!();
  }
}

Color darken(Color color, ShadowDegree degree) {
  double amount = degree == ShadowDegree.dark ? 0.3 : 0.07;
  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

  return hslDark.toColor();
}

Color opacityByDisable(Color color) {
  return color.withOpacity(.5);
}

enum ShadowDegree { light, dark }
