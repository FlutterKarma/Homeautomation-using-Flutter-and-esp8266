import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void snackBarMessage(BuildContext context, String message) {
  Scaffold.of(context).removeCurrentSnackBar();
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text(message),
  ));
}

void setStatus(BuildContext context, String selectedDevice, int value) async {
  try {
    var res = await http.post("http://$selectedDevice/status", body: {
      "bulb": value.toString(),
    });
    if (res.statusCode != 200) {
      snackBarMessage(context, "Device Error setting color");
    }
  } on SocketException {
    snackBarMessage(context, "Connection Error");
  }
}
