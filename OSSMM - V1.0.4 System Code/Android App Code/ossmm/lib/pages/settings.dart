// Import packages
import 'dart:async';
import 'package:flutter/material.dart';

/* ----------------------------------------------------------------
    Create 'Settings' Class
   ----------------------------------------------------------------
*/
class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth Settings'),
      ),
      body: ListView(
        children: const <Widget>[
          Divider(),
          ListTile(title: Center(
            child: Text(
                'Bluetooth Connection Settings',
                style: TextStyle(fontWeight: FontWeight.bold)
            ),
          )),
        ],
      ),
    );
  }

}

