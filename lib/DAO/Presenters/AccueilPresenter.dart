import 'dart:async';

import 'package:allozoe_livreur/DAO/Rest_dt.dart';
import 'package:allozoe_livreur/Models/Categorie.dart';

abstract class AccueilContract {
  void onLoadingSuccess(List<Categorie> categories);
  void onLoadingError();
  void onConnectionError();
}

class AccueilPresenter {
  AccueilContract _view;
  RestDatasource api = new RestDatasource();
  AccueilPresenter(this._view);

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
}
