import 'package:flutter/material.dart';
import 'package:homeautomation/widgets/living_home/living_home_page.dart';
import 'package:homeautomation/widgets/powerswitch.dart';
import 'package:shared_preferences/shared_preferences.dart';

void snackBarMessage(BuildContext context, String message) {
  Scaffold.of(context).removeCurrentSnackBar();
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text(message),
  ));
}

void main() =>
    runApp(MaterialApp(debugShowCheckedModeBanner: false, home: RemotePage()));

// Entry-Page
class RemotePage extends StatefulWidget {
  @override
  _RemotePageState createState() => _RemotePageState();
}

class _RemotePageState extends State<RemotePage> {
  TextEditingController _c;
  @override
  void initState() {
    super.initState();
    getControllers();
    _c = TextEditingController();
  }

  List<String> conList;
  String selectedDevice;

  void getControllers() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("conList") && prefs.containsKey("lastDevice")) {
      setState(() {
        conList = prefs.getStringList("conList");
        selectedDevice = prefs.getString("lastDevice");
      });
    } else {
      setState(() {
        conList = [];
        selectedDevice = null;
      });
    }
  }

  void saveDevices() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList("conList", conList);
    prefs.setString("lastDevice", selectedDevice);
  }

  Widget deviceDropDown() {
    if (selectedDevice != null && conList != null) {
      return DropdownButton<String>(
        icon: Icon(
          Icons.arrow_downward,
          color: Colors.amber,
        ),
        underline: Container(
          height: 0,
        ),
        dropdownColor: Colors.grey,
        value: selectedDevice,
        style: TextStyle(fontSize: 18, color: Colors.white),
        onChanged: (String newDevice) {
          setState(() {
            selectedDevice = newDevice;
            saveDevices();
          });
        },
        items: conList.map<DropdownMenuItem<String>>((String device) {
          return DropdownMenuItem<String>(
            value: device,
            child: Text(
              device,
            ),
          );
        }).toList(),
      );
    } else if (conList == null) {
      return Row(
        children: [
          Text(
            "loading devices",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          SizedBox(
            width: 5,
          )
        ],
      );
      // conList.isEmpty
    } else {
      return Row(
        children: [
          Text(
            "add your first device",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          SizedBox(
            width: 5,
          )
        ],
      );
    }
  }

  // Managing devices

  String lastRemovedDevice;

  void undoRemoveDevice(BuildContext context) {
    if (lastRemovedDevice != null) {
      setState(() {
        conList.add(lastRemovedDevice);
        selectedDevice = lastRemovedDevice;
      });
      saveDevices();
      snackBarMessage(context, "readded $lastRemovedDevice");
      lastRemovedDevice = null;
    } else {
      snackBarMessage(context, "nothing to readd");
    }
  }

  void removeDevice(BuildContext context) {
    int conListLength = conList.length;
    if (conListLength == 0) {
      snackBarMessage(context, "no devices to remove");
    } else if (conListLength == 1) {
      setState(() {
        conList = [];
        selectedDevice = null;
      });
      saveDevices();
      snackBarMessage(context, "removed last device");
    } else {
      lastRemovedDevice = selectedDevice;
      setState(() {
        conList.remove(selectedDevice);
        selectedDevice = conList[0];
      });
      saveDevices();
      snackBarMessage(context, "removed $lastRemovedDevice");
    }
  }

  void addDevice() {
    showDialog(
      context: context,
      child: AlertDialog(
        contentTextStyle: TextStyle(color: Colors.amberAccent),
        backgroundColor: Colors.black,
        actions: <Widget>[
          FlatButton(
              child: const Text(
                'cancel',
                style: TextStyle(color: Colors.amberAccent),
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          FlatButton(
              child: const Text(
                'add',
                style: TextStyle(color: Colors.amberAccent),
              ),
              onPressed: () {
                setState(() {
                  conList.add(_c.text);
                  selectedDevice = conList.last;
                  saveDevices();
                });
                _c.clear();
                Navigator.pop(context);
              })
        ],
        contentPadding: const EdgeInsets.all(16.0),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TextField(
                  controller: _c,
                  cursorColor: Colors.amberAccent,
                  style: TextStyle(color: Colors.white),
                  autofocus: true,
                  decoration: InputDecoration(
                      labelText: "IP-Adress",
                      labelStyle: TextStyle(color: Colors.amberAccent))),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          actions: [
            Center(child: deviceDropDown()),
            Builder(
              builder: (context) => GestureDetector(
                child: Icon(Icons.add, color: Colors.amber),
                onTap: () {
                  addDevice();
                },
                onLongPress: () {
                  removeDevice(context);
                },
                onDoubleTap: () {
                  undoRemoveDevice(context);
                },
              ),
            ),
          ],
          elevation: 0,
          title: Text(
            "LIGHT BULB",
            style: TextStyle(color: Colors.amber),
          ),
          backgroundColor: Colors.black,
        ),
        body: LivingHomePage(
          selectedDevice: selectedDevice,
        ),
      ),
    );
  }
}
