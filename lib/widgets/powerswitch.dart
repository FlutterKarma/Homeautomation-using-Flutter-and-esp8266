import 'package:flutter/material.dart';

import 'living_home/living_home_page.dart';

class PowerSwitch extends StatefulWidget {
  @override
  _PowerSwitchState createState() => _PowerSwitchState();
}

class _PowerSwitchState extends State<PowerSwitch> {
  Color currentColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return LivingHomePage();
  }
}
