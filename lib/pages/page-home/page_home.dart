import 'package:flutter/material.dart';

import '../../constants/themes-color.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          iconTheme: IconThemeData(color: ColorPalette.themeColor),
          backgroundColor: Colors.white,
          title: Text(
            "Home",
            style: TextStyle(
                color: ColorPalette.themeColor, fontWeight: FontWeight.bold),
          )),
    );
  }
}
