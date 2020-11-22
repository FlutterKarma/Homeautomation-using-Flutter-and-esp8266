import 'package:flutter/material.dart';

class LEDBulb extends StatelessWidget {
  final double screenWidth, screenHeight;
  final Color color, onColor, offColor;
  final bool isSwitchOn;
  final Duration animationDuration = const Duration(milliseconds: 4000);

  const LEDBulb(
      {Key key, this.screenWidth, this.screenHeight, this.color, this.onColor, this.offColor, this.isSwitchOn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: screenWidth * 0.1,
      top: screenHeight * 0.35,
      child: AnimatedContainer(
        duration: animationDuration,
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSwitchOn ? onColor : offColor,
        ),
      ),
    );
  }
}
