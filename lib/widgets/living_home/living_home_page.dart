import 'dart:io';

import 'package:flutter/material.dart';
import 'package:homeautomation/utility/utilitys.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'LEDBulb.dart';
import 'lamp.dart';
import 'lamp_hanger_rope.dart';
import 'lamp_switch.dart';
import 'lamp_switch_rope.dart';
import 'room_name.dart';

final darkGray = const Color(0xFF232323);
final bulbOnColor = const Color(0xFFFFE12C);
final bulbOffColor = const Color(0xFFC1C1C1);
final animationDuration = const Duration(milliseconds: 500);

class LivingHomePage extends StatefulWidget {
  final String selectedDevice;
  LivingHomePage({Key key, this.selectedDevice})
      : super(
          key: key,
        );
  @override
  _LivingHomePageState createState() => _LivingHomePageState();
}

class _LivingHomePageState extends State<LivingHomePage> {
  var _isSwitchOn = false;
  Color currentColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    void turnDeviceOn() async {
      setStatus(context, widget.selectedDevice, 1);
      snackBarMessage(context, "Turned on ${widget.selectedDevice}");
    }

    void turnDeviceOff() async {
      setStatus(context, widget.selectedDevice, 0);

      snackBarMessage(context, "Connection Error");
    }

    return Stack(
      children: <Widget>[
        LampHangerRope(
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            color: darkGray),
        LEDBulb(
          screenWidth: screenWidth,
          screenHeight: screenHeight,
          onColor: bulbOnColor,
          offColor: bulbOffColor,
          isSwitchOn: _isSwitchOn,
        ),
        Lamp(
          screenWidth: screenWidth,
          screenHeight: screenHeight,
          color: darkGray,
          isSwitchOn: _isSwitchOn,
          gradientColor: bulbOnColor,
          animationDuration: animationDuration,
        ),
        LampSwitch(
          screenWidth: screenWidth,
          screenHeight: screenHeight,
          toggleOnColor: bulbOnColor,
          toggleOffColor: bulbOffColor,
          color: darkGray,
          isSwitchOn: _isSwitchOn,
          onTap: () {
            if (_isSwitchOn == true) {
              turnDeviceOff();
            } else {
              turnDeviceOn();
            }

            setState(() {
              _isSwitchOn = !_isSwitchOn;
            });
          },
          animationDuration: animationDuration,
        ),
        LampSwitchRope(
          screenWidth: screenWidth,
          screenHeight: screenHeight,
          color: darkGray,
          isSwitchOn: _isSwitchOn,
          animationDuration: animationDuration,
        ),
        RoomName(
          screenWidth: screenWidth,
          screenHeight: screenWidth,
          color: darkGray,
          roomName: "living room",
        ),
      ],
    );
  }
}
