import 'dart:async';

import 'package:allozoe_livreur/DAO/Rest_dt.dart';
import 'package:allozoe_livreur/Database/DatabaseHelper.dart';
import 'package:allozoe_livreur/Models/Commande.dart';

abstract class HomeContract {
  void onLoadingSuccess(Commande commandes, int notif);
  void onLoadingError();
  void onConnectionError();
}

class HomePresenter {
  HomeContract _view;
  RestDatasource api = new RestDatasource();
  HomePresenter(this._view);
  DatabaseHelper db;

  loadHome(Commande cmd, int notif) {
    _view.onLoadingSuccess(cmd, notif);
  }

  Future<bool> accepterCommande(int deliver, int order) {
    return api.accepterCommande(deliver, order).then((bool etat) {
      if (etat != false)
        return true;
      else
        return false;
    }).catchError((onError) {
      _view.onConnectionError();
    });
  }

  Future<bool> RefuserCommande(int deliver, int order) {
    return api.refuserCommande(deliver, order).then((bool etat) {
      if (etat != false)
        return true;
      else
        return false;
    }).catchError((onError) {
      _view.onConnectionError();
    });
  }
}
