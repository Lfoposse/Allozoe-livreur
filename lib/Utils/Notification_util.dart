import 'dart:io';

import 'package:allozoe_livreur/DAO/Presenters/PositionLivreurPresenter.dart';
import 'package:allozoe_livreur/Database/DatabaseHelper.dart';
import 'package:allozoe_livreur/Models/Client.dart';
import 'package:allozoe_livreur/Models/Commande.dart';
import 'package:allozoe_livreur/Models/CommandeNotif.dart';
import 'package:allozoe_livreur/NotificationScreen.dart';
import 'package:allozoe_livreur/Utils/AppSharedPreferences.dart';
import 'package:allozoe_livreur/Utils/Notification.dart';
import 'package:allozoe_livreur/Utils/gps_util.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class NotificationUtil extends StatefulWidget with WidgetsBindingObserver {
  //var location = new Location(0.0, 0.0);
  GpgUtils gpgUtils;
  NotificationPage notif;
  NotificationUtil();
  BuildContext context;
  PositionLivreurPresenter _presenter;
  AppLifecycleState _stateIndex;
  AudioPlayer audioPlayer = new AudioPlayer();
  String mp3Uri;
  AudioPlayer audioPlugin = AudioPlayer();
  init(BuildContext context) {
    this.context = context;
    WidgetsBinding.instance.addObserver(this);
    _presenter = new PositionLivreurPresenter();
    _load();
    notification();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _stateIndex = state;
    AppSharedPreferences().setState(state.toString());
    print(_stateIndex);
  }

  notification() {
    print("timer");
    WidgetsBinding.instance.addObserver(this);
    _presenter = new PositionLivreurPresenter();
    print(_stateIndex);
    new DatabaseHelper().getClient().then((List<Client> c) {
      if (c == null || c.length == 0)
        return null;
      else {
        _presenter.checkCommande(c[0].id).then((List<Commande> cmd) {
          var Body;
          //new DatabaseHelper().clearNotif();
          if (cmd != null && cmd.length > 0) {
            Body = "Vous avez " +
                cmd.length.toString() +
                " proposition(s) de commande(s)";

            new DatabaseHelper()
                .loadCommande()
                .then(((List<CommandeNotif> notif) {
              // print("notification :"+notif.length.toString());
              if (notif.length <= 0) {
                for (int i = 0; i < cmd.length; i++) {
                  new DatabaseHelper().savenotif(cmd[i]);
                }
                if (_stateIndex == AppLifecycleState.paused) {
                  print("pause");
                  notifCommande('Nouvelle Commande', Body, cmd, c[0].id);
                } else {
                  showDialog(
                    context: context,
                    builder: (_) {
                      _playSound();
                      return new NotificationScreen(cmd, c[0].id);
                    },
                  );
                }
              }
            }));
          }
        });
      }
    });
    WidgetsBinding.instance.removeObserver(this);
  }

  notifCommande(
      String title, String body, List<Commande> commandes, int livreur) {
    notif = new NotificationPage();
    notif.init(context, title, body, commandes, livreur);
  }

  playLocal() async {
    int result = await audioPlayer.play("images/notif.mp3", isLocal: true);
    print(result);
  }

  Future<Null> _load() async {
    final ByteData data = await rootBundle.load('images/notif.mp3');
    Directory tempDir = await getTemporaryDirectory();
    File tempFile = File('${tempDir.path}/notif.mp3');
    await tempFile.writeAsBytes(data.buffer.asUint8List(), flush: true);
    mp3Uri = tempFile.uri.toString();
    print('finished loading, uri=$mp3Uri');
  }

  void _playSound() {
    if (mp3Uri != null) {
      audioPlugin.play(mp3Uri, isLocal: true);
    }
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return null;
  }
}
