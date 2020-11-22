import 'package:flutter/material.dart';

class Lamp extends StatelessWidget {
  final double screenWidth, screenHeight;
  final Color color, gradientColor;
  final bool isSwitchOn;
  final Duration animationDuration;

  const Lamp({
    Key key,
    @required this.screenWidth,
    @required this.screenHeight,
    @required this.color,
    @required this.isSwitchOn,
    @required this.gradientColor,
    this.animationDuration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: -screenWidth * 0.95,
      top: screenHeight * 0.15,
      width: screenWidth * 2.1,
      child: ClipPath(
        clipper: TrapezoidClipper(),
        child: Column(
          children: <Widget>[
            Container(
              height: screenHeight * 0.25,
              color: color,
            ),
            AnimatedContainer(
              duration: animationDuration,
              height: screenHeight * 0.75,
              decoration: BoxDecoration(
                gradient: isSwitchOn
                    ? LinearGradient(
                        colors: [gradientColor.withOpacity(0.4), gradientColor.withOpacity(0.01)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      )
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TrapezoidClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(size.width * 0.3, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width * 0.7, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
