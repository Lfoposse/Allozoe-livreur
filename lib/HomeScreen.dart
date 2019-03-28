import 'dart:async';

import 'package:allozoe_livreur/Accueil/Accueil.dart';
import 'package:allozoe_livreur/Accueil/CommandeRefresh.dart';
import 'package:allozoe_livreur/Accueil/Profil.dart';
import 'package:allozoe_livreur/Database/DatabaseHelper.dart';
import 'package:allozoe_livreur/Models/Commande.dart';
import 'package:allozoe_livreur/Utils/AppBars.dart';
import 'package:allozoe_livreur/Utils/Notification_util.dart';
import 'package:allozoe_livreur/Utils/map_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';

class HomeScreen extends StatefulWidget {
  int notif;
  HomeScreen(this.notif);
  @override
  createState() => new HomeStateScreen();
}

class HomeStateScreen extends State<HomeScreen> {
  int space_index = 0;
  Commande cmd;
  var mapUtil = new MapUtil();
  var notif = NotificationUtil();
  Timer timer;
  @override
  void initState() {
    super.initState();
    new DatabaseHelper().clearNotif();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    timer =
        Timer.periodic(Duration(seconds: 30), (Timer t) => notif.init(context));
    mapUtil.init(context);
  }

  @override
  dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  Widget getAppropriateScreen() {
    //_showWeightPicker();
    switch (space_index) {
      case 2:
        {
          // zone de consultation des commandes effectuees et de leur status
          new DatabaseHelper().clearNotif();
          return CommandeRefresh();
        }

      case 3: // zone de modification du profil
        {
          new DatabaseHelper().clearNotif();
          return Profil();
        }

      case 0:
        {
          // zone d'accueil
          new DatabaseHelper().clearNotif();
          return Accueil(null);
        }

      default:
        {
          // zone d'accueil
          new DatabaseHelper().clearNotif();
          return Accueil(null);
        }
    }
  }

  bool isSelectedButton(int index) {
    return space_index == index;
  }

  PositionedTapDetector buildButtonColumn(
      IconData icon, String label, bool selected_button, int button_index) {
    Color selected_color = Colors.lightGreen;
    Color color = Colors.black;

    return PositionedTapDetector(
        onTap: (position) {
          setState(() {
            space_index = button_index;
          });
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: selected_button ? selected_color : color),
            Container(
              margin: const EdgeInsets.only(top: 4.0, bottom: 4.0),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w400,
                  color: selected_button ? selected_color : color,
                ),
              ),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    Widget buttonSection = Container(
      padding: EdgeInsets.only(top: 5.0, bottom: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildButtonColumn(Icons.home, 'Accueil', isSelectedButton(0), 0),
          buildButtonColumn(Icons.list, 'Commandes', isSelectedButton(2), 2),
          buildButtonColumn(Icons.person, 'Profil', isSelectedButton(3), 3),
        ],
      ),
    );

    return Material(
      child: Column(
        children: <Widget>[
          HomeAppBar(extraHeight: 0.0),
          Expanded(
            child: getAppropriateScreen(),
          ),
          buttonSection
        ],
      ),
    );
  }
}
