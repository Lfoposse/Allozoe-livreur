import 'dart:async';

import 'package:allozoe_livreur/DAO/Rest_dt.dart';
import 'package:allozoe_livreur/Database/DatabaseHelper.dart';
import 'package:allozoe_livreur/Models/Client.dart';
import 'package:allozoe_livreur/Models/Commande.dart';

abstract class NotificationContract {
  void onLoadingSuccess(int client);
  void onLoadingError();
  void onConnectionError();
}

class NotificationPresenter {
  NotificationContract _view;
  RestDatasource api = new RestDatasource();
  NotificationPresenter(this._view);
  DatabaseHelper db;

  checkCommande(int livreur) {
    return api.checkCommande(livreur).then((List<Commande> commande) {
      print("commande livreur :");
      if (commande != null)
        return commande;
      else
        print("erreur check commande");
    }).catchError((onError) {
      print("Exception erreur check commande");
    });
  }

  getLivreur() {
    new DatabaseHelper().getClient().then((List<Client> c) {
      if (c != null || c.length >= 0) _view.onLoadingSuccess(c[0].id);
    });
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

  Future<bool> refuserCommande(int deliver, int order) {
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
