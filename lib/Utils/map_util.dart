import 'package:allozoe_livreur/DAO/Presenters/PositionLivreurPresenter.dart';
import 'package:allozoe_livreur/Database/DatabaseHelper.dart';
import 'package:allozoe_livreur/Models/Client.dart';
import 'package:allozoe_livreur/Utils/AppSharedPreferences.dart';
import 'package:allozoe_livreur/Utils/Notification.dart';
import 'package:allozoe_livreur/Utils/gps_util.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class MapUtil extends StatefulWidget
    with WidgetsBindingObserver
    implements GpsUtilListener {
  //var location = new Location(0.0, 0.0);
  GpgUtils gpgUtils;
  NotificationPage notif;
  MapUtil();
  BuildContext context;
  PositionLivreurPresenter _presenter;
  AppLifecycleState _stateIndex;
  AudioPlayer audioPlayer = new AudioPlayer();

  init(BuildContext context) {
    this.context = context;

    gpgUtils = new GpgUtils(this);
    gpgUtils.init();
    _presenter = new PositionLivreurPresenter();
    new DatabaseHelper().getClient().then((List<Client> c) {
      if (c == null || c.length == 0)
        return null;
      else
        _presenter.UpdatePosition(c[0].id, 0.0, 0.0);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _stateIndex = state;
    AppSharedPreferences().setState(state.toString());
    print(_stateIndex);
  }

  @override
  onLocationChange(Position currentLocation) {
    new DatabaseHelper().getClient().then((List<Client> c) {
      if (c == null || c.length == 0)
        return null;
      else
        _presenter.UpdatePosition(
            c[0].id, currentLocation.latitude, currentLocation.longitude);
    });
    print("logitude:" +
        currentLocation.latitude.toString() +
        "laltidude :" +
        currentLocation.longitude.toString());
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return null;
  }
}
