import 'dart:async';

import 'package:allozoe_livreur/DAO/Rest_dt.dart';
import 'package:allozoe_livreur/Database/DatabaseHelper.dart';
import 'package:allozoe_livreur/Models/Client.dart';
import 'package:allozoe_livreur/Models/Commande.dart';

abstract class RestaurantCmdContract {
  void onLoadingSuccess(List<Commande> commandes, int livreur);
  void onLoadingError();
  void onConnectionError();
}

class RestaurantCmdPresenter {
  RestaurantCmdContract _view;
  RestDatasource api = new RestDatasource();
  RestaurantCmdPresenter(this._view);
  DatabaseHelper db;

  loadRestaurantCmdList(int restaurantID, int livreur) {
    api
        .loadCommandsRestaurant(restaurantID, livreur)
        .then((List<Commande> commandes) {
      if (commandes != null) {
        new DatabaseHelper().getClient().then((List<Client> c) {
          print("client :" + c.length.toString());
          if (c == null || c.length == 0)
            _view.onConnectionError();
          else
            _view.onLoadingSuccess(commandes, c[0].id);
        });
      } else
        _view.onConnectionError();
    }).catchError((onError) {
      _view.onConnectionError();
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

  Future<bool> livrerCommande(int deliver, int order) {
    return api.statusCommande(deliver, order).then((bool etat) {
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
