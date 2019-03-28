
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';


class GpgUtils {
  GpsUtilListener listener;

  GpgUtils(this.listener);
  var geolocator = Geolocator();
  var locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
  Position _position;
  void init() {
    initPlatformState();

   /* StreamSubscription<Position> positionStream = geolocator.getPositionStream(locationOptions).listen(
            (Position position) {
              listener.onLocationChange(_position);
          print(_position == null ? 'Unknown' : _position.latitude.toString() + ', ' + _position.longitude.toString());
        });*/
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    //Geolocator geolocator = Geolocator()..forceAndroidLocationManager = true;
    GeolocationStatus geolocationStatus  = await Geolocator().checkGeolocationPermissionStatus();

    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    listener.onLocationChange(position);
  }
}

abstract class GpsUtilListener {
  onLocationChange(Position position);
}