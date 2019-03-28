import 'dart:async';

import 'package:allozoe_livreur/DAO/Rest_dt.dart';
import 'package:allozoe_livreur/Database/DatabaseHelper.dart';
import 'package:allozoe_livreur/Models/Client.dart';
import 'package:allozoe_livreur/Models/Commande.dart';
import 'package:allozoe_livreur/Models/Produit.dart';

abstract class OrderDetailContract {
  void onLoadingSuccess(List<Produit> produits, int livreur);
  void onLoadingError();
  void onConnectionError();
  void onApprouvedOrder(int code);
}

class OrderDetailPresenter {
  OrderDetailContract _view;
  RestDatasource api = new RestDatasource();
  OrderDetailPresenter(this._view);

  loadOrderDetails(Commande commande) {
    api.loadOrderDetails(commande).then((List<Produit> produits) {
      if (produits != null || produits == null) {
        new DatabaseHelper().getClient().then((List<Client> c) {
          if (c == null || c.length == 0)
            _view.onLoadingError();
          else
            _view.onLoadingSuccess(produits, c[0].id);
        });
      } else
        _view.onLoadingError();
    }).catchError((onError) {
      _view.onConnectionError();
    });
  }

  Future<bool> accepterCommande(int deliver, int order) {
    return api.accepterCommande(deliver, order).then((bool etat) {
      if (etat != false) {
        _view.onApprouvedOrder(200);
        return true;
      } else {
        _view.onApprouvedOrder(400);
        return false;
      }
    }).catchError((onError) {
      _view.onConnectionError();
    });
  }

  Future<bool> refuserCommande(int deliver, int order) {
    return api.refuserCommande(deliver, order).then((bool etat) {
      if (etat != false) {
        _view.onApprouvedOrder(200);
        return true;
      } else {
        _view.onApprouvedOrder(400);
        return false;
      }
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
}
