import 'package:allozoe_livreur/DAO/Presenters/PositionLivreurPresenter.dart';
//import 'package:allozoe_livreur/Utils/Notification.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'HomeScreen.dart';
import 'SignInScreen.dart';
import 'Utils/AppSharedPreferences.dart';

class SplashScreen extends StatefulWidget {
  final Duration duration;

  const SplashScreen({this.duration});

  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  AnimationController animationController;
  PositionLivreurPresenter _presenter;
//  NotificationPage notif;
  AppLifecycleState _stateIndex;
  bool firstCheck;
  AudioPlayer audioPlayer = new AudioPlayer();
  int stateIndex;
  bool stop;

  void goToAuthentification() {
    // lance l'espace d'authentification

    AppSharedPreferences().isAppFirstLaunch().then((bool isFirstLaunch) {
      if (isFirstLaunch) {
        AppSharedPreferences().setAppFirstLaunch(false);
        Navigator.pushReplacement(context,
            new MaterialPageRoute(builder: (BuildContext context) {
          return SignInScreen();
        }));
      } else {
        Navigator.pushReplacement(context,
            new MaterialPageRoute(builder: (BuildContext context) {
          return SignInScreen();
        }));
      }
    }, onError: (e) {
      Navigator.pushReplacement(context,
          new MaterialPageRoute(builder: (BuildContext context) {
        return SignInScreen();
      }));
    });
  }

  @override
  void initState() {
    firstCheck = true;
    stop = false;
    stateIndex = 0;
    animationController =
        new AnimationController(duration: widget.duration, vsync: this)
          ..forward()
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              AppSharedPreferences().isAppLoggedIn().then((bool is_logged) {
                if (is_logged) {
                  // on va direct a la page d'accueil

                  Navigator.pushReplacement(context,
                      new MaterialPageRoute(builder: (BuildContext context) {
                    return HomeScreen(0);
                  }));
                } else {
                  goToAuthentification();
                }
              }, onError: (e) {
                goToAuthentification();
              });
            }
          });

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _stateIndex = state;
  }

  @override
  Widget build(BuildContext context) {
    return new AnimatedBuilder(
      animation: animationController,
      builder: (context, _) {
        return Material(
            child: Image.asset(
          'images/splash_bgd.jpg',
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ));
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SplashScreen(duration: Duration(seconds: 3)),
    //home: NotificationPage(),
  ));
}
